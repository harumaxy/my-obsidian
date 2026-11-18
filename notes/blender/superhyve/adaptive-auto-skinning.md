---
title: Adaptive Auto Skinning
description: 既存リグに体+服を GPU ボクセルソルバーで一括スキン。評価5.0 (20件)。$29.75、30日返金保証
# permalink:  # don't use
aliases:
  - adaptive-auto-skinning
  - AAS
tags:
  - blender
  - superhive
  - rigging
  - skinning
draft: false
date: 2026-11-18
---

# Adaptive Auto Skinning

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/adaptive-auto-skinning

## 価格・状態

- 作者 Jessy Leite。$29.75 (定価 $35)。バンドル (+ Voxel Weight Transfer) $38.25 (定価 $45)。
- 単品 Voxel Weight Transfer は $25。
- **評価 5.0 (20件、5星 95%)**。販売数表示なし。
- Win / Mac / Linux。Blender 4.2〜5.3+。Metal / Vulkan / DirectX 対応 GPU。依存なし。
- 最新 1.5.7 (2026-11-14)。更新頻度高。日本語 UI あり。
- **30日返金保証**。更新は購入バージョン内無料。

## 概要

- **既存のリグ**に対し、体と服の全メッシュを GPU で一括スキニング。体 + 服で約1秒。
- **リグ生成機能なし**。RigMend のようなリグ生成とは別工程。
- 頂点グループだけ書く。1ステップで Undo 可。

## 仕組み

- ボクセル体積スキニング。体積をボクセルで埋め、各ボクセルを骨に割り当ててから表面へウェイトを渡す。
- 内外判定を形状自体から取るので**非水密・二重・重なりメッシュでも失敗しない**。AI 生成の乱れたメッシュに強い。
- アダプティブグリッド: 体は粗く (既定 92)、2面が近い場所 (指の間) だけ細分化。均一グリッド比で約13分の1のセル数。
- 骨名に依存せず骨の形状で判断。Mixamo / Auto-Rig Pro / Rigify / 手作りで同じ動作。

## 精度 (作者計測)

- 202キャラのベンチで、手塗りと支配骨が一致する頂点 80.9%。他の自動手法より上と主張。
- 平均 0.57秒 (MacBook Air M4)。
- 顔などは手作業が必要な場合あり。

## 機能

- Collection / Mesh / Bone スコープ。Only Selected Bones。既存ウェイト Keep / Replace / Clear。
- マルチカラー ウェイト オーバーレイ (骨ごとの領域を色分け)。
- **顔の自動スキニング (実験的) は Auto-Rig Pro リグ限定**。他リグは今後 (ロードマップ)。
- バンドルの Voxel Weight Transfer: 体のウェイトとシェイプキーを新しい衣装へ転写。**着せ替えキャラ向け**。

## レビュー (1ページ目 10件)

- 「数時間が数秒」「ゼロからのウェイト塗りより断然速い」(複数)。
- 「複数メッシュのキャラのスキニングが1ボタン + 数分手直しに」(Steen)。
- 「ローポリでも動く」(pondoweed)。
- 「Voxel Heat Diffuse + ARP を長年使ってきたが、指と顔が悩みだった。解決した」(Alan Night) ← ユーザーと同じ構成。
- 「AccuRIG でリグ → 再ウェイトが最も完璧に近い」(Marcelo)。
- 「ギガバイト級の依存やモデル重みのダウンロード不要」(Joseph)。
- 2ページ目 (10件)、Version History は未読。

## Auto-Rig Pro + Voxel Heat Diffuse 持ちの視点

- VHD に対する差: 指、顔 (ARP)、体 + 服 + 小物の一括、乱れた AI メッシュ、速度。
- きれいな手作りメッシュで指・顔を気にしないなら VHD で足りる。
- 買う前に同じ AI メッシュで ARP + VHD の結果を確認 → 不満なら AAS。

## 関連

- [[rigmend]] (リグ生成)
- 後段: [[blaze-puppeteer]] / [[motiongen]] (モーション)
