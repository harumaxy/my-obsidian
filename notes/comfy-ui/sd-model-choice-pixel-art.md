---
title: sd-model-choice-pixel-art
description: 2Dゲームピクセルアート/スプライト生成向けモデル選定メモ
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - stable-diffusion
  - pixel-art
draft: false
date: 2026-09-05
---

## 目的

2Dゲームキャラアセット作成。ピクセルアートスタイル。アニメーションスプライト作成支援(LoRA, IPAdapter, OpenPose)。高品質不要、ドット化はポスト処理任せ。生成速度・LoRA学習速度重視、開発イテレーション優先。

## Flux vs Stable Diffusion

SD一択。

- 生成速度: Flux(12B, DiTアーキテクチャ)重い。SDは軽量でイテレーション速度段違い
- LoRA学習速度: SD数分〜数十分。Flux桁違いに遅い
- エコシステム成熟度: ControlNet(OpenPose)・IPAdapter、SDが対応モデル最多・最枯れ
- ピクセルアート系LoRA: SDコミュニティに大量蓄積(civitai等)。Flux用少数
- 高品質不要な用途 → Fluxの強み(高精細・プロンプト忠実度)不要。SD弱点(細部崩れ)はポスト処理ドット化で吸収可

## SD1 / SD1.5 / SDXL / SD3 比較

SD1.5一択。

- SD1: SD1.5の前身。使う理由なし
- **SD1.5**: エコシステム最大。ピクセルアートLoRA・アニメスプライトLoRA・ControlNet(OpenPose)・IPAdapter、全部ここが本拠地。軽量・高速・学習速い
- SDXL: 品質・解像度は上だが重い。生成遅い・LoRA学習遅い・VRAM要求高い。ControlNet/IPAdapter選択肢もSD1.5ほど豊富でない
- SD3: ライセンス制限厳しい(商用面倒)。エコシステム未成熟。LoRA/ControlNet資産ほぼなし。避ける

## 速度ベンチマーク(ソースあり)

推論速度(同一GPU、it/s、SD1.5=95it/s基準):

- SD1.5: 95 it/s
- SDXL: 約43 it/s(SD1.5比3.2〜3.4倍遅い。UNetパラメータ数3.5倍・ピクセル数4倍)
- Flux.1 Dev: 約19 it/s(1step FLOPS数SD1.5の約5倍。DiT重い)
- 実測(RTX5090): Flux 25step画像=1.6秒、SDXL 30step画像=1.0秒

画像1枚あたり生成時間:

- SDXL: 4〜6秒
- Flux Dev: 18〜40秒

LoRA/フルファインチューン学習時間:

- SD1.5フルFT: A100 80GB×1枚で約9時間
- SDXLフルFT: 同条件で約40時間
- Flux.1 devフルFT: 12k step、A100×8で23.4時間
- SDXL LoRA(スタイル転移): RTX4090×1枚で約12分

出典:
- [GIGAGPU: SD1.5 vs SDXL Speed by GPU](https://gigagpu.com/sd15-vs-sdxl-speed-by-gpu/)
- [fal-ai stable-diffusion-benchmarks (GitHub)](https://github.com/fal-ai/stable-diffusion-benchmarks/blob/main/README.md)
- [Will It Run AI: Stable Diffusion vs Flux in 2026](https://willitrunai.com/blog/stable-diffusion-vs-flux-2026)
- [SolidAITech: Speed Calculator IT/s Benchmark 2026](https://www.solidaitech.com/2026/05/stable-diffusion-speed-calculator-its-benchmark-guide.html)
- [InsiderLLM: SDXL vs SD1.5 vs Flux](https://insiderllm.com/guides/sdxl-vs-sd-1-5-vs-flux/)

## ピクセルアート生成: 直接生成 vs 後処理ドット化

後処理ドット化推奨。

- 構造制御精度: OpenPose/IPAdapterは通常解像度空間で効かせた方が正確。ピクセルアートLoRA併用するとスタイルLoRAと構造制御が衝突→崩れやすい
- スプライト一貫性: 同キャラ複数ポーズ生成時、高解像度側で特徴保持→ダウンサンプルしても一貫性残る。低解像度直接生成は個体差ブレやすい
- ピクセルアートLoRA自体の限界: 多くは「ピクセル風味の塗り」止まり。実ドットグリッド(1px=1マス)にはならない→結局後処理の減色・グリッド整列が必要になるケース多い
- 後処理ツールの制御性: 減色・パレット固定・アウトライン強調、Aseprite/ImageMagick/専用scriptで確立済み手法。狙った見た目にしやすい

組み合わせ案: ピクセルアート系スタイルLoRAを弱め(weight 0.3〜0.5程度)にかけて色使い・シルエットだけ寄せつつ、OpenPose/IPAdapterで構造固定→最後に後処理ドット化。両取り。

## 関連

[[flux-lora-ecosystem]]
