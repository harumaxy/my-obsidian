---
title: ローカルLLM（Gemma / Llama / Ollama）
description: オープンウェイトLLMとローカル実行ツールの概要
# permalink:  # don't use
aliases:
  -
tags:
  - LLM
  - AI
  - Ollama
draft: false
date: 2026-07-05
---

## 主なオープンウェイトLLM

| モデル | 開発元 | 特徴 |
|--------|--------|------|
| **Llama** | Meta | 動物のラマが由来。ローカルLLMエコシステムの中心 |
| **Gemma** | Google DeepMind | ラテン語で「宝石」。Geminiと同じ技術ベース |
| **Mistral** | Mistral AI | 南仏の強風が由来。軽量・高性能 |

## 実行ツールの関係

```
Llama / Gemma / Mistral など（モデル本体）
    ↓
llama.cpp（C++製推論エンジン。CPUでも動く）
    ↓
Ollama（llama.cppのラッパー。Docker感覚で使える）
```

## Ollama の使い方

```bash
brew install ollama

ollama run llama3
ollama run gemma3
ollama run mistral
```

## 名前の由来

- **Llama**: 南米の動物ラマ。llama.cpp → Ol' Llama (Ollama) と派生
- **Gemma**: ラテン語・イタリア語で「宝石」。Geminiの弟分
- **Mistral**: 南フランスの強風
- **Claude**: フランス系の人名
- **Grok**: SF『異星の客』の造語（深く理解する）
