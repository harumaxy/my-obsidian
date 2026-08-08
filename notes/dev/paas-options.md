---
title: PaaS 選択肢まとめ
description: セルフホスト vs マネージド PaaS の比較
# permalink:  # don't use
aliases:
  -
tags:
  - paas
  - docker
  - devops
draft: false
date: 2026-08-03
---

# PaaS 選択肢まとめ

Docker アプリのデプロイ先。AWS/GCP 直は面倒 → PaaS レイヤー挟む。

## セルフホスト系

自分でサーバー借りて乗せる。サーバー代のみ、アプリ数制限なし。

### Dokku
- Docker ベース ミニ Heroku
- CLI 中心、シンプル
- git push でデプロイ
- 古参、軽量

### Coolify
- Dokku のモダン版、Web UI あり
- 280+ one-click services（Postgres/Redis/WordPress 等）
- 自動 SSL（Let's Encrypt）
- PR プレビュー環境
- 複数サーバー管理可

**構成イメージ**
```
EC2
└── Coolify
    ├── Traefik (リバプロ + SSL)
    ├── app-container
    └── postgres-container
```

**限界**
- オートスケール（負荷連動 台数増減）なし
- K8s 的分散なし
- 手動で台数増やして割り当ては可能

向き: 個人・スタートアップ、トラフィック予測可能なサービス  
不向き: 突発バズ、数百台規模、SLA 99.99%

## マネージド系

インフラ管理不要。楽。

| サービス | 特徴 |
|---------|------|
| **Railway** | git push → 自動デプロイ、無料枠あり |
| **Render** | Heroku 代替として人気 |
| **Fly.io** | Docker イメージそのまま `fly deploy`、グローバル分散 |
| **Porter** | AWS/GCP 上に Heroku UX を重ねる |

**Fly.io が最も手軽** — Docker イメージ → `fly deploy` 一発、AWS IAM 不要。

## 結論

- スモールスタート → Coolify or Railway/Fly.io
- スケール必要 → ECS/EKS 移行
- 最初から K8s は過剰
