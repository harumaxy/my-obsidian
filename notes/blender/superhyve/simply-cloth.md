---
title: Simply Cloth Studio
description: Blender 内で型紙から服を作る布シミュ補助アドオン。Studio $36 / Cut & Sew 型紙200+付き $66。所持済み・未使用
# permalink:  # don't use
aliases:
  - simply-cloth
tags:
  - blender
  - superhive
  - clothing
  - cloth-simulation
draft: false
date: 2026-11-18
---

# Simply Cloth Studio

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/simply-cloth

ユーザー所持済み (購入後未使用)。ページ記載ベース、動作検証なし。

## TL;DR

- Blender 内の**布シミュのセットアップ補助 + Cut & Sew (型紙から服を作る)**。Marvelous Designer の簡易版の位置。
- 出力は「体に落としてベイクした服メッシュ」。体型追従・リトポ・UV・ウェイトは別作業。
- 外部ソフトへの往復なし (Blender 内完結)。量産フローに入れやすい。
- 柔らかい服 (ドレープ、マント、ジャケット) 向け。SF のボディスーツ・アーマーなど硬い服は手モデリングの方が速い (推測)。

## 内容

- 作者 VjaceslavT。v2.0 は Blender 5.0 以降向けの作り直し (新 UI、パフォーマンス改善)。
- 素材プリセット (シルク、デニム、コットン)、風、ピン、衝突・自己衝突。
- Cut & Sew: 平面の型紙を作る/既製テンプレートを使う → 辺・頂点で縫製 → 体に落とす。
- v2 新機能: Adaptive Wrinkle (皺認識) と皺マップ用 Adaptive Subdivision。
- Cloth スカルプトブラシ、キーフレームのベイク、Geometry Nodes 互換。
- ドキュメントは英語・日本語。

## 価格

- Studio 2.0 $36 (全機能)。
- Studio + Cut & Sew Asset Library $66 (型紙 200+)。
- 5 席スタジオ $270。全版で商用可 (スタジオ・チーム利用はスタジオ版)。
- 更新は無期限 (その版の開発が続く限り)。
- 無料のサンプル・テストアセットあり。Example Pack (9 シーン) は購入時に差額精算。

## 同作者の関連

- Simply Clothing Pack (別売): 同じ 200+ 点を**シミュ済みの完成服**にしたもの。このアドオン不要。
- Simply Tear: Lite 機能が内蔵、Pro は別作者の別売。

## 使い方メモ (推測)

- 既製の服で足りないとき、1 着だけ作る用途。量産の主軸にはしない ([[character-clothing-workflow]])。
- ゲーム用は仕上げに、リトポ + ノーマルマップ焼き込み + ウェイト転写が要る。
- 体型 morph に追従させるには、服側にもシェイプキーが必要 (Blender 一般の仕組み、ページ記載なし)。

## 関連

- [[autocharacters]] (自作服の取り込みは v3.1 予定。現状は親子付け + ウェイト転写)
- [[adaptive-auto-skinning]] (服のウェイト)
