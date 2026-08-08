---
title: quilkin
description: EmbarkStudios製 Rust製 UDP プロキシ。大規模マルチプレイヤーゲームサーバー向け
# permalink:  # don't use
aliases:
  -
tags:
  - networking
  - gamedev
  - rust
draft: false
date: 2026-08-02
---

# Quilkin

- repo: https://github.com/EmbarkStudios/quilkin
- EmbarkStudios + Google 共同開発
- Rust製 非透過型 UDP プロキシ
- ベータ段階（API変更あり得る）
- Apache 2.0

## 何モノ

大規模マルチプレイヤーゲームサーバーの前段に置くプロキシ。
ゲームクライアント/サーバー側 改修不要で導入できる。

## 解決する問題

### サーバーIP隠蔽

```
クライアント → Quilkin(公開IP) → ゲームサーバー(非公開IP)
```

実サーバーIP非公開 → DDoS当たり先がプロキシになる。

### 不正パケット除去

フィルターチェーンで改ざん・不正パターンパケット破棄。
ゲームコードに書かなくていい。

### マッチメイキング後のルーティング

クライアント設定変更なしに Quilkin側ルーティング変更で接続先切替。

### テレメトリ一元化

全パケット通過点でレイテンシ・パケットロス率・接続数を計測。
100台サーバーのログ収集が一箇所で済む。

## なぜ UDP 専用か

ゲーム = 多少パケット落ちてもいいから速さ優先 → UDP。
Nginx/Envoy はTCP/HTTP前提 → UDP扱いが苦手。
Quilkin = UDP専用最適化プロキシ。

## アーキテクチャ

```
インターネット
  → Cloud DDoS保護（AWS Shield / Cloud Armor）← ボリューム吸収
  → Quilkin（不正パケットフィルタ・IP隠蔽）
  → ゲームサーバー
```

スケールアウト: Kubernetes前提設計 → Deployment複数Pod = 水平スケール。
Agones（Google製ゲームサーバー管理基盤）統合あり。

```
クライアント → L4 LB → [Quilkin x N] → ゲームサーバー
```

## DDoS対策の責務

Quilkin単体でDDoS解決はしない。

| | ゲームサーバー | Quilkin |
|--|--|--|
| 状態 | ステートフル（ゲーム進行中） | ステートレス |
| 落ちたら | ゲームセッション消滅 | 新インスタンスで即復旧 |
| スケール速度 | 遅い（重い） | 速い（軽い） |

DDoSでQuilkin落ちてもゲームサーバー無傷。Quilkinだけ再起動・増設すればいい。

Quilkinの役割 = 「DDoSを防ぐ」ではなく「ゲームサーバーを見えなくする＋不正パケット除去」。
DDoS対策はインフラ層（クラウドプロバイダ）の仕事。責務が違う。
