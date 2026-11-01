---
title: ggxrd-anime-face-topology
description: ギルティギア Xrd アニメ調3Dモデル Tips。頬ライン調整と、Tripo 出力が似てる話
aliases:
  - GGXrd AnimeStyleModelTips
tags:
  - 3d
  - modeling
  - anime
  - topology
  - tripo
draft: false
date: 2026-10-28
---

## 出典

- X: https://x.com/gus_animator/status/2106696355603488958
  - @gus_animator が @Dstudio_ai に返信。「日本語版 ネット 絶対ある」と Google スライド共有
- スライド: `GGXrd AnimeStyleModelTips.pptx` (アークシステムワークス ギルティギア Xrd。アニメ調3Dモデル制作 Tips)
  - https://docs.google.com/presentation/d/1WUvd9s8d_5ENBnbSpXo6ajdeTGODPr6S/mobilepresent?slide=id.p35
- 読んだの 35枚目のみ。他スライド 未読

## 35枚目: 頬ライン調整 (Adjust the cheek line)

- 頬のライン、正面・側面から 見えない
- でも「鋭さ」「柔らかさ」「ごつさ」の印象 すごく左右する
- 美少年・美少女キャラの 生命線
- テク:
  - ラインのための 専用エッジ 作る。ポリゴン 分割する
  - 欲しいライン 出すため ポリゴン 惜しむな

## Tripo の話

- Tripo 出すアニメ風キャラ、Xrd モデルの口周りトポロジに 似てる、と指摘あり
- 学習元に Xrd 参考にした 可能性、あるかも。確証なし
- 直接コピー以外の 説明:
  - アニメ調キャラ 口角から頬へ 放射状エッジループ、定番
  - Xrd 手法 GDC 等で公開済み。参考にした公開モデル 多い。間接的に似る
- 未確認: Tripo 出力 トポロジまで学習か、見た目だけ学習してメッシュ後処理 (自動リトポ) か

## 関連

- [[ai-3d-character-llm-tripo-blender]]
- [[charakuru-tripo-vrm-kit]]
