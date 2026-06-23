---
title: Spin Framework Overview
description: WebAssembly サーバーレスフレームワーク Spin の概要
aliases:
  -
tags:
  - wasm
  - spin
  - serverless
draft: false
date: 2026-06-21
---

## Spin とは

WebAssembly（Wasm）コンポーネントを使ったサーバーレスフレームワーク。
HTTP リクエストを Wasm モジュールにルーティングして処理させる。

---

## spin.toml = ルーター

`spin.toml` はサーバーフレームワークの Router オブジェクトに相当する。

```toml
spin_manifest_version = 2

[application]
name = "myapp"

[[trigger.http]]
route = "/api/..."
component = "my-api"

[[trigger.http]]
route = "/static/..."
component = "assets"
```

- HTTP ルートと Wasm コンポーネントをマッピングする
- 各コンポーネントは独立したサンドボックスで実行される

---

## アプリケーション構成

### 推奨構成（フラット構造）

```
myapp/
├── my-api/
│   ├── Cargo.toml
│   └── src/lib.rs
├── assets/          # 静的ファイル
└── spin.toml
```

- コンポーネント間に階層・ネストは不要
- `spin new -t http-empty` で開始 → `spin add` でコンポーネントを追加

### コンポーネント種別

| 種別 | 説明 |
|------|------|
| 自作コンポーネント | 自分でコードを書いてビルドした .wasm |
| 外部コンポーネント | GitHub Release 等から URL で取得する .wasm |

```toml
# 自作
[component.my-api]
source = "my-api/target/wasm32-wasip2/release/my_api.wasm"

# 外部（URL で .wasm を指定するだけでマウントできる）
[component.assets]
source = { url = "https://github.com/spinframework/spin-fileserver/releases/download/v0.1.0/spin_static_fs.wasm", digest = "sha256:..." }
files = [ { source = "assets", destination = "/" } ]
```

---

## 権限管理

各コンポーネントは明示的に許可した権限のみ使用可能（サンドボックス）。

```toml
[component.my-api]
allowed_outbound_hosts = ["https://api.example.com:443"]  # 外部通信先
key_value_stores = ["default"]                            # KV ストアアクセス
files = [ "data/**" ]                                     # アクセス可能なファイル
```

---

## WebAssembly コンポーネントモデル

### 背景：Core Wasm の限界

Core Wasm は `i32 / i64 / f32 / f64` の数値型しかやり取りできなかった。
→ 異なる言語間でのデータ連携が困難。

### WIT（WebAssembly Interface Types）

`string`, `list`, `tuple`, `struct`, `enum` など高レベルな型を定義できるインターフェース言語。

```wit
package security:http;

interface malice {
  check-request: func(url: string, headers: list<tuple<string, string>>) -> bool;
}
```

- WIT からそれぞれの言語向けバインディングが自動生成される
- 手動でメモリ操作をする必要がない

### コンポーネントモデル

WIT インターフェースを使って、異なる言語でビルドした Wasm コンポーネント同士を合成する仕組み。

```
Core Wasm:        i32/i64 だけ → 言語間連携ほぼ不可能
WIT:              型安全なインターフェース定義 + バインディング自動生成
コンポーネントモデル: WIT を使って異言語 Wasm を合成する仕組み
```

### Spin での依存コンポーネント

```toml
[component.my-app.dependencies]
"security:http/malice" = { package = "bargains:inspection", version = "2.0.0", registry = "packages.example.com" }
```

- `bargains:inspection` パッケージをレジストリからダウンロード
- `security:http/malice` インポートをその実装に自動接続
- 実装を別ベンダーに切り替えても、コードの変更は不要

---

## Docker との比較

```
Docker:  docker pull nginx  → ポートをマウント → HTTP を nginx が処理
Spin:    source = { url = "...spin_static_fs.wasm" } → ルートをマウント → HTTP を Wasm が処理
```

| | Docker | Spin + Wasm |
|--|--------|------------|
| 実行単位 | コンテナ（OS プロセス） | Wasm モジュール（サンドボックス） |
| 起動速度 | 秒〜分 | ミリ秒以下 |
| 言語 | 何でもあり | Wasm にコンパイルできる言語 |
| 権限制御 | Linux capability | WIT + spin.toml |

---

## 設計思想

> URL で .wasm を指定するだけで、誰でも書いた HTTP ハンドラーをルーティングにマウントして動かせる

npm や Docker Hub に近い **Wasm コンポーネントのパッケージエコシステム** を目指している。
