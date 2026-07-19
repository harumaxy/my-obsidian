---
title: "ComfyUI Tutorial Ep08 - Flux 1: Schnell と Dev のインストールガイド"
description: Black Forest Labs の Flux モデルのインストール方法・各バージョンの比較・ワークフロー設定
aliases:
  -
tags:
  - comfyui
  - flux
  - stable-diffusion
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Ep08 - Flux 1: Schnell と Dev のインストールガイド

- 動画: https://www.youtube.com/watch?v=ImWHS5Ux36E
- チャンネル: pixaroma

## Flux とは

Black Forest Labs（Stability AI 元研究者チーム）が開発した画像生成モデル。

### バージョン

| バージョン | ライセンス | 特徴 |
|-----------|-----------|------|
| Pro | APIのみ | ダウンロード不可 |
| Dev | 非商用 | 最高品質 |
| Schnell | Apache 2.0 | 高速・商用利用可 |

- Dev ライセンスの注意：**生成画像の商用利用は可**。ただし Flux で競合モデルのトレーニングは不可

### モデルのサイズと配置先

| モデル | サイズ | 配置先 |
|--------|--------|--------|
| Schnell FP8 | 17GB | `checkpoints/` |
| Dev FP8 | 17GB | `checkpoints/` |
| Dev 通常版（本体） | 23GB | `unet/` |
| Dev 通常版（CLIPモデル×2） | - | `clip/` |
| VAE（ae.safetensors） | - | `vae/` |
| Schnell NF4 | 11GB | `checkpoints/` |
| Dev NF4 | 11GB | `checkpoints/` |

FP8版はモデル1つにCLIP・VAEが内包されていてシンプル。通常版は分離している。

## ワークフロー設定

### 共通ポイント

- Negative Prompt は不要（Flux は非対応）
- Empty Latent Image は **SD3 Latent Image** ノードを使う
- CFG は **1** に固定（Negative を無視させるため）

### Schnell の設定

```
Steps: 4
Sampler: euler
Scheduler: simple
CFG: 1
```

### Dev の設定

```
Steps: 20〜30
Sampler: dpmpp_2m  ← ぼやけ防止
Scheduler: sgm_uniform  ← ぼやけ防止
CFG: 1
+ FluxGuidance ノード（デフォルト: 3.5）
```

`FluxGuidance` ノードは Dev 専用。Positive プロンプト → FluxGuidance → K Sampler の positive に接続する。値を下げると絵画風になることがある。

### ぼやけた画像の修正

サンプラーを `dpmpp_2m`、スケジューラーを `sgm_uniform` に変更する。

### NF4 版の追加手順

`bitsandbytes` カスタムノードが必要（Managerには未掲載）。手動インストール：

```bash
# custom_nodes フォルダで
git clone <bitsandbytes ノードのGitHub URL>
pip install bitsandbytes
```

ノードは `Load Checkpoint NF4` を使う（通常の `Load Checkpoint` の代わり）。

## アートスタイルの使用

ep07 の Multiple Style Selector ノードがそのまま使える。
Flux は SDXL より認識できるスタイル数は少ないが、影響は出る。

## LoRA の使用

- `Load LoRA` ノードを Load Checkpoint と CLIP Text Encoder の間に挿入
- xlabs 製リアリズム LoRA が flux dev と相性が良い

## Dev vs Schnell 比較

Dev の方が全体的に優れている点：
- 雨などの環境表現
- テキスト描写
- 手の描写（他モデルより全般的に優秀）
- 細部・ディテール

速度優先なら Schnell、品質優先なら Dev FP8。
通常版 Dev と FP8 Dev の差は小さく、複雑さを考えると FP8 で十分な場合が多い。


# 実際は？

商用を考えると schnell(シュネル) がおすすめ


# fp16 vs fp8 vs nf4

float point の精度

多くの場合、大きな違いが無いため fp8 で十分
通常のfp16バージョンを使うメリットはほぼ無い

VRAMが少ない人向けに NF4 = normalized float 4 bit もある

Comfy UI で nf4 チェックポイントを動作させるには
`ComfyUI_bitsandbytes_NF4` カスタムノードが必要
手動でインストールが必要

git clone ...
pip install -U bitsandbytes

`CheckpointLoaderN4` ノードが選択できるようになればインストール成功


# Flux Guidance

Dev モデルでしか使用できない

Positive Prompt - KSampler の入力の間に追加
たぶん、プロンプトをembeddingしたConditioningをなんかしている
