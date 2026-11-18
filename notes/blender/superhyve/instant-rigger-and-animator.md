---
title: Instant Rigger and Animator
description: 人型の自動リグ + 2300+ アニメライブラリ + FBX/GLB 出力。完全ローカル。$39 (セール $28.86)、評価なし
# permalink:  # don't use
aliases:
  - instant-rigger
tags:
  - blender
  - superhive
  - rigging
  - animation-library
draft: false
date: 2026-11-18
---

# Instant Rigger and Animator

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/instant-rigger-and-animator-auto-rig-animate-and-export-humanoid-characters-

## 価格・状態

- blenderustad。$39 (セール $28.86)。販売 20+、評価なし (前回調査時の数値)。
- Blender 4.2〜5.2 (4.2 LTS と 5.2 Windows で検証)。完全ローカル。

## 要件

- 人型1体、T / A ポーズ。既存アーマチュアモディファイア・シェイプキー付きメッシュは不可 (複製で対応)。
- 体 10万評価頂点まで。服含め 50万頂点まで (マルチパートは合計 10万)。

## 5ステップのウィザード

1. Character (メッシュ選択、向き、ポーズ指定)。
2. Body Guides (12点、自動配置 + 手動調整、ミラー、Side View)。
3. Skeleton & Bind (19 deform ボーン、指ありで 49)。Auto Bind Character。Test Pose (Neutral / Elbows / Arms / Hip)。
4. Animate (ライブラリ 2300+ クリップ、24カテゴリ)。
5. Edit & Keyframe (IK/FK コントロール、Key、Save Pose)。

## 自動バインドが形状で方式を選ぶ

- 体 + 服: 体をスキン後、服へ転写。
- 体なしの服だけ: 一時コピーで穴を塞いでスキン。元の開いた縁と UV は保持。
- ロボ・鎧: 硬いパーツごとに1ボーン (剛体)。
- 髪・目・歯: 最近接面に追従 (名前が明確なら頭)。
- キャラ種別のドロップダウンなし。

## アニメーション

- 2300+ クリップ (Walk / Run / Dance / Fight / Sit / Jump / Climb / Sports / Gestures ほか)。クリック即再生。Add to Character で複数追加。
- **リターゲット設定不要** (専用スケルトンにマップ済み)。T / A ポーズの違いもプレビューで補正。
- Animation Corrections: IK/FK コントロールを1回動かすと、範囲全体にブレンド付きオフセット。元モーションは保持。
- 指は任意 (指先クリックで生成、6本以上も可)。ただし指の動きがあるクリップは5本のみ。

## 出力

- FBX / GLB。Character + Animation / Animation Only / Mesh + Rig (Rest Pose)。
- ヘルパーボーンのない deform ボーンのみのクリーンなスケルトン。Unity / Unreal / Godot / Web 向け。

## 限界 (作者の記載)

- 人型の二足のみ。動物・顔リグなし。
- 足ロール・自動足固定・接地検出なし。
- 衣類 / 髪シミュなし。長いスカート・マントは要修正。
- ガイド配置は幾何的推定。変則的な体型は要確認。

## Auto-Rig Pro 持ちの視点

- 自前スケルトン前提で ARP と競合。リグ生成は ARP で足りる。
- 価値: 2300+ クリップのライブラリ + 敵・モブ量産のプロトタイプ。ARP リグにはそのまま使いにくい。

## 関連

- [[rigmend]] (同じく AI メッシュ向けリグ生成)
- [[blaze-puppeteer]] / [[motiongen]] (モーション生成・取得)
