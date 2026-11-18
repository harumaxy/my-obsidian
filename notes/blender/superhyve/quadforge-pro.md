---
title: QuadForge Pro
description: AI・スキャンメッシュの掃除 → QuadriFlow でクアッド化 → 手描きリトポ → UV シーム → LOD → 3D プリント分割。$39、公開8日、評価なし
# permalink:  # don't use
aliases:
  - quadforge-pro
tags:
  - blender
  - superhive
  - retopology
  - lod
draft: false
date: 2026-11-18
---

# QuadForge Pro

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/quadforge-pro

## TL;DR

- **自動 + 手動のリトポ**、UV シーム、LOD、3D プリント分割までを 1 つに。Quad Draw 風の手描きツール (PolyPen など) が入っているのが他と違う。
- 自動部分は **Blender 標準の QuadriFlow を土台にした掃除 + チェック** ([[quadmend]] は 2 エンジン)。
- 公開 8 日、評価なし、Windows のみテスト。実績ゼロ。$39。
- 主力キャラで**関節ループを自分で引きたい**ときの選択肢。ただ Blender 標準機能と無料アドオン (RetopoFlow など) の領域とも被る。

## 価格・状態

- 作者 alastorv。$39 (Pro)。Lite (手描きリトポのみ) は別売。評価なし、販売数不明。
- Blender 4.2 LTS〜5.x。テストは Windows のみ (Mac・Linux 未テスト)。GPL-3.0-or-later。

## 機能

- Mesh Prep: 小穴を埋める、浮いた破片を落とす、壊れたカスタムノーマルを消す。元メッシュは触らない。
- Poly Budget: 指定面数に近い全クアッド (または三角形) に再構築。対称。元からノーマル・テクスチャをベイク。
- 手描きリトポ (Shift+Q のリングメニュー): Contours、PolyStrips、PolyPen (開いた辺からクアッドを伸ばす)、Patches、Strokes、ブラシ。元に吸着し、服など層状メッシュに強い。ライブ対称、Quad Draw のキーマップ。
- 品質マップ: 面の良し悪しを色分け (緑 = 良、黄・赤 = 引き伸ばし/ねじれ、白点 = 極)。
- セクション → UV シーム: 頭・顔・首などのグループ境界をシームにして展開。シャープ・角度からのシームも。
- LOD チェーン: シームとシャープを保ち、GLB / FBX で Unity / Unreal / Godot の命名規則に合わせて出力。
- Print Split: 平面/自由描画で切断、位置合わせピン、水密チェック、STL 出力 (Bambu・Prusa・Ender・レジンのプリセット)。

## 注意

- 説明は機能の宣伝文のみで、自動リトポの品質データ (成功率・実測) の記載なし。
- Print Split はゲーム用途では不要。

## 関連

- [[quadmend]] (自動のみ、実測データあり) / [[smart-remesh]] / [[mesh-prep-studio]]
