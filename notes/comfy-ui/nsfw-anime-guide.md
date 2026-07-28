---
title: ComfyUI NSFW 2次元イラスト生成ガイド
description: anime NSFW モデル・LoRA 入手法と ComfyUI ワークフロー
aliases:
  -
tags:
  - comfyui
  - stable-diffusion
  - nsfw
  - anime
draft: false
date: 2026-07-22
---

# ComfyUI NSFW 2次元イラスト生成

## ベースモデル

**Illustrious XL 系** — 現状最強 anime 基盤

- `Illustrious-XL` — 高品質 anime 特化、NSFW 対応版多数
- `NoobAI-XL` — Illustrious 派生、NSFW 強め、プロンプト追従性高
- `PonyDiffusion V6 XL` — Pony 系 tag 体系、NSFW コンテンツ量最多

入手先: [Civitai](https://civitai.com) → NSFW フィルター ON → Model Type: Checkpoint

## LoRA

種類:
- キャラ LoRA — 特定キャラ再現
- スタイル LoRA — 絵柄・作家風
- コンセプト LoRA — ポーズ・衣装・行為

入手先:
- Civitai（メイン） — NSFW フィルター ON 必須
- Hugging Face — `search: lora nsfw anime`

配置先: `ComfyUI/models/loras/`

## ComfyUI ワークフロー

1. `ComfyUI-Manager` インストール → カスタムノード管理
2. ベース: `SDXL + Illustrious XL` 系推奨
3. LoRA 複数スタック → `LoraLoader` ノード連結
4. Negative Embedding → `EasyNegative XL` 等で品質向上

## Tag 体系

Illustrious / NoobAI / Pony → Danbooru タグ互換

```
# ポジティブ例
masterpiece, best quality, 1girl, nude, nsfw, ...

# ネガティブ例
worst quality, low quality, bad anatomy, EasyNegativeXL
```

## 注意

- Civitai NSFW 閲覧 → ログイン + 年齢確認設定必須
- モデル配置先: `ComfyUI/models/checkpoints/`
