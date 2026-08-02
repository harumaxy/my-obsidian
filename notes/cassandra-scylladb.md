---
title: Cassandra / ScyllaDB メモ
description: ワイドカラム型分散DBの概念、RDBとの違い、ScyllaDB移行、ホスティング選定
aliases:
  - cassandra
  - scylladb
tags:
  - db
  - distributed
draft: false
date: 2026-08-02
---

# Cassandra / ScyllaDB

参考動画: [Cassandraはなぜ王座を譲り始めたのか](https://www.youtube.com/watch?v=RsMgBfzAP-w)

## Cassandraとは

ワイドカラム型 分散DB。2007年 Facebook 受信箱検索のために誕生。Dynamo論文 × BigTable論文 合体設計。2008年OSSリリース、2010年 Apache トップレベル。

## RDBとの違い

**データモデル**
- RDB: 行×列 固定テーブル。JOIN で関連付け
- Cassandra: 行ごとに列が違う。パーティションキーで配置場所決定、クラスタリングキーで行内ソート順制御
- クエリ形状を先に決めてテーブル設計 (逆転の発想)

**整合性**
- RDB: ACID。強整合性
- Cassandra: 結果整合性 (Eventual Consistency)。Consistency Level で調整可能だが、上げるほどレイテンシ増

**書き込み速度**
- RDB: ランダムIO → 遅い
- Cassandra: LSMツリー = ログ追記 + メモリ更新のみ → ランダムIOなし → 書き込み圧倒的速い

**スケール**
- RDB: 縦スケール中心
- Cassandra: 横スケール前提。ノード追加で線形性能向上。全ノード対等 (マスターなし)

**苦手**
- JOIN 不可
- 柔軟な集計 (GROUP BY 等)
- アドホッククエリ

**向いてる用途**: 時系列 / チャット履歴 / IoT / 閲覧履歴 / 書き込み洪水でクエリパターンが固定されてる領域

## 弱点: Java GC

JavaのGC停止がボトルネック。Discord 事例:
- 2022年: 177ノード / 数兆件メッセージ
- P99レイテンシ 40ms〜125ms で暴れる
- ホットパーティション: 人気チャンネルへのアクセス集中 → 特定ノード加熱 → クラスター全体に波及

ホットパーティションは「発生しづらい」ではなく「データの偏りがあれば発生する」。コンシステントハッシングで均等分散を試みるが、アクセスパターンの偏りは防げない。

## ScyllaDB

読み: スキュラ (ギリシャ神話の怪物)

KVMの作者 (Avi Kivity) が Cassandra 設計を尊重したまま C++ で再実装 (2015年)。

**互換性**
- CQL (Cassandra Query Language) 互換
- SSTable ファイル形式 互換
- 既存 Cassandra ドライバーそのまま使える
- アプリコード変更ほぼ不要

**改善点**
- GC なし (C++ → メモリ管理自前)
- Shard-per-core 設計: コアごとに独立処理系、ロックなし → コア増加分そのまま性能向上
- 1ノード処理能力 数倍

**Discord 移行結果**: 177台 → 72台、P99レイテンシ 15ms 安定、書き込み 5ms 固定

注意: 「ほぼ互換」であって「完全互換」ではない。一部機能の差異あり。大規模移行前に検証必須。

## ホスティング選定

**マネージドサービス (運用コスト最小)**
- **Amazon Keyspaces**: AWSのCassandra互換。サーバーレス課金。完全互換ではない (LWT 等使えない制限あり)
- **Astra DB (DataStax)**: Cassandra公式マネージド。互換性高い
- **ScyllaDB Cloud**: ScyllaDB公式マネージド。AWS/GCP/Azure対応

**セルフホスト**
- EC2直接: 自由度最大、運用コスト高
- k8s (EKS/GKE) + Operator: scylla-operator 等で管理

**規模別推奨**
- 個人/小規模: Astra DB 無料枠 or Amazon Keyspaces
- 中規模・本番: ScyllaDB Cloud
- 大規模・コスト削減: EC2 + ScyllaDB セルフホスト
- 既存AWSインフラ統合重視: Amazon Keyspaces (制限確認必須)

## クロスプロバイダー レイテンシ問題

Cloudflare Workers + Neon + ScyllaDB Cloud のように複数プロバイダー分散構成時の注意点。

**エッジFaaSのパラドックス**
Workers はユーザーに近いエッジで実行 → ユーザーまで -10ms。でも Workers → ScyllaDB Cloud (別リージョン) が +150ms なら意味がない。Cloudflare **Smart Placement** を有効化すると DB に近い場所に Worker を自動配置する。

**AWS 同一リージョンの優位性**
- 同一VPC内: Private Link / VPCエンドポイント経由 → インターネット経由なし
- 同一AZ: 0.1ms 以下
- Egress 料金なし

クロスプロバイダーは 1〜5ms のオーバーヘッドに加え Egress 課金が発生。

**判断基準**
- DB 呼び出しが多い同期処理 → 同一プロバイダー同一リージョンに寄せる
- 分析・非同期・バッチ → どこにあっても実害少ない
