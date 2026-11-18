---
title: Texturaizer
description: ComfyUI API を Blender から使うフロントエンド。オブジェクト・マテリアル別プロンプト、PBR 生成、ビルボード。評価5.0 (8件)。Blender 4.5 まで
# permalink:  # don't use
aliases:
  - texturaizer
tags:
  - blender
  - superhive
  - comfyui
  - texture
draft: false
date: 2026-11-18
---

# Texturaizer

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/texturaizer

## TL;DR

- **Blender ↔ ComfyUI の橋渡し**。ComfyUI は既に Windows PC (RTX4080) で運用中なので、前提は満たしている。
- 強み: マルチパスのレンダリングを ControlNet 等に流し、**オブジェクト・マテリアルごとに別プロンプト**で 1 回生成。PBR マップ生成、タイリング、ビルボード/ポスター。
- 弱み: **Blender 4.2〜4.5 まで**。公開から約 2 年 (v0.2.5)。Blender 5 系は未対応表記。
- ゲーム用のキャラ・モブのテクスチャ量産 (腐肉など) に使えそうだが、Blender 5 を使うなら現状は不可。優先度低〜中。

## 価格・状態

- 作者 Latent Space Directive。Educational $36 (非商用) / Individual Commercial $78 / Shared (2〜5人) $249 / Small Studio (〜10人) $499。永久ライセンス。
- 販売 100+、評価 **5.0 (8件)**。Blender 4.2〜4.5。GPL。

## 機能

- ComfyUI ローカル実行 (リモートサーバーも可)。オープンソース。専用 ComfyUI ノードパックが付属。
- Stable Diffusion / Flux、LoRA、ControlNet、スタイル/画像プロンプト。
- バックグラウンドのマルチパスレンダリング。ビューア・履歴パネルを Blender 内に。
- PBR シェーダー自動生成、タイリング、シームレステクスチャ、プリセット。
- ビルボード・ポスター: 背景アセットの生成。
- カスタムワークフロー (Blender 内か ComfyUI の Web UI)。

## レビュー

- 全員 5 星。「ComfyUI をよく理解している」「フォルダ探しの手間が消える」。
- 初心者は ComfyUI のセットアップに学習曲線あり。Flux モデルが UNET フォルダだと見つからない件は設定 (Checkpoint / Diffusion / UNET の切替) で解決。
- 最新レビューは約 1 年前。

## 使い所の見立て (推測)

- 3D キャラへのテクスチャ・見た目の方向性出し。ただし 2D 画像のテクスチャ → UV への落とし込みは別作業。
- ゲーム用 PBR は、ComfyUI 単体 (Windows PC) でも足りる。Blender 内で完結したい場合の利便性が価値。
- Blender 5 系で使えない間は、[[pixel-local-ai]] や ComfyUI 直接利用の方が現実的。

## 関連

- [[image-generator-2]] (クラウド型) / [[pixel-local-ai]]
