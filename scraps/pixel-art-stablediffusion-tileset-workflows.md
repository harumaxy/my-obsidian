---
title: PIXEL ART with StableDiffusion + Tileset workflows
source: https://www.youtube.com/watch?v=FIOXGWCQgAI
channel: Not4Talent
date: 2024-03-26
---

# PIXEL ART with StableDiffusion + Tileset workflows

Stable Diffusion ピクセルアート生成 動画要約。

## 基本セットアップ

- チェックポイント: PixelArt LoRA使用。キーワード「pixel art」「pixel world」付加
- サンプラー DPM++ SDE、10ステップ、CFG5、Clip skip 2
- Hires fix 非推奨（ピクセルサイズ崩れ）。デノイズ0.7以上、512→大きめ解像度対応

## 背景（繰り返し可能）

Tile X有効化 → 非対称タイリングでシームレス生成

## 色コントロール

- ピクセルアート拡張の色数スライダーで制御
- グレースケール/白黒/カスタムパレット選択可
- カスタムカラーは Lospec からパレット抽出

## キャラクター・アニメーション

- ControlNet: OpenPose + Depth（重み0.85）使用。Pose My Art でポーズ作成
- 動き変更時: Depth + 新OpenPose + Reference（重み0.5、開始15%）組合せ
- 欠点: ControlNetガイド強すぎるとキャラ変形難しい。シンプルなポーズ推奨

## Img2img（ダークストーム氏手法）

- ラフスケッチ → img2img変換
- ControlNet Tile でバランス、デノイズ0.55〜0.65程度
- 色ズレる場合「Color correction for img2img」拡張使用

## アセット・タイルセット作成

- 素材まとめて1枚に描いてから生成 → 統一感保つ（バラバラ生成しない）
- ControlNet: Tile1（balanced, weight0.7, end0.4）+ Tile2（weight0.4, start0.2 end0.6）2重がけ
- XYZプロットでCFG×デノイズ組合せ確認 → 良い結果再入力し仕上げ
- 木材/彫刻/背景タイル等、同手法でスプライトシート化 → Unity等組込み可

## 他スタイル

等角投影(isometric)未検証。同ワークフロー流用できるはず、と話者言及。

## 元notes

- 関連: [[sd-model-choice-pixel-art]]
