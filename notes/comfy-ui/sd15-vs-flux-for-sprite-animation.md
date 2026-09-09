---
title: sd15-vs-flux-for-sprite-animation
description: 2Dゲームスプライートアニメ制作、SD1.5 vs Flux/Z-Image/Qwen-Image使い分け
# permalink:  # don't use
aliases:
  -
tags:
  - comfy-ui
  - stable-diffusion
  - flux
draft: false
date: 2026-09-06
---

## 前提

2Dゲームアセット、スプライートアニメ作る話。キャラ一貫性LoRA学習、ポーズ固定にOpenPose/Depth ControlNet使う構成。この用途でFlux/Z-Image/Qwen-Image等最新モデルに乗り換えるメリットあるか検討。

## 結論

メリット薄い。SD1.5が現状最適。

## 理由

- **ControlNet成熟度**: OpenPose/DepthそもそもSD1.5用に最初に育った資産。骨格精度(DWpose等拡張)・種類ともに最多。Flux用ControlNetはUnion型中心でまだ発展途上。[[flux-lora-ecosystem]]の通りflux2は特に若い。Qwen-Image/Z-ImageはControlNet対応さらに薄い
- **生成速度**: 歩行8方向×フレーム数など大量バッチ必須用途。SD1.5 10-15秒/枚 vs Flux/Qwen-Image級は同条件で数倍〜十数倍重い。試行錯誤コスパで差開く
- **出力解像度の無駄**: ドット絵/低解像度スプライートに落とし込む前提なら高精細さ活きない。SD1.5の512x512基準がちょうどいい
- **LoRA学習実例の厚み**: [[lora-training-tools-2026]]の通りai-toolkitでFlux/Qwen-Image/Z-Image学習自体は可能。だがアニメ/ドット絵スプライート特化のノウハウ・community LoRA蓄積はSD1.5が圧倒的。[[sprite-generation-animatediff-vs-openpose]]の元ネタもSD1.5前提

## 最新モデル乗り換え検討場面

- フォトリアル系・3Dライク高解像度アセットが必要な時
- 複雑ポーズ・シーンでプロンプト追従精度要る時(それでもControlNetでの姿勢固定精度はSD1.5に分がある)

## ハイブリッド案

Flux等でキャラ参照シート高品質生成→それを学習データにSD1.5側LoRA作る、程度なら使い道あり。
