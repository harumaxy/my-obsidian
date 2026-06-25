---
title: Vercel Sandbox
description: 信頼できないコードを隔離されたLinux環境で安全に実行するコンピュート基盤
aliases:
  - Vercel Sandbox
tags:
  - vercel
  - infrastructure
  - sandbox
  - cloud-computing
draft: false
date: 2026-06-24
---

# Vercel Sandbox

信頼できないまたはユーザーが生成したコードを、隔離されたLinux環境で安全に実行するためのコンピュート基盤。Firecracker microVMを使用した強力な隔離を提供。

## 概要

### 主な特徴
- **隔離**: Firecracker microVMで各サンドボックスが独立した Linux 環境で実行
- **複数ランタイム**: Node.js (v26, 24, 22) + Python 3.13 に対応
- **システム権限**: sudo アクセスで Docker など権限が必要なプロセスにも対応
- **高速起動**: ミリ秒単位での起動時間
- **永続化**: デフォルトでファイルシステムを自動保存・復元

### 利用ケース
- AI 生成コードの安全な実行
- ユーザー提出コードのテスト
- コード生成ツールやプレイグラウンド
- 開発環境の再現性確保
- 一時的なデバッグ環境

## Docker との比較

| 項目 | Docker | Vercel Sandbox |
|------|--------|---|
| **隔離** | ホストカーネル共有 | 専用カーネル（Firecracker） |
| **セキュリティ** | 信頼できるコード向け | 信頼できないコード向け |
| **起動時間** | サブ秒 | ミリ秒 |
| **用途** | アプリケーション本体 | 任意コード実行 |

## システムパッケージのインストール

Amazon Linux 2023 が動作するため、dnf パッケージマネージャーでインストール:

```typescript
await sandbox.runCommand({
  cmd: 'dnf',
  args: ['install', '-y', 'golang'],
  sudo: true,
});
```

⚠️ **注意**: パッケージはセッション間で永続化しない。永続化するにはスナップショットを作成する必要がある。

## ベース環境の作成とテンプレート化

### ローカル開発時：`getOrCreate()` で初期化

新規環境を一度だけ作成し、その後再利用する場合の推奨パターン:

```typescript
const sandbox = await Sandbox.getOrCreate({
  name: 'build-template',
  runtime: 'node24',
  onCreate: async (sbx) => {
    // 新規作成時のみ実行
    await sbx.runCommand('dnf', ['install', '-y', 'golang'], { sudo: true });
    await sbx.runCommand('npm', ['install', '-g', 'cli-tool']);
  },
  onResume: async (sbx) => {
    // 再開するたびに実行（バックグラウンドサービス起動など）
    await sbx.runCommand({ cmd: 'npm', args: ['run', 'dev'], detached: true });
  },
});

await sandbox.stop();  // スナップショット自動保存
```

**動作**:
- 初回呼び出し → `onCreate` を実行してセットアップ
- 2 回目以降 → `onResume` のみ実行
- スナップショット期限切れ → 自動削除して再作成

### 本番 Vercel：`fork()` で複製

テンプレートから新しいインスタンスを作成して実行:

```typescript
const instance = await Sandbox.fork({
  sourceSandbox: 'build-template',
  name: `build-${Date.now()}`,
});

const result = await instance.runCommand('go', ['build', '.']);
await instance.stop();
```

## スナップショット（環境保存）

### 概要

Sandbox のファイルシステムと設定を保存。以降の起動時に復元される。

### スナップショット作成

#### 1. 自動作成（推奨）
永続化が有効なサンドボックスは `stop()` 時に自動的にスナップショット作成:

```typescript
const sandbox = await Sandbox.create({ persistent: true });  // デフォルト
// ... セットアップ ...
await sandbox.stop();  // 自動的にスナップショット保存
```

#### 2. 手動作成
セッション中に明示的にスナップショットを作成:

```typescript
const snapshot = await sandbox.snapshot({ expiration: ms('14d') });
console.log(snapshot.snapshotId);  // snap_xyz を保存
```

### スナップショット管理

#### 保持ポリシー
最新 N 個のスナップショットのみ保持し、古いものを自動削除:

```typescript
const sandbox = await Sandbox.create({
  name: 'my-env',
  keepLastSnapshots: {
    count: 3,  // 最新 3 個を保持
    deleteEvicted: true,  // 古いものは自動削除
    expiration: 14 * 24 * 60 * 60 * 1000,  // 14 日で期限切れ
  },
});
```

#### バージョン管理・ロールバック
特定のスナップショットに切り替え:

```typescript
// 過去のスナップショットに戻す
await sandbox.update({
  currentSnapshotId: 'snap_old-version',
});
```

#### スナップショット一覧確認
```typescript
const snapshots = await sandbox.listSnapshots();
for await (const snap of snapshots) {
  console.log(snap.id, snap.createdAt, snap.sizeBytes);
}
```

## ローカルと本番の連携

### 仕組み

Sandbox は **Vercel プロジェクト内** に保存されるため、ローカルと本番の両方からアクセス可能。

```
Vercel Project（クラウド上で一元管理）
├── ローカル開発: vercel link + env pull
├── 本番 Function: 自動認証
└── CI/CD: アクセストークン認証
    ↓
すべて同じ Sandbox に アクセス
```

### 認証方法

#### ローカル開発
```bash
vercel link          # プロジェクトにリンク
vercel env pull      # VERCEL_OIDC_TOKEN を取得（12時間有効）
```

#### 本番（Vercel 上のコード）
自動的に OIDC トークンが生成され、認証される。

#### 外部 CI/CD
アクセストークンを使用:
```bash
VERCEL_TEAM_ID=team_xxx
VERCEL_PROJECT_ID=prj_xxx
VERCEL_TOKEN=your_access_token
```

### 推奨ワークフロー

```
1. ローカル開発時：
   vercel link && vercel env pull
   ↓
   npm run setup-sandbox  # getOrCreate() で初期化
   ↓
   スナップショット自動保存

2. 本番デプロイ:
   Vercel Function の中で fork()
   ↓
   ローカルで作成したテンプレートを複製して実行
```

## SDK の主要 API

### Sandbox.getOrCreate()
存在確認と作成を自動処理。ローカル開発での初期化に最適。

```typescript
const sandbox = await Sandbox.getOrCreate({
  name: 'template-name',
  runtime: 'node24',
  onCreate: async (sbx) => { /* 初回のみ */ },
  onResume: async (sbx) => { /* 毎回 */ },
});
```

### Sandbox.fork()
既存サンドボックスの最新スナップショットから新しいインスタンスを作成。

```typescript
const instance = await Sandbox.fork({
  sourceSandbox: 'template-name',
  name: 'instance-unique-name',
  persistent: false,  // 本番での一時実行用
});
```

### Sandbox.get()
既存のサンドボックスを取得。停止中なら自動的に再開。

```typescript
const sandbox = await Sandbox.get({ name: 'my-sandbox' });
```

### コマンド実行
```typescript
// ブロッキング
const result = await sandbox.runCommand('node', ['--version']);
console.log(result.exitCode);
console.log(await result.stdout());

// デタッチド（バックグラウンド）
const cmd = await sandbox.runCommand({
  cmd: 'npm',
  args: ['run', 'dev'],
  detached: true,
});
```

## ファイルシステム

### ファイル読み書き
```typescript
// ファイル書き込み
await sandbox.writeFiles([{
  path: 'hello.txt',
  content: Buffer.from('Hello'),
  mode: 0o644,  // オプション：パーミッション設定
}]);

// ファイル読み込み
const content = await sandbox.readFileToBuffer({ path: 'hello.txt' });
```

### Node.js fs/promises 互換 API
```typescript
await sandbox.fs.mkdir('/tmp/results', { recursive: true });
const files = await sandbox.fs.readdir('/tmp');
await sandbox.fs.chmod('/tmp/script.sh', 0o755);
```

## タイムアウト

デフォルト: 5 分
プラン別の最大:
- Hobby: 45 分
- Pro/Enterprise: 24 時間

```typescript
// タイムアウト拡張
await sandbox.extendTimeout(60 * 1000);  // 60秒延長
```

## ネットワークポリシー

```typescript
// デフォルト：すべての外部通信を許可
const sandbox = await Sandbox.create({
  networkPolicy: 'allow-all',  // または 'deny-all'
});

// 特定のドメインのみ許可
await sandbox.update({
  networkPolicy: {
    allow: ['api.example.com', 'npm.org'],
  },
});
```

## コスト観点

計測される項目:
- Sandbox 作成数
- プロビジョニングメモリ
- CPU 使用時間
- データ転送量
- スナップショットストレージ

スナップショットを効率的に管理（`keepLastSnapshots`）することでコスト削減可能。

## 参考

- [Vercel Sandbox 公式ドキュメント](https://vercel.com/docs/sandbox)
- JS SDK: `@vercel/sandbox`
- Python SDK: `vercel.sandbox`
- CLI: `sandbox` コマンド
