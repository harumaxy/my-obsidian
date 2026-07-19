---
title: "ComfyUI Tutorial Ep13 - Ollama, LLaVA, Gemma でプロンプト生成"
description: ComfyUI内でOllamaを使ってローカルLLMによるプロンプト自動生成と画像認識を行う方法
aliases:
  -
tags:
  - comfyui
  - ollama
  - llm
  - llava
  - gemma
draft: false
date: 2026-07-12
---

# ComfyUI Tutorial Ep13 - Ollama, LLaVA, Gemma でプロンプト生成

url: https://www.youtube.com/watch?v=eK6MXm7q37c

## 概要

ComfyUI内でOllamaを使い、ローカルLLM（Gemma・LLaVAなど）でプロンプトを自動生成する方法。テキストからの生成と、画像を読み込んでの説明文生成（Vision）の両方を解説。

## Ollama のセットアップ

- [ollama.com](https://ollama.com) からインストール
- タスクトレイにアイコンが常駐。使わないときは右クリック→Quit でVRAM解放
- モデルの追加・削除はコマンドプロンプトで行う

```bash
ollama pull gemma:7b       # モデルインストール
ollama list                # インストール済み一覧
ollama rm <モデル名>        # 削除
```

## モデルのサイズ感

| 表記 | パラメータ数 | 特徴 |
|------|------------|------|
| 2B   | 20億       | 軽量・低精度 |
| 7B   | 70億       | 高精度・VRAM消費多め |

## ComfyUI でのノード構成

### テキストプロンプト生成

1. ComfyUI Manager → Custom Nodes → "ollama" → **ComfyUI-ollama** をインストール
2. `OllamaGenerate` または `OllamaGenerateAdvanced` ノードを追加
3. system（指示文）とプロンプトを入力
4. `response` 出力を `Show Any` ノードや KSampler のポジティブプロンプトに接続

### 画像認識→プロンプト生成（Vision）

1. `OllamaVision` ノード + `Load Image` ノードを追加
2. Vision対応モデル（`llava:7b` など）を選択
3. 画像の説明文を自動生成し、そのままポジティブプロンプトとして使える

## VRAM に関する注意

Ollama + ComfyUI の同時実行はVRAMを多く消費する。

- **VRAMに余裕あり** → Ollamaの出力を直接ワークフローに繋げてワンショット生成が可能
- **VRAMが足りない場合** → Ollamaでプロンプトを先に生成してコピー → Ollamaを終了 → 画像生成

特にFlux Devモデルは重く、Gemma 7B + Flux の同時実行は厳しいケースが多い。SDXLならば比較的動きやすい。

## SDXLとFluxの比較

| モデル | アートスタイル対応 | プロンプト理解 |
|--------|-----------------|--------------|
| SDXL   | 豊富            | 普通         |
| Flux   | 少なめ（改善期待）| 高い         |

## テクニック

- ノードをグループ選択 → 右クリック → **Save selected as template** で他のワークフローに再利用可能
- システムプロンプト（指示文）をウィジェットからテキスト入力に変換すると大きいウィンドウで編集しやすい
- 指示文にアニメ系ワード（`anime`, `2D`, `chibi` など）を追加すると狙ったスタイルに誘導しやすい
