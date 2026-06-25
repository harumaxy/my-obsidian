---
title: Cap'n Web - JavaScript ネイティブ RPC ライブラリ
description: Cloudflare が開発した WebSocket/HTTP 対応の型安全 RPC システム
aliases:
  - capnweb
tags:
  - cloudflare
  - rpc
  - websocket
  - typescript
draft: false
date: 2026-06-25
---

## 概要

Cloudflare が開発した JavaScript/TypeScript ネイティブな RPC ライブラリ。
スキーマ不要・10kB 以下・依存なしで、HTTP / WebSocket / postMessage() に対応。

- 参考記事: https://zenn.dev/yusukebe/articles/3c18e280eaa490
- 公式ブログ: https://blog.cloudflare.com/capnweb-javascript-rpc-library/
- GitHub: https://github.com/cloudflare/capnweb

## トランスポート

| プロトコル | 用途 |
|---|---|
| WebSocket | 永続接続、双方向、低レイテンシ |
| HTTP バッチ | 一度限りの呼び出し |
| `postMessage()` | iframe / Worker 間通信 |
| カスタムトランスポート | 拡張可能 |

## 主要機能

### 双方向 RPC

クライアント → サーバーだけでなく、サーバー → クライアントのコールバックも可能。
コールバック関数を RPC 越しに渡せるので、サーバープッシュが実現できる。

### オブジェクト参照渡し (Capability-based RPC)

`RpcTarget` を継承したオブジェクトを引数・戻り値として渡せる。

```typescript
// ログイン後に認証済みオブジェクトを返す → 偽造不可
const session = await rpc.login(credentials)
await session.doSomethingPrivate()
```

### Promise Pipelining

前の呼び出し結果を `await` せずそのまま次の引数に渡すと、1 往復で完結する。

```typescript
// 通常: 2往復
const user = await rpc.getUser(id)
const profile = await rpc.getProfile(user.id)

// パイプライン: 1往復
const userPromise = rpc.getUser(id)
const profile = await rpc.getProfile(userPromise)
```

### バッチ処理

複数の呼び出しを `await` せず保留しておき、最後にまとめると 1 リクエストになる。

### `.map()` マジックメソッド

配列の各要素への RPC 呼び出しを 1 ラウンドトリップで実行。

### ストリーミング

`ReadableStream` / `WritableStream` を RPC 越しにそのまま渡せる。フロー制御付き。

## Cap'n Proto との関係

Cap'n Web は [Cap'n Proto](https://capnproto.org) の「Web 向け精神的後継」。

| | Cap'n Proto | Cap'n Web |
|---|---|---|
| 対象 | ネイティブ・サーバー間 | Web / JS 環境 |
| フォーマット | バイナリ | JSON |
| スキーマ | `.capnp` ファイル必須 | 不要 (TS 型で代替) |
| 共通点 | Promise Pipelining、Capability-based RPC | ← 同じ思想を継承 |

Promise Pipelining と Capability-based RPC は Cap'n Proto で生まれた概念を JS に移植したもの。

## 注意点

- WebSocket は cross-site 接続が通るため、認証は RPC メソッド経由 (インバンド) で行う
- パイプラインの悪用でサーバーキューが肥大化するリスク → レート制限が必要
- ランタイム型チェックなし → Zod との併用推奨
- まだ実験的段階

## 比較

| | Cap'n Web | tRPC | Hono RPC | GraphQL |
|---|---|---|---|---|
| 構文 | JS ネイティブ | スキーマ定義 | ルート定義 | クエリ言語 |
| バッチ | 自動 | 手動 | なし | なし |
| パイプライン | あり | なし | なし | なし |
| サーバープッシュ | あり | なし | なし | Subscription |
| 外部公開 API | 不向き | 可 | 可 | 向いている |

## ユースケース

向いている:
- Cloudflare Workers / Durable Objects 環境
- フルスタック TS の内部 API
- チャット・コラボ編集など双方向リアルタイム通信

向いていない:
- 外部公開 API (REST/GraphQL のほうがドキュメント化しやすい)
- 多言語バックエンド混在環境
