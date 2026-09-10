---
title: Robot Designer(Blenderアドオン)+ ゲームボーン規格メモ
date: 2026-09-10
---

# Robot Designer(Blenderアドオン)+ ゲームボーン規格メモ

対象: SuperhiveMarket "Robot Designer" 調査 + 汎用ヒューマノイドボーン命名調査

## Robot Designer 概要

作者Alexis Eginard。procedural robot生成アドオン。Blender 4.5.4+、V3最新。

- プリセット選択→スライダー→10分未満で完成品
- ジオメトリnodes 800+パラメータ、25プリセット、Body Type 3種(Muscular/Average/Skinny)
- スマートマテリアル(PBR)、ゾーン別調整、ID map自動(Substance Painter用)
- リグ2択: Rigify(IK/FK) or Mixamo。custom hard-surface skinning内蔵、ウェイトペイント不要
- 仕上げ: アトラスベイク、LOD、FBX/OBJ/GLB、Unity/UE5/Sketchfabプリセット
- V3新機能: フィムボット対応、腹部形状カスタム、部位別長さ調整(Mixamoリグ限定)、対称カット
- ライセンス: Personal $29 / Commercial個人 $69 / Small Studio(〜10人) $149 / Large Studio $349
- 販売1000+、評価8件★高評価多数
- 制限: アドオン再配布禁止、生成ロボ単体転売禁止(大幅改変前提)

## 汎用ヒューマノイドボーン構造(ゲーム業界標準)

階層(root→末端)共通:

- Hips(骨盤、起点)
  - Spine → Spine1 → Spine2
    - Neck → Head
    - Shoulder → Arm(UpperArm) → ForeArm(LowerArm) → Hand → 指骨
  - UpLeg(Thigh) → Leg(Calf) → Foot → ToeBase

総数目安15〜20本(指込み50〜65本)。左右対称命名(`_L/_R`, `.L/.R`, `Left/Right`)。

## 規格ごと命名ブレ

同一規格内でもツール・バージョンで微妙違う:

- Mixamo — `mixamorig:Hips`。複数キャラ同時読込で`mixamorig1:`等連番プレフィックス付与→名前不一致事故あり
- Unity Humanoid — Avatar経由で役割マッピング(名前自由)。Unity内部表示名は`LeftUpperArm`(Mixamoの`LeftArm`と語順違う)
- UE Mannequin(旧) — `upperarm_l`。UE5 Manny/Quinn(新)は同名だが`ik_foot_root`等IK専用ボーン追加。UEFN系は独自命名混在
- Rigify(Blender) — `DEF-upper_arm.L`(変形用)/`upper_arm_ik.L`(コントロール用)でDEF/CTRLプレフィックス分岐。Mixamo系と互換ゼロ、要リターゲット
- VRM/VRoid — `J_Bip_L_UpperArm`。Unity Humanoidへ変換前提

実務対処: ボーン名文字列一致でなく「役割マッピング」(Unity Avatar / UE5 IK Retargeter / Blender Bone Constraints)経由が主流。名前ブレはマッピング層で吸収。

Robot DesignerのMixamoリグは公式Mixamoボーン名そのまま出力→素のMixamoアニメFBXとノーリターゲットで直結可能、が売り。関連: [[mixamo-arpg-motions]]

## 出典

- [Robot Designer — Superhive Market](https://superhivemarket.com/products/robot-designer)
