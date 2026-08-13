---
title: なぜただ時間で並んだだけのデータに専用のDBが生まれたのか
description: 時系列データベース(TimescaleDB)誕生理由と導入方法まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - timescaledb
  - postgresql
  - database
draft: false
date: 2026-08-09
---

元動画: https://www.youtube.com/watch?v=pTmUF9xnykE (IT技術屋のボヤキ)

## 時系列データ 3特性(業務データと真逆)

1. 書込み一方向に増え続ける(蛇口全開)
2. 追記のみ、書き換えなし(過去確定)
3. 新しいほど精密、古いほど粗くて良い

業務データ = 1件1件大事、書換え前提、全部精密保持。真逆の性質。

## 普通DBが辛い理由

1件ずつ丁寧扱う設計(宝石箱型)。インデックスがデータと一緒に肥大化。古いデータの一括削除も苦手。

## TimescaleDB の解法

- ゼロから新設計せず、PostgreSQLの上に乗る形(拡張機能)
- データを時間で自動区画分け(チャンク)。最新チャンクは軽量高速書込み、古いチャンクは自動圧縮
- 集計(1時間平均等)も差分更新、全件再計算しない
- さらに割り切り: 古いデータは粗い集計だけ残し生データ捨てる「賢く忘れる」設計(retention policy)

## 向いてるユースケース

- IoTセンサー値(機械稼働データ、温湿度等)
- サーバー監視メトリクス(CPU/メモリ/レイテンシ)
- 金融の値動き(株価、暗号資産)
- アクセスログ

共通条件: 一方向増加・追記のみ・新しいほど精密で古いほど粗くて良い、の3条件満たすデータ。逆に注文情報等、都度書き換える業務データには不向き。

## 置き換えではなく併用

主力DB(業務用)を置き換えるものではなく、隣に配置して時系列部分だけ任せる適材適所が基本形。同じPostgreSQLインスタンス内で業務テーブルと時系列テーブル共存も可能(JOINも通常通り)。

類似DB: InfluxDB(監視特化)、QuestDB(取込速度特化)。Messari社(暗号資産データ)はInfluxDB→TimescaleDBに移行し読み書き速度向上した実例あり。

## 導入方法

マネージド/セルフホスト両方あり。

- **マネージド**: Timescale Cloud(旧名、現Tiger Data)。フルマネージド、拡張機能最初から有効
- **セルフホスト**:
  - ワンライナー: `curl -sL https://tsdb.co/start-local | sh`
  - Docker: `docker run -d -p 6543:5432 -e POSTGRES_PASSWORD=xxx timescale/timescaledb-ha:pg18`
  - 既存PostgreSQLへ追加: apt/rpmで`timescaledb-2`パッケージ→`CREATE EXTENSION timescaledb;`

## 既存RDBと同居 or 別インスタンス

技術的にはextensionなので同一インスタンス・同一DB内で共存可能。

**同居で良いケース**: 書き込み量少〜中規模、業務データと時系列データJOINしたい要件あり、運用対象減らしたい小規模プロジェクト

**別インスタンス推奨ケース**: 時系列側書込み激しい、`timescaledb-tune`が書込み特化にpostgresql.conf調整するため業務系最適設定と競合しうる、スケーリング特性違う、メンテナンスウィンドウ分離したい

最初は同居で試し、書込み負荷/運用要件次第で分離検討が定石。

## AWS/GCPで統一したい場合

**セルフホスト必要。** RDS for PostgreSQL、GCP Cloud SQLは共にtimescaledb拡張非対応(サポート対象extensionリストになし)。

- EC2 / GCE インスタンスに直接インストール(apt/docker)
- EKS / GKE 上にコンテナで運用

補足: Azure Database for PostgreSQL Flexible Serverは対応(唯一の例外的マネージド選択肢)。Timescale CloudはAWS上でホストされてる裏側構成だが管理はTimescale社、AWSアカウント内完結にはならない。運用(パッチ適用、バックアップ、圧縮ジョブ監視等)は自前になる。
