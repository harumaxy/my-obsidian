---
title: ComfyUI Tutorial Ep.11 - LLM・プロンプト生成・img2txt・txt2txt
description: ComfyUI で Florence 2 や Surge LLM を使ったプロンプト自動生成の解説
aliases:
  -
tags:
  - comfyui
  - llm
  - prompt-generation
draft: false
date: 2026-07-05
---

# ComfyUI Tutorial Ep.11 — LLM・プロンプト生成・img2txt・txt2txt

**チャンネル:** pixaroma  
**URL:** https://www.youtube.com/watch?v=yutYU97Bj7E  
**公開日:** 2024-09-04

---

## 1. 画像からプロンプト生成（img2txt）— Florence 2

- **Florence 2**（Microsoft製の視覚言語モデル）で画像のキャプションを取得し、プロンプトとして利用
- ComfyUI Manager から `Florence` ノード（ID: 269）をインストール
- ノード構成：`Load Image` → `Florence to Run`（モデル: `Download and Load Florence Model`）→ `Show Any`
- タスク選択：`Caption` / `Detailed Caption` / `More Detailed Caption`
- 利用可能なモデル：Florence Base（軽量）、SD3 Captioner、Cog v2.2、PromptGen など
- Flux Dev ワークフローへの接続は `convert widget to input` でテキスト入力化して行う

## 2. テキスト指示からプロンプト生成（txt2txt）— Surge LLM

- **Surge LLM**（カスタムノード ID: 97）でテキスト指示から詳細プロンプトを自動生成
- モデルは **Mistral の GGUF 形式**（Q4 または Q8）を `models/llm_gguf/` に配置
- ノード構成：`Surge LLM` に指示文を入力 → 生成プロンプトを Flux/SDXL に接続
- `Text Concatenate` ノードで「指示部分」と「内容部分」を分離して管理しやすくする
- 注意：シードが固定されていると同じプロンプトが生成される。毎回変えること

## 3. ワークフロー管理の便利機能

- **グループ化**（`Add Group to Selected Nodes`）でノードをまとめて管理
- **RG3 パック**の **Fast Groups Muter** ノードで複数グループを一括 ON/OFF
- **Any Switch** ノード（RG3）で「画像からのプロンプト」と「カスタムプロンプト」を切り替え

## まとめ

| 手法 | ノード | 用途 |
|------|--------|------|
| img2txt | Florence 2 | 画像の内容を忠実に描写したプロンプト生成 |
| txt2txt | Surge LLM (Mistral) | テキスト指示から創造的なプロンプト生成 |

---

## 補足：Surge LLM のモデルを別モデルに差し替える

Surge LLM は llama.cpp ベースなので、`models/llm_gguf/` に置いた GGUF ファイルを差し替えるだけで任意のモデルに変更できる。

- Qwen 2.5、DeepSeek R1/V2、Gemma 3 など Hugging Face に GGUF 版があるものはすべて対応

### Ollama 経由で使う場合

Surge LLM は Ollama API 非対応なので別のカスタムノードが必要。Ollama は OpenAI 互換 API（`localhost:11434/v1`）を持つ。

- **ComfyUI-LLM-Party** — Ollama・OpenAI API 両対応
- **ComfyUI-Ollama** — Ollama 専用、シンプル

| 方法 | メリット | デメリット |
|------|---------|-----------|
| Surge LLM + GGUF | ComfyUI 完結 | モデルファイルを手動管理 |
| Ollama 経由 | `ollama pull` だけで管理できる | 別プロセスの起動が必要 |

Ollama を普段使いしているなら ComfyUI-LLM-Party + Ollama の組み合わせが管理しやすい。


---

## 用語解説

### img2txt / txt2txt
- **img2txt**: 画像を入力してテキストを出力する処理の総称
- **txt2txt**: テキストを入力してテキストを出力する処理（LLM の基本動作）

### Florence 2
Microsoft 製の**視覚言語モデル（VLM）**。画像を理解してキャプションを出力する。キャプション生成・物体検出・領域説明などのタスクを切り替えられる。

Florence Base は汎用キャプションモデルで SD 特有の語彙を知らない。SD3 Captioner・PromptGen は「この画像を生成したプロンプトは何か」という逆問題で fine-tune されており、出力が最初から SD/Flux 向けの語彙になっている。

### GGUF
llama.cpp が定めた LLM のファイル形式。Q4/Q8 などの数字は量子化レベル（ビット精度）。小さいほど軽くて速いが精度が落ちる。

### RG3 パック
ComfyUI のカスタムノードをまとめたパック。主なノード：

**Any Switch** — 複数入力のうち最初に有効なものを選んで出力する。プログラムの `??`（null 合体）演算子に近い概念。Florence キャプションとカスタムプロンプトの切り替えに使う。

**Fast Groups Muter** — キャンバス上のグループをリスト表示して一括 ON/OFF できるコントロールパネル。`match colors` で特定色のグループだけ表示するフィルターもある。Any Switch とセットで使うのが典型パターン。

---

## LLM がプロンプトを最適化できる原理

### 背景：プロンプトエンジニアリングの難しさ
SD/Flux のテキスト理解は人間の言語感覚とズレがある。CLIP は単語の共起統計で学習しているため、Danbooru タグ体系などモデルの学習データに合わせた特殊語彙が効く。元素法典（中国コミュニティ）はこの経験則を集合知として集めたもの。

### LLM の場合
Civitai・PromptHero・Reddit r/StableDiffusion などのプロンプト共有投稿を大量に学習済みなので、「効くプロンプトのパターン」を内包している。プロンプトエンジニアリングの知識が**人間の頭からモデルの重みの中に移動した**イメージ。

### VLM（Florence 系）の場合
SD3 Captioner・PromptGen は（画像, 実際に使われた SD プロンプト）ペアで fine-tune されており、自然言語ではなく最初から SD の語彙で出力する。

---

## Searge LLM の instructions フィールド（システムプロンプト）

ノードには `text`（ユーザー入力）と別に **`instructions`** フィールドがあり、デフォルトで以下が入っている：

```
generate a prompt from [text] using the given format
```

これが実質的なシステムプロンプト。`convert instructions to input` で外部入力化すれば自由にカスタマイズできる。

```
instructions: "generate a prompt for"  ← Text Concatenate で結合
text:         "a cute cartoon bunny"
              ↓
出力: "fluffy white bunny, lush forest, dappled sunlight..."
```

instructions を変えることで詩・商品説明・チャット応答など全く違う用途にも使える。

## Max tokens

LLM が一度に生成するテキストの最大長。SD/Flux の CLIP は 75 トークン上限（Flux は長め）なので、プロンプト生成目的なら **150〜256 が実用的**。それ以上にしても CLIP 側で切り捨てられる。

---

# その他テクニック

- `Show Any` ノード: どんな型のデータもプレビュー
  - `ComfyUI Easy Use` 拡張機能に含まれる
  - image, text, その他(embedded, etc...?)
- `複数ノード選択 > 右クリック > Add Group For Selected Nodes`
  - 選択ノードを包むフレームでグルーピング(Convert to Group ... と違い、一つのノードにはならない)
  - 同じような処理を複製してバージョン別にするのに便利。
  - 右上メニューから `Bypass` を選ぶと、実行時にグループがスキップされる。実行するノードを単位ごとにを切り替えたい時便利
