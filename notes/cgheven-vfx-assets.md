---
title: CGHEVEN - 無料 VFX 素材サイト
description: VFX・VDB・フリップブック等を無料配布するアセットサイト。素材種別の違いを整理
# permalink:  # don't use
aliases:
  - cgheven
tags:
  - vfx
  - 3dcg
  - asset
  - godot
draft: false
date: 2026-11-01
---

# CGHEVEN

https://cgheven.com/

キャッチコピー "Visuals Without Limits."
VFX 素材、3D モデル配布サイト。運営 アーティスト Ammar Khan。

## 素材 (全体 841+ 件)

- VFX 526: 実写エフェクト映像。爆発、雷、煙
- VDB 133: 3D 体積データ
- Flipbooks 128: 連番スプライトシート
- 3D モデル 41
- HDRI 3
- Shaders 1

例: Aerial Explosion 01-07、Thor Lightning Energy Arc (Slomo) 01-08、Smoke Plume Rising

## 料金

- 無料: 618 素材、1K / 2K、登録不要 DL
- Pro: 月 $5 (年払い 月 $4.17)、4K、EXR 連番、毎週プレミアム追加
- 上位 Studio / API プランあり
- 商用利用可と記載。細部 License ページ要確認 (未確認)

## 無料ツール・アドオン

- アドオン: AE, Premiere, DaVinci, Blender, Unreal, Houdini, Maya, Godot 対応
- ツール: PBR マップ生成、3D ビューア、背景除去
- チュートリアル: 英語、ウルドゥー語

## VFX = Visual Effects

映像に後から合成する視覚効果。爆発、煙、炎、雷。
このサイトの VFX 素材 = 実際に撮影したエレメント映像。CG シミュより質感リアル。

## VFX / VDB / フリップブック 違い

- VFX
    - 実写エレメント動画。2D。視点固定
    - 映像編集ソフトで重ねる。Screen / Add 合成で黒背景透過
- VDB
    - ボリュームデータ。3D。視点自由
    - Blender / Houdini でレンダリング。一番リアル、一番重い
- フリップブック
    - コマを格子状に並べた 1 枚画像。パラパラ漫画式
    - ゲームエンジン向け。一番軽い

重さ: VDB > VFX > フリップブック

## 拡張子 (一般論。サイト実物は未確認)

- VFX: `.mp4` `.mov` / `.png` 連番 / `.exr` 連番 (Pro)
- VDB: `.vdb` (連番 `smoke_0001.vdb` ...)
- フリップブック: `.png` `.webp` `.exr` 。行数・列数は別途メモ必要
- HDRI: `.hdr` `.exr`
- 3D モデル: `.fbx` `.obj` `.blend` `.glb`

## VDB 語源

Volumetric Dynamic B+tree。OpenVDB の中核データ構造。

- 作者: DreamWorks Animation の Ken Museth。のちにオープンソース化
- 3D 空間を B+木 管理。中身ある領域だけ保存、空は持たない (疎ボクセル)
- 煙、雲 = 大半が空の体積。省メモリで高解像度
- Houdini, Blender, Maya 標準対応

## Godot で使うなら

1. フリップブック選ぶ (一番直接使える)
2. `GPUParticles3D` か `AnimatedSprite` で再生
3. 加算ブレンドで光る爆発

VFX 動画はスプライトシート化が必要。VDB は Godot 直接非対応。
