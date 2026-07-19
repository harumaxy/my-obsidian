---
title: "ComfyUI チュートリアル Ep05 - Stable Diffusion 3 Medium"
description: SD3 Mediumのモデル種類・設定・SDXLとの比較まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - stable-diffusion
  - sd3
draft: false
date: 2026-07-04
---

# ComfyUI チュートリアル Ep05 - Stable Diffusion 3 Medium

- 動画: https://www.youtube.com/watch?v=q9ufjcMofI0
- チャンネル: pixaroma

## モデルの種類と選び方

CivitAI または Hugging Face からダウンロード。

| モデル | サイズ | 特徴 |
|---|---|---|
| sd3_medium (clip付き) | ~5GB | テキストエンコーダー内蔵。VRAM少ない環境向け |
| sd3_medium_fp8 | ~10GB | FP8のテキストエンコーダー。高画質 |
| sd3_medium_fp16 | ~15GB | FP16。最高品質、要高VRAM |

- VRAM が少ない → 5GB版
- 余裕があれば → 10GB or 15GB版

## CLIPとは

SD3は内部で3つのテキストエンコーダーを使用：

| エンコーダー | 役割 |
|---|---|
| CLIP-L | 基本的なテキスト理解 |
| CLIP-G | より高度なテキスト理解 |
| T5-XXL | 長く複雑なプロンプトの理解（非常に大きい） |

「clip付き」= CLIP-L + CLIP-G + T5-XXL が1ファイルに同梱。ダウンロードしてすぐ使える。
「clipなし」= T5-XXL のみ。CLIPを別途配置が必要なため非推奨。

## ComfyUI での設定

- **K-Sampler推奨設定:** Steps=28〜30、CFG=4.5、Sampler=DPM++ 2M、Scheduler=SGM Uniform
- **Latent Image:** 「Empty SD3 Latent Image」を使う（内部計算式がSD3向けに最適化）

## 複数ワークフロー比較テクニック

- テキストエンコーダーの入力を「Convert Widget to Input」でポート化
- Primitive ノードでプロンプトとシードを1箇所に集約して複数ワークフローへ共有
- 保存ファイルのプレフィックスをモデル名にして出力を識別

## SD3 vs SDXL（Juggernaut X）比較

**SD3が得意:**
- 風景・テクスチャのシャープさ
- テキスト描画（短い英語なら正確）
- 複雑なプロンプトの理解
- オブジェクト・食べ物・白背景イラスト

**SDXLが得意:**
- 人物・動物・キャラクター
- ファインチューン済みモデルの豊富さ（AnimagineXL、Pony Diffusion など）
- 手足など人体の描写（SD3は壊滅的に苦手）

**使い分け:**
- SD3 → 風景、テキスト入り画像、食べ物、オブジェクト
- SDXL → 人物、動物、サブカル・キャラクター系
- 手や四肢はどちらも苦手
- SD3は「medium版」なので改良版のリリース待ち
