---
title: ComfyUI Tutorial Ep.12 - AI画像のアップスケール
description: ComfyUIでAI生成画像を高品質のまま大きくするアップスケール方法
aliases:
  -
tags:
  - comfyui
  - upscale
  - pixaroma
draft: false
date: 2026-07-12
---

# ComfyUI Tutorial Ep.12 — AI画像のアップスケール方法

動画: https://www.youtube.com/watch?v=i8v9RbNy4Zw

## 必要なモデル

Model Manager → Upscale でフィルタして導入。

| モデル名 | 用途 |
|---|---|
| `4x_NMKD-Siax_200k` | 汎用（写真・風景・リアル系） |
| `4x-AnimeSharp` | アニメ・イラスト向け |

## 必要なカスタムノード

- **ControlAltAI Nodes**
- **ComfyUI-PixelResolutionCalculator** — 最適解像度を自動計算
- **ComfyUI Easy Use**
- **rgthree's ComfyUI Nodes** — Image Comparer など

## ワークフローの流れ

1. 画像生成 → VAE Decode → 最初の画像を保存
2. `Upscale Image by` ノードで2〜4倍に拡大（Siax or AnimeSharp を選択）
3. Pixel Resolution Calculator で最終解像度を計算
4. VAE Encode → Latentに戻してサンプリング（Denoise低め: 0.3〜0.5）
5. 最終 VAE Decode → 保存（3枚の比較画像を自動保存）

## Tips

- **Flux** は CFG=1 必須
- 解像度は **64の倍数**にすること
- VRAM不足なら `Tiled VAE Encode/Decode` ノードを使う
- Denoiseを上げすぎると過シャープになるので注意
- `Image Comparer` ノードでビフォーアフターをリアルタイム比較できる
