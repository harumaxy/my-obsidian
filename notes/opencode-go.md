---
title: OpenCode Go 使ってみた
description: 月$10でOSSモデル(Kimi 2.6 / DeepSeek v4 Pro / Qwen3.6 Plus)使い放題っぽいサービス。voluntas氏の体験記
aliases:
  - OpenCode Go
tags:
  - llm
  - opencode
  - kimi
  - deepseek
draft: false
date: 2026-10-12
---

元記事: https://voluntas.ghost.io/opencode-go/

## 背景

- 著者 Codex / Claude Code / Copilot 使う。Copilot 従量課金化で OSS 系モデル試す
- 先に Cursor Composer 2 Fast (MAX) 1ヶ月。調査向き、速い、間違い少ない
  - Pro+ で 13.6億 tokens 使って枠 77%
  - Composer 2 ベース = Kimi 2.5

## OpenCode Go

- 月 $10 (初月 $5)
- 5時間ごとのリクエスト上限内で GLM / Kimi / MiMo / Qwen / MiniMax / DeepSeek 使える
- 自前ホスト コスト合わない → ホスティング使う

## モデル評価

### Kimi 2.6
- 全体「かなり良い」
- レビュー: Opus 4.7 と遜色なし
- コード: Opus 4.7 よりミス少し多い
- 調査: 速度差ほぼ無し
- 価格 (100万tok): Kimi $0.95 in / $4 out / cache $0.16、Opus 4.7 $5 in / $25 out / cache $0.50
  - 約 1/5。Opus 代替 現実的
- コンテキスト 約25万。1M 無理

### DeepSeek v4 Pro
- 1M コンテキスト
- 品質 Kimi 2.6 より落ちる印象
- でも「でかい文脈持たせて何回もレビュー」に強い
- 100回レビューさせても使用率ほぼ減らない。Opus 4.7 / GPT 5.5 はすぐ枯れる

### Qwen3.6 Plus
- 速い。Composer 2 Fast 近い。早いは正義
- レビュー質 微妙。調査向き

## 結論

- OpenCode Go かなり良い
- OSS モデル ローカルより プロバイダ使うが現実的
- 用途 = 調査とレビュー。3モデル全部好印象
