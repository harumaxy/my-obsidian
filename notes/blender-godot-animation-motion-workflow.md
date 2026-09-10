---
title: blender-godot-animation-motion-workflow
description: Blender+Auto Rig Pro所持者がGodotゲーム用モーション調達→リギング→AnimationTree構築するまでの手順メモ
# permalink:  # don't use
aliases:
  -
tags:
  - blender
  - godot
  - animation
draft: false
date: 2026-09-10
---

## 前提

Blender + Auto Rig Pro(ARP)所持。手付けアニメ面倒→既存モーション流用or AI生成で楽したい。最終ターゲットはGodotゲーム。

## モーション調達手段

### 量で攻める（本命、ゲーム制作向き）

- **Mixamo** — 無料。移動系（歩く/走る/ジャンプ/しゃがむ）は全部揃う。ゲーム制作の第一候補
- **ActorCore (Reallusion)** — Mixamoより高品質。戦闘系（剣戟/格闘）パック充実、Mixamo補完に使う
- Unity Asset Store / Unreal Marketplace にもモーションパックあり（エンジン別最適化済み、Godotなら該当薄い）

### AI生成（ピンポイント補完用、量産には不向き）

- **DeepMotion SayMotion** — text prompt→3Dモーション生成。出力: FBX/GLB/BVH/MP4。Inpaintingで部分修正可。クレジット制、無料枠あり
- **Kinetix** — 元Text2Emotes。ゲームSDK組込み前提の設計→ゲーム制作目的なら相性良い。ライブラリに無い特殊技の補完向き
- **Meshy AI Animation** — text-to-motionというよりプリセットモーションライブラリ寄り（600+動作、FBX/GLB出力）
- **Cascadeur** — AI物理ベースキーポーズ補間。生成というより手付け労力を激減させる補助ツール
- **Wonder Studio** — 実写演技動画→3Dキャラへ自動モーション+ライティング+コンポジット転写。品質段違いだが実写演技が撮れる前提
- **Rokoko Video / Move.ai** — スマホ動画からモーキャプ

判断: 移動・基本動作はMixamoで足りる。戦闘の特殊技・必殺技だけAI生成で埋める、が効率良い。

### BVHとは

モーキャプデータの標準フォーマット。骨階層+各フレーム回転値のみ、メッシュ/マテリアル無し（軽い）。FBXは全部入り（重い、汎用）。モーションだけ移植したい時BVH、キャラ丸ごとならFBX。

## Blender→Godot取り込みフロー

GodotはFBX直インポートが弱い→Blender経由でglTF化が鉄板:

1. Mixamo/ActorCoreからFBXダウンロード
2. BlenderにインポートしARP Retargetingで自キャラボーンに移植
3. 全モーション統合したキャラをglTF(.glb)でエクスポート
4. Godotにインポート（glTFがGodot標準、一番安定）

Godot 4.3+はglTFインポート時`SkeletonProfileHumanoid`でリターゲット可能→同じHumanoidプロファイルなら1体分のモーションを複数キャラで使い回せる。

## Godot側 AnimationTree構成

### シーン構成

```
Character (CharacterBody3D)
├── Skeleton3D
├── AnimationPlayer   ← 全クリップ保持
└── AnimationTree     ← ブレンド/遷移制御（active=true, anim_player指定必須）
```

### 移動: BlendSpace1D/2D

root を `AnimationNodeBlendTree` にし `BlendSpace1D` 追加。idle@0.0, walk@0.5, run@1.0 配置。毎フレーム速度で駆動:

```gdscript
var blend = inverse_lerp(0.0, run_speed, velocity.length())
anim_tree["parameters/BlendSpace1D/blend_position"] = blend
```

8方向欲しいなら`BlendSpace2D`で`input_dir`(Vector2)をそのまま渡す。

### 戦闘: StateMachine + travel()

```gdscript
var playback = anim_tree["parameters/playback"]
playback.travel("attack1")
```

`travel()`は滑らか遷移、`start()`は即切替。コンボは`animation_finished`シグナル+攻撃入力バッファで次の技に繋ぐ。ヒットボックスON/OFFは**Call Method Track**で攻撃モーションの特定フレームに仕込む（毎フレームコードでやらない）。

### 注意点

- AnimationTreeの`active`false忘れ→何も再生されない
- ブレンドパラメータは状態変化時だけでなく毎フレームセット必須
- looping系(idle/walk/run)はLoop設定、one-shot系(attack/death)はNone設定
