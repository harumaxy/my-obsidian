---
title: WeightForge
description: ウェイトの問題を診断・自動修正し、階層を考慮してバインドするアドオン。$30 (表示 $22.50)。販売20+、評価なし
# permalink:  # don't use
aliases:
  - weightforge
tags:
  - blender
  - superhive
  - rigging
  - weight-painting
draft: false
date: 2026-11-18
---

# WeightForge

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/weight-painting-addon-fix-weight-painting

## TL;DR

- 既存のウェイトの**不具合修正 + 階層考慮のバインド**。診断 → 補正 → バインドの3段。
- 対象: 腰・肩の潰れ (打ち消し合う影響)、肘・膝・指のキャンディラップ状のねじれ、手が腰から影響を借りる誤バインド。
- 作者は「芸術的なウェイト塗りの代替ではない」「極端なポーズは手直し要」と明記。
- 評価なし、販売 20+、公開4か月。実績が薄い。**[[adaptive-auto-skinning]] (評価 5.0・20件) と役割が重なる**。優先度低。

## 価格・状態

- 作者 Anvil Interactive Solutions。$30 (表示 $22.50)。販売 20+、評価なし。公開4か月前。
- Blender 4.2〜5.2。ライセンス GPL。Cycles / Eevee。

## 機能

- Cancelling Weights: 逆向きの骨の影響が打ち消し合う頂点を検出し再配分。腰・肩の潰れ、引き裂けの原因。
- Joint Falloff: 急なグラデーション偏りを自然な減衰カーブに置換。肘・膝・指。
- Hierarchy Bind: 距離 + 骨階層で影響を決める。影響する骨を自動検出。
- ライブヒートマップ: 問題領域を調整中にリアルタイム表示。
- 想定ユーザー: キャラリガー、ゲームアセット制作、アニメーター。

## 限界 (作者の記載)

- 既存の頂点グループと骨階層に対して補正する。親子付けが大きく狂っている・欠けている場合は先に整える。
- スタイライズ・非物理変形は手作業が必要。
- 極端なポーズは手直し。

## ARP + VHD 持ちの視点

- 使い所があるとすれば、VHD で出た後の**不具合箇所の仕上げ**。ただし [[adaptive-auto-skinning]] の方が実績があり、再ウェイトも同時にできる。
- 具体的な手法・数値・アルゴリズムの記載は薄い。比較検証なしで買う理由は弱い。
- 試すなら、VHD 後に腰・肩が潰れた 1 体で診断機能だけ見る。返金条件はページに記載なし (要確認)。

## 関連

- [[adaptive-auto-skinning]] / [[rigmend]] / [[auto-rig-ragdoll-wizard]]
