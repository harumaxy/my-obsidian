---
title: API Gateway
description: API Gateway の概念・ツール比較・AWSデプロイ構成まとめ
# permalink:  # don't use
aliases:
  - api gateway
tags:
  - api-gateway
  - infrastructure
  - krakend
draft: false
date: 2026-08-03
---

# API Gateway

クライアントと複数バックエンドの間に立つ中継レイヤー。

```
Client → [API Gateway] → Service A
                       → Service B
                       → Service C
```

本質はリバースプロキシ + API特化機能。

## やること

- ルーティング: `/users` → User Service、`/orders` → Order Service
- 認証: JWT/OAuth 検証を一箇所で処理（各サービスが個別実装不要）
- レート制限・スロットリング
- レスポンス集約: 複数サービスの結果を1レスポンスにまとめる
- ロギング・テレメトリ集中管理

## ツール比較

**Nginx**
- 元々 Web サーバー、プロキシは後付け
- 設定: `nginx.conf`（手書き）
- 動的ルーティング苦手（設定変更→リロード必要）
- 実績・情報量が最大

**Traefik**
- Docker/K8s ネイティブ
- ラベルでルーティング自動検出 → コンテナ増やすだけで設定不要
- Let's Encrypt 自動取得
- API Gateway 機能は薄め

**KrakenD**
- API Gateway 専用、Go製
- レスポンス集約・変換が得意
- ステートレス設計で水平スケール簡単
- 設定 JSON 一本
- 70K+ req/s、メモリ 50MB 以下

**Kong**
- API Gateway の老舗
- プラグインエコシステムが豊富
- DB 必要（ステートフル）→運用コスト高

### 選び方

- コンテナ環境でルーティングだけ → Traefik
- 静的コンテンツ + リバースプロキシ → Nginx
- マイクロサービス、レスポンス集約・認証一元化 → KrakenD / Kong
- プラグインで機能拡張したい → Kong

## AWS の場合

AWS 完結なら素直にマネージド使う。

**AWS API Gateway**: JWT認証・レート制限・ステージ管理。Lambda と相性抜群。従量課金。

**ALB**: パスベースルーティング。ECS/EKS との統合がシンプル。固定コスト寄り。

セルフホストが必要なケース:
- マルチクラウド or オンプレ混在
- ベンダーロックイン回避
- レスポンス集約など AWS では対応しにくい機能が必要

## セルフホスト: ECS Fargate 構成

KrakenD はステートレス → Fargate と相性最良。EC2 管理不要。

```
Internet
  ↓
ALB (SSL終端)
  ↓
ECS Fargate (KrakenD タスク × N)
  ↓
各バックエンドサービス
```

- CPU 負荷でオートスケール
- `krakend.json` は S3 or 環境変数で渡す
- 公式 Docker イメージそのまま使える
