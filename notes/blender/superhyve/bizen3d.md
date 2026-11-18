---
title: Bizen3D
description: 画像→3D生成 + クアッドリメッシュ + ベイクまで1本で完結するローカルアドオン。$20、レビュー0件
# permalink:  # don't use
aliases:
  - bizen3d
tags:
  - blender
  - superhive
  - ai
  - image-to-3d
draft: false
date: 2026-11-18
---

# Bizen3D

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/bizen3d

## 価格

- $20 (定価 $24)。サポート版 $26。5席 $60。
- 公開11日前。v1.0.x。Blender 4.5〜5.2。GPL。
- **レビュー0件。実績不明**。

## 概要

- 画像 → テクスチャ付き 3D。完全ローカル。アカウント不要。
- 「新しい image-to-3D モデルが出るたびに取り込み、購入者に無料提供」が売り。生涯アップデート。

## エンジン

- Pixal3D: 入力画像に位置合わせして生成。
  - Pixel Match: 元画像のピクセルを表面に直接貼る。顔・ロゴ・文字がボケない。見えない面は生成色で補完。
  - Multi-View: 前・左・背・右の最大4枚。
- TRELLIS.2: 約1分。Fast/Smooth と High。エンジン導入で同梱。
- Hi3D (Enhance Detail): 既存モデルを約100万三角形まで精細化。

## 後処理 (Image to 3D との最大の差)

- Upscale Texture: Real-ESRGAN で2倍。最大4096px。色・粗さ・金属は拡大、法線は据え置き。
- Remesh into Quads: 三角形 → クアッド。既定1万、数は指定可。元の色・粗さ・金属・法線をベイク。20秒 (1万quad)。
- 上の2つは生成物以外の任意メッシュにも使える。
- UV 展開・リグの記載なし。

## 設定

- 面数 1,000〜2,000,000。テクスチャ 128〜4096px。
- テクスチャ無しで約2倍速。Seed 指定可。512px 未満の画像は×4 拡大してから生成。
- 生成設定は .blend に保存。別プロセス実行、キャンセル可。10分未使用で GPU 解放。

## 時間 (4070 Ti SUPER 16GB)

- Pixal3D High 15万面: 78秒。TRELLIS.2 High: 52〜72秒。
- Multi-View 4枚: 約2分。Enhance Detail: 112秒。Remesh 1万quad: 20秒。
- 起動後の初回は +20〜30秒。

## 容量・要件

- Engine (必須、TRELLIS.2 込み) 約14GB。Pixal3D 5.8GB。Multi-View 5.2GB。Enhance Detail 10.6GB。全部で約36GB。
- NVIDIA VRAM 6GB+ (Multi-View / Enhance は 8GB+)。Windows 10/11 前提。Linux はコード上対応だが未テスト。AMD は実験的。Mac 不可。
- 完全オフライン (ダウンロード時のみネット)。

## ライセンス

- TRELLIS.2 / Pixal3D は MIT。
- Hi3D (Enhance Detail) のみ Hi3D Open License + 利用規約 (AUP)。追加時に同意が必要で、生成モデルにも適用。商用は要確認。
- Hunyuan 不使用。EU / UK / 韓国の制限なし。

## 入力のコツ

- 1物体、全体がフレーム内、無地背景、正面か斜め前。背景は自動除去。

## 弱点・未確認

- docs 短い。UV の扱い不明。Remesh 後のベイクで UV 新規作成のはず (推測)。
- Remesh の手法 (Instant Meshes 系か) 不明。
- Version History 未読。
- Blender MCP から呼べるか不明。

## 関連

- [[image-to-3d-milad]] と二者択一でなく、品質比較したい。
- UV を詰めるなら [[auto-unwrap]] を後段に。
