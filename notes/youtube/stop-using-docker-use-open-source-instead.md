---
title: "Dockerを使うな。オープンソースを使え - Podmanガイド"
description: "DevOpsToolboxチャンネル - DockerからPodmanへの移行ガイド。Kubernetes統合とコンテナ管理の実践"
aliases:
  - Stop Using Docker
  - Podman Guide
tags:
  - containers
  - kubernetes
  - devops
  - podman
draft: false
date: 2026-06-23
---

## 📌 概要

Dockerの商用化による課題と、オープンソース代替ツール**Podman**の機能・利点を紹介。ローカルKubernetes環境構築まで網羅。

**チャンネル**: DevOps Toolbox  
**動画URL**: https://www.youtube.com/watch?v=Z5uBcczJxUY

---

## 🚨 Dockerの問題点

### 商用化による制限
- **2年前**から商用化戦略を開始
- Docker Hub でのレート制限で企業の作業停止
- Mac版 Docker Desktop：商用利用でライセンス必須
- 規約違反時の法的リスク

### 課題の具体例
```bash
# Docker Hub のレート制限でブロック
docker push/pull
# → 結果：work ground to a halt

# Mac Docker Desktop（商用利用）
# → 月額ライセンス購入が必須
```

---

## ✅ Podman とは

Docker のオープンソース代替品。ほぼ完全互換でありながら、より安全・高速・軽量。

### 主な特徴

| 特徴 | 説明 |
|------|------|
| **ライセンス** | 完全無料（個人・商用） |
| **互換性** | Docker コマンドがそのまま動作 |
| **Daemon-less & Rootless** | ルートプロセス不要。セキュリティ向上 |
| **Pods対応** | 複数コンテナを Pod 内で管理（Kubernetes風） |
| **Kubernetes生成** | `podman generate kube` で YAML 自動生成 |

---

## 🛠️ 使用例

### 基本操作（Docker同様）
```bash
# イメージ検索
podman search redis --filter=official

# コンテナ実行
podman run -d -p 6379:6379 redis

# 実行中のコンテナ確認
podman ps
```

### Pod の作成と管理
```bash
# Pod 作成
podman pod create --name web-app

# Pod 内にコンテナ追加
podman run -d --pod web-app nginx
podman run -d --pod web-app postgres

# Pod 検確認
podman pod ps

# Pod の詳細情報
podman pod inspect web-app
```

### コンテナ間通信（localhost経由）
```bash
# Redis に接続
podman run --rm --pod web-app redis-cli -h localhost ping
# → PONG（成功）
```

---

## 🚀 Kubernetes 統合（最強機能）

### YAML自動生成
```bash
# Pod のコンテナから Kubernetes マニフェストを生成
podman generate kube web-app > deployment.yaml

# 結果：Volumes, Mounts, 全設定が YAML に
```

### ローカルで Kubernetes を実行
```bash
# YAML ファイルをデプロイ
podman play kube deployment.yaml

# Kubernetes で実際に動作確認
podman ps  # nginx, postgres が起動

# 完全な Pod に
podman pod ps
```

### 本番環境へ
```bash
# ローカル YAML を kubectl で本番環境にデプロイ
kubectl apply -f deployment.yaml
```

---

## 🎨 Podman Desktop

GUI ツール。コンテナ・Pod・イメージ・ボリューム・Kubernetes を一元管理。

### 主な機能
✅ コンテナのリアルタイムログ閲覧  
✅ コンテナ設定の UI 確認  
✅ Kubernetes マニフェスト生成  
✅ 組み込みターミナルシェル  
✅ Pod 管理  
✅ ボリューム・イメージ・ネットワーク管理  
✅ Kubernetes ダッシュボード統合  

---

## 🔄 Podman vs Docker vs OrbStack

### 選択基準

| 用途 | 推奨 | 理由 |
|------|------|------|
| **Kubernetes 学習** | Podman | 無料。YAML生成・実行機能が強力 |
| **macOS での快適性重視** | OrbStack | 起動2秒。メモリ 200MB。Kubernetes 標準搭載 |
| **商用利用で無料** | Podman | 完全無料（商用OK） |
| **すでに使用中** | 現状維持 | 移行の手間より現状が最適 |

### 詳細比較

#### Podman
- ✅ 完全無料（個人・商用）
- ✅ マルチプラットフォーム（Linux・macOS・Windows）
- ✅ Kubernetes 統合が強力
- ❌ 初期セットアップやや複雑

#### OrbStack
- ✅ 起動 2 秒（vs Docker 20-30秒）
- ✅ メモリ 200MB（vs Docker 4GB）
- ✅ Kubernetes 組み込み。GUI 統合
- ✅ LoadBalancer が `*.k8s.orb.local` で直接アクセス可能
- ❌ macOS 専用
- ❌ 商用利用は月 $8

#### Docker Desktop
- ✅ 機能が豊富
- ❌ 起動が遅い
- ❌ メモリ消費が多い
- ❌ 商用ライセンス有料

---

## 🎓 Kubernetes 学習の進め方

### OrbStack を使う場合（推奨：既に導入済み）
```bash
# 1. Kubernetes 起動
orb start k8s

# 2. kubectl で操作
kubectl get nodes
kubectl apply -f deployment.yaml
kubectl logs pod-name

# 3. GUI で管理・確認
# OrbStack Desktop → Kubernetes タブ
```

### Podman を使う場合
```bash
# 1. Pod 作成
podman pod create --name learning

# 2. コンテナ追加
podman run -d --pod learning nginx
podman run -d --pod learning postgres

# 3. Kubernetes YAML 生成
podman generate kube learning > manifest.yaml

# 4. ローカルで実行・検証
podman play kube manifest.yaml

# 5. 本番環境へデプロイ
kubectl apply -f manifest.yaml
```

---

## 💡 Key Takeaways

1. **Docker に依存する必要はない**  
   - OrbStack（macOS）や Podman（マルチプラットフォーム）で十分

2. **Kubernetes 学習には Podman が強力**  
   - YAML 生成・ローカル実行・本番デプロイがシームレス

3. **OrbStack は現状ベスト**（既に導入済みなら）  
   - セットアップ不要。Kubernetes も標準搭載
   - 軽量で高速。GUI 統合

4. **商用利用なら Podman を選ぶ**  
   - 完全無料。法的リスク無し

---

## 📚 参考資料

- [Podman 公式ドキュメント](https://podman.io)
- [OrbStack Kubernetes ガイド](https://docs.orbstack.dev/kubernetes/)
- [Omer's Dotfiles](https://github.com/omerxx/dotfiles)
- Kubernetes 学習コース：Zero To KNOWING Kubernetes in Under 90 Minutes
