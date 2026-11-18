---
title: Image to 3D (AI in Your Local Blender) ZEG
description: Apple Silicon 対応の唯一の画像→3D アドオン。$2.99、実験的、機能は最小
# permalink:  # don't use
aliases:
  - image-to-3d-local
  - ZEG Image to 3D
tags:
  - blender
  - superhive
  - ai
  - image-to-3d
  - mac
draft: false
date: 2026-11-18
---

# Image to 3D (AI in Your Local Blender) ZEG

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/image-to-3d-local

## 価格

- Personal $2.99 (個人・フリーランス)。Commercial $3.99 (商用・クライアント案件)。Studio $29.99 (最大100席)。
- 10%オフクーポンあり (1か月、同作者 252商品対象)。
- 公開8日前。Blender 4.2〜5.2。GPL。評価・販売数の表示なし。

## 概要

- 1枚の写真 → 3D モデル。サイドバー1タブ。画像選択 → エンジン選択 → Generate。
- PBR マテリアル付きの通常メッシュを取り込む。
- テクスチャ 512 / 1024 / 2048。
- インストーラー、進捗、キャンセル、エンジンごとのログあり。
- エンジンとウェイトは指定フォルダ (拡張機能内には入れない)。実行環境で動くエンジンだけ一覧に出る。

## エンジン

- TRELLIS.2: Apple Silicon と Windows x64 のデフォルト。Windows は Vulkan ランタイムで実験的。RTX 4080 ノートで 1024px モデルが約3分。
- Hunyuan 2.1: 形状のみ or 形状 + PBR。Apple Silicon (macOS 15+) 向け。
- UltraShape: 粗いメッシュ (シーン内 or OBJ/GLB) を参照画像で精細化。
- TripoSR: CPU 実行の実験的エンジン。コード・ウェイトとも MIT。

## 要件

- **Apple Silicon 24GB+ 推奨**。調査対象で Mac 動作を明記する唯一の製品。

## 注意点 (作者の記載)

- 作者自身が「実験的」と明記。初回インストールは数GB〜と大容量で時間がかかる。
- 小さい文字やロゴはぼやける。テクスチャに斑点が出ることがある。
- 背景がプレーンで被写体が単独の画像が最適。
- Windows エンジンは全 GPU でテスト済みではない。
- ライセンス: Hunyuan 2.1 は EU・UK・韓国を対象外。TRELLIS.2 の DINOv3 ウェイトは Meta 規約。商用前に各エンジンを確認。
- 後処理 (UV / リトポ / ベイク / リグ) の記載なし。UltraShape の精細化のみ。

## 位置づけ

- 最安。Mac で品質検証するのに向く。本命は Windows (RTX4080) 側で [[bizen3d]] / [[image-to-3d-milad]]。

## 関連

- [[bizen3d]] / [[image-to-3d-milad]] / [[genmesh]]
