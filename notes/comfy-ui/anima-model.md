---
title: anima-model
description: 画像生成AI Anima モデルの概要・ComfyUI 配置・アーキテクチャ理解
aliases:
  - Anima
tags:
  - comfyui
  - image-generation
  - anime
draft: false
date: 2026-07-28
---

# Anima

CircleStone Labs × Comfy Org 製 アニメ特化 テキスト→画像モデル。

- 2B パラメータ
- アーキテクチャ: DiT 系 (SDXL/SD1.x とは別物)
- テキストエンコーダ: **Qwen-3 LLM** (CLIP でなく LLM でプロンプト解釈)
- 学習データ: アニメ数百万枚 + 非アニメ芸術80万枚。合成データ不使用
- ライセンス: 非商用のみ (CircleStone Labs Non-Commercial License)

## リリース

- 2026/03: Preview 2
- 2026/04: Preview 3 Base
- 2026/05/15: 正式版 `anima-base-v1.0`

## バリアント

- **Base**: 未調整。LoRA 学習ベース向け。スタイル多様
- **Aesthetic**: 高品質画像で fine-tune。プロンプトにクオリティタグ不要
- **Turbo**: 蒸留版。CFG 1、8〜12 step で高速生成

## ダウンロード

- [CivitAI](https://civitai.com/ecosystems/anima) — モデル本体・派生モデル一覧
- HuggingFace — テキストエンコーダ・VAE

## ComfyUI 配置

Anima はファイル分割型。`checkpoints/` でなく以下に配置:

```
ComfyUI/models/diffusion_models/   ← モデル本体 (UNet/DiT)
ComfyUI/models/text_encoders/      ← qwen_3_06b_base.safetensors
ComfyUI/models/vae/                ← qwen_image_vae.safetensors
```

ノード: `Load Diffusion Model` + `Load CLIP` + `Load VAE` を別々に接続。

---

# ComfyUI: checkpoints vs diffusion_models

| | checkpoints/ | diffusion_models/ |
|---|---|---|
| 内容 | MODEL+CLIP+VAE 統合1ファイル | UNet/DiT のみ |
| 読込ノード | Load Checkpoint | Load Diffusion Model |
| 対象モデル | SD1.x, SDXL | FLUX, Anima 等 |
| CLIP/VAE | 自動ロード | 別ノードで個別ロード |

**歴史的経緯**: SD1.x 時代 (2022) は小さいので1ファイルで十分だった。FLUX (12B+) で巨大化 → コンポーネント分離が現実的に。

---

# CLIP / VAE の役割

## CLIP (テキストエンコーダ)

テキスト → 潜在ベクトル変換。変えるとプロンプト解釈が変わる。

- SD1.x: CLIP-L (768 dim)
- SDXL: CLIP-L + CLIP-G (dual)
- FLUX: CLIP-L + T5-XXL
- Anima: Qwen-3

## VAE

潜在空間 ↔ ピクセル変換。変えると色再現・細部シャープさが変わる。

- SD1.x: 4ch 潜在空間
- FLUX: 16ch 潜在空間

## モデル間共有

**同系列内のみ共有可**。異アーキテクチャ間は不可。

理由: UNet/DiT が特定の埋め込み次元数・潜在チャンネル数で学習済み。次元不一致 → 動作しない。
