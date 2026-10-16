---
title: モデル × ハーネス ベンチ (8090 Labs)
description: 同じモデルでもハーネス変えると成功率が最大35pt動く。優劣より相性。
# permalink:  # don't use
aliases:
  - Same Model, Different Harness
tags:
  - ai
  - coding-agent
  - benchmark
  - harness
draft: false
date: 2026-10-15
---

## 出所

- 元ポスト: https://x.com/chamath/status/2109703737493344363 (Chamath, 2026-10-13)
- 一次ソース: https://8090.ai/blog/same-model-different-harness (2026-10-09)
- 紹介ポスト: https://x.com/studio_yebisu/status/2109899908572705223
    - 「公式ハーネス以外に繋ぐのが流行」「DSH の日本人向けクローン作成中」と言ってる

## ベンチ概要

- Datacurve DeepSWE v1.1。実 OSS の bug fix / 機能追加 113 タスク。Go, Python, TS が 103 件
- 7 モデル × 5 ハーネス。各タスク 2 回ずつ。Datacurve のテストで採点
- モデル: GPT-5.6 Sol / Terra / Luna, Claude Fable 5.1, Grok 4.6, GLM 5.3 Flash, DeepSeek V4 Flash 0731
- ハーネス: Codex, Claude Code, OpenCode, Pi, DeepSeek harness
- 8090 = Chamath の会社 (Social Capital 8090)。独立機関じゃない。ベンチ自体は「リーダーボードじゃない」と自分で断ってる

## 結果 (成功率 %)

| モデル | Codex | Claude Code | OpenCode | Pi | DeepSeek |
|---|---|---|---|---|---|
| GLM 5.3 Flash | 24 | 26 | 27 | 58 | 59 |
| DeepSeek V4 Flash | 39 | 30 | 21 | 37 | 37 |
| GPT-5.6 Luna | 57 | 60 | 53 | 64 | 58 |
| GPT-5.6 Terra | 66 | 66 | 60 | 68 | 69 |
| GPT-5.6 Sol | 72 | 69 | 69 | 75 | 71 |
| Grok 4.6 | 67 | 69 | 65 | 64 | 65 |
| Claude Fable 5.1 | 61 | 41 | 50 | 60 | 48 |

- GLM: 最大差 35pt (Codex 24 → DeepSeek 59)
- Fable 5.1: Claude Code 41 / Codex 61。ツール呼び出し中央値 28 回 vs 66 回
- GPT-5.6 Sol 差 6pt、Grok 差 5pt。ハーネスほぼ無関係
- 自社ハーネスで最強のモデルは無し。Claude Code も Fable に最適じゃない
- 9pt 以下の差はノイズ (記事の見積り)。言語別は 1 言語約 34 タスクで誤差約 17pt

## コスト

- 成功 1 件あたりで見ろ。安い run が安い仕事とは限らない
- GLM: Codex は 1 run $0.22 → 成功 1 件 $0.93。Pi は 1 run $0.25 → 成功 1 件 $0.43
- 差の原因はほぼ成功率 (24% vs 58%)

## 再現性

- 2 回とも成功したタスク数 (GLM): DeepSeek harness 51 / Pi 50 / Codex 16 / Claude Code 14
- 2 回試行は少ない。上限扱い

## 解釈 (自分の考察)

- 優劣より相性。ハーネス平均を出すと、クローズド 5 モデルでは差が最大 7pt でノイズ内
- 平均 (7 モデル): Pi 61, DeepSeek 58, Codex 55, Claude Code 52, OpenCode 49
- 平均 (クローズド 5 モデル): Pi 66, Codex 65, DeepSeek 62, Claude Code 61, OpenCode 59
- 大きな差は GLM と Fable に集中
- GLM は 2 グループに割れる (Codex / Claude Code / OpenCode が 24-27、Pi / DeepSeek が 58-59)。DSH が特別なわけじゃない。Pi でも同じ
- 原因は未検証。推測: 小型 open-weight モデルはツール呼び出し形式・プロンプトの癖との相性で壊れる
- open-weight モデルは Fireworks / Baseten 経由。provider 差が混ざってる可能性。記事は切り分けてない
- 「公式以外のハーネスが流行」を一般化する根拠は薄い。GLM の特殊例に引っ張られてる

## 結論

- モデル単体ベンチだけでモデルとハーネスを選ぶな、は妥当
- 自分の用途で 2〜3 ハーネス試すのが早い
- 数字の出所は確か。主張の強さは Chamath ポストより記事本文のほうが控えめ
