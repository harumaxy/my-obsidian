---
title: jev-typesafe-ai
description: TypeSafe AI製モデルJev。エージェント中間判断特化、爆速・激安
# permalink:  # don't use
aliases:
  -
tags:
  - AI
  - LLM
draft: false
date: 2026-09-23
---

元ネタ: https://x.com/Mikadzyki_NFT/status/2101141853810618747

## Jevとは

TypeSafe AI開発。代表 Diogo Almeida、元OpenAI、InstructGPT共著者。
System Oneファミリー第一弾モデル。

自然言語生成せず、選択肢・スコア・確率を直接返す専用モデル。
エージェントのツール選択・分類・優先度判定など「説明不要な決定」用。
訓練法: RLCD (Reinforcement Learning for Calibrated Decisions)。

## 速い理由

通常LLMはJSON Schema使ってもトークン逐次生成。
Jevは複数独立質問を並列評価→1リクエストでまとめて回答。

## 性能・コスト

- 精度: Terra比 67.8% vs 67.9%、ほぼ同等
- 速度: ワークフロー実行 0.4秒 vs 10.1秒 → 193.6倍高速
- コスト: 444.6倍削減。入力$0.042/M、出力無料
- Qwen Flashより入力単価高いが出力無料分で有利なケースあり

## 質問タイプ3種

- Choice: 選択肢から1つ選ぶ
- Score: スケール評価
- Noul: 真偽の確率を返す

リクエスト構成: `state`(文脈) + `questions`(instructions+type+criteria)。
質問キー名はコード用識別子、モデルには渡らない。

## 統合

LangChain対応。`langchain-typesafe` パッケージ、`TypeSafeClassifier`クラス。

## デモ事例

- Doom bot: 秒10コール、時給約$7
- Wikipediaページ間ナビゲーション(リンク数百〜数千から選択)
- メール500通分類: コスト3.5セント
- 発話内容連動スライド自動切替

## 位置づけ

大型モデルが計画・生成担当、Jevが中間判断(ツール選択・ルーティング・確信度評価)、
コードが実行&結果検証、という分業モデル提案。
汎用ライティング・複雑問題解決には非対応と明言。

## 参考

- https://typesafe.ai/blog/introducing-system-one-models-and-jev
- https://evals.typesafe.ai/
- https://docs.typesafe.ai/introduction
