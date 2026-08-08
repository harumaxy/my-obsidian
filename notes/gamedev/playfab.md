---
title: PlayFab
description: Microsoft製ゲームバックエンドBaaS
# permalink:  # don't use
aliases:
  - playfab
tags:
  - gamedev
  - backend
  - baas
draft: false
date: 2026-08-02
---

# PlayFab

Microsoft製 ゲーム特化 BaaS（Backend as a Service）。Azure上で動作。

## 何ができるか

- 認証（匿名/Steam/CustomID等）
- プレイヤーデータ保存
- リーダーボード
- マッチメイキング（マッチングのみ、通信は別）
- 経済システム（仮想通貨・アイテム）
- Analytics / PlayStream イベント収集
- CloudScript（サーバーサイド軽量ロジック）

## CloudScript

PlayFabサーバー上で動くJS/Azure Functions。
用途: チート防止・トランザクション・バリデーション。
権威サーバー（物理演算・当たり判定）には使えない。Godot Headlessとは別物。

## リアルタイム通信との関係

PlayFab = セッション外の状態管理専用。リアルタイム通信は別途必要。
- Microsoft系なら Azure PlayFab Multiplayer Servers（別製品・別料金）
- 一般的には Photon / Mirror / Fishnet + 自前ホスト

## Godot連携

公式SDKなし。非公式アドオン: [godot-playfab](https://github.com/Structed/godot-playfab)
- GDScriptネイティブ
- シグナルベースコールバック
- Steam(GodotSteam)連携対応
- Godot 4.3/4.4/4.5対応
- Dome Keeper が本番採用済み

## メリット・デメリット

### 使う意味がある場合

- 小規模チーム/インディーで運用コスト0にしたい
- リーダーボード・マッチメイキングを素早く動かしたい
- ゲームロジックに集中してバックエンドに時間かけたくない

### 微妙な点

- ベンダーロックイン強い
- Godot SDKは非公式 → 壊れたら自分で直す
- 複雑ロジックはCloudScriptで無理やり書く羽目に
- 無料枠超えると課金が読みにくい

### 代替

- 認証だけ → Firebase Auth / Supabase
- DB → Supabase / PlanetScale
- リーダーボード → Redis Sorted Set 自作

Godot + 個人開発なら過剰。Unity + 中規模スタジオくらいが刺さる。
