---
title: Kimi K3
description: Moonshot AIの中国製フロンティアモデル。Opus超えコーディング性能、1Mコンテキスト、オープンウェイト。
# permalink:  # don't use
aliases:
  -
tags:
  - ai
  - llm
  - china
draft: false
date: 2026-08-02
---

# Kimi K3

Moonshot AI（中国スタートアップ）製。2026年7月16日リリース。

## スペック

- パラメーター: 2.8兆（MoE構成）
- コンテキスト: 1M tokens
- チップ: NVIDIA最先端チップ不使用（Huawei Ascend系で訓練）
- thinking mode固定（`reasoning_effort: low/high/max` で調整）

## 性能

Intelligence Index ランキング:
1. Claude Fable 5: 59.86
2. GPT-5.6 Sol: 58.89
3. **Kimi K3: 57.11**
4. Claude Opus 4.8: 55.69

コーディング特化:
- Frontend Code Arena **1位**（Fable 5超え）
- DeepSWE（エージェント系）優勢

## 料金

| | Kimi K3 | Claude Opus 4.8 |
|--|--|--|
| input | $3/M | ~40%高い |
| output | $15/M | ~40%高い |
| context | 1M | 200K |

キャッシュヒット率92%実績 → 実効input ~$0.52/M

## 利用方法

OpenAI互換API → `base_url` 差し替えるだけ

```bash
# OpenRouter経由
モデルID: moonshotai/kimi-k3

# 公式
export MOONSHOT_API_KEY=...
base_url: https://api.moonshot.cn/v1
```

Claude Code / Cline / OpenCode 対応を公式ドキュメントが明記。

## サブスクプラン

| プラン | 月額 |
|--|--|
| Adagio | 無料 |
| Moderato | $19 |
| Allegretto | $39 |
| Allegro | $99 |
| Vivace | $199（年払い$159） |

※近々「KimiチャットとKimi Code」に分離予定。

## 戦略的文脈

- オープンウェイト → ダウンロード・改変・自社ホスティング可
- 中国政府の5ヵ年計画に組み込み、国策で補助
- グローバルサウス29カ国がAI協力協定に参加
- 「AI公共財」として世界標準プラットフォーム化を狙う
