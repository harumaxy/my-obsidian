---
title: Mesh Prep Studio Toolkit Helper
description: 掃除 → 面数削減 → リメッシュ → UV → ベイク → 出力を 1 パネルに。Auto HP→LP ワンボタン。$22、評価4.0 (1件)。アニメ用トポロジーではないと明記
# permalink:  # don't use
aliases:
  - mesh-prep-studio
tags:
  - blender
  - superhive
  - retopology
  - bake
draft: false
date: 2026-11-18
---

# Mesh Prep Studio Toolkit Helper

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/ai-mesh-toolkit-helper

## TL;DR

- **Blender 標準機能を 1 パネルにまとめた準備ツール**。クリーンアップ → 面数削減 → ベース作成 (Instant Meshes / QuadriFlow / Voxel) → Smart Project UV → Cycles ベイク → FBX / GLB / OBJ。
- Auto HP→LP はワンボタン。ただし作者が「**アニメ・リグ用のトポロジーではない**。手作業のリトポが要る」と明記。
- 独自アルゴリズムの記載は薄い。[[quadmend]] (AI メッシュ修復 + 2 エンジン + 実測データ) の方が AI メッシュに特化。
- $22、評価 4.0 (1件、「動画チュートリアルがほしい」)、公開 7 か月。優先度低。

## 価格・状態

- 作者 DanilGOE ([[autocharacters]] と同作者)。Personal $22 / Commercial $44。販売 30+、評価 4.0 (1件)。
- Blender 3.6 / 4.x / 5.x (対応表記 4.0〜5.1)。Win / Mac / Linux。ベイクのみ Cycles が必要。GPL。

## 機能

- Fix Mesh (重複頂点結合、穴埋め、法線再計算、スムーズシェード) / Remove Errors (重複面・浮いた形状のみ)。
- 面数削減: 目標面数指定。境界・UV シームの保持。
- リメッシュ基盤: Instant Meshes (QuadriFlow フォールバック、Voxel Remesh)。目標面数、スムージング。
- Auto HP→LP: 複製 → リメッシュ → Shrinkwrap → Smart Project UV → Albedo/Normal ベイク → 法線整理 → Principled BSDF 配線。
- Texture Projection: 自作の低ポリに、高ポリのテクスチャを転写。
- 出力: FBX / GLB / OBJ。.blend の保存が必須 (ベイク PNG の保存先)。

## 注意

- UV は Smart Project のみ。品質は [[auto-unwrap]] や [[quadforge-pro]] のシーム機能に劣る (推測)。
- 開発者が更新・動画チュートリアルを約束した (6か月前)。

## 関連

- [[quadmend]] / [[quadforge-pro]] / [[smart-remesh]]
