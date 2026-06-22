---
title: How to Choose Your Multiplayer Backend
description: ゲームのマルチプレイバックエンド選択ガイド
permalink: /youtube/multiplayer-backend
aliases:
  - マルチプレイ
  - ネットコード
tags:
  - game-development
  - networking
  - backend
  - multiplayer
draft: false
date: 2026-06-22
video_url: https://www.youtube.com/watch?v=sT0UPlJ2cpc
channel: BatteryAcidDev
---

# How to Choose Your Multiplayer Backend

> ゲーム開発初心者～中規模スタジオ向けのマルチプレイサーバー構築戦略ガイド

## サーバーの役割

サーバーは**フィールド（接続場所）**と**審判（ルール執行）**の2つの役割を担う。

- **フィールド**：プレイヤーを一箇所に集める
- **審判**：公正性を保証し、チート防止

### サーバー権限パターン

- **Server-Authoritative**（推奨）：サーバーが真実の唯一ソース
- **Client-Authoritative**（非推奨）：クライアント側で入力を信頼（チート対象）
- **Hybrid**：バランス型だが長期的に問題化しやすい

## 5つのバックエンド選択肢

### 1. Dedicated Server Build

```
Game Engine (Unity/Godot)
  ├─ Client Code
  └─ Server Code（同じプロジェクト内）
      ↓
  Dedicated Server Build（Linux推奨）
      ↓
  デプロイ先：AWS GameLift, Unity Game Hosting, EC2
```

**特徴**
- ゲームエンジン本体のネットワークAPI（RPC, Sync Variables, Network Transform等）
- TCP/UDP ベースの低遅延通信
- 完全なサーバーサイドシミュレーション

**適用ゲーム**：FPS, 格ゲー, リアルタイムアクション, 高速マッチング必須

**コスト**：最も高い（常時インスタンス必要）

**デプロイ先別コスト**
| サービス | 特徴 |
|---------|------|
| AWS GameLift | フリート管理、マッチメイキング、スケーリング対応 |
| Unity Game Hosting | Unity エコシステム内で統一可能 |
| AWS EC2 | シンプルだが手作業が多い |

**重要**：Linux デプロイを選ぶ（Windows より大幅に安い、業界標準）

### 2. WebSocket

```
Game Client
  ↓ HTTP ベース継続接続
Lambda/WebSocket Server (Serverless)
  ↓ ゲームセッション処理
```

**特徴**
- HTTP ベースの軽量接続
- 手動でメッセージ設計・管理が必要（JSON等）
- Serverless 実装で接続時間のみ課金

**適用ゲーム**：カードゲーム、ターン制ゲーム、実時間戦略（RTS）ゆっくり進行

**コスト**：低い（セッション時間のみ課金）

### 3. Custom Networking

UDP/TCP の低レイヤーAPIを直接制御。KCP等の改良版プロトコルもある。

**適用**：高度なチューニングが必要な中～大規模スタジオ向け

### 4. Peer-to-Peer（P2P）

**非推奨**（本番環境）。開発・テストのみ。スケーリング・セキュリティの問題。

### 5. WebRTC

ブラウザベースの直接P2P接続。Godot/Unity でも対応開始。

**適用**：ドローン操作、ビデオチャット + ゲーム等の一部ユースケース

## 設計時の判断軸

```
意思決定フロー
  ↓
1. シミュレーション要件
   ├─ 重い（物理演算、衝突検出等）→ Dedicated Server
   └─ 軽い（ターン制） → WebSocket
  ↓
2. コスト
   ├─ 最小化 → Serverless / WebSocket
   └─ パフォーマンス重視 → Dedicated Server
  ↓
3. ゲームタイプ
   ├─ リアルタイム → Dedicated Server（TCP/UDP）
   └─ 非リアルタイム → WebSocket
```

## Serverless 活用パターン

ゲームロジックとは別に、以下を serverless で実装：

**非同期処理（遅延OK）**
- IAP（課金処理）
- Steam/Platform 認証
- チャットシステム
- マッチメイキング/ロビー
- 実績判定
- 分析/ログ収集

**時間経過イベント（AWS Step Functions）**

```
クライアント："資源採掘開始"
  ↓
Lambda: Step Functions をキック（30分スケジュール）
  ↓
30分経過
  ↓
Lambda: コールバック実行
  - プッシュ通知送信
  - DB更新
  - SNS通知
  ↓
クライアント：バックグラウンドで結果反映
```

**メリット**
- ゲームサーバー負荷軽減
- オンデマンド課金（常時稼働不要）
- 言語選択自由（Python, Node, Go等）
- ゲーム進行をブロックしない

## 重要な注意点

**Server Build のサイズ管理**
- ゲームサーバービルドは「scenes」「scripts」のみ
- UI アセットを含めると肥大化 → 早期に検出・修正が必須
- 後付けは技術的債務が膨大に

**クライアント側のシミュレーション**
- 採掘・建設等の時間経過は**ローカルで表示**
- サーバーからの確定値で同期（チート防止）
- オフライン状態での整合性が課題

## 実装選択のアドバイス

### 初心者・小規模スタジオ
→ WebSocket + Serverless から始める方がコスト効率的

### やることリスト
1. 実際のシミュレーション要件を洗い出す
2. 遅延要件を明確にする
3. 同期頻度を決定する
4. "なぜ Dedicated Server が必要か"を正当化できるか検証

多くの開発者は「とりあえず Dedicated Server」と思い込んでいるが、実は WebSocket で十分な場合が多い。

