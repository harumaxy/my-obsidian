---
title: AWS Blocks + Amplify Gen2 まとめ
description: AWS の新しい IfC ツール AWS Blocks の概要と Amplify Gen2 との比較・統合方法
# permalink:  # don't use
aliases:
  - aws-blocks
tags:
  - aws
  - amplify
  - ifc
  - cdk
draft: false
date: 2026-06-25
---

## AWS Blocks とは

AWS が提供する新しい **IfC（Infrastructure from Code）** ツール。アプリコードを書くと、そこからインフラが自動的に導出される。

- ブロック単位でバックエンド機能を組み合わせて構築
- ローカル開発時はモック動作、デプロイ時は CDK 構造に自動変換
- AWS アカウント不要で完全ローカル実行が可能
- 内部は CDK アプリ → CDK を直接書いて拡張できる「逃げ道」あり

## 提供ブロック一覧

### データ・ストレージ

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `KVStore` | Key-Value ストレージ | DynamoDB |
| `DistributedTable` | インデックス・クエリ付き構造化データ | DynamoDB |
| `Database` | SQL（Kysely）マネージド Postgres | Aurora Serverless v2 |
| `DistributedDatabase` | ゼロアイドルコストのサーバーレス SQL | Aurora DSQL |
| `FileBucket` | ファイルストレージ・署名付き URL | S3 |

### 認証

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `AuthBasic` | ユーザー名/パスワード認証 | DynamoDB + JWT |
| `AuthCognito` | MFA・グループ・パスキー対応 | Cognito |
| `AuthOIDC` | Google/GitHub/Okta SSO | OAuth |

### コンピュート・バックグラウンド

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `AsyncJob` | 非同期バックグラウンド処理 | SQS + Lambda |
| `CronJob` | スケジュール実行 | EventBridge + Lambda |

### AI

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `Agent` | ツール付き AI エージェント・会話履歴 | Bedrock |
| `KnowledgeBase` | セマンティック検索・RAG | Bedrock Knowledge Bases |

### コミュニケーション

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `Realtime` | WebSocket pub/sub | API Gateway WebSocket |
| `EmailClient` | トランザクションメール | SES |

### 設定・可観測性

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `AppSetting` | 設定値・シークレット管理 | SSM Parameter Store |
| `Logger` | 構造化ログ | CloudWatch Logs |
| `Metrics` | カスタムメトリクス | CloudWatch |
| `Tracer` | 分散トレーシング | X-Ray |
| `Dashboard` | 自動生成オブザーバビリティダッシュボード | CloudWatch |

### ホスティング

| ブロック | 内容 | AWS サービス |
|---|---|---|
| `Hosting` | SSR 対応フロントエンドデプロイ | CloudFront + S3 |

## Amplify Gen2 との比較

公式ドキュメントでも **「補完関係」** と明記されている。

| | Amplify | Blocks |
|---|---|---|
| **強み** | ホスティング・CI/CD・管理コンソール | 対応サービスの幅・型安全・ローカル開発 |
| **DB** | DynamoDB / RDS(接続) | DynamoDB / Aurora / Aurora DSQL |
| **オブザーバビリティ** | なし | Logger / Metrics / Tracer / Dashboard |
| **メール** | なし | `EmailClient`（SES） |
| **リアルタイム** | なし（自前実装） | `Realtime`（WebSocket） |
| **AI** | なし | `Agent` / `KnowledgeBase`（Bedrock） |
| **CI/CD** | 組み込み（Git 連携・ブランチ環境） | なし（CDK deploy のみ） |
| **ホスティング** | フル対応 | `Hosting` ブロックあるが簡素 |
| **コンソール管理** | Amplify Studio あり | なし |

## Amplify + Blocks の統合方法

`BlocksBackend` を Amplify の `backend.ts` に埋め込むことで一元管理できる。

```typescript
// amplify/backend.ts
backend.createStack('blocks')
// BlocksBackend.create() で統合
```

デプロイ時は以下のオプションが**必須**（ないとブロックがモック動作のまま）:

```bash
NODE_OPTIONS="--conditions=cdk" npx ampx sandbox
```

## 推奨アーキテクチャ

```
Blocks   → バックエンドの機能定義（サービスの幅が広い）
Amplify  → ホスティング・CI/CD・ブランチ環境管理
CDK      → どちらもカバーしていない部分の補完
```

## 参考

- [Zenn: AWS Blocks と Amplify Gen2 は補完関係にあるのか](https://zenn.dev/ncdc/articles/bb8ffdd1a874ea)
- [AWS Blocks 公式ドキュメント](https://docs.aws.amazon.com/blocks/latest/devguide/what-is-blocks.html)
- [AWS Blocks 公式サイト](https://aws.amazon.com/products/developer-tools/blocks/)
