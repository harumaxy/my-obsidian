---
title: Rust から C/C++ を使う — FFI・bindgen・ビルドシステム
description: C/C++ 資産を Rust から活用する方法。bindgen のワークフロー、build.rs の役割、サードパーティラッパーとの比較、Zig との対比まで。
# permalink:  # don't use
aliases:
  -
tags:
  - rust
  - cpp
  - ffi
  - bindgen
draft: false
date: 2026-06-23
---

## C++ は嫌われるが消えない

- Stack Overflow 2024: C++ ユーザーの 46% しか「来年も使い続けたい」と回答（Rust 81%）
- TIOBE では世界 4 位。Photoshop, Chrome, Unreal Engine, PyTorch の中核は C++
- 新規開発で C++ を選ぶ理由は薄い → **Rust / Go / Zig を選ぶべき**
- C++ を触る機会は「既存コードベースの保守」がほぼ全て

---

## C/C++ 資産の活用：FFI vs 書き直し

| 状況 | 選択 |
|------|------|
| 既存ライブラリを呼び出すだけ | **FFI（bindgen）** |
| 既存システムの一部置き換え | **段階的 FFI + Rust 化** |
| 小さいライブラリ、セキュリティ重要箇所 | **書き直しも検討** |

世界には数兆行の C++ コード資産がある。全部書き直しは現実的に不可能。

---

## bindgen ワークフロー

```
C/C++ ヘッダ
    ↓
build.rs で bindgen 実行
    ↓
OUT_DIR に bindings.rs 自動生成
    ↓
src/main.rs で include!() して使う
```

```toml
# Cargo.toml
[build-dependencies]
bindgen = "0.69"
```

```rust
// build.rs
fn main() {
    let bindings = bindgen::Builder::default()
        .header("vendor/mylib.h")
        .generate()
        .unwrap();

    bindings
        .write_to_file(
            format!("{}/bindings.rs", std::env::var("OUT_DIR").unwrap())
        )
        .unwrap();

    println!("cargo:rustc-link-lib=mylib");
}
```

```rust
// src/main.rs
mod bindings {
    include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
}

fn main() {
    unsafe { bindings::mylib_init(); }
}
```

---

## build.rs とは

- Cargo がメインコンパイル**前**に実行する前処理スクリプト
- プロジェクトルートに置くだけで Cargo が自動検出
- `println!("cargo:...")` で Cargo にリンク設定を指示

```
cargo build
    ↓
① build.rs を実行
    ↓
② FFI 生成・ライブラリリンク設定
    ↓
③ src/*.rs をコンパイル
```

主な用途：
- **Code Generation**（bindgen で FFI binding 生成）
- **External Library Linking**（`-lssl` 等の指定）
- **外部ビルドシステムの呼び出し**（cmake クレート等）

---

## C/C++ ライブラリのパターン別対応

| ライブラリ | 戦略 | クレート |
|-----------|------|---------|
| SQLite（単一 .c） | git submodule + cc 直接コンパイル | `cc` |
| zlib（CMake 小〜中） | git submodule + cmake | `cmake` |
| OpenSSL（システムに多い） | pkg-config で検出 | `pkg-config` |
| FFmpeg（超複雑） | system or vendored CMake | `cmake` |

### system と pkg-config とは

- **system ライブラリ**：brew / apt でインストールされた OS のライブラリ
  ```bash
  brew install openssl
  # → /usr/local/opt/openssl/lib/libssl.a に配置
  ```
- **pkg-config**：そのライブラリのパスや flags を問い合わせるツール
  ```bash
  pkg-config --libs openssl
  # → -L/usr/local/opt/openssl/lib -lssl -lcrypto
  ```
  build.rs がこれを呼び出して自動検出する。

---

## サードパーティラッパーの付加価値

自前 bindgen は生の C API がそのまま出てくる。サードパーティラッパーは以下を提供：

| 項目 | 自前 bindgen | サードパーティ |
|------|-------------|---------------|
| **API** | 生の C API（unsafe） | Rust らしい API |
| **エラー処理** | C のエラーコード | `Result` / `?` |
| **メモリ管理** | 手動 | RAII（自動 Drop） |
| **build.rs** | 自分で書く | クレートが持つ |

```rust
// 自前 bindgen
unsafe {
    let ctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(ctx, EVP_sha256(), ptr::null_mut());
    EVP_DigestFinal_ex(ctx, out.as_mut_ptr(), &mut len);
    EVP_MD_CTX_free(ctx);  // 忘れたらメモリリーク
}

// openssl クレート（サードパーティ）
let mut hasher = Hasher::new(MessageDigest::sha256())?;
hasher.update(data)?;
let result = hasher.finish()?;
```

**方針：サードパーティラッパーがある → 使う / ない → 自前 bindgen**

---

## Rust vs Zig のビルドシステム比較

| 観点 | Rust | Zig |
|------|------|-----|
| **パッケージ宣言** | Cargo.toml（宣言） + build.rs（手続き） | build.zig.zon（URL + hash） |
| **C/C++ 依存** | git submodule + build.rs | build.zig.zon で URL 指定 |
| **ビルドロジック** | build.rs（メインコンパイル前の前処理） | build.zig（ビルド全体を定義） |
| **サブコマンド** | Cargo が `build`, `run`, `test` を標準提供 | build.zig で自分で定義 |

- **Rust の build.rs** = Makefile の前処理部分
- **Zig の build.zig** = Makefile 全体（CMake 相当）

Zig は C/C++ リポジトリを URL + hash で宣言的に取得できる点が優れているが、**ビルドロジックの複雑さは C/C++ 側に起因するため変わらない**。

### Zig パッケージマネージャー（2026年6月現在）

- Zig 0.16.0（2026年4月）が最新
- 0.16 から依存が `zig-pkg/` ディレクトリにプロジェクトローカルで配置
- 設計はモダンだが中央レジストリなし、Dependabot / Renovate 非対応
- 「設計はいい、エコシステムはまだこれから」の段階
