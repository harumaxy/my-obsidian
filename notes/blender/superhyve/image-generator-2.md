---
title: Image Generator 2
description: Blender のレンダーを Gemini (Nano Banana) / OpenAI 画像モデルで加工するクラウド型。自前 API キー必須。$29、評価5.0 (1件)
# permalink:  # don't use
aliases:
  - image-generator-2
tags:
  - blender
  - superhive
  - image-generation
  - cloud
draft: false
date: 2026-11-18
---

# Image Generator 2

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/image-generator2

## TL;DR

- **3D のレンダー → AI で製品写真風・コンセプト画像に変換**。クレイ (灰色) レンダーを素材付き写真にする用途。
- **クラウド型**。Gemini (請求有効な API キー) か OpenAI の API キー必須。利用料は別、モデル・品質・規制は提供元次第。
- ゲーム用 3D 制作の本筋ではない。ブロックアウトからのコンセプト出し・紹介画像向け。ローカル ComfyUI を持っているなら優先度低。

## 価格・状態

- 作者 Unik Studio。Personal $29 (1席) / Team 5席。販売数不明、評価 5.0 (1件)。公開 5 か月前、v2.5.0。
- Blender 4.0〜5.3。GPL。
- 旧モデルの終了日 (2026 年 10 月) に言及あり。モデル一覧は 2026-09-16 確認時点。

## 機能

- Edit Render: 現在のレンダー結果を AI で編集 (クレイ → フォトリアル)。保持ロック (カメラ・光・形・材質・ロゴ・文字)。
- Text to Image (プロンプトのみ)、プロンプトテンプレート (製品・ライフスタイル・コンセプト・ナイト等)。
- 参照画像最大 5 枚、マスク編集 (Annotate で範囲を描く)。
- Keep Maintain Consistency: 別カメラ角度でも同じ製品の見た目を維持。
- 履歴、AI アップスケール、1K / 2K / 4K (プロバイダー次第)。分割ビュー。
- モデル: Gemini 4 種 (Nano Banana 2 など) + OpenAI 7 種。

## レビュー

- 1 件 (5 星): 製品アセットの本番利用で、Gemini 単体より物のスケール感が良いとのこと。作者返信が別製品名 (MergeTools) と混ざっており、やや雑。

## 注意

- 提供元のモデル・規約・モデレーションで出力が左右される。生成物の権利は各プロバイダーの規約に従う (要確認)。
- ゲームのキャラ・モブのテクスチャ量産にはほぼ関係しない。
- ローカル運用なら [[texturaizer]] (ComfyUI)。

## 関連

- [[texturaizer]] / [[pixel-local-ai]]
