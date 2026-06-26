---
title: やったらあかんで！AWS アンチパターンと解決策
description: AWS 初心者が踏みがちな16個のアンチパターンと、それぞれの解決策・関連知識のまとめ
aliases:
  - AWS アンチパターン
tags:
  - aws
  - infrastructure
  - iac
  - security
draft: false
date: 2026-06-25
---

原文: https://zenn.dev/isawa/articles/3e9f9aeba89bde

## 概要

初心者・小規模チームが AWS 運用で踏みがちな失敗パターンを16個まとめた記事。
「インフラの負債は後から直すほど工数が膨れ上がる」という問題意識で書かれている。

---

## アンチパターンと解決策

### アカウント・IAM

| アンチパターン | 解決策 |
|---|---|
| 複数環境を1アカウントに統合 | AWS Organizations でアカウントを環境ごとに分離（dev/stg/prd） |
| 個別 IAM ユーザーを各アカウントに発行 | IAM Identity Center（SSO）で一元管理 |
| CI に IAM キーを直書き | GitHub Actions は OIDC + AssumeRole でキーレス認証 |

### ネットワーク設計

| アンチパターン | 解決策 |
|---|---|
| サブネット CIDR が雑 | 最初から `/16` の VPC + `/24` サブネット以上を確保。拡張余地を持たせる |
| RDS/ECS をパブリックサブネットに配置 | プライベートサブネットに配置。踏み台は SSM Session Manager か VPN |
| S3 をパブリックアクセス開放 | パブリックアクセスブロックを有効化。公開が必要なら CloudFront 経由 |

### セキュリティ・運用

| アンチパターン | 解決策 |
|---|---|
| 全許可 SG の使い回し | サービス単位で SG を作成。ソースは CIDR でなく SG ID で指定 |
| NAT Gateway に全通信を集約 | S3/DynamoDB は VPC エンドポイント（Gateway型、無料）を使う |
| ECS Exec を無効化 | タスク定義と IAM ロールに ECS Exec を有効化しておく |

### アプリ・リソース管理

| アンチパターン | 解決策 |
|---|---|
| ECS タスク定義に機密情報を直書き | Secrets Manager or Parameter Store に格納し `secrets` フィールドで参照 |
| ECR の `latest` タグで本番デプロイ | コミットハッシュやバージョン番号をタグにする（例: `sha-abc123`） |
| Lambda をコンソールで直接編集 | IaC（SAM/CDK/Terraform）+ CI/CD パイプラインで管理 |
| 命名規則の不統一 | `{env}-{service}-{resource}` などの規則を最初に決める |

### データ保護

| アンチパターン | 解決策 |
|---|---|
| RDS バックアップをデフォルト7日で放置 | 保持期間を要件に合わせて延長（最大35日） |
| RDS の自動マイナーバージョンアップ有効 | 無効化し、メンテナンスウィンドウを自分でコントロール |
| S3 バージョニング無効 | バージョニングを有効化。コスト対策はライフサイクルポリシーで古バージョンを削除 |

### コスト管理

| アンチパターン | 解決策 |
|---|---|
| EC2 削除後も EBS が残る | EC2 の「終了時に削除」を有効化。Cost Explorer で孤立リソースを定期チェック |

---

## マルチアカウント構成

### アカウント分離

AWS Organizations で環境ごとにアカウントを分離する。各アカウントには一意のメールアドレスが必要。

**Gmail の `+` エイリアスで対応できる（個人・小規模チーム向け）**

```
harumaxy+aws-dev@gmail.com
harumaxy+aws-stg@gmail.com
harumaxy+aws-prd@gmail.com
```

### IaC のマルチアカウントデプロイ戦略

コードは1つ、デプロイ先を変数で切り替えるのが基本。

**Terraform**
- `terraform workspace` + 環境ごとの `.tfvars` で state を分離
- `assume_role` で各アカウントの IAM ロールを使い分け

**AWS CDK**
- `env: { account: '...', region: '...' }` で明示的に指定
- CDK Pipelines で dev → prd を自動ステージング（prd は ManualApprovalStep）

---

## OIDC + AssumeRole

CI/CD から AWS を操作する際の現代的な認証方式。IAM キーを一切持たずに認証できる。

### 仕組み

```
GitHub Actions
  ↓ OIDC トークン（JWT）で身元証明
AWS（GitHub の公開鍵で検証）
  ↓ AssumeRole
一時クレデンシャル（15分〜1時間）を発行
  ↓
AWS リソースを操作
```

### 設定手順

1. **AWS 側**：IAM > Identity providers に GitHub の OIDC プロバイダーを登録
2. **AWS 側**：IAM ロールの信頼ポリシーで特定リポジトリ・ブランチに絞る
3. **GitHub Actions 側**：`aws-actions/configure-aws-credentials` で role-to-assume を指定

```yaml
permissions:
  id-token: write
  contents: read

steps:
  - uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: arn:aws:iam::123456789012:role/TerraformDeployRole
      aws-region: ap-northeast-1
```

### IAM キーとの比較

| | IAM キー（旧） | OIDC + AssumeRole |
|---|---|---|
| 認証情報の保存 | GitHub Secrets に永続キー | キー不要 |
| 漏洩リスク | 高い | 低い（一時トークン） |
| 権限の絞り込み | 難しい | リポジトリ・ブランチ単位で可能 |
| ローテーション | 手動 | 自動（毎回発行） |
