---
title: ComfyUI チュートリアル #2 — ノードとワークフローの基礎
description: ノードの基本構造・接続ルール・テキスト→画像ワークフローをゼロから構築する手順
# permalink:  # don't use
aliases:
  - ComfyUIノード基礎
tags:
  - comfyui
  - stable-diffusion
  - ai
  - image-generation
draft: false
date: 2026-07-01
---

## 概要

ノードとワークフローの基本を解説する第2回。自分でワークフローを作らなくても、他人のワークフローをダウンロードして改変する際にも役立つ知識。

動画: https://www.youtube.com/watch?v=JE5eykLuTXI

---

## ワークフローをケーキ作りに例えたアナロジー

| ケーキの工程 | ComfyUI のノード |
|---|---|
| 優秀なパティシエを選ぶ（モデル選択） | Load Checkpoint |
| 「バニラ・イチゴ入りで」と指示 | CLIP Text Encode（positive） |
| 「ナッツなし」と指示 | CLIP Text Encode（negative） |
| ケーキを焼く | KSampler |
| ケーキのサイズを決める | Empty Latent Image |
| デコレーション・仕上げ | VAE Decode |
| 完成品をテーブルに飾る | Save Image |

---

## インターフェース操作

| ボタン | 機能 |
|---|---|
| Queue Prompt | ワークフローをキューに追加して生成開始 |
| Save / Load | ワークフローの保存・読み込み |
| Clear | ワークフローをリセット |
| Load Default | デフォルト設定に戻す |
| Manager | カスタムノードや設定の管理 |

---

## ノードの基本構造

- **名前** — ノードの機能を示す（例: Load Checkpoint, KSampler）
- **Input（入力）** — 他ノードからデータを受け取る接続点（左側）
- **Output（出力）** — 他ノードへデータを送る接続点（右側）
- **パラメータ** — ノード内の設定値（seed, steps, CFG など）

---

## ノード操作のショートカット

| 操作 | 方法 |
|---|---|
| ノード追加 | キャンバスをダブルクリック or 右クリック → Add Node |
| ノードコピー | Alt + ドラッグ / Ctrl+C → Ctrl+V |
| 複数選択 | Shift + クリック or Ctrl + ドラッグ |
| 複数を一括移動 | Shift + ドラッグ |
| ノード削除 | Delete キー or 右クリック → Remove |
| ノード折りたたみ | ノード名の左の小さい丸をクリック |
| リサイズ | 右下角をドラッグ（右下のみ有効） |

---

## 接続（リンク）のルール

- 接続点の**色と名前が一致するもの**だけ繋げられる
  - 例: 紫（model）同士はOK、オレンジ（conditioning）と黄（clip）は不可
- ドラッグ＆リリースで候補ノードが表示され、ワンクリックで追加＆接続できる
- リンクの切断: 接続点をドラッグして離す、または接続点の小さい丸をクリック → Delete

---

## 潜在空間（Latent Space）

- KSampler の処理はすべて**潜在空間**上で行われる
- ピクセル画像はそのまま入力できない → `VAE Encode` で変換が必要
- 潜在空間のサイズはピクセルの約1/8（計算コストを大幅削減）

```
ピクセル画像
    ↓ VAE Encode（圧縮）
潜在空間（特徴ベクトル）← KSampler がここでノイズ除去を繰り返す
    ↓ VAE Decode（展開）
ピクセル画像
```

### txt2img における Empty Latent Image

- `Empty Latent Image` は**サイズ（幅・高さ）だけを定義する器**
- 実際の中身は KSampler が**ランダムノイズ**で埋めてから処理を開始する
- img2img の場合は元画像を VAE Encode した値を初期値にするため構図が引っ張られる

---

## テキスト→画像ワークフローをゼロから構築する手順

1. `Load Checkpoint` でモデルを読み込む（出力: model / clip / vae）
2. `KSampler` を追加 → `model` 出力を接続
3. `CLIP Text Encode` を2つ追加（positive / negative）→ `clip` 出力を接続
4. KSampler の `positive` / `negative` 入力にそれぞれ接続
5. `Empty Latent Image` でサイズ指定（SDXL なら 1024px 推奨）→ `latent_image` に接続
6. `VAE Decode` を追加 → KSampler の `LATENT` 出力と、`vae` 出力を接続
7. `Save Image` を追加 → VAE Decode の `IMAGE` 出力を接続
8. Queue Prompt で生成

---

## VAE について

- **VAE（Variational Auto Encoder）** — 圧縮（Encode）と展開（Decode）を担うモデル
- Juggernaut など多くのモデルは **VAE 内蔵（baked in）** → Load Checkpoint の vae 出力をそのまま使える
- VAE が内蔵されていないモデルは `Load VAE` ノードで別途 VAE ファイルを読み込む必要がある

---

## ワークフロー整理のTips

- **Reroute ノード** — ケーブルを整理してスッキリ見せる（ケーブルオーガナイザーの役割）
- **グループ** — 右クリック → Add Group で関連ノードをまとめて一括移動・管理
- **リンクスタイル** — Settings でSpline（なめらか）/ Straight（直線）に変更可能
- ノード折りたたみ（Collapse）で複雑なワークフローでも見やすくなる
- ノード右クリック → Colors で色分けして重要ノードを目立たせられる

---

## Forge（Stable Diffusion WebUI Forge）との比較

動画内で ComfyUI のノード配置を Forge の UI に似せるデモが行われた。

- **Forge** は AUTOMATIC1111（A1111）のフォーク。A1111 と同じくフォーム型の WebUI
- A1111 より**メモリ効率・生成速度が大幅改善**されており、同じ VRAM でより大きい画像を生成できる
- A1111 の拡張機能をほぼそのまま利用可能

| | Forge / A1111 | ComfyUI |
|---|---|---|
| UI スタイル | フォーム型（設定項目を上から順に埋める） | ノード型（処理をグラフで組む） |
| 操作のしやすさ | 直感的・初心者向け | 学習コストあり・柔軟 |
| カスタマイズ性 | 拡張機能で追加 | ノードで何でも組める |
| 処理の可視化 | ブラックボックス気味 | 全工程が見える |

ComfyUI はノードを自由に配置できるため、Forge に慣れたユーザーも似たレイアウトに組み替えて使うことができる。

---

## 次回予告

- img2img ワークフロー（VAE Encode を使った画像入力）
- カスタムノードによる UI 簡略化
