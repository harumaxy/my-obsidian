---
title: Mixamo モーション調査 - トップダウン2.5D ARPG向け
date: 2026-09-09
---

# Mixamo モーション調査

対象: トップダウン2.5D アクションRPG(Diablo系)

## 総評

プロトタイプ・インディー向き◎。無料・自動リギング・数百種即使用可。
本番polish向きには限界あり。

強み: 検索豊富、リギング自動化、時短。
弱み: 特定ジャンル動作(戦闘武器種別、クリーチャー、スポーツ)薄い。複数投稿者混在→動き質感バラバラ(dissonance)。

## カテゴリ別 検索キーワード

移動:
- Idle, Walking, Running, Sprint
- カメラ固定角度→8方向不要。回転はエンジン側Blend Tree/Blend Spaceで処理

近接攻撃(武器種ごと複数DL→コンボ用):
- "Sword And Shield Slash" / "Great Sword Slash" / "Standing Melee Attack" 系
- 同一武器カテゴリ統一→振り質感揃う

遠距離/魔法:
- "Standing 2H Magic Attack" 系(詠唱)
- "Bow Shooting"

被弾・死亡:
- "Hit Reaction" 系複数(方向別あれば尚良)
- "Dying" / "Death From Right" 等

回避:
- "Roll" — ARPG必須、Mixamo種類少ない→Dodge系代用 or 有料アセット

その他:
- "Picking Up"(拾い)
- "Drink" / "Use Item"(ポーション等)

## 既知バグ・不満点

- FBXスケール暴発(Unity取込時 巨大化)
- 指/脚 変形(Blender経由export時)
- Root Bone名不一致(`mixamorig:Hips` vs `mixamorig1:Hips`)→センターずれ
- 武器種別戦闘・クリーチャー・スポーツ系は薄い→専門アセット補完要

## 運用Tips

- 自キャラをMixamoにアップ→専用リギング→そのモデル向けDL最安定。汎用DLは破綻しやすい
- DLオプション"In Place"選択→Rootモーションなし版取得。トップダウンはコード側移動制御が扱いやすい
- 複数キャラ跨いでも同一武器カテゴリのモーションだけ拾う→違和感減る
- Roll/Dodge質良いもの少ない→ここだけ有料補完が定番

## 補完アセット(有料)

- Mobility Starter — 35+種、Idle/Walk/Jog/Jump/Crouch/Strafe等
- ByteSumPi Locomotion Pack — 581種、FPS/TPS向け

## 出典

- [Adobe Community - How to best use Mixamo](https://community.adobe.com/t5/mixamo-discussions/how-to-best-use-mixamo-characters-and-animations/m-p/13889535)
- [Adobe Community - Scale bug in Unity](https://community.adobe.com/t5/mixamo-discussions/animation-from-mixamo-greatly-increases-the-scale-of-my-character-in-unity/m-p/12854872)
- [itch.io - Mixamo glitchy models](https://itch.io/t/482960/solved-mixamo-models-acting-glitchy-and-strange)
- [MoCap Online - Mixamo Alternatives](https://mocaponline.com/blogs/mocap-news/mixamo-alternatives-character-animations)
- [Mobility Starter](https://mocaponline.itch.io/mobility-starter)
- [ByteSumPi Locomotion Animation Pack](https://bytesumpi.gumroad.com/l/ByteSumPi_TheLocomotionAnimationPack)
