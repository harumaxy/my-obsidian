---
title: RigMend
description: AI生成の人型メッシュを1クリックでリグ+スキン。Lite $1 / Pro $24。純Python、GPU不要、Mac可。レビュー0件
# permalink:  # don't use
aliases:
  - rigmend
tags:
  - blender
  - superhive
  - rigging
  - ai-mesh
draft: false
date: 2026-11-18
---

# RigMend

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/rigmend

## 価格・状態

- 作者 MendWorks。Lite $1 / Pro $24。
- **レビュー0件**。販売数表示なし。
- Blender 4.2+ (5.0 / 5.2.2 検証)。**Win / Mac / Linux、純 Python、GPU 不要、完全オフライン**。

## 要件

- 人型のみ。T ポーズ or A ポーズ。**単一メッシュ**。既存リグは先に削除。
- 入力: GLB / FBX / OBJ。

## 仕組み (作者の説明)

- メッシュをソリッド化 → 股・首・肩・四肢を形状から検出 → 骨配置 (hips / spine / neck / head / shoulders / elbows / wrists / knees / ankles / toes)。
- フード・リュック・ジャケット付きでも崩れにくいと主張。
- Find Joints でマーカーを表示、手動調整可。
- スキニングは自社 WeightMend エンジン。ボタン・ストラップ・髪カードなどの分離パーツは乗っている部位に追従。

## 精度・速度 (作者計測)

- 関節位置: Mixamo の3キャラで身長比 1.2〜1.6% 以内。
- 6k 頂点で約1秒。16k 頂点で約25秒 (ノート PC)。25万頂点超も処理可。
- Mixamo「Samba Dancing」(547フレーム) のリターゲットが約6秒。

## Lite と Pro

- **Lite ($1)**: 全身リグ + スキン、Mixamo 骨名、マーカー、Test Pose、Remove。
- **Pro ($24)**: + 指、Apply Animation (Mixamo FBX。A ポーズでも T ポーズ素材が再生可)、Unreal / Unity / Godot 骨名、書き出しプリセット、Rig Each Selected (一括)。
- Lite と Pro は同時インストール不可。
- Test Pose で弱点確認 (腕上げ・膝曲げ・首回し)。Remove Rig で元メッシュに完全復帰。

## 限界 (作者の自己申告)

- 人型のみ。動物・クリーチャー不可。
- 腕を体に密着 + 太い胴体 (鎧・大きなコート) は胴体にウェイトが漏れる。肩マーカー調整か腕を上げて対処。
- AI 生成の融合した指は「ミトン」扱い (手1本につき曲げチェーン1本)。指が分離なら5本。
- 顔リグなし。

## 関連 (同作者 MendWorks)

- QuadMend: リメッシュ。リメッシュするとリグが壊れるので**先にリメッシュ**。
- SeamMend / WeightMend / SwayMend (髪・尻尾・マントの揺れ物)。

## Auto-Rig Pro 持ちの視点

- Pro ($24) は不要。リグ・指・顔・エンジン出力・Mixamo リターゲットは ARP で足りる。
- Lite ($1) は価値あり: 敵・モブ量産 (マーカー調整なし・一括)、使い捨てプロトタイプ、AI 生成品質の検証。
- 主力キャラには不向き (顔なし・指ミトン・ウェイト漏れ)。

## 関連

- [[adaptive-auto-skinning]] (再ウェイト)
- 前段: [[image-to-3d-milad]] / [[bizen3d]]
