---
title: ComfyUI エコシステム・カスタムノード
description: ゲームアセット・キャラクターデザイン向けカスタムノードとリソース
aliases:
  - ComfyUI カスタムノード
tags:
  - comfyui
  - stable-diffusion
  - game-assets
draft: false
date: 2026-07-25
---

# ComfyUI エコシステム・カスタムノード

## まず入れるもの

- **ComfyUI-Manager** — カスタムノード管理。他全部これ経由でインストール

## カスタムノード（ゲームアセット視点）

### 必須

- **ComfyUI-Impact-Pack** — Detailer（顔・手自動修正）、SEGSマスク処理
- **ControlNet Auxiliary Preprocessors** — ポーズ・深度・線画・法線マップ抽出
- **rgthree-comfy** — ノード整理UI、Bookmark、高速ループ処理

### 効率化

- **Efficiency Nodes** — 主要ノード群を1つに圧縮。ワークフロー見通し改善
- **ComfyUI-Custom-Scripts** — プリセット保存、画像比較、自動補完
- **WAS Node Suite** — バッチ処理、ファイル保存パス制御、テキスト操作

### 高度・特殊用途

- **ComfyUI-AnimateDiff-Evolved** — 2Dアニメーション素材生成
- **ComfyUI Segment Anything (SAM)** — 任意オブジェクト切り抜き自動化
- **ComfyUI-BRIA-Background-Removal** — 背景除去
- **Ultimate SD Upscale** — タイル分割高解像度化（アップスケール品質高）

## モデル・LoRA探し

- **[Civitai](https://civitai.com)** — モデル・LoRA配布。ゲーム系・ピクセルアート多数。ワークフロー `.json` 付きモデルはそのまま読み込める
- **[Tensor.Art](https://tensor.art)** — ゲーム系モデル充実

### 検索キーワード（Civitai）

- `pixel art` `game asset` `character sheet` `sprite`
- `isometric` `top-down` `RPG`

## 学習リソース

### YouTube

- **Olivio Sarikas** — 基礎〜応用、ゲームアセット向けあり
- **Sebastian Kamph** — ワークフロー解説、実践的
- **Matteo Penzo** — 高度ワークフロー、ゲーム向け多め

### ドキュメント・サイト

- [ComfyUI Wiki](https://comfyui-wiki.com) — ノード解説網羅
- [ComfyUI公式 Examples](https://github.com/comfyanonymous/ComfyUI_examples) — 公式サンプルワークフロー

### コミュニティ

- Reddit: `r/comfyui` `r/StableDiffusion`
- Discord: ComfyUI公式、Stable Foundation
- X(Twitter): `#ComfyUI` `#StableDiffusion`

## ゲームアセット向けワークフローパターン

### キャラクターシート（多角度）

ControlNet OpenPose + Reference Only → 同一キャラ複数アングル生成

### バッチ量産

WAS Node Suite のファイルループ + プロンプト変数化 → 連続生成

### アップスケール（高品質）

Ultimate SD Upscale → タイル分割でVRAM節約しつつ高解像度化

### 背景除去 → ゲームエンジン素材化

SAM / BRIA → PNG透過出力 → Unity/Godot直接利用可
