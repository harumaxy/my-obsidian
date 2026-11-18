---
title: QuadMend
description: AI・スキャンの三角形メッシュを修復してクアッド化。Instant Meshes と QuadriFlow を両方走らせ良い方を採用。$15、評価5.0 (2件)。完全オフライン
# permalink:  # don't use
aliases:
  - quadmend
tags:
  - blender
  - superhive
  - retopology
  - ai-mesh
draft: false
date: 2026-11-18
---

# QuadMend

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/quadmend

## TL;DR

- **AI 生成メッシュ向けの自動クアッドリメッシャー**。ボタン1つ。修復 → クアッド化 (2エンジン) → 元形状に貼り付け → テクスチャ焼き込み。
- 作者のテスト: Tripo / Hunyuan3D / SAM 3D の AI 生成 18 体 × 面数 2 設定 = 36 回で、**使える結果は QuadMend 22 / Instant Meshes 単体 4 / QuadriFlow (掃除後) 2 / QuadriFlow 単体 0** (単体は20回拒否)。作者自己申告。
- $15、完全オフライン、GPU 不要。Win / Linux 完全対応、Mac Apple Silicon はベータ。
- **[[smart-remesh]] ($17) の有機モードと競合**。Smart Remesh は Instant Meshes のみ。QuadMend は 2 エンジン + 修復 + ベイクで AI メッシュ特化。
- 評価 5.0 (2件) と薄いが、価格が安く試しやすい。

## 価格・状態

- 作者 MendWorks ([[rigmend]] と同作者)。$15。販売 20+、評価 5.0 (2件)。公開約2か月前、v0.10.9。Blender 4.2〜5.2、GPL。
- 作者の返信は 72 時間以内。Copy Report で状態を共有できる。

## 何をするか

1. 修復: 割れた継ぎ目の溶接、浮いた破片の除去、内側の殻の除去、複数片を 1 つの閉じた面に再構築。
2. クアッド化: Instant Meshes と QuadriFlow を走らせ、良い方を採用 (Best モード)。Fast モードは QuadriFlow のみ。
3. 元の表面にフィット (形状維持)。
4. ベイク: ベースカラー、粗さ、メタリック、アルファ、エミッション + ディテールのノーマルマップ。1K/2K/4K。
- 細かい隙間 (指の間など) を保つ。**リグ向けに部位を分けたい**ときに有効。
- 面数予算を指定: ゲーム小物 3,000、ヒーロー 10,000+。
- 元オブジェクトは変更せず、新規オブジェクトを作る。Ctrl+Z で戻せる。品質レポート付き。

## v0.10.8〜0.10.9 の機能

- Mirror モディファイア対応 (片側を処理して戻す)。閉じたモデルの小穴を自動で埋める。
- 小パーツ除去のしきい値 (0 で歯・バックル・小物を残す)、選択パーツ除去除外。
- Keep Separate: パーツごとに別々にリメッシュ (手の剣を分離のまま)。
- Remesh Each Selected: 複数モデルを連続処理。対称、シャープエッジ、誤差マップ。

## 速度・資源

- 20万トライアングル: デスクトップで約1.5分、一般的なノート PC で約4分 (テクスチャ込み)。
- Low Resource Mode (低優先度で動く)。

## 限界 (作者の記載)

- 面数予算に入らない細部 (細い棘、爪、文字) は丸まる。ノーマルマップで補う。
- 自動リメッシャーで、手作業のリトポではない。**変形が要るキャラは出発点として使う** (関節ループは意図的に作られない)。
- 外部レビュー: 3DSkillUp が Labrador の AI → リグ付きゲーム素材のタイムラプスで使用 (作者ページ記載)。

## レビュー

- 3DSkillUp (無償提供): 第一印象は良好。進捗表示とリソース使用の改善を要望 (作者は v0.10.9 で対応)。
- Dima: 最初はバグがあったが、連絡後に作者がすぐ修正。

## 関連

- [[smart-remesh]] (有機は Instant Meshes のみ、ハードサーフェス用 n-gon 化あり) / [[quadforge-pro]] / [[mesh-prep-studio]]
- [[bizen3d]] は生成 + クアッドリメッシュ込み。後処理を別にするなら [[image-to-3d-milad]] と組み合わせる
