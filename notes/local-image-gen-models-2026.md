---
title: 2026年 ローカル画像生成モデル比較
description: ComfyUI で動かせる 2026年のローカル画像生成モデル。VRAM・ライセンス・得意分野まとめ
# permalink:  # don't use
aliases:
  - local-image-gen-models-2026
tags:
  - ai
  - comfyui
  - 画像生成
draft: false
date: 2026-10-31
---

出典: https://www.earngenix.com/blog/best-local-image-generation-models-2026
(2026/7/8 更新。RTX 4090 24GB + ComfyUI v0.3.7 で検証)

## 結論

- Krea 2: フォトリアル 1位。速い
- Ideogram 4.0: 画像内テキスト・タイポ最強
- FLUX.2: 複数参照画像で一貫性。追加学習いらない
- Qwen-Image 2.0: 英中テキスト強い。速い
- どれも 8〜16GB VRAM くらいから動く

## モデル詳細

### Krea 2

- 12B DiT。実画像だけで学習。合成データなし
- RAW: 蒸留前 52 step。LoRA 学習・ファインチューン向け
- Turbo: 8 step 蒸留。普段使い
- VRAM: FP8 Turbo 約 12GB。nvfp4 は 8〜12GB
- ライセンス: Krea 2 Community License。年商 $1M 未満なら商用 OK

### Ideogram 4.0

- 2026/6/3 公開。9.3B DiT。Ideogram 初のオープンウェイト
- JSON プロンプト対応。bbox でレイアウト、HEX でカラー指定
- ポスター・パッケージ・看板向き
- VRAM: nf4 で 24GB。fp8 は高精細だがメモリ食う
- ライセンス: 非商用。商用は有償契約
- 低頻度なら API (Turbo $0.03/枚〜) が現実的

### FLUX.2

- Black Forest Labs 製。ネイティブ 4MP
- Multi-Reference: キャラ・スタイル・商品を複数参照で合成
- VRAM: GGUF Q4 で 8GB。一番手軽
- ライセンス: schnell は Apache 2.0。dev は非商用

### Qwen-Image 2.0

- Alibaba 製。2026/2/10 公開。生成+編集を 7B に統合
- ネイティブ 2048x2048
- Lightning 版: 4 step。標準 40 step の約 10 倍速
- VRAM: FP8 で 12〜16GB
- ライセンス: Apache 2.0

### Z-Image

- 軽量・高速。画質より throughput
- 8GB で動く。記事中で最低要求

### HunyuanImage 3.0

- Tencent 製。80B MoE (有効 約 13B)
- 1000 字超の長文プロンプト対応
- int8 でも約 80GB。コンシューマ GPU 無理

## GPU 別おすすめ

- 8GB: FLUX.2 GGUF Q4 / Z-Image
- 12〜16GB: Krea 2 Turbo FP8 / Qwen-Image 2.0
- 24GB: Ideogram 4.0 nf4 / Krea 2 Turbo
- 32GB 以上: Krea 2 RAW (BF16。LoRA 学習)
- 40GB 以上 / クラウド: HunyuanImage 3.0

## ライセンス

- 商用しやすい: Qwen-Image 2.0, Z-Image Turbo, FLUX.1 schnell, HiDream-I1 (MIT), SDXL
- 条件付き・非商用: Krea 2, Ideogram 4.0, FLUX.2 dev, FLUX.1 dev
- open-weight と open-source は別。重み DL できても商用ダメな場合あり

## ローカル vs クラウド API

- API: $0.02〜0.08/枚。月数十枚なら楽
- ローカル: 初期投資と設定の手間。入れたら電気代だけ。出力が外に出ない

## 自分用メモ

- 手持ち RTX 4080 (16GB)。Krea 2 Turbo FP8 と Qwen-Image 2.0 が射程内
- Ideogram 4.0 nf4 は 24GB 前提。4080 厳しそう
- 4080 での実測は記事になし。自分で試す
