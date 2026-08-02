---
title: 【TiDB】中国発DBがMySQLの玉座を狙っている話
description: TiDB の誕生・アーキテクチャ・ホスティング選択肢まとめ
aliases:
  - TiDB
tags:
  - database
  - distributed
  - mysql
  - tidb
draft: false
date: 2026-08-02
---

# 【TiDB】中国発DBがMySQLの玉座を狙っている話

動画: IT技術屋のボヤキ
URL: https://www.youtube.com/watch?v=GU2Nt55iEm0

## 誕生

2015年、北京のエンジニア3人がMySQLシャーディング地獄に嫌気。
Google Spanner論文(2012)をオープンソースで再実装 → PingCAP設立。

MySQLシャーディングの沼:
- テーブル手動分割 + 深夜データ移行
- JOINがシャードをまたげない
- トランザクション保証なし
- DBの都合がアプリコードに全部漏れる

## アーキテクチャ

3層構成:
- **TiDB** - SQLレイヤー(MySQL 5互換プロトコル)
- **TiKV** - 分散ストレージ(Raft合意アルゴリズム、3複製)
- **PD** - メタデータ・配置管理

シャーディングをシステムが自動。外からはただのSQL。

**HTAP**: 同じデータを行形式(トランザクション)と列形式(分析)の両方で保持 → 夜間バッチ&DWH転送が不要。

ACIDトランザクション維持。分散でも一貫性を捨てない。

## 立ち位置

従来の選択肢:
- 小規模 → MySQL/PostgreSQL(シングルノード、フルSQL)
- 大規模 → DynamoDB/Cassandra(分散、SQL捨てる)

TiDBの立ち位置: **大規模 + フルSQL + ACIDトランザクション**

MySQL互換プロトコル → ドライバもほぼそのまま移行可能。
シャーディング検討し始めた瞬間が乗り換えの分岐点。
小規模には過剰装備(複数ノード必須)。

## 実績

- **中国**: 美団・ビリビリ・北京銀行(金融系も)
- **日本**: PayPay・USEN-NEXT・カプコン・サイバーエージェント
- **海外**: Pinterest・Stripe・Atlassian

2018年CNCF寄贈 → 2020年卒業プロジェクト認定(Kubernetesと同じ財団)

## 世界展開

- PingCAP本社をサニーベール(CA)に設置
- Apache 2.0ライセンス維持(競合CockroachDBは2019年商用制限へ)
- コード全公開 → 透明性でバックドア疑念を打消し

MySQLが停滞中(Oracle傘下) → 既存資産の移行先争いが発生。
競合: MariaDB・Aurora・CockroachDB(PostgreSQL互換)。

## AIエージェント対応(2026)

PingCAP、TiDBを「AIエージェント向けDB」と再定義。

- エージェント並列動作で接続数・データ量が予測不能に膨張
- ベクトル検索をエンジン統合 → 専用ベクトルDB不要
- Manus・fy等が採用

## ホスティング選択肢

**TiDB Cloud (フルマネージド)**:
- **Serverless** - 使った分だけ課金、無料枠あり。お試し・小規模向け
- **Dedicated** - 専有クラスタ、HA・HTAP全機能。本番向け
  - AWS / GCP → GA
  - Azure → Public Preview(東日本リージョンあり)

**セルフホスト**:
- Kubernetes + TiDB Operator
- AWS EKS / GCP GKE / Azure AKS 全対応
- Terraform Provider あり
- 運用コスト重い
