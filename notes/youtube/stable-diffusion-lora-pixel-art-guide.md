---
title: stable-diffusion-lora-pixel-art-guide
description: Stable Diffusion XLをLoRAでファインチューンしドット絵スプライト生成する手順。31回学習実験の学びまとめ
# permalink:  # don't use
aliases:
  -
tags:
  - youtube
  - ai
  - gamedev
draft: false
date: 2026-09-09
---

元動画: [How to Fine-Tune Stable Diffusion for Pixel Art (LoRA Guide)](https://www.youtube.com/watch?v=OdafuDeNMyM) by pookie

## 概要

LLM駆動RPG開発中の投稿者、敵スプライトもAI生成化目指す。Dragon Quest風モンスター絵目標にSDXLをLoRAでファインチューン。31回試行錯誤の記録。

## データセット

- **枚数**: 145枚、512×512統一
- **出所**: Dragon Questスプライトシート切出し→アップスケール→紫背景統一加工（著作物由来、グレーゾーン扱い）
- **ラベル形式**: カンマ区切りタグ3〜5個/枚（例: `scorpion, claws, exoskeleton, dq_pookie`）。全画像共通トリガーワード`dq_pookie`付与
- ラベリング方針: スタイル自体は書かず、生成時に変えたい要素（種族・特徴）だけラベル
- LLM(Llama 4)自動ラベリング試すも誤認識連発→手動4時間かけ直し。データセット品質が学習成否の最重要要因
- 公開データセット: huggingface.co/datasets/pookie3000/pookie-pixel-512

## モデル選定: SD1.5 vs SDXL

- 制約: MacBookでローカル実行前提→重量級モデル除外、候補はSD1.5とXLの2択
- 同一データセットで両方学習→SDXL明確に優位。SD1.5はドット絵として不整合な出力、紫背景再現も失敗しがち
- 推測理由: SDXLはテキストエンコーダが二重構成(CLIP+OpenCLIP)で概念紐付けが強い、ベース学習データ品質も高く構造忠実性(アンチエイリアス無し等)に有利

## 拡散モデルの仕組み(誤解訂正)

- ピクセル直接予測ではない。純粋ノイズから開始し、除去すべきノイズを予測→繰り返しで画像生成
- 学習時: データセットから画像取得→ノイズ付加→モデルにノイズ量予測させる→予測精度上げる方向にパラメータ調整
- 3要素構成
  - **U-Net**: ノイズ除去役（「用務員」的役割）
  - **テキストエンコーダ**: プロンプトを数値列に変換、U-Netが解釈できる形にする
  - **VAE**: 画像を低次元空間へ圧縮/再構成（絵→スケッチ→絵、のイメージ）
- U-Netを低次元空間で動かす設計がSD論文のブレークスルー。高速化と高品質化を同時達成

## LoRAとは

- SDXL本体(UNet全体)は学習コスト高すぎ→低ランク行列(LoRA)だけ学習し本体に上乗せする手法
- 本体パラメータは凍結、LoRAアダプタのみ更新。少データ・短時間で済む

## 学習環境

- 24GB VRAM必要、Google Colab無料枠不可
- スポンサーEnverge提供のA100使用
- GUI(Automatic1111等)でなくdiffusersライブラリ+Python直書き選択

## 31回実験の学び

- **LoRA rank**: 低い方が良い。デフォルトrank4が最適。rank64→ドット絵として破綻。rank32でも紫背景再現失敗。学習容量上げすぎが逆効果
- **ステップ数**: 最低10000推奨。5000だとスプライトが崩れた見た目に
- **データセット品質最重要**: LLM自動ラベリングは失敗の元
- **SDXL >> SD1.5**: 同一データセットでも明確差

## 最終ベスト設定

SDXL、512×512画像、通常学習率、batch size 1、デフォルトLoRA rank(4)→MacBook上でDS世代らしいスプライト生成成功

## リンク

- Fine-tuning code: github.com/vossenwout/pixel-art-diffusion
- 学習済モデル: huggingface.co/pookie3000/pixel-monsters-lora-sdxl
- 学習データセット: huggingface.co/datasets/pookie3000/pookie-pixel-512
