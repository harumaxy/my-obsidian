---
title: DatabricksのOLAP×OLTP両刀の次世代DBアーキテクチャ「LTAP」を深堀る
description: OLTP と OLAP のストレージ層を Iceberg/Delta Lake で統合し、ETL 不要でリアルタイム分析を実現する Databricks の新アーキテクチャ。
# permalink:  # don't use
aliases:
  - ltap-databricks
tags:
  - databricks
  - database
  - oltp
  - olap
  - data-engineering
  - iceberg
draft: false
date: 2026-06-25
---

## 一言で言うと

**PostgreSQL 互換 DB と分析エンジンが、同じ Iceberg ファイルを直接読み書きする。ETL 不要。**

## 課題：従来の OLTP/OLAP 連携

```
アプリ → PostgreSQL ─┐
                      ├─ ETL → Redshift → 分析
分析ツール  ──────────┘
```

- ETL パイプラインのコスト・運用負荷
- データコピーによる二重管理
- 同期遅延でリアルタイム分析が困難

## LTAP のアプローチ

```
アプリ → Lakebase (Postgres互換) ─┐
                                    ├─ Iceberg/Delta Lake（単一ストレージ）
分析エンジン (Spark/Photon) ────────┘
```

**コンピュート層は分離、ストレージ層は統合。**

- WRITE: Lakebase (OLTP) が Postgres 互換 API でアプリから受け付け
- STORE: Mooncake Labs 由来の技術で列指向に変換し Iceberg 形式で保存（圧縮率 10〜100倍）
- READ: 分析エンジンが同じ Iceberg ファイルを直接参照

## Lakebase の進化 (2025〜2026)

| 機能 | 概要 |
|------|------|
| Autoscaling | 負荷に応じた自動スケール |
| ブランチング・インスタントリストア | 開発・テスト用の DB 分岐 |
| Lakehouse Sync (CDC) | 変更データキャプチャ |
| Lakebase Search | ベクトル検索・全文検索 |

## AWS との対比

| 役割 | AWS | Databricks (LTAP) |
|------|-----|-------------------|
| OLTP | PostgreSQL / Aurora | Lakebase (Postgres互換) |
| OLAP | Redshift | Spark / Photon |
| 連携 | ETL (Glue など) | **不要（共通 Iceberg）** |

## 現状

- Data+AI Summit 2026 で発表
- **現時点では "Coming Soon"**
- 実装詳細の完全公開は今後

## 参考

- [Zenn: DatabricksのOLAP×OLTP両刀の次世代DBアーキテクチャ「LTAP」を深堀る](https://zenn.dev/nttdata_tech/articles/e1e7bc7aeb9b20)
- 著者: 井能武 (NTTデータ Databricksビジネス推進室)
