---
title: ComfyUI チュートリアル #1 — 入門と基本
description: Stable Diffusion AI を ComfyUI で使うチュートリアルシリーズ第1回のメモ
# permalink:  # don't use
aliases:
  - ComfyUI入門
tags:
  - comfyui
  - stable-diffusion
  - ai
  - image-generation
draft: false
date: 2026-07-01
---

## 概要

グラフィックデザイナーの視点から ComfyUI の基礎を誰でも理解しやすく解説するシリーズ第1弾。
初心者〜上級者まで段階的に学べるよう構成されている。

動画: https://www.youtube.com/watch?v=Zko_s2LO9Wo

---

## ComfyUI とは

- Stable Diffusion AI のためのノードベースのビジュアルインターフェース
- ノードをドラッグ＆ドロップで接続し、画像生成ワークフローを自由に構築できる
- コーディング不要で複雑なパイプラインを作れる
- 他のユーザーのワークフローをロード・共有できる

---

## システム要件

- Windows + Nvidia GPU（最低 8GB VRAM 推奨）
- RTX シリーズが特に推奨（速度面で優位）
- VRAM が少ないと処理が遅くなる

---

## インストール手順（Windows ポータブル版）

1. ComfyUI ポータブル版をダウンロード・解凍
2. `D:\comfy UI` などのフォルダに保存
3. `Run Nvidia GPU.bat` をダブルクリックで起動
4. コマンドウィンドウが開き、ブラウザで自動的にインターフェースが起動

---

## モデルのダウンロード

- Civit AI サイトからチェックポイントモデルをダウンロード
- `ComfyUI/models/checkpoints/` フォルダに配置
- ファイル形式は `.ckpt` より安全な **Safe Tensor（.safetensors）** を推奨
- 使用例：**Juggernaut**（v1.5 版と SDXL 版）

### Civitai で良いモデルをダウンロードする方法
シヴィットエーアイ

- 評価順、DL数順に並べると良いものが出る
- Day, Week, Month, Year などでトレンドを見る
- 最近の人気モデルタイプ
  - SD 1.5
  - SDXL
  - SD 3

動画ではSDXLが利用されている

## モデルタイプについて

Civitai は、上記の Model タイプ (1.5, XL, 3) をベースにリファインしているものが多い
Lora, VAE, その他などはタイプごとに互換性がないので、周辺ツールも加味して選ぶ

カスタムモデル自体のバージョンは、新しい方がより多くの教育を受けて安定した品質を出す可能性が高い


---

## 基本ワークフローのノード構成

| ノード | 役割 |
|--------|------|
| Checkpoint Loader | モデル読み込み |
| CLIP Text Encode | ポジティブ・ネガティブプロンプト |
| Empty Latent Image | 解像度設定 |
| KSampler | サンプラー・ステップ数・CFG 設定 |
| VAE Decode | 潜在画像をピクセルに変換 |
| Save Image | 画像保存 |

---

## 重要な設定パラメータ

- **Sampler**: DPM++ 2M Karras が推奨
- **CFG**: 7 前後が基本
- **解像度**: SDXL は 1024×1024 基準（v1.5 は 512/768 ベース） でトレーニングされている
- 同じベースモデル同士で揃えることが重要（v1.5 同士、SDXL 同士）

---

## 便利な機能

- 生成画像にワークフロー情報が埋め込まれる → 他人の画像をドラッグすると設定を再現できる
- **Comfy UI Manager** でカスタムノードを追加・管理できる
- ワークフローを JSON で保存・ロード可能
- デスクトップにショートカットを作成して素早く起動できる
