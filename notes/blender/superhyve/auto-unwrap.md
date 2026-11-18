---
title: Auto Unwrap 2
description: Milad の UV 自動展開アドオン。AI 生成 (UV なし) モデル向け。シーム自動配置、UDIM、$18
# permalink:  # don't use
aliases:
  - auto-unwrap
tags:
  - blender
  - superhive
  - uv
  - ai-mesh-cleanup
draft: false
date: 2026-11-18
---

# Auto Unwrap 2

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/auto-unwrap

## 価格・状態

- Full $18 (1席、個人・商用)。Studio $85 (5席超の組織)。
- 販売 1200+、評価 9件、公開約2か月前。GPL。
- 要件: Blender 4.2+ (ページ表記 4.1〜5.2)。**Windows / Linux** (ドキュメント基準。ページ上部は Mac 表記もあり食い違い。ドキュメント側が正と見る)。
- 25%オフクーポンあり (3日間)。
- パーツ分割 (Smart Segment 相当) を内蔵。別途購入不要。

## 4つのボタン

- **Unwrap (Organic)**: モデルを読み、必要な所にシームを入れ、全パーツを展開。隠れた面と対称線に沿って切る。キャラ・クリーチャー・スカルプト・AI 生成メッシュ向け。
- **Smart UV (Hardsurface)**: パーツごとの高速投影。モデル自身のラインに沿って切る。ミラーパーツは同じ場所を共有可。銃・乗り物・機械向け。
- **Garment Seams**: クアッドの衣類 (Marvelous Designer / CLO 書き出し) に、衣服デザイナーの切り方でシーム。約40着のアーティスト作品から学習。
- **Preview Seams**: 展開前にシーム位置を確認。

## 主な機能

- 「AI エンジン」を 1,200+ 個のパーツで再学習。シームがアーティストの置く位置に近づく。
- 展開は OptCuts ベースと記載 (ページ上)。
- Parts: 展開前にパーツ分割 (最大5,000)。シームはパーツ境界を越えない。Show Parts / Pick and Merge / Split。
  - 1 にするとエンジン任せ。人型は多め、ハードサーフェスは 8〜30。
- Seams: Less Stretch / Balanced / Fewer Seams。
- Pick Islands On Model、Redo Selected Island (他の島はそのまま)。
- 対称性: パーツ・シーム・UV がミラーされる。ミラー面にシーム。対称性スコア。
- ハードサーフェス: テスト車両で島 178 (Blender 標準 Smart UV は 563)。Optimize Layout で島を格子に整列。
- UDIM タイル配分 (Object / Balanced)、Stack Repeats (同一パーツの UV 重ね)、UV Orientation。
- 複数オブジェクト一括展開。最後に Blender 標準パッカーで全選択をテクセル密度統一・UDIM 維持。**手動 Pack Islands 不要**。

## 位置づけ

- AI 生成 (UV なし) モデルに「アーティスト水準の UV」を即付与、と明記。
- 3製品 ([[image-to-3d-milad]] / [[bizen3d]] / [[genmesh]]) の docs に UV 記載がないので、UV を詰めたいならここが埋め役。

## 関連

- 前段: [[smart-remesh]]
- 同作者: [[mk-smart-segment]]
