---
title: dev
description:
aliases:
  -
tags:
  -
draft: false
date: 2026-06-21
---

## spin watch

ファイル変更を監視して自動的にリビルド＆リスタートする開発用コマンド。

```bash
spin watch
```

### オプション

| オプション | 説明 |
|-----------|------|
| `-f, --from <APP_MANIFEST_FILE>` | 監視対象アプリを指定（デフォルト: `spin.toml`） |
| `-c, --clear` | 実行毎にスクリーンをクリア |
| `-d, --debounce <DEBOUNCE>` | 変更検知から再実行までのタイムアウト（ms）。デフォルト: `100` |
| `--skip-build` | ビルドスキップ、ビルド成果物（`.wasm`等）の変更時のみ再起動 |
| `[UP_ARGS]...` | `spin up` に渡す追加引数 |

### 監視対象ファイル

| ファイル | `spin watch` | `spin watch --skip-build` |
|---------|-------------|--------------------------|
| `spin.toml` | ✅ | ✅ |
| `component.build.watch` で指定したファイル | ✅ | ❌ |
| `component.files` | ✅ | ✅ |
| `component.source`（ビルドコマンドなし時） | ✅ | ✅ |

### spin.toml での watch 設定

```toml
[component.my-app.build]
command = "cargo build --target wasm32-wasip1 --release"
watch = ["src/**/*.rs", "Cargo.toml"]
```

## 言語選択

| 言語 | 特徴 |
|------|------|
| **Rust** | 型安全・パフォーマンス最高、SDKが最も充実。**推奨** |
| **Go (TinyGo)** | ビルド速い、ただし標準ライブラリに制限あり |
| **TypeScript** | `@fermyon/spin-sdk` で対応 |
| **C/Zig** | バイナリが小さい、低レベル制御向き |
| **Python** | 実験的サポート |

Rustは `spin-sdk` が最も機能豊富で公式ドキュメントのサンプルもRust中心。
増分コンパイルが効くので `spin watch` 時のビルド速度も許容範囲。



## build, up

WASMランタイムで動かすためには、普段ビルドが不要なインタプリタ言語でもビルドが必要(js, python, etc...)
`componentize-*` というツールが各言語に用意される
(componentize-py, componentize-go, esbuild - build.mjs + SpinEsbuildPlugin)


```sh
spin build
spin build --up
spin up
spin watch
```

## build profile

コンポーネントの設定を状況に応じて切り替える機能。デバッグ版・リリース版など異なるビルド設定を管理できる。

### 定義方法

```toml
[component.example]
source = "./out/release/example.wasm"      # ← デフォルト（ベース）
[component.example.build]
command = "make release"

[component.example.profile.debug]          # ← プロファイル "debug"
source = "./out/debug/example.wasm"
environment = { TRACE_LEVEL = "full" }
[component.example.profile.debug.build]
command = "make debug"
```

### 使用方法

```bash
$ spin build --profile debug
$ spin up --profile debug
```

### 上書き可能な設定

- `source`: Wasmファイルの出力パス
- `build.command`: ビルドコマンド
- `environment`: 環境変数
- `dependencies`: 依存関係

部分的な上書きも可能。指定しない設定はベース値を継承。

### ⚠️ よくある落とし穴

```bash
$ spin build --profile debug
$ spin up                              # ← デフォルト版が起動！
```

**対策:**
```bash
$ spin up --profile debug --build      # 常に再ビルドして一貫性保証
# または
export SPIN_ALWAYS_BUILD=1             # 常に --build を強制
```

## Publishing to Registry

Spin Application を OCI container registry（ghcr.io, Docker Hub等）に公開できる。

### Spin Application Bundle

`spin.toml` + 複数コンポーネント（.wasm）を1つのユニットとしてパッケージ化したもの。

```
Spin Application Bundle
├── spin.toml
├── component.api.wasm
├── component.ui.wasm
└── component.db.wasm
```

### 公開・実行フロー

```bash
# 1. registry にログイン
$ spin registry login ghcr.io

# 2. アプリケーション公開
$ spin registry push ghcr.io/username/myapp:v1
# → spin.toml + 全コンポーネント + メタデータを OCI registry に保存

# 3. registry から実行
$ spin up -f ghcr.io/username/myapp:v1
# → バンドルをダウンロード → 全コンポーネント起動
```

### Registry Reference フォーマット

```
<registry>/<username>/<app-name>:<version>

例: ghcr.io/alyssa-p-hacker/hello-world:v1
```

### ダイジェスト指定（不変参照）

```bash
# tag は mutable（上書き可能）
$ spin up -f ghcr.io/user/app:v1

# digest は immutable（常に同じビルド）
$ spin up -f ghcr.io/user/app@sha256:06b19
```

### 署名・検証（Cosign対応）

```bash
$ cosign sign ghcr.io/user/app@sha256:06b19
$ cosign verify ghcr.io/user/app@sha256:06b19
```

### Build Profile との組み合わせ

```bash
# デフォルト公開
$ spin registry push --build ghcr.io/user/app:v1

# debug プロファイル公開（別タグ）
$ spin registry push --profile debug --build ghcr.io/user/app-debug:v1
```
