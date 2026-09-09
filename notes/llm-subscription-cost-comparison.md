---
title: OpenCode向けLLM比較 (Kimi/GLM/Grok Code Fast vs Claude)
description: Claude Code代替候補のコーディング用LLM、料金・性能・サブスク使用量比較
# permalink:  # don't use
aliases:
  -
tags:
  - llm
  - opencode
draft: false
date: 2026-09-06
---

## OpenCode とは

Claude Code同等ポジションのオープンソースCLI（SST製）。モデル自由選択可。Anthropic/OpenAI/OpenRouter/ローカル問わず接続可。

## 候補モデル概要

### GLM-4.6（Zhipu / Z.ai）

- コンテキスト窓 205K
- SWE-bench Verified 68%、LiveCodeBench v6 82.8%（Claude 4系に近い水準）
- function calling対応、Claude Code系ハーネスとの互換性高い

### Kimi K2（Moonshot）

- 現行 K2.6（汎用）/ K2.7 Code（コーディング特化）。旧K2系は2026/5/25退役
- コンテキスト窓 262,144（256K）
- SWE-bench Verified 約69.2%（旧K2-0905時点）
- tools/tool_choice でfunction calling正式対応

### Grok Code Fast 1（xAI）

- コンテキスト窓 256K、速度重視設計（92 tok/s）
- xAI自社ハーネスでSWE-bench Verified 70.8%、第三者評価だと57.6%まで落ちる報告あり（バラつき大）
- vision入力・tool calling・prompt caching・構造化出力対応

## API従量課金 $/M トークン（入力/出力）

- Claude Opus 5: $5 / $25
- Claude Sonnet 5: $3 / $15
- GLM-4.6: $0.43 / $1.75（OpenRouter最安）〜$0.60 / $2.20（Z.ai公式）
- Kimi K2.6: $0.55 / $2.31
- Kimi K2.7 Code: $0.66 / $3.40
- Grok Code Fast 1: $0.20 / $1.50（3社中最安、キャッシュ入力$0.02/M）

→ GLM-4.6はSonnet比で入力約7分の1・出力約8.6分の1。Opus比だと入力約12分の1・出力約14分の1。

## サブスクプラン

### Claude

- Pro $20/月: 5時間窓 約45メッセージ
- Max 5x $100/月: Proの5倍
- Max 20x $200/月: Proの20倍

### GLM Coding Plan（Z.ai）

- Lite $18/月: 5時間窓 約120プロンプト
- Pro $80/月: 5時間窓 約400プロンプト・週2,000
- Max $168/月: 5時間窓 約1,600プロンプト・週8,000
- 年払いで30%引き
- credit消費式: (入力トークン×係数 + キャッシュ入力×係数 + 出力トークン×係数) ÷ 10,000。Z.ai公称、Lite $18でAPI従量換算 約$150相当

### Kimi 会員プラン

- 5段階: 無料(Adagio) → $19(Moderato) → $39(Allegretto) → $99(Allegro) → $199(Vivace)
- $19プランはK2.6チャット+入門用コード credit。コーディング中心なら$39〜が現実的
- credit⇔トークン変換比率は非公開（タスク複雑度で変動、公式は「目安」としか言わない）
- Vivace($199)は「Code 30倍credit + 並列エージェントswarm」という毛色。Claude Maxの「1人で回す用の生量」とは設計思想が違う

## 同価格帯での実測比較（プロンプト数ベース）

- Claude Pro $20 ≈ 45プロンプト/5h
- GLM Lite $18 ≈ 120プロンプト/5h（**Claudeの約2.7倍**）
- GLM Pro $80 ≈ 400プロンプト/5h（Claude Max5x $100と比べ**約2〜3倍**）
- GLM Max $168 ≈ 1,600プロンプト/5h（Claude Max20x $200と比べ**約3倍**、実測報告あり）
- Kimiは具体的プロンプト数非公開、定量比較できるデータなし

※ 各社「プロンプト」の定義が違う（GLMは1プロンプト裏で15〜20回モデル呼ぶ想定、Claudeはセッション単位）ので厳密な等価比較ではない、あくまで目安。

## 結論

- 単価・透明性ともGLM-4.6が一番良い。Grok Code Fastは最安だが精度バラつき報告あり
- 同価格帯で比べるとGLM系サブスクはClaude比おおよそ2〜3倍使える（実測ベース）
- Kimiはcredit⇔トークン比率が非公開で定量評価しづらい、GLMの方が選びやすい
- 精度が必要な難タスクはClaude、量産・雑タスクはGLM/Kimiという使い分けが現実的
- $18〜19プランはClaude Proクラスの格。Max級の物量欲しければGLM Pro($80)以上が必要

## 参考リンク

- https://pricepertoken.com/pricing-page/model/z-ai-glm-4.6
- https://openrouter.ai/moonshotai/kimi-k2.7-code
- https://www.requesty.ai/models/xai/grok-code-fast-1
- https://x.ai/news/grok-code-fast-1
- https://news.ycombinator.com/item?id=45064606
- https://www.aipricing.guru/z-ai-subscription-pricing/
- https://www.eesel.ai/blog/kimi-k3-pricing
- https://intuitionlabs.ai/articles/claude-max-plan-pricing-usage-limits
- https://benchlm.ai/anthropic/api-pricing
- https://medium.com/@elio.verhoef/glm-coding-plan-how-i-get-3-claude-max-code-usage-for-30-month-07503db5eeb2
- https://kingy.ai/blog/ai-coding-plan-limits/
- https://www.codeagentswarm.com/en/guides/kimi-code-vs-claude-code
