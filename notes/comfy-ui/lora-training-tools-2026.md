---
title: lora-training-tools-2026
description: LoRA学習ツール比較。sd-scripts(Kohya) vs AI-Toolkit(ostris)
# permalink:  # don't use
aliases:
  -
tags:
  - lora
  - stable-diffusion
draft: false
date: 2026-09-05
---

3年前動画（sd-scripts導入解説）見た。当時と今のベストプラクティス差分メモる。

## ベースモデル変化

SD1.5前提の情報は化石。今はSDXLかFLUX系（FLUX.1/FLUX.2）が主戦場。

## ツール比較: Kohya SS(sd-scripts) vs AI-Toolkit(ostris)

sd-scripts自体は今もエンジンとして現役、SDXL/FLUX両対応。GUI/派生ツール乱立、エンジンはだいたいsd-scripts流用。

### 対応モデル数

AI-Toolkitが圧倒的に広い。

- SD1.5, SDXL, FLUX.1系, FLUX.2系, Qwen-Image, Z-Image, HiDream, Wan2.1/2.2(動画), LTX
- モデルごとに拡張機能として追加する設計→新モデル対応速い

Kohya SSはSD1.5/SDXLがメイン戦場、FLUXも対応済みだが新モデル追従はAI-Toolkitより遅め。

### VRAM効率

Kohyaが強い。fused backward pass（v0.9.0, 2025年1月導入）でSDXL学習が fp32~17GB、bf16~10GBまで軽量化。8-12GB帯のカードならKohya有利。

### ドキュメント/実績

Kohyaが古参で圧倒的に厚い。community config資産も多い。AI-Toolkitは相対的に薄い、詰まった時の情報探しがKohyaより大変。

### 設定方式

- Kohya: GUIクリック中心
- AI-Toolkit: YAML直書き中心

### デフォルトscheduler差（要注意）

- Kohyaデフォルト: cosine with restarts（3サイクル）
- AI-Toolkitデフォルト: cosine

同じstep数コピペしても仕上がり変わる。目安: Kohyaで800step/10epoch相当≒AI-Toolkitで1600step/15epoch、という報告あり。乗り換え時はステップ数盛る必要ある。

### 結論

学習アルゴリズム自体の品質差はほぼ無い。差は「VRAM効率」と「デフォルト設定の癖」。

- SDXLメイン＋低VRAM機 → Kohya SS
- 対応モデル数優先（FLUX.2/Qwen-Image/Z-Image触りたい）→ AI-Toolkit
- 迷ったら対応モデル数で選んで一本化、詰まったらKohya系情報を横目で見る

## 動画当時から変わらない原理

- DreamBooth+キャプション方式の考え方（素材−キャプション=学習データ）は今も有効
- トリガーワード先頭配置、正則化画像は任意、の原則も同じ
- キャプションはVLMオートキャプション→手動編集が今の標準（当時のWD14Taggerと役割は同じ）

## 参考パラメータ目安（2026時点）

- SDXL顔LoRA: dim32 / alpha16
- FLUX顔LoRA: dim16 / alpha8
- スタイルLoRA: dim64
- LR: SDXL標準1e-4、LoRA+なら5e-5

## 参考リンク

- https://github.com/ostris/ai-toolkit
- https://github.com/kohya-ss/sd-scripts
- https://sanj.dev/post/onetrainer-vs-kohya-ss-vs-ai-toolkit/
- https://sanj.dev/post/lora-training-2025-ultimate-guide/
- https://www.earngenix.com/blog/ai-toolkit-vs-kohya-vs-fluxgym
- https://civitai.com/articles/27116/ai-toolkit-usage-tips
