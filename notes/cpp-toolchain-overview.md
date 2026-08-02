---
title: C++ ツールチェーン概要
description: C++のコンパイラ・ビルドシステム・パッケージマネージャーの整理
# permalink:  # don't use
aliases:
  -
tags:
  - cpp
  - toolchain
draft: false
date: 2026-08-02
---

# C++ ツールチェーン概要

## なぜ混沌か

- 言語仕様 (ISO) はコンパイラの動作だけ決める。ビルドツールは各自で何とかしろが暗黙の前提
- Rust/Go は最初からビルドツール込みで設計。C++ は 50 年の技術的負債
- バイナリの ABI 互換問題 → パッケージ配布が根本的に難しい → vcpkg/Conan が乱立

## コンパイラ

- **GCC** — Linux デファクト。古参
- **Clang** — macOS デファクト。エラーメッセージ読みやすい。LLVM ベース
- **MSVC** — Windows / Visual Studio 専用
- **Intel ICC** — HPC 向け最適化特化

macOS → Clang、Linux → GCC か Clang

## ビルドシステム

### Make / Makefile

- `Makefile` = ビルド手順記述ファイル
- `make` = それを読んで実行するツール
- 自分で Makefile を書くのが昔スタイル

### CMake

Makefile を生成するツール。自分ではコンパイルしない。

```
CMakeLists.txt → cmake → Makefile (自動生成) → make → コンパイル
```

`CMakeLists.txt` に「何をどうビルドするか」宣言 → クロスプラットフォーム対応が目的

### Ninja

Make の代替。CMake が生成できるターゲットの一つ。Google が Chrome ビルド用に作成。並列ビルド設計が最初から最適化 → Make より速い。

```
CMakeLists.txt → cmake -G Ninja → build.ninja (自動生成) → ninja → コンパイル
```

### 役割まとめ

| ツール | 役割 | 自分で書くか |
|--------|------|-------------|
| Makefile | ビルド定義 | 書く (昔) |
| make | Makefile 実行 | 実行するだけ |
| CMakeLists.txt | ビルド定義 | 書く (今) |
| cmake | Makefile or build.ninja 生成 | 実行するだけ |
| ninja | build.ninja 実行 | 実行するだけ |

人間が書くのは CMakeLists.txt だけ。あとは自動生成 → 自動実行。

## パッケージマネージャー

- **vcpkg** — Microsoft 製。CMake 連携が楽。`vcpkg.json` に依存宣言
- **Conan** — 最有力候補。`conanfile.txt` で依存管理
- 現実: `git submodule` で依存丸ごと取り込み or OS パッケージマネージャー (`apt`, `brew`) に頼る

Rust の Cargo みたいな「これ一択」がない。

## 現代的推奨スタック (技術負債無視)

```
vcpkg (依存管理)  →  CMakePresets.json (宣言的設定)  →  ninja (高速ビルド)  →  clang (コンパイル)
```

開発ツール全部 LLVM ファミリーで統一:
- `clangd` — LSP
- `clang-format` — フォーマット
- `clang-tidy` — 静的解析
- `AddressSanitizer` + `UBSanitizer` — 開発時バグ検出

### ファイル構成

```
project/
├── CMakeLists.txt
├── CMakePresets.json   # dev/release/ci プロファイル
├── vcpkg.json          # 依存パッケージ宣言
├── .clang-format
├── .clang-tidy
└── src/
```

## C++ の現代的機能 (Rust 比較)

| 概念 | Rust | C++17〜 |
|------|------|---------|
| Sum type | `enum` | `std::variant` |
| Optional | `Option<T>` | `std::optional` |
| Result | `Result<T,E>` | `std::expected` (C++23) |
| map/filter | イテレータ | `std::views::transform` / `std::views::filter` (C++20) |

- デフォルトは mutable。意識して `const` / `constexpr` つけないと immutable にならない
- パターンマッチング: `std::visit` + `std::variant` で擬似的に可能。C++26 でネイティブ `match` 提案中 (P2688)
- ラムダ構文が独特 (`[capture](args) -> ret { body }`) → 既存関数ポインタ構文との兼ね合い
