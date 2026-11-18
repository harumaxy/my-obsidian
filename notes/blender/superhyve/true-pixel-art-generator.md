---
title: True Pixel Art Generator v2
description: 3D モデル・アニメを 2D ピクセルアートのスプライトシートに書き出す Blender アドオン。生成 AI ではない。$1
# permalink:  # don't use
aliases:
  - true-pixel-art-generator
tags:
  - blender
  - superhive
  - pixel-art
  - sprite
draft: false
date: 2026-11-18
---

# True Pixel Art Generator v2

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/true-pixel-art-generator-v2

## TL;DR

- **生成 AI ではない**。3D モデル + アニメを、ピクセルアートのスプライト (PNG、連番、GIF、スプライトシート) にレンダリングする書き出しパイプライン。
- 3D モデルは非破壊。ビューではピクセル化せず、プレビューと書き出しで変換。
- 2D ゲーム向けに 3D キャラを使いたいときに有効。$1 なので試す価値あり。3D ゲーム用途なら不要。

## 価格・状態

- 作者 ByteBard。$1。販売 30+、公開 8 か月前。
- ページ本文は Blender 5+ 向けと書くが、詳細欄は Blender 4.0〜5.0 と表記が矛盾。Eevee。GPL。

## 機能

- 前後左右上下 + 3/4 の固定カメラ、モデルに合わせた平行投影カメラ。
- 高解像度でレンダー → 指定ピクセルサイズへ縮小。減色、アルファ整理、ディザ、コントラスト/彩度、ピクセルアウトライン。
- 出力: PNG 単体、PNG 連番、GIF (FFmpeg があれば)、グリッド詰めスプライトシート。フレームステップ指定。
- ライブプレビュー + Image Editor 分割。ライティングプリセット。

## 注意

- 小さいスプライト (32x32〜48x48) は単純なモデルと強いシルエット向き。細かいキャラは 64〜128 以上。
- 描き込まれない細部は補われない (簡素化・カメラ調整・サイズアップ)。

## 使い所の見立て

- 2D ゲームのスプライト制作に、3D キャラ + [[motiongen]] / [[blaze-puppeteer]] のモーションを組み合わせる流れが成立する (推測)。
- スプライトそのものを AI 生成する製品は見つからなかった。2D は ComfyUI (Windows PC) が現実的。
