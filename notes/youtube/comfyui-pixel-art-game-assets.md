---
title: ComfyUIでゲームアセット生成＋カラーパレット制限
description: ピクセルアート生成ワークフローとVexTrノードによる色数制限手法
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - pixel-art
  - game-dev
  - ai-art
draft: false
date: 2026-07-23
---

動画: https://www.youtube.com/watch?v=wrsYJ5gli1U
チャンネル: Learn Digital Art with William Jiamin

## 方針

インディーゲーム開発。大量アセット→AI任せ、重要シーン(メインキャラ・カットシーン・ラスボス)→手描き分業。

AI生成ベース + ピクセルアート基礎学んで修正。品質ライン引いて使い分け。

## ワークフロー構成

1. civitaiからピクセルアート専用チェックポイント入手(ライセンス確認必須)
2. ポジティブ/ネガティブプロンプト設定
3. レイテント画像サイズ
   - 512x768: 全身キャラ
   - 768x512: 背景・ダイアログ
   - `half body`指定で顔詳細UP
4. VAE Decode → 基本これで十分

## カラーパレット制限 (GitHub: ComfyUI VexTr Nodes)

色数フラット化ノード。ゲーム機時代の再現。

- 2色: Game Boy / Play Date風
- 8色: Game Boy Color風
- 16〜32色: Sega Genesis / SFC風

**推奨: 8色以上か2色。3〜4色は中途半端で結果微妙。**

## 背景生成

`pixel art, castlevania style castle, moon, background` などで生成可。横長レイテントでパララックス背景として使用。

## 入手

ワークフロー: Patreon → Googleドライブ共有
