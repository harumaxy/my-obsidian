---
title: observability
description:
aliases:
  -
tags:
  -
draft: false
date: 2026-06-21
---

## OpenTelemetry (OTel) 統合

Spin は OpenTelemetry 標準をネイティブサポートしており、`spin otel` プラグインで簡単にセットアップできます。

### セットアップ

```bash
# プラグインのインストール
spin plugin install otel

# OTel 依存関係をセットアップ（Docker で自動起動）
spin otel setup

# Aspire Dashboard を使う場合
spin otel setup --aspire
```

### OTel スタック（デフォルト設定）

デフォルトでは以下のコンテナが起動されます：

| コンポーネント | 役割 |
|---|---|
| **Tempo** | トレース保存・表示 |
| **Loki** | ログ保存・表示 |
| **Prometheus** | メトリクス保存・表示 |
| **Grafana** | 統一ダッシュボード（全データソース集約） |
| **OTel Collector** | 各バックエンドへのルーティング |

代替として `.NET Aspire Standalone Dashboard` を選択可能（`--aspire` フラグ）

### 実行

```bash
# Spin アプリを OTel 環境変数と一緒に実行
spin otel up

# ダッシュボード（Grafana）をブラウザで開く
spin otel open

# セットアップをクリーンアップ
spin otel cleanup
```

### アプリケーション側の実装

#### Rust（WASM 環境）

WASM 環境では `opentelemetry` の初期化は不要です。Spin ランタイムが自動的に処理するため、アプリケーション側は単にログ出力するだけで十分です：

```rust
use spin_sdk::http::{IntoResponse, Request, Response};
use spin_sdk::http_service;

#[http_service]
async fn handle_request(req: Request) -> anyhow::Result<impl IntoResponse> {
    let url = req.headers()
        .get("spin-full-url")
        .and_then(|h| h.to_str().ok())
        .unwrap_or("unknown");

    // ログ出力（Spin ランタイムが自動で OTel に送信）
    println!("[{}] Handling request to {}", req.method(), url);

    Ok(Response::builder()
        .status(200)
        .header("content-type", "text/plain")
        .body("Hello Rust Wasm!".to_string()))
}
```

### テレメトリ確認方法

Grafana の「Explore」機能で各データソースを確認：

- **トレース**: Data Source → Tempo を選択、コンポーネント ID で検索
- **ログ**: Data Source → Loki を選択、job フィルタで検索
- **メトリクス**: Data Source → Prometheus を選択、メトリクス名で検索

### 自動設定の仕組み

`spin otel setup` が裏で行うこと：

1. **Docker Compose ネットワーク構築** - 複数コンテナが同一ネットワークで連携
2. **環境変数の自動設定** - `OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318`
3. **Grafana データソース自動登録** - Prometheus/Loki/Tempo の接続が自動設定される
4. **OTel Collector 設定** - 各テレメトリ種別が正しいバックエンドにルーティングされる

ラベルメタデータ（`com.docker.compose.*`）で Docker が管理します。

### 開発と本番での使い分け

- **開発時**: `--aspire` フラグでシンプルなダッシュボード
- **本番・複雑な環境**: デフォルト設定で Grafana 経由の詳細な可視化
