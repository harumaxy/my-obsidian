---
title: dify
description: LLMアプリ開発プラットフォーム Dify のメモ
# permalink:  # don't use
aliases:
  -
tags:
  - ai
  - llm
  - dify
draft: false
date: 2026-06-25
---

## Dify とは

[GitHub: langgenius/dify](https://github.com/langgenius/dify) ⭐ 146,000+

「プロダクション対応のエージェントワークフロー開発プラットフォーム」。
ビジュアルUIでLLMアプリをノーコード/ローコードで構築し、プロトタイプから本番環境へ素早く移行できる。

LangChain が「材料と工具」なら、Dify は「材料+工具+作業台+納品先」まで揃えたセット。

## 主な機能

| 機能 | 内容 |
|------|------|
| **ワークフロービルダー** | ビジュアルキャンバスでAIパイプラインを設計 |
| **RAGパイプライン** | PDF・PPT等のドキュメントをナレッジベース化 |
| **マルチモデル対応** | GPT・Mistral・Llama3など数百のLLMをサポート |
| **エージェント** | Google検索・DALL·Eなど50以上の組み込みツール |
| **プロンプトIDE** | モデル間比較、テキスト音声変換機能 |
| **LLMOps** | ログ・パフォーマンス監視・分析 |

## 技術スタック

- フロントエンド: TypeScript (52%)
- バックエンド: Python (44%)

## アーキテクチャ

Docker Compose で13コンテナが立ち上がる構成。

```
├── nginx          (リバースプロキシ)
├── web            (Next.js フロントエンド)
├── api            (Python/Flask バックエンド)
├── worker         (Celery 非同期ワーカー)
├── db             (PostgreSQL)
├── redis          (キュー・キャッシュ)
├── weaviate       (ベクトルDB)
├── sandbox        (コード実行の隔離環境)
└── ...など計13個
```

マイクロサービスというより「モノリスをDocker Composeで綺麗に切り出した」感じに近い。全部同じマシンで動かす前提の構成。

## デプロイ

### ローカル（一番簡単）

```bash
git clone https://github.com/langgenius/dify
cd dify/docker
cp .env.example .env
docker compose up -d
# → http://localhost でアクセス
```

必要スペック: CPU 2コア以上、RAM 4GB以上

### リモートデプロイ先

| プラットフォーム | 向いてる用途 | 備考 |
|---|---|---|
| **Railway** | 個人・小規模 | Docker Compose対応、簡単 |
| **Fly.io** | 個人・小規模 | 無料枠あり、ただしメモリ注意 |
| **VPS（Hetzner/DigitalOcean）** | コスパ重視 | 4GB RAMで月$10〜。一番素直 |
| **AWS ECS / GCP Cloud Run** | 本番・チーム | 公式でCDK/Terraform対応済み |
| **Kubernetes (Helm)** | 大規模・HA構成 | コミュニティ製Helmチャートあり |

個人利用なら Hetzner VPS がコスパ最良（月€4〜5）。

## 認証・アクセス制御

- メール招待制でメンバー管理（デフォルト）
- ロール: `Owner` / `Admin` / `Editor` / `Normal`
- 作ったアプリを「非公開」にすれば外部からアクセス不可
- SSO（Google/SAML等）は**エンタープライズ版のみ**
- 小規模チームなら招待制で十分

## REST API 公開

ワークフローを作ると自動でAPIエンドポイントが生成される。

```bash
curl -X POST https://your-dify-host/v1/workflows/run \
  -H "Authorization: Bearer {API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"inputs": {"query": "..."}, "response_mode": "blocking", "user": "user-id"}'
```

- **Bearer Token認証** → 標準対応。UIでアプリごとにAPIキーを発行できる
- **OpenAPI仕様書** → JSONファイルで提供（Swaggerに読み込み可能）
  - `openapi_workflow.json`
  - `openapi_chatflow.json`
  - `openapi_chat.json`
  - `openapi_completion.json`
  - `openapi_knowledge.json`

既存サービスのバックエンドからDifyのワークフローを呼び出す構成が普通に組める。
