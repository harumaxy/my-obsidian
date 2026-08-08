---
title: Nodot — Godot 4 ノードコンポジションライブラリ
description: FPS/TPS/RTS 向けゲームロジック部品集。コンポジション設計で自由に組み合わせ可能。
aliases:
  - nodot
tags:
  - godot
  - addon
  - game
draft: false
date: 2026-08-02
---

# Nodot

https://github.com/NodotProject/nodot

Godot 4 向け ノード/Autoload/Scene コレクション。テンプレートではなくコンポジション部品集。

## インストール

Godot アドオンストアから、または `addons/` にコピーして Plugin 有効化。

## 設計思想

- `NodotCharacter3D`（CharacterBody3D 継承）が StateMachine 自動生成
- `CharacterExtensionBase3D` を子ノードに追加 → SM に自動登録
- ロジックノード自体はグラフィックなし。ビジュアルは外部ノードを `@export` で差し込む
- 自作拡張は `CharacterExtensionBase3D` を継承して子に置くだけ

## カテゴリ一覧

### character

- `NodotCharacter3D` / `CharacterExtensionBase3D` — ベースクラス
- **Locomotion3D**: Move / Jump / Idle / Crouch / Prone / Climb / Swim / Fly / ZeroGravity
- **FirstPerson**: キャラクター・アイアンサイト・アイテムスウェイ・入力(KB/Mouse/Joypad)
- **ThirdPerson**: キャラクター・カメラ・入力(KB/Mouse/Joypad)
- **RTS**: マウス入力・ユニット選択

### physics / detection / interaction

- `Mover3D` / `WaterArea3D`
- `HitBox3D` / `PlaneGate3D` / `StepUp3D` / `ViewCone3D`
- `Health` / `DamageArea3D` / `Burnable3D` / `Ladder3D` / `Teleport3D` / `Outline3D`
- `RigidBreakable3D` / `StaticBreakable3D` — HP ゼロで replacement_node に差し替え
- `RigidCollectable3D` / `StaticCollectable3D` / インタラクト可能オブジェクト系

### animation

- `NodotAnimationTree` — AnimationTree ラッパー
  - `parameters/` プレフィックス省略 API
  - `fire_oneshot` / `abort_oneshot` / `travel_state`
  - `lerp_blend_amount` / `lerp_blend_position` — lerp 込み操作
  - パラメータキャッシュ（`get_property_list()` 毎回走らせない）

### その他

- controls: Accordion / AccordionStack（UI）
- sound / effects / shaders / hud / gui / menus / debug / utility / signaling / filesystem

## サンプルプロジェクト

- FPS: https://github.com/NodotProject/nodot-fps
- 3D プラットフォーマー: https://github.com/NodotProject/konna3d
- RTS: https://github.com/NodotProject/nodot-rts
- マルチプレイ FPS: https://github.com/NodotProject/nodot-multiplayer-fps

## ドキュメント

https://nodotproject.github.io/nodot
