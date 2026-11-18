---
title: Image to 3D (Milad_Kambari)
description: Superhive のローカル画像→3D生成アドオン。TRELLIS/Pixal3D/Hunyuan + Canvas ノード式。$18
# permalink:  # don't use
aliases:
  - Image to 3D 2
  - imageto3d
tags:
  - blender
  - superhive
  - ai
  - image-to-3d
draft: false
date: 2026-11-18
---

# Image to 3D (Milad_Kambari)

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/imageto3d — $18

## 概要

- ローカル完全動作。クラウド・クレジット不要。
- v2.0.20 最新。無料アップデート。公開19日前。販売 1300+、評価 4.0 (22件)。GPL。
- Blender 4.2〜5.2。
- 25%オフクーポンあり (3日間、同作者 85商品対象)。

## v2 の Canvas (ノード式ボード)

- Prompt: テキスト → 画像。3D Ready プリセットで背景クリーン化。
- Upload / Image / Upscale。
- Multi View: 1枚から背面・左・右を生成。
- Find Parts: パーツ検出 + 各パーツ画像。
- Generate 3D → Enhance Detail → Enhance Texture。
- Auto Run: 全部一括。

## エンジン

- TRELLIS: 速い、細部多め。デフォルト。
- Pixal3D: 入力画像に忠実。
- Hunyuan: 形・テクスチャ最良。左右背面の追加画像を受け取れる唯一。
- Hi3D (Enhance Detail): 既存モデルの表面ディテール追加。
- Enhance Texture: FLUX.2 Klein + Marigold。

## 設定

- 面数 5千〜200万。テクスチャ 1K/2K/4K。テクスチャ無しなら高速。
- 品質 Fast / High / Ultra。Ultra は VRAM 12GB 必要 (8GB は High になる)。
- Seed 指定可。背景は自動除去。別プロセスなので Blender は固まらない。

## 時間 (4070 Ti 12GB 実測、4K・20万面)

- TRELLIS 1:21〜2:32。Pixal3D 2:48〜2:30。Hunyuan 2:18〜3:12。
- Enhance Detail 4:32。Enhance Texture 2:09。
- 4060 級 8GB の推定は約2倍。

## 容量・要件

- 全部入り約132GB。TRELLIS 単体 16.8GB。エンジンごとに別途 Python 環境の初回インストール。
- NVIDIA のみ (AMD GPU 不可)。VRAM 8GB+、RAM 16GB+。Windows / Linux。Mac 不可。

## ライセンス

- Canvas の全モデルは商用可。エンジンごとは個別 (THIRD_PARTY_LICENSES.md)。

## レビュー (Superhive 22件読了)

- 好評
  - 作者の対応が超速い。バグ1時間で修正。Discord 活発。
  - Linux で安定。サブスク生成サービスより安く時短。
  - 同作者の remesh / UV アドオンと併用して使う人あり。
- 不満
  - 直線的なハードサーフェス (家など) が苦手。有機形状・遠景の埋め草向き。
  - イラスト・デフォルメ系で失敗報告 (作者は「入力画像の問題」と回答)。
  - RAM 8GB は数時間かかる。
- 環境問題
  - 96% で止まる。原因: 日本語ファイル名、RTX 50系 (Blackwell) の Python/PyTorch 競合。
  - **画像は英字ファイル名で渡す**。
  - Ultra で黒メッシュ、生成後モデル無し → v1.0.3 で修正済み。
- 低評価は主に v1 初期の環境依存バグ。RTX4080 (Ada) は当たらない可能性高い。

## 弱点・注意

- UV / PBR ベイク / リトポ / リグの記載なし。リトポは [[smart-remesh]]、UV は [[auto-unwrap]] 併用前提。
- 作者ロードマップ: クアッド生成、100〜5000面指定 (未実装)。

## 関連

- 同作者の後処理: [[smart-remesh]] / [[auto-unwrap]] / [[mk-smart-segment]]
- 競合: [[bizen3d]] / [[genmesh]] / [[image-to-3d-local-zeg]]
