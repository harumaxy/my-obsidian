---
title: ComfyUI でゲーム用ピクセルアートアセット生成 + カラーパレット制限
description: 自作ゲーム アセット量産に ComfyUI を活用する方法。カラーパレット制限ノードで8bit/16bit質感を再現。
aliases:
  - comfyui pixel art game
tags:
  - comfyui
  - pixel-art
  - game-dev
  - ai-art
draft: false
date: 2026-07-19
---

# ComfyUI でゲーム用ピクセルアートアセット生成

元動画: https://www.youtube.com/watch?v=wrsYJ5gli1U
チャンネル: William (Code with Jam)

## 背景

- William が自作ゲーム開発中。アセット量産が必要
- 10万種モンスター等、全部手描き不可 → AI で量産
- 方針:
  - 主要キャラ・ストーリー場面 → 手描き
  - モンスター等の量産 → AI 生成 → 自分で修正

## ワークフロー

### 1. モデルロード

- ピクセルアート特化モデルを使用（例: `rzb-pixel-mix`）
- Civitai 等で入手
- **ライセンス確認必須**（`creative-ml-openrail-M` = 商用可、法令遵守条件）

### 2. プロンプト

- 正/負プロンプト + ベースサンプラー
- 参照画像でキャラ外観固定可

### 3. 解像度

- `512×768` or `768×512` でアスペクト比制御
- full body / half body 切替で詳細度調整

### 4. カラーパレット制限（重要）

GitHub: `ComfyUI-Extra-Nodes` の flatten ノード使用

色数指定で時代設定を再現:

- 256色 → Sega Genesis 風
- 16色 → NES / ゲームボーイ風
- 8色 → レトロ wash out
- 2色 → モノクロ

グラデーション除去 → フラットなピクセルアート質感に

## 要点

- AI = 「ベース下絵を素早く作るツール」。その後自分で修正・学習
- カラー制限ノードで 8bit/16bit 質感を数値で制御できる
- ライセンス確認を怠るな
