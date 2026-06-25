---
title: Cloudflare Sandbox SDK
description: Cloudflare Edge でコンテナベースの隔離実行環境を提供する SDK
aliases:
  - Sandbox SDK
tags:
  - cloudflare
  - edge-computing
  - containers
draft: false
date: 2026-06-24
---

# Cloudflare Sandbox SDK

## 概要

Cloudflare Edge ネットワーク上で **信頼されていないコードを安全に隔離実行** できる SDK。Linux コンテナベースの実行環境で、Python・JavaScript の実行、ファイル操作、任意のコマンド実行が可能。

**主な用途：**
- AI システムのコード実行（AI エージェント、コードインタープリタ）
- 対話的な開発環境
- データ分析パイプライン
- CI/CD システム

## Workers との主な違い

| 観点 | Workers | Sandbox SDK |
|------|---------|------------|
| **用途** | 一般的なサーバーレス関数 | 信頼されていないコード実行 |
| **言語** | JavaScript/TypeScript のみ | Python + JavaScript |
| **ファイルシステム** | 制限あり | フルアクセス |
| **コマンド実行** | 限定的 | 任意のコマンド実行可能 |
| **隔離方式** | V8 分離 | **Linux コンテナ** |
| **位置付け** | メインプラットフォーム | Workers 上で補完サービス |

## 実装アーキテクチャ

```
HTTPクライアント
    ↓
[Worker]（TypeScript/JavaScript）
  ├─ fetch() ハンドラで HTTP リクエスト受け取り
  ├─ URL パスでルーティング
  └─ sandbox.exec() でコマンド実行
    ↓
[Sandbox コンテナ]（Linux コンテナ）
  ├─ Python/JavaScript コード実行
  ├─ ファイルシステム操作
  └─ シェルコマンド実行
    ↓
Worker が結果（stdout/stderr）を JSON で返却
```

**重要：** Sandbox SDK は Worker 内から呼び出す補完的なサービス。

## 実装例

```typescript
export default {
  async fetch(request: Request, env: Env) {
    const url = new URL(request.url);
    const sandbox = getSandbox(env.SANDBOX_BINDING);

    // コマンド実行エンドポイント
    if (url.pathname === "/run") {
      const cmd = url.searchParams.get("cmd");
      const result = await sandbox.exec(cmd);
      return Response.json({
        stdout: result.stdout,
        stderr: result.stderr,
        exitCode: result.exitCode,
      });
    }

    // ファイル読み込みエンドポイント
    if (url.pathname === "/file") {
      const content = await sandbox.readFile("/workspace/data.txt");
      return Response.json({ content });
    }

    return new Response("Not Found", { status: 404 });
  },
};
```

## コア API

### コマンド実行

```typescript
// シンプル実行
const result = await sandbox.exec("ls -la");

// ストリーミング実行（リアルタイム出力）
const stream = await sandbox.execStream("python script.py");

// バックグラウンドプロセス
const process = await sandbox.startProcess("npm run server");
```

返り値：`{ stdout, stderr, exitCode, success }`

### ファイル操作

```typescript
await sandbox.writeFile("/workspace/file.txt", "content");
const content = await sandbox.readFile("/workspace/file.txt");
```

### サービス公開

```typescript
// ローカルポートをパブリック URL に公開
const url = await sandbox.tunnels.get(8080);
// → https://xxx.trycloudflare.com
```

### ファイルシステム監視

```typescript
const watcher = sandbox.watch("/workspace");
for await (const event of watcher) {
  console.log("ファイル変更:", event);
}
```

## ガイド一覧（18種類）

### 実行・処理関連
- **Code Interpreter** — Python/JavaScript コード実行、ステートフル、AI生成コード対応
- **Execute Commands** — exec/execStream/startProcess の使い分け
- **Background Processes** — 長時間実行サービス管理
- **Streaming Output** — リアルタイム出力

### ファイル・ストレージ
- **Manage Files** — 読み書き、ディレクトリ操作
- **File Watching** — ファイル変更監視（SSE）
- **Backup and Restore** — R2 へのスナップショット保存
- **Mount Buckets** — R2/S3 をローカルマウント

### ネットワーク・接続
- **Expose Services** — ローカルサービスを公開 URL 化
- **WebSocket Connections** — ブラウザターミナル、双方向通信
- **Browser Terminals** — xterm.js 対応
- **Outbound Traffic** — 外向き通信フィルタリング

### インテグレーション
- **Git Workflows** — リポジトリクローン、ブランチ管理
- **Proxy Requests** — JWT 検証経由で認証情報注入
- **Workers Bindings** — KV/R2/Durable Objects アクセス
- **Docker-in-Docker** — コンテナ内でコンテナ実行

### デプロイ・運用
- **Production Deployment** — ワイルドカード DNS 設定
- **2026 Deprecation Migration** — API マイグレーション予定

## 開発・デプロイフロー

### ローカル開発

```bash
# 1. テンプレートから初期化
npm create cloudflare@latest -- my-project \
  --template=cloudflare/sandbox-sdk/examples/minimal

# 2. ローカル開発サーバー起動
npm run dev
# → Docker コンテナをビルド・起動（初回2-3分）

# 3. API テスト
curl http://localhost:8787/run?cmd=ls
```

### デプロイ

```bash
npx wrangler deploy
```

- Dockerfile をビルド
- Cloudflare コンテナレジストリにプッシュ
- グローバルエッジに展開（2-3分で完全プロビジョニング）

## コンテナ環境カスタマイズ

### Dockerfile

```dockerfile
FROM python:3.11

RUN apt-get update && apt-get install -y \
    nodejs \
    git \
    # その他ツール

WORKDIR /app
```

### wrangler.jsonc での参照

```json
{
  "containers": {
    "main": {
      "dockerfile": "./Dockerfile",
      "instance_type": "lite"
    }
  }
}
```

ローカルテスト → 自動ビルド → Cloudflare にプッシュ という標準的な Docker ワークフロー。

## セキュリティ

- **コンテナ隔離** — Linux コンテナで完全隔離
- **認証情報保護** — 認証情報は Worker 経由で注入（Sandbox に直接保存しない）
- **JWT トークン検証** — API リクエスト時に短期トークンで検証
- **入力検証** — exec() 呼び出し前に入力チェック必須

## 制限事項

- Docker-in-Docker での iptables は無効
- 初回デプロイ後、2-3分待つ必要がある
- `.workers.dev` ドメインはワイルドカード非対応（本番環境ではカスタムドメイン必須）

## 活用シーン

- **AI コードインタープリタ** — ユーザー入力の Python コード安全実行
- **オンライン IDE** — ブラウザベース開発環境
- **データ分析プラットフォーム** — Jupyter ノートブック的な処理
- **CI/CD パイプライン** — エッジでのビルド・デプロイ
- **リポジトリ管理** — Git 自動化ツール


# その他

色々サービスある

e2b.dev

E2B
https://e2b.dev
https://note.com/mauve_0210/n/n1fb8e6cd0e5a
