---
title: DeepSeek V4.1 Flash と Claude のコスパ・速度比較
description: DeepSeek-V4.1-Flash の概要、Claude 5.5 系との価格・速度・知能の比較、サブエージェント用途の向き不向き
# permalink:  # don't use
aliases:
  - deepseek-flash
tags:
  - llm
  - deepseek
  - claude
  - pricing
draft: false
date: 2026-10-12
---

# DeepSeek V4.1 Flash

## 概要

- 2026-09-10 リリース。API 名 `deepseek-flash`。
- 旧 `deepseek-v4-flash` も受付。中身は V4.1 Flash に振り分け。
- 新アーキテクチャ系列で一番小さい。MoE。画像理解も付いた。
- パラメータ数 出典で食い違い。552B 説と 763B 説。
- コンテキスト 1M。最大出力 384K。MIT ライセンス。重み公開。
- 同時実行上限 2500。
- 自己申告ベンチ: Terminal-Bench 2.1 で 90.6。Opus 5 の 89.1 より上と主張。
  - 第三者ベンチと合わない。鵜呑み禁止。

## 価格 ($/1M tokens)

ピーク = UTC 01-04 / 06-10 の平日 (JST 10-13 / 15-19)。オフピークは半額。

| | キャッシュヒット入力 | 入力 | 出力 |
|---|---|---|---|
| Flash ピーク | 0.006 | 0.30 | 1.20 |
| Flash オフピーク | 0.003 | 0.15 | 0.60 |
| Haiku 5.5 (100K 以下) | 0.01 | 0.10 | 0.50 |
| Sonnet 5.5 | 0.10 | 2 | 10 |
| Opus 5.5 | 0.20 | 4 | 20 |
| Fable 5.1 | 0.25 | 10 | 50 |

- Sonnet 5.5 比 出力 約 8 倍安。入力 約 7 倍安。キャッシュヒット 約 17 倍安。
- 短い文脈なら Haiku 5.5 のほうが安い。100K 超なら Flash が安い。
- エージェントは長い文脈を何度も再送する。キャッシュヒット安が効く。

## 速度と知能 (Artificial Analysis)

| モデル | Intelligence Index | 出力速度 tok/s |
|---|---|---|
| Opus 5.5 high | 54 | 77 |
| Fable 5.1 high | 51 | 54 |
| Sonnet 5.5 high | 47 | 101 |
| Sonnet 5.5 medium | 41 | 99 |
| Flash max | 39 | 217 |
| Haiku 5.5 high | 38 | 174 |

- Flash の知能 = Sonnet 5.5 の medium〜low と Haiku 5.5 の間。**Opus 級ではない**。
- 出力速度は Sonnet 5.5 の約 2 倍、Opus 5.5 の約 3 倍。
- TTFT は比較注意。Claude 側は思考完了までを含む。Flash は思考を流すので 1.2 秒。
- Flash は出力が冗長との報告。速度の利点が相殺される可能性。
- 総所要時間の公式数値なし。実測が必要。

## 使いどころ

向く:
- 大量の調査・要約・検索の fan-out
- 読み取り中心の作業。親が結果を検証できる
- 同じ接頭辞を使い回す作業。キャッシュで安くなる
- バッチ処理。オフピーク (JST 夜〜朝、土日) に回せば半額

向かない:
- 最終判断、設計、マージ前レビュー
- 書き込み・破壊的操作。ツール呼び出しの安定性が未検証
- 機密コード。データが中国のサーバーを通る
- 難問。品質が足りずやり直しになると、待ち時間がかえって増える

## Claude Code への組み込み

- サブエージェント単位でプロバイダを変える標準機能なし。
- `ANTHROPIC_BASE_URL` でセッション全体を切り替える方式が現実的。
- V4.1 向けの Anthropic 互換エンドポイントがあるかは未確認。
- 自作スクリプト (Deno など) から API を直叩きする fan-out が簡単。

## 次にやること

- zenn 記事 20 本ほどの要約を Sonnet 5.5 と Flash で回し、品質・費用・所要時間を比べる。

## 参考

- [DeepSeek 公式 Pricing](https://api-docs.deepseek.com/quick_start/pricing)
- [DeepSeek Change Log](https://api-docs.deepseek.com/updates/)
- [SiliconANGLE: DeepSeek releases V4.1-Flash](https://siliconangle.com/2026/09/10/deepseek-releases-v4-1-flash-says-it-outperforms-flagship-v4-pro/)
- [Claude Pricing](https://platform.claude.com/docs/en/about-claude/pricing)
- [Artificial Analysis: DeepSeek V4.1 Flash](https://artificialanalysis.ai/models/deepseek-v4-1-flash)
- [Artificial Analysis: LLM Leaderboard](https://artificialanalysis.ai/leaderboards/models)
