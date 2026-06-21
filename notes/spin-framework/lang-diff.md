---
title: Spin Framework 言語比較
description: Spin で使える言語の違い（executor, SDK, パフォーマンス）
permalink:
aliases:
  -
tags:
  - spin
  - wasm
draft: false
date: 2026-06-21
---

## 対応言語と第一級市民

### 第一級市民（公式 SDK + Component Model 対応）

| 言語 | SDK | トリガー例 |
|---|---|---|
| Rust | `spin-sdk` | HTTP, Redis など |
| Go | `spin-go-sdk` | HTTP |
| TypeScript/JS | `@spinframework/wasi-http-proxy` + Hono | HTTP |
| Python | 公式 SDK あり | HTTP |

### コミュニティサポート（WAGI 経由）

| 言語 | 方式 | 備考 |
|---|---|---|
| C | WAGI（CGI スタイル） | `zig cc` でビルド可 |
| Zig | WAGI（CGI スタイル） | 最小バイナリが強み |

---

## executor の違い

### `default`（Component Model）
- WIT インターフェースを経由して Spin がハンドラを直接呼び出す
- Rust, Go, TS など公式 SDK 対応言語が使う
- オーバーヘッドが少なく推奨方式

### `executor = { type = "wagi" }`（WAGI = CGI スタイル）
- HTTP リクエストを stdin/環境変数で受け取り、stdout にレスポンスを書く
- WASI にコンパイルできれば Component Model 非対応でも動く
- C, Zig などが使う旧方式

---

## HTTP ハンドラの書き方比較

```c
// C（WAGI）: stdout に CGI スタイルで書く
printf("content-type: text/plain\n\n");
printf("Hello from %s\n", getenv("SERVER_SOFTWARE"));
```

```zig
// Zig（WAGI）: 同様に stdout に書く
try stdout.print("content-type: text/plain\n\n", .{});
try stdout.print("Hello World!\n", .{});
```

```go
// Go（Component Model）: net/http 互換インターフェース
spinhttp.Handle(func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Hello World!")
})
```

```rust
// Rust（Component Model）: Spin SDK 独自型
#[http_service]
async fn handle(req: Request) -> anyhow::Result<impl IntoResponse> {
    Ok(Response::builder().status(200).body("Hello World!"))
}
```

```ts
// TypeScript（Component Model）: Hono 経由
const app = new Hono()
app.get('/', (c) => c.text('Hello World!'))
```

---

## パフォーマンス・サイズ比較

| 言語 | バイナリサイズ | 速度 | 理由 |
|---|---|---|---|
| C / Zig | 最小（数十KB〜） | 最速 | ランタイムなし |
| Rust | 小〜中（数百KB） | 最速クラス | ゼロコスト抽象化 |
| Go | 大（数MB） | 中 | GC ランタイム同梱 |
| TypeScript | 大（数MB〜） | 低 | StarlingMonkey（SpiderMonkey）同梱 |

### TypeScript の仕組み

```
src/index.ts → esbuild → bundle.js → [StarlingMonkey] → .wasm
                                         ↑ JSエンジン丸ごと含む
```

JS/TS は WASM の中で JS エンジンを動かすため、コールドスタートと実行速度が犠牲になる。
ただし Hono などの npm エコシステムが使えるため開発速度は高い。

---

## WebAssembly Component Model とは

- **WIT**（Wasm Interface Type）という言語中立のインターフェース定義言語で API を記述
- 各言語のバインディングを自動生成 → 手動グルーコード不要
- WASI Preview 2（0.2）から正式採用
- Spin では `executor` 未指定（default）の場合に使われる

```
WIT 定義（Spin が提供）
  ├── Rust バインディング自動生成
  ├── Go バインディング自動生成
  └── TS バインディング自動生成
```

---

## 選択指針

| 優先事項 | 推奨言語 |
|---|---|
| パフォーマンス・サイズ最優先 | Rust |
| 最小バイナリ | C / Zig |
| 開発速度・npm エコシステム | TypeScript（Hono） |
| Go に慣れている | Go（※現状ビルド不可、下記参照） |
| Redis などイベントトリガー | Rust |

---

## Go の現状（2026-06 時点）

**ビルドエラーが発生しており、現状 Spin で Go は使用不可。**

```
runtime.wasiOnIdle.wrapinfo: relocation target runtime.wasiOnIdle not defined
```

### 原因

- `componentize-go` は Go スケジューラと WASIp3 の非同期モデルを橋渡しする `runtime.wasiOnIdle` 関数を必要とする
- この関数は [golang/go PR #76775](https://github.com/golang/go/pull/76775) で提案されているが、**まだ未マージ**（Go 本体に未収録）
- `componentize-go` は回避策として [dicej/go](https://github.com/dicej/go/releases) のパッチ済みバイナリをダウンロードして使う
- しかしキャッシュに古いバージョンが残っていると v2 パッチ（`go1.25.5-wasi-on-idle-v2`）と噛み合わずエラーになる

### 解決待ち

- `runtime.wasiOnIdle` が Go 本体にマージされるまで根本解決しない
- 進捗は [golang/go#77141](https://github.com/golang/go/issues/77141) を参照
