---
title: LocalStack から MiniStack への移行ガイド
description: LocalStack の有料化に対応するため MiniStack を採用してローカル AWS インフラを再現
# permalink:  # don't use
aliases:
  - localstack-to-ministack-migration
tags:
  - AWS
  - Docker
  - Terraform
  - インフラ
  - ローカル開発
draft: false
date: 2026-06-24
---

# LocalStack から MiniStack への移行ガイド

https://zenn.dev/kamegoro/articles/ef1ab1c9527f9d

## 概要

LocalStack が有料化したため、個人開発で AWS インフラをローカルで再現する代替手段として **MiniStack** を採用した経験をまとめた記事。

## MiniStack の特徴

- **無料で MIT ライセンス、登録不要** → LocalStack の有料化に対応
- RDS や ECS を実コンテナで動作させ、SQL の動作確認もローカルで可能
- Docker socket をマウントして実行する方式

## 実装のポイント

著者が構築した構成：
- VPC・ECS Fargate・RDS・CloudFront・Secrets Manager・ECR
- providers.tf でエンドポイント設定するだけで通常の Terraform コマンドが使える

## 実用的な工夫

1. **Makefile で操作を統合** → `make e2e` で起動からテスト実行まで一括実行
2. **ローカル環境向けに設定を調整**
   - `force_destroy = true`
   - `recovery_window_in_days = 0`
3. **開発環境と本番環境で同じ Terraform モジュールを再利用**

## まとめ

MiniStack により、実 AWS コストを避けながらローカルで本格的なインフラ検証が実現できる。
