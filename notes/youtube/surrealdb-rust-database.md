---
title: SurrealDB — Rust製マルチモデルDB
description: SurrealDB の概要・特徴・ホスティング・React連携まとめ
aliases:
  - SurrealDB
tags:
  - database
  - rust
  - surrealdb
draft: false
date: 2026-08-02
---

# SurrealDB — Rust製マルチモデルDB

元動画: [SurrealDBというRust製データベース](https://www.youtube.com/watch?v=nozAuWvMDlA) / IT技術屋のボヤキ

## 一言で

「全部入り」DB。SQL・ドキュメント・グラフ・Key-Value を1つで扱う。Rust製。

## なぜ作った？

通常ECサイト = PostgreSQL + MongoDB + Neo4j の3DB運用。
SurrealDB = これを1つに統合 → 運用コスト・学習コスト削減が目的。

## Rust製メリット

- 高速 + メモリ安全（コンパイル時バグ検出）
- 単一バイナリ配布 → デプロイ簡単
- 組み込みモード対応（SQLiteの代替になる）

## グラフDB部分について

RDBのJOINは深くなると指数的に遅くなる。
グラフDBはノード→エッジをポインタ直接追跡 → 関係が深くても O(1) per hop。
SurrealDB はグラフ専用DB（Neo4j等）なしで同じDBでグラフクエリ可能。

## SurrealQL（独自クエリ言語）

- SQLベース + 拡張。SQL知識あればすぐ使える
- レコードリンク: JOIN不要で関連データアクセス
- グラフクエリ: Neo4j の Cypher 不要

## 組み込み機能

### ライブクエリ（リアルタイム）

WebSocket 接続でテーブル監視。データ変更が即プッシュ。

```typescript
const unsubscribe = await db.live("posts", (action, result) => {
  // INSERT/UPDATE/DELETE で即呼ばれる
});
```

ポーリング不要。チャット・ダッシュボード・通知に使える。

### 組み込み認証 + フロントエンド直結（BaaS的使い方）

Supabase / Firebase 的な構成が SurrealDB 単体で可能。

```sql
-- 自分のレコードしか見えない
DEFINE TABLE post SCHEMAFULL
  PERMISSIONS
    FOR select, update, delete WHERE user = $auth.id;
```

```typescript
// フロントから直接接続
await db.signin({ access: "user", variables: { email, password } });
const posts = await db.select("post"); // 自分のだけ返る
```

シンプルなCRUD + リアルタイム同期アプリならバックエンド不要になる場面も。
複雑なビジネスロジック（決済・外部API）は別途バックエンド必要。

## React連携

```bash
bun add surrealdb @tanstack/react-query
```

```tsx
<QueryClientProvider client={queryClient}>
  <SurrealProvider endpoint="ws://localhost:8000" params={{
    namespace: "myapp",
    database: "mydb",
  }}>
    <App />
  </SurrealProvider>
</QueryClientProvider>
```

公式で `useSurrealClient()` / `useAuth()` / `useLiveQuery()` hook 提供。
TanStack Query との組み合わせが公式推奨パターン。

## ホスティング

| 選択肢 | 概要 |
|---|---|
| SurrealDB Cloud | 公式マネージド。インフラ運用不要。本番向けHA構成 |
| 単一バイナリ on VPS | 最小構成。ダウンロードして起動するだけ |
| Docker | 軽量イメージ。`docker run surrealdb/surrealdb` |
| Kubernetes | EKS/AKS/GKE対応。大規模向け |
| 組み込み | アプリ内埋め込み。SQLite的使い方 |

**ストレージ**: SSDが必須（RocksDB = LSM-Tree構造でランダム書き込み多い）。
公式Kubernetesサンプルは 50Gi をデフォルト値として使用。

## 課題

- エコシステム未熟（ライブラリ・ドキュメント少）
- 本番採用事例ほぼなし
- 信頼性未証明（DB は実績が重要）

## 向いてる場面

- 新規プロジェクト / プロトタイプ
- リアルタイム機能が必要なアプリ
- 既存PostgreSQLシステムの移行には向かない

## 総評

技術的に面白い挑戦者。エコシステムが育てば化ける可能性あり。
今は「観察フェーズ」。新規プロジェクトで試す価値はある。
