---
title: v-sekai
description: OSSソーシャルVRプラットフォーム。Godot + Elixir構成。
aliases:
  - V-Sekai
tags:
  - godot
  - vr
  - vrchat
  - vrm
  - elixir
  - multiplayer
draft: false
date: 2026-08-02
---

# V-Sekai

https://github.com/V-Sekai/v-sekai-game

OSSのソーシャルVRプラットフォーム。VRChat的なことをGodot + Elixirで再現する試み。

## 構成

```
クライアント/ゲームサーバー: Godot 4 (GDScript)
バックエンドAPI: Elixir / Phoenix (URO)
DB: CockroachDB
キャッシュ: Redis
フロント: Next.js
リバプロ: Caddy
```

## アバター

- **VRM** 形式メイン（glTF拡張、VRChat互換）
- 許可拡張子: `.vrm` `.glb` `.scn`
- スケルトン: 57ボーン Humanoid定義（`humanoid_data.gd`）
- VRM準拠 → 異なるリグをリターゲット吸収
- Godot内でアバターアップロード完結（Unity不要）

## URO (バックエンド)

- **役割**: アカウント・アバター・マップのデータ管理のみ。ゲームロジックなし
- ファイルストレージ: **Waffle** ライブラリ（S3互換 or ローカル、config依存）
- クライアントからは `godot_uro` addon がHTTPで叩く
- Elixir採用理由: Phoenix PubSub + BEAM の大量WebSocket接続耐性。ただしADR文書なし

## ゲームサーバー

- **Godotヘッドレスビルド** = ゲームサーバー本体
- 1プロセス = 1ワールドインスタンス（VRChatのinstance概念と同じ）
- 起動: `godot --headless -- --dedicated --map <map> --port 7777 --max_players 32`
- ネットワーク: **ENet**（Godot組み込みUDP）

### サーバーモード3種
- `dedicated` — 純粋ゲームサーバー（プレイヤーなし）
- host/client hybrid — ホスト兼プレイヤー
- relay — P2P中継（VRChatインスタンスオーナー方式に近い）

## addons 構成（41モジュール）

- `network_manager` — ENet / RPC / 物理 / エンティティ / 状態同期
- `godot_uro` — URO APIクライアント（HTTP Pool）
- `vsk_avatar` — ボーン / IK / ハンドポーズ
- `vrm` — Godot VRM実装
- `Godot-MToon-Shader` — トゥーンシェーダー
- `godot_speech` — VoIPパケット符号化・復号化
- `sar1_vr_manager` — HMD / トラッカー管理
- `godot-xr-tools` — XR統合
- `vsk_importer_exporter` — コンテンツバリデーション + アップロード
- `entity_manager` — ゲーム内エンティティ管理
- `state_machine` / `godot_state_charts` — ステートマシン

## VRChatとの比較

| | VRChat | V-Sekai |
|---|---|---|
| アバター作成 | Unity + 独自SDK | Godot内完結 |
| フォーマット | VRM / FBX | VRM / GLB |
| ゲームサーバー | Unity headless | Godot headless |
| バックエンド | 非公開 | Elixir / Phoenix (OSS) |
| 状態 | 製品 | プレリリース / 実験的 |
