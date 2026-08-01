---
title: TanStack DB + オフラインファースト同期
description: TanStack DB / PowerSync / ElectricSQL によるオフラインファーストアーキテクチャまとめ
aliases:
  - tanstack-db
  - offline-first
tags:
  - tanstack
  - offline-first
  - powersync
  - electricsql
  - react
draft: false
date: 2026-08-01
---

## TanStack DB とは

**リアクティブ インメモリ コレクション + ライブクエリ層**。SQLite ではない。

- `Collection` = 正規化インメモリストア（Redux の EntityAdapter に近い）
- `LiveQuery` = コレクション変化 → UI 自動再レンダリング
- 楽観的更新内蔵
- SQLite / 同期エンジンは全部オプトイン

```
TanStack DB コア（メモリ）
    ↓ opt-in
    ├── 永続化: SQLite / IndexedDB
    └── 同期: PowerSync / ElectricSQL / TanStack Query
```

## Live Query

SQL ライク method chain でクエリ記述 → コレクション変化で自動再計算。

```typescript
const todos = useLiveQuery((q) =>
  q.from({ todos: todosCollection })
   .where(({ todos }) => eq(todos.completed, false))
   .select(({ todos }) => ({ id: todos.id, text: todos.text }))
)

// JOIN も可能
const personIssues = useLiveQuery((q) =>
  q.from({ issues: issueCollection })
   .join({ persons: personCollection },
     ({ issues, persons }) => eq(issues.userId, persons.id)
   )
   .select(({ issues, persons }) => ({
     id: issues.id,
     userName: persons.name,
   }))
)
```

## 同期エンジン 3択

### 1. TanStack Query（REST ポーリング）

```typescript
const todoCollection = createCollection(
  queryCollectionOptions({
    queryKey: ['todos'],
    queryFn: async () => fetch('/api/todos').then(r => r.json()),
    queryClient,
    getKey: (item) => item.id,
    onInsert: async ({ transaction }) => { /* POST */ },
    onUpdate: async ({ transaction }) => { /* PUT */ },
    onDelete: async ({ transaction }) => { /* DELETE */ },
  })
)
```

同期方式: TanStack Query キャッシュ更新 → コレクション反映。

### 2. ElectricSQL（Postgres WAL → SSE）

```typescript
const todoCollection = createCollection(
  electricCollectionOptions({
    id: "todos",
    shapeOptions: {
      url: "https://api.electric-sql.cloud/v1/shape",
      params: { table: "todos" },
    },
    getKey: (item) => item.id,
    onInsert: async ({ transaction }) => {
      const res = await api.todos.create(transaction.mutations[0].modified)
      return { txid: res.txid }
    },
  })
)
```

同期方式: Postgres WAL → Electric サーバー → HTTP SSE → コレクション更新。

### 3. PowerSync（Postgres → WebSocket → SQLite）

```typescript
const todosCollection = createCollection(
  powerSyncCollectionOptions({
    database: db,
    table: AppSchema.props.todos,
    syncMode: 'eager',
  })
)
```

同期方式: Postgres → PowerSync → WebSocket → ローカル SQLite → コレクション更新。

## 全体フロー

```
Postgres WAL変更
    ↓
Electric/PowerSync サーバー（SSE or WebSocket）
    ↓
ローカル SQLite or メモリ更新
    ↓
TanStack DB コレクション反映
    ↓
useLiveQuery 自動再計算 → UI 再レンダリング
```

書き込み逆向き: UI mutation → onInsert/onUpdate → REST/RPC → サーバー → WAL → 降ってくる（楽観的更新で先に UI 反映も可）。

## ElectricSQL vs PowerSync

| | ElectricSQL | PowerSync |
|---|---|---|
| 同期プロトコル | HTTP SSE | WebSocket |
| ローカルDB | メモリ or 任意 | SQLite 固定 |
| 書き込み | 自前API | PowerSync経由 |
| セルフホスト | OSS 可 | OSS 可 |
| SaaS | electric.cloud | powersync.com |

ElectricSQL: 軽量・シンプル。PowerSync: オフライン SQLite 永続化込み・ヘビー。

## Postgres WAL 監視の仕組み

CDC（Change Data Capture）全般の実装パターン。

```
Postgres
  ↓ logical replication スロット (pgoutput)
CDC プロセス（Electric / PowerSync / Debezium）
  ↓ フィルタ・変換
  ↓ SSE / WebSocket / Kafka に配信
```

Postgres 側設定必須:

```ini
# postgresql.conf
wal_level = logical
max_replication_slots = 10
max_wal_senders = 10
```

類似技術: MySQL = binlog、MongoDB = oplog。

## セルフホスト

両方 OSS で Docker 1発。

```bash
# ElectricSQL
docker run -e "DATABASE_URL=postgresql://..." -p 3000:3000 electricsql/electric:latest

# PowerSync
docker run -p 8080:80 -e POWERSYNC_CONFIG_B64="$(base64 -i ./config.yaml)" journeyapps/powersync-service:latest
```

## Cloudflare Durable Object + TanStack DB

DO の WebSocket + SQLite をカスタムアダプターで接続するパターン。

```
DO (per room/session)
  ├── SQLite（セッション内ソースオブトルース）
  └── WebSocket ハイバネーション
         ↕
TanStack DB カスタムコレクション → LiveQuery → UI
```

```typescript
function durableObjectCollectionOptions(config: { url: string }) {
  return {
    getKey: (item) => item.id,
    sync: {
      sync: ({ begin, write, commit, markReady }) => {
        const ws = new WebSocket(config.url)

        ws.onmessage = (event) => {
          const msg = JSON.parse(event.data)
          if (msg.type === 'init') {
            begin()
            for (const item of msg.data) write({ type: 'insert', value: item })
            commit()
            markReady()
          } else {
            begin()
            write({ type: msg.op, key: msg.key, value: msg.data })
            commit()
          }
        }

        return () => ws.close()
      },
    },
    onInsert: async ({ transaction }) => {
      ws.send(JSON.stringify({ op: 'insert', data: transaction.mutations[0].modified }))
    },
  }
}
```

### 公式統合 vs カスタムアダプター

| 機能 | PowerSync/Electric | DO カスタムアダプター |
|---|---|---|
| リアルタイム同期 | ✅ | ✅ |
| オフライン永続化 | ✅ 内蔵 | ❌ 自前実装 |
| 再接続時差分同期 | ✅ 内蔵 | ❌ 自前実装 |
| 競合解決 | ✅ 内蔵 | ❌ 自前実装 |
| セッション内共有 | 別途設計 | ✅ DO の本領 |

### 用途の分岐

- **DO + TanStack DB** → リアルタイムコラボ・マルチプレイ。オフライン不要。Figma 的。
- **PowerSync / Electric** → オフラインファースト。Postgres グローバル DB。モバイルアプリ的。

リアルタイムコラボ Web アプリならオフラインなしで DO + TanStack DB で十分。  
後からオフライン対応が必要になったら公式統合アダプターに差し替えるだけ。
