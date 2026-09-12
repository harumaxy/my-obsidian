---
title: Blender 3Dモデル→アイソメドット絵スプライト作成
date: 2026-09-12
---

# Blender 3Dモデル→アイソメドット絵スプライト作成

出典: ArtStation Blog "Tutorial: Creating 2D Pixel Art Style Isometric Sprites from a 3D Model in Blender" (Jen S Abbott) https://www.artstation.com/blogs/jsabbott/YQaAw/tutorial-creating-2d-pixel-art-style-isometric-sprites-from-a-3d-model-in-blender

## Step1: モデル準備

- モデル選択 → Object > Set Origin > Origin to Geometry
- Nパネル > View タブ > Lock Camera to View ON

## Step2: アイソメカメラ設定

- カメラ Location: X10 Y-10 Z10、Rotation: X54.736 Y0 Z45
- カメラタイプ → Orthographic
- Render > Film > Transparent ON
- 出力解像度 256×256
- テンキー0でカメラビュー確認、モデル位置・スケール調整

## Step3: ドット絵化(シェーダー+コンポジット)

- Shading workspace: BSDF→Material Output間に Shader to RGB ノード挿入
- 続けて Color Ramp 追加、補間 Constant(影くっきり、ハイライト強度調整可)
- Render > Film > Filter Size = 0.01
- Color Management > View Transform = Standard
- Compositing workspace で Use Nodes ON
- Render Layers→Composite/Viewer 間に Scale ノード追加
- Value ノード(0.2)をScaleのX/Yに接続→縮小
- 縮小後に Pixelate ノード
- Scale+Valueノード複製、Pixelate後に配置、Value=5→拡大
- これでピクセルアート風になる

## Step4: 回転アニメーション(8方向)

- Frame1でLocation/Rotation/Scaleキーフレーム(I)
- Frame2でZ軸45度回転→キーフレーム、Frame8まで繰り返し(360度一周分)
- End Frame = 8
- 出力 PNG + RGBA(透過)
- Render > Render Animation

## Step5: スプライトシート化

- Affinity Photo等で新規ドキュメント(例1024×512、透過背景)
- 8枚ドラッグ、ガイド線で位置揃え(例256/512/768)
- PNG書き出し→ゲームエンジンで使用

## メモ

車モデル例だが任意モデルに応用可。フレーム数増やせば滑らか、Color Rampいじれば影の見た目変わる。
