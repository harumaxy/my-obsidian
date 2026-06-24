---
title: PartyKitとYjsで作るリアルタイムコラボレーションアプリ
description: Cloudflareが買収したPartyKitとYjsを使ったマルチプレイヤーアプリ・共同編集機能の実装ガイド
aliases:
  - PartyKit
  - Yjs
  - リアルタイムコラボレーション
tags:
  - cloudflare
  - websocket
  - partykit
  - yjs
  - durable-objects
  - 共同編集
draft: false
date: 2026-06-23
---

## PartyKitとは

CloudflareがPartyKitを買収（2024年4月）し、リアルタイムマルチプレイヤーアプリケーション構築プラットフォームとして統合した。

### 特徴
- **Durable Objects上の抽象化** — CloudflareのDurable ObjectsをシンプルなクラスベースのAPIで扱える
- **WebSocketの簡素化** — WebSocket処理を1つのクラスで完結できる
- **スケーラビリティ** — Hibernation APIで32,000接続/ルームまで対応可能
- **低レイテンシ** — エッジでの実行により低遅延を実現

### 使用ユースケース
- マルチプレイヤーゲーム
- リアルタイムコラボレーション（共同描画、ホワイトボード）
- チャットアプリケーション
- ライブコラボレーション機能の追加

## Durable Objectsとは

Cloudflareのステートフルなサーバーレスコンピューティングプリミティブ。

### 従来のサーバーレスとの違い
- **ステートレス** — 一般的なServerless Function（AWS Lambda等）はリクエスト処理後、状態が保持されない
- **ステートフル** — Durable Objectsはリクエスト間で状態を保持し、複数クライアント間での状態同期が容易

### 利点
- 複雑な分散システム問題を解決
- 外部データベースへの依存を削減
- 開発の複雑性を軽減

## Yjsとは

共同編集機能を実装するためのJavaScriptライブラリ。CRDT（Conflict-free Replicated Data Type）技術を採用。

### CRDTの利点
- **競合の自動解決** — 複数ユーザーの同時編集時も自動的に一貫性を保つ
- **オフライン対応** — インターネット接続がなくても作業継続可能
- **最終的一貫性** — どの順序で更新が到着しても全員が同じ状態に

### 対応フレームワーク
- React
- Vue
- Monaco Editor
- その他多数のエディタ

## PartyKit + Yjsの組み合わせ

### 実装の流れ

**サーバー側：**
```typescript
import { onConnect } from "y-partykit";

export default class YjsServer implements Party.Server {
  onConnect(conn: Party.Connection) {
    return onConnect(conn, this.party, {
      persist: { mode: "snapshot" }
    });
  }
}
```

**クライアント側：**
```typescript
import YPartyKitProvider from "y-partykit/provider";
import * as Y from "yjs";

const yDoc = new Y.Doc();
const provider = new YPartyKitProvider(
  "example.com",
  "document-name",
  yDoc
);
```

### 変更履歴の保存

Y-PartyKitは2つの保存モードを提供：

1. **snapshot** — 接続中は変更のスナップショットをストレージに書き込み、接続終了時にマージ保存
2. **history** — すべての変更履歴を保存（長期保存時は`maxBytes`や`maxUpdates`で定期的にマージが必要）

## Hibernation API

DurableObjectsの機能で、メッセージ送受信がない期間、WebSocket接続を維持したまま休止状態にできる。

### メリット
- **料金削減** — スリープ中はCPU使用料がかからない
- **スケーラビリティ向上** — PartyKit標準（100接続/ルーム）→ Hibernation使用時（32,000接続/ルーム）

### 注意点
- スリープ時間は約10秒
- インメモリ状態は破棄されるため、定期的に外部ストレージに保存が必要
- メッセージ受信時に毎回保存するか、Alarmでバッチ保存する必要あり

## デプロイ

### 環境設定
```bash
npm create partykit@latest
rm -rf package-lock.json
bun i
```

### .env ファイル
```
CLOUDFLARE_API_TOKEN=<Create Token > Edit Cloudflare Workers>
CLOUDFLARE_ACCOUNT_ID=<Worker&Pages サイドメニューに表示>
```

### デプロイコマンド
```bash
bun --env-file .env partykit deploy --domain zzz.yyy.xxx
```

## 制限事項

- **Binding未対応** — KV、R2、D1、logpush等のCloudflare機能と連携できない
- **カスタムドメイン** — PartyKitプラットフォームデプロイ時は未対応
- **ビルドプロセス** — PartyKitサーバーでビルドが行われるため、ハックが難しい

## 今後の展開

Cloudflareは以下の発展を予定：
- 既存プロジェクトとの統合（Workers/Pagesプロジェクト内でPartyKitを使用）
- 主要フレームワーク（React、Vue、Angular）との統合拡充
- Binding対応の検討

## 参考

- 2024年4月時点でCloudflareがPartyKitを買収
- PartyKitはDurable Objectsの上に構築されたプラットフォーム
- サーバーレスの未来はステートフル化へ向かっている
