---
title: "ComfyUI Tutorial Series: Ep03 - TXT2IMG Basics"
description: ComfyUI テキスト→画像ワークフローの基礎。シード・ステップ数・CFG・グループノードなどの操作方法
# permalink:  # don't use
aliases:
  - comfyui-ep3
tags:
  - comfyui
  - stable-diffusion
  - tutorial
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Series: Ep03 - TXT2IMG Basics

- 動画: https://www.youtube.com/watch?v=g8UlYE_HM2M
- チャンネル: pixaroma
- 公開日: 2024-07-16

---

## 使用モデル: Juggernaut XL（Juggernaut X）

- civitai で公開されている人気の SDXL ベースファインチューンモデル
- **フォトリアリスティックな人物・ポートレート**に特化。肌の質感や顔のディテールが高品質
- SDXL ベースなので高解像度（1024×1024 など）の出力が得意
- バージョンが複数あり、X（v10）は比較的新しいバージョン
- civitai ページで推奨 CFG・ステップ数・サンプラー設定・プロンプト例を確認できる

---

## シード値

- シードは画像生成のランダム処理の出発点。同じシード＋同じ設定 = 必ず同じ画像が生成される
- **制御オプション（control after generation）:**
  - `Randomize` - 毎回ランダムなシードを使用
  - `Fixed` - 同じシードを固定（プロンプトを微調整しながら比較するときに便利）
  - `Increment` - 生成のたびに+1
  - `Decrement` - 生成のたびに-1

## キューとバッチ処理

- 複数ジョブをキューに追加可能。"View Queue" でキャンセルもできる
- **Auto Queue** を有効にすると連続生成し続ける
- **Empty Latent の `batch_size`** を増やすと一度に複数枚生成
  - RTX 4090 で batch 8 枚 → 約30秒（1枚ずつ8回 = 約35秒より速い）

## ステップ数（steps）

- 多いほど詳細な画像になるが、生成時間も増加
- 少なすぎると粗い結果になる（5ステップではほぼ見えない）
- このモデルでは **30〜40ステップ** が推奨。それ以上は時間がかかるだけで品質向上しない

## CFG（Classifier Free Guidance）

- 低い → モデルの自由度が高く、多様な出力だがプロンプトへの忠実度が低い
- 高い → プロンプトに忠実だが、多様性が低くなる
- このモデル（Juggernaut X）では **5〜7** が目安
- CFGを上げると画像のコントラストが上がる傾向（直接的な効果ではなく副作用）
- モデルごとに推奨値が異なるため、[civitai](https://civitai.com) などのモデルページで確認するのが確実

## Primitive ノード（ウィジェットの入力変換）

- ノードを右クリック →「**Convert widget to input**」で設定値をノード化できる
- Primitive ノードをつなぐことで：
  - 複数のKサンプラーに同じ値を共有
  - `Increment` などの制御を適用してバリエーションのテストが可能
- 戻すときは右クリック →「Convert input to widget」

## グループノードでUIの整理

- 複数ノードを選択 → 右クリック →「**Convert to group node**」でひとつのノードにまとめられる
- 右クリック →「**Manage group node**」でノードの順序変更や非表示設定が可能
- 「**Convert to nodes**」でいつでも元の展開表示に戻せる
- Save Image ノードはグループに含めない（プレビューが小さくなるため）

## 複数ワークフローの並列実行

- グループに対して右クリック →「**Bypass group nodes**」で一時的にスキップ可能
- 「**Set group nodes to always**」で再度有効化
- Kサンプラー・VAE Decode・Save Image をセットでコピー（`Ctrl+Shift+V` でリンクごとペースト）して、異なるプロンプトで同時に複数の画像を生成できる

## その他のTips

- **Save Image ノードのプレフィックス**を変更することで、出力フォルダ内でシリーズごとに整理できる（例: `robot_`, `v1_`）
- ノードのバイパスはすべてのノードで使えるわけではない（必須ノードはエラーになる）
- `Ctrl+Shift+V` でノードをリンクごとペーストできる

---

次回（Ep04）: Image-to-Image と LoRA モデルの使い方予定
