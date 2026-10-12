---
title: ローカルLLMで DeepSeek V4 Flash 0731 (DGX Spark x2)
description: DGX Spark 2台で DSV4F をローカル稼働。コスパ悪いがロマン枠、というvoluntas氏の体験記
aliases:
  - DSV4F ローカル
tags:
  - llm
  - local-llm
  - deepseek
  - dgx-spark
draft: false
date: 2026-10-12
---

元記事: https://voluntas.ghost.io/local-llm-deepseek-v4-flash-0731/ (2026-08-12)

## 主張

- ローカルLLM コスパ悪い。非推奨。サブスク/API の方が速くて安い
- 著者にとって ロマン枠 (趣味)。税理士・会計士の了承は取った

## 動機

- DSV4F (DeepSeek V4 Flash 0731) 累計 200億 tokens 以上使用。速い・安い・そこそこ賢い
- DGX Spark 2台で 30–60 tok/s 出ると記事で読んだ
- Spark 発売約1年で成熟、値上がり予想、2台構成で DSV4F 動かしやすい

## 構成

- DGX Spark x2
- JetKVM x2 (既所有、Tailscale 設定済 → 楽)
- 手順: MiaAI-Lab の GitHub レシピ "DeepSeek-v4-Flash 0731 on 2x DGX Sparks"。変更は Tailscale 使うだけ
- OpenCode Go 経由で環境自動設定

## 感想

- thinking max: ちょい遅い。high: なんとか実用
- API より かなり遅い。並列10プロジェクト回す著者には throughput 足りない
- それでもこのレベルがローカルで動く = 体験価値あり

## 結論

- 「悪くない」けどコスパ悪い。元取るため 24/365 稼働させる

## 注意

- 量子化形式・メモリ使用量・自前ベンチ記載なし
- 30–60 tok/s は他記事由来
