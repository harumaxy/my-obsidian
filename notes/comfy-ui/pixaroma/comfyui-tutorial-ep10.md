---
title: "ComfyUI Tutorial Ep10 - Flux GGUF とカスタムノード"
description: "カスタムノードの管理方法と Flux GGUF のセットアップ・比較"
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - flux
  - gguf
draft: false
date: 2026-07-05
---

# ComfyUI Tutorial Ep10 - Flux GGUF とカスタムノード

- 動画: https://www.youtube.com/watch?v=Ym0oJpRbj4U
- チャンネル: pixaroma
- 公開日: 2024-08-28

## カスタムノードの管理

- Manager からインストール・アンインストール・更新が可能
- 「installed」フィルターで現在入っているノード一覧を確認できる
- 競合（conflict）警告は多くの場合無視して問題なし
- Manager に表示されないノードは `custom_nodes` フォルダから直接削除する

## ワークフローを開いたときのエラー対処

- 不足ノードがあると赤くハイライトされる
- Manager の **「Install Missing Custom Nodes」** で必要なノードを一括確認・インストール
- 代替ノードに切り替えたい場合は手動で削除・再接続する
- ノードの GitHub ページを確認すること（依存関係や設定が必要な場合あり）

## GGUF とは

- **Georgi Gerganov Unified Format** の略
  - GG = llama.cpp 作者 Georgi Gerganov のイニシャル
  - UF = Unified Format（統一フォーマット）
  - 前身の GGML（Georgi Gerganov Machine Learning）の後継。2023年8月導入
- **量子化フォーマット**。llama.cpp 由来で元々は LLM 向け
- モデルの重みを低ビット精度に圧縮してファイルサイズと推論速度を改善する
- `Q8`（8bit）、`Q4`（4bit）などの段階があり、数字が大きいほど高精度・大容量
- 拡張子は `.gguf`（safetensors とは別物）
- Flux は通常版が巨大（fp16 で約 24GB）なため GGUF が有効

## Flux GGUF のセットアップ

### 必要ファイルの配置先

| ファイル | フォルダ |
|---|---|
| GGUF モデル（Dev or Schnell の Q版） | `models/unet/` |
| clip_l モデル | `models/clip/` |
| T5 モデル（Q8 推奨） | `models/clip/` |
| VAE モデル | `models/vae/` |

※ `checkpoints` フォルダには入れないこと

### ワークフロー構成

```
UnetLoaderGGUF
DualCLIPLoader (GGUF版, type=flux) ← clip_l + T5
Load VAE
↓
SD3 Latent Image    ← Flux と SD3 は同じ 16ch latent を使うため流用
Flux Guidance（Dev のみ。Schnell では不要）
K-Sampler: CFG=1, steps=20（Schnell は 4〜8）
VAE Decode
Save Image
```

### なぜ SD3 Latent Image ノードを使うのか

拡散モデルはピクセルを直接処理せず、**VAE で圧縮した latent 空間**で処理する。
latent のチャンネル数はモデルによって異なる：

| モデル | latent チャンネル数 |
|---|---|
| SD 1.5 / SDXL | 4ch |
| SD3 / Flux | **16ch** |

`Empty Latent Image`（4ch）を使うとチャンネル数不一致でエラーになる。
Flux は SD3 と同じ 16ch VAE アーキテクチャを採用しているため、ComfyUI では SD3 用ノードを流用している。

チャンネルが多いほど 1ピクセルあたりの情報量が多く、細かいディテールを latent に保持できる。これが Flux の高品質な理由の一つ。

## Dev Q8 vs Schnell Q8 比較

| 項目 | Dev Q8 | Schnell Q8 |
|---|---|---|
| 生成時間（RTX 4090） | 初回 28秒 / 以降 16秒 | 初回 17秒 / 以降 4秒未満 |
| 通常版（fp16）との比較 | fp16 は 81秒 → Q8 は約半分 | - |
| 画風 | リアル系、テキスト描写が得意 | イラスト・色鮮やか、やや不正確 |
| ファイルサイズ | fp16 の約半分 | - |

→ **Q8 は速くて軽く品質もほぼ同等のためおすすめ**

## 便利なカスタムノード

| ノード | 用途 |
|---|---|
| ComfyUI-GGUF (by city96) | GGUF モデルの読み込みに必須 |
| Cris Tools | メモリ使用量モニタリング |
| RG3 | **Image Comparer**（マウスで2画像をスライド比較） |
| Primitive ノード | シードやプロンプトを複数ワークフローに一括接続 |

## Tips

- ノード検索は Manager より **comfy.icu** の Custom Nodes ページが高機能
- ノードに「バッジ」表示を設定するとどのカスタムノードか分かりやすい
- K-Sampler のシードを「Convert widget to input」→ Primitive ノードで複数ワークフローに共有できる
- 古い NF4 ノードは deprecated → GGUF に移行推奨


# その他テクニック
- Image Comparer: `image`_a/b を入力。ドラッグで切り替え
  - Slide を Click に切り替えて、クリックで即座に切り替えるスタイルも可能
- 右クリック > Convert `****` to input: ComfyUI ノードの入力フォームを、ピンにして外部入力できる
  - 例1. KSampler の `seed` 値を input に変換。条件や接続フローを変えた同一モデルの画像生成ワークフローを2つ並べ、同じシードで同出力が変わるか実験する
- `Primitive` ノード: int, text, image, ... 何かしらのリテラルを出力するノードを宣言。定数値のようなもの
  - Int > `increment` : 実行のたびに値を増やせる(バリエーション)


# Stable Diffusion のプロンプトを ChatGPTで生成する

LLMを画像生成 T2I の補助に使用する

`give me a stable diffusion prompt for a cute cartoon ninja in a bamboo forest, dont include quotes`
> ...

コピーしやすいように　 block code として出させる指示
