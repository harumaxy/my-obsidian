---
title: civitai-model-types
description: Civitai のモデルタイプ一覧と役割
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - stable-diffusion
  - civitai
draft: false
date: 2026-07-22
---

# Civitai モデルタイプ

## ベースモデル系

- **Checkpoint** — モデル本体。画像生成の核心。SD1.5/SDXL/Flux等
- **VAE** — 潜在空間エンコーダー。色味・シャープネス調整。Checkpointに追加適用
- **UNet** — Checkpointの構成要素。ノイズ除去ネットワーク単体

## ファインチューン系（Checkpointに追加）

- **LoRA** — 軽量追加学習。キャラ・スタイル・概念を少パラメータで注入
- **LyCORIS** — LoRA拡張。LoHa/LoKr等の手法を含む。少サイズで高品質
- **DoRA** — LoRAの改良版。重みを大きさ+方向に分解して学習。Flux系で主流
- **Hypernetwork** — 旧世代の追加学習手法。LoRA以前の主流
- **Embedding / Textual Inversion** — テキストエンコーダーに概念埋め込み。`<token>`で呼び出す

## テキスト系

- **TextEncoder** — CLIPやT5等のテキスト→ベクトル変換器単体
- **VLM** — 画像→テキスト理解モデル（LLaVA等）

## 制御系

- **ControlNet** — ポーズ・深度・輪郭等で生成を空間的に制御
- **Detection** — 物体検出モデル（ControlNet前段等で使用）
- **Poses** — ControlNet用ポーズデータ集

## 後処理系

- **Upscaler** — 超解像。ESRGAN/RealESRGAN等
- **Motion** — AnimateDiff用の動き制御モジュール

## その他

- **Aesthetic Gradient** — 美的スコアで生成誘導（マイナー）
- **Wildcards** — プロンプトのランダム置換テキストファイル
- **Workflows** — ComfyUIのワークフローJSON
- **Other** — 分類外

## 実用優先度

Checkpoint > LoRA/LyCORIS > VAE > ControlNet > Embedding

## LyCORIS 詳細

LoRAの上位互換ライブラリ。複数手法を統合:

- **LoHa** — ハダマード積で重み表現。LoRAより表現力高い
- **LoKr** — クロネッカー積。大きいモデル(SDXL)で効率的
- **DyLoRA** — ランク動的調整
- **GLoRA** — 全レイヤー適用可能

## DoRA 詳細

重みを **大きさ(magnitude)** と **方向(direction)** に分解して学習。
LoRAは方向だけ学習 → DoRAは大きさも別途調整 → フルファインチューンに近い品質。
Flux系モデルで採用増。ユーザー側はLoRAと同じ使い方でOK。

## 使い分け

- **普通のLoRA** — キャラ・スタイル追加。互換性最高。大半はこれで十分
- **LyCORIS** — LoRAで品質不足 or ファイル軽量化したい時
- **DoRA** — 高品質なFluxモデル用LoRAを使う時（意識不要）
