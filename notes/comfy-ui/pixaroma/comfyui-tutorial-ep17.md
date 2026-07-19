---
title: "ComfyUI Tutorial Ep17 - Flux LoRA の使い方・ベスト設定と新UI"
description: "Flux LoRA モデルのダウンロード・使い方・複数LoRA組み合わせ・新UIメニューの紹介"
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
  - flux
  - lora
draft: false
date: 2026-07-12
---

# ComfyUI Tutorial Ep17 - Flux LoRA の使い方・ベスト設定と新UI

- 動画: https://www.youtube.com/watch?v=-aW1U8QEak0
- チャンネル: pixaroma

## LoRA とは

**Low Rank Adaptation（低ランク適応）** の略。  
ベースモデル全体を再トレーニングせず、「付箋メモ」のような小さな差分データで特定のスタイル・キャラ・オブジェクトを学習させる技術。

- LoRA はベースモデルの差分だけを保持しているため、**同じベースモデルで訓練されたLoRAでないと使えない**
  - Flux Dev 用のLoRA は Flux Dev に適用、SDXL用には適用不可

## LoRA の種類

| 種類 | 説明 |
|------|------|
| **Character LoRA** | 特定の人物・アニメキャラを生成 |
| **Style LoRA** | ゴッホ風・コミック風など画風を変える |
| **Object LoRA** | 宇宙船・ファンタジー武器など新しい概念を追加 |
| **Modifier LoRA** | ステップ数を減らして高速生成など（例: Turbo Alpha LoRA） |

## 新しいUIメニュー

- Settings → デフォルト無効 → 「Place on top」で有効化
- 上部メニューバーに Workflow / Edit が表示される
- 左サイドバー: Queue / ノードライブラリ / モデルライブラリ / ワークフロー / ノードマップ
- リンク（接続線）の表示・非表示トグルあり

## Power LoRA Loader のセットアップ

1. キャンバスをダブルクリック → **"Power LoRA Loader"** を検索（RG3 ノードパックに含まれる）
2. 接続順: `モデルローダー → Power LoRA Loader → KSampler`
3. CLIP も: `DualCLIPLoader → Power LoRA Loader → Positive/Negative prompt`
4. LoRA ファイルは `models/loras/flux/` フォルダに配置して整理する
5. ComfyUI の「Refresh」ボタンでリストを更新

### 便利な設定

- 右クリック → RG3 Node Settings → "Auto Nest Subdirectory" を有効化（例: 閾値2）
  → モデル追加時にサブフォルダが表示されて整理しやすい

## LoRA のダウンロード先

| サイト | 特徴 |
|--------|------|
| **CivitAI** | モデルタイプ・ベースモデル・商用利用でフィルタリング可 |
| **Shakker** | 商用利用可否フィルタが充実 |
| **HuggingFace** | Files and Versions タブからダウンロード |

ダウンロード後は `models/loras/flux/` へ配置。

## トリガーワード

LoRA を有効化するための「キーワード」。プロンプトの先頭に入れる。

- Power LoRA Loader ノードで **右クリック → "Show Info"** → トリガーワードをコピー可能
- **"Fetch Info from CivitAI"** ボタンで最適なワードを取得できる
- メモノードにトリガーワードをまとめておくと便利

## 強度設定のコツ

- 通常は **0.8 以下**を推奨（創造性を保ちつつスタイルを適用）
- LoRA をオン/オフで効果の差を比較できる
- 複数LoRA 使用時は **合計が1.0になるよう分散**
  - 2つ → 各 0.5
  - 3つ → 各 0.33、または重視したいものを高くして残りを分配

## Turbo Alpha LoRA（高速生成）

- ステップ数を **8** に削減して高速生成
- トリガーワード不要
- 生成時間の目安（Flux Dev Q8）:
  - 通常（20steps）: 15秒
  - Turbo Alpha（8steps）: 10秒
- やや品質低下するため VRAM に余裕がない場合に有効

## img2img での LoRA 活用

- Denoise 値 × LoRA 強度の組み合わせでスタイル変換度を制御
  - Denoise 高め → 元画像から離れ、よりLoRAスタイルが強くなる
  - Denoise 低め → 元画像に近い結果
- 例: Denoise 0.75 + アニメLoRA → 半分写真・半分リアルアニメ風
