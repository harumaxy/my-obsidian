---
title: MK Smart Segment
description: Milad のメッシュ自動パーツ分割アドオン。厚み+凹み検出、スライダー即時、手動結合。AI 生成の一体メッシュ向け
# permalink:  # don't use
aliases:
  - smart-segmention
  - Smart Segmentation
tags:
  - blender
  - superhive
  - segmentation
  - ai-mesh-cleanup
draft: false
date: 2026-11-18
---

# MK Smart Segment

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/smart-segmention-

## 状態

- 販売 300+、評価 2件、公開3か月前。Blender 4.2〜5.2。GPL。価格は未取得。
- 純 Python、外部依存なし。任意のメッシュで動く。
- 25%オフクーポン対象 (同作者)。

## 概要

- 一体メッシュを自然なパーツに自動分割し、手動で補正してから確定。
- 「AI 生成モデルの融合ブロブを頭・服・靴などに分ける」用途と明記。リグ・テクスチャ・3D プリントの下準備にも。

## 仕組み (docs より)

- Analyze Model を1回押す (数秒)。**各点での厚み**と**表面が内側に折れる場所**を測り、その信号で切る。
- 以降のスライダー操作は即時 (再計算なし)。
- Boundary Refinement: 境界を高解像度メッシュの実際のクリースに吸着。Stiffness (既定 0.6)、Band Width で制御。
- 厚み推定 (Shape Diameter Function 系) + 凹み検出の組み合わせと推測。

## 機能

- Parts スライダー (ライブ)、Auto (自然な分割数)。
- Brush / Lasso / Box で手動結合 (Ctrl で消去、Ctrl+Z、Shift+Click で対象切替、Enter 確定)。カメラ側の面のみ対象。
- Pick & Merge、Merge Selected Faces。結合は**ジオメトリで記憶**され、パーツ数変更後も残る。
- 領域ごとに分割数を指定 (体は1つ、腕は5分割など)。Apply & Pick Next で積み重ね。
- Explode プレビュー。
- 出力: パーツごとに別オブジェクト (切断面は自動で蓋、専用コレクション) or パーツごとに別マテリアル。Min Part Faces で小片を破棄。
- 30万面超ではライブ更新オフ。

## 位置づけ

- [[auto-unwrap]] にも同種のパーツ分割が内蔵。単体で使うのは分割結果自体が欲しいとき (リグ前の分離、パーツ別テクスチャ、プリント)。

## 関連

- [[image-to-3d-milad]] / [[smart-remesh]] / [[auto-unwrap]]
