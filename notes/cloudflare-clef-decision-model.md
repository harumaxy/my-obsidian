---
title: Cloudflare Clef - Decision Model (System One)
description: Cloudflare の open-weight Decision Model Clef。Jev, GLiDE との比較。Workers で使える利点と価格の話
# permalink:  # don't use
aliases:
  - Clef
  - Cloudflare Clef
tags:
  - ai
  - llm
  - system1
  - cloudflare
draft: false
date: 2026-10-31
---

## きっかけ

X トレンド「Cloudflare の新 AI モデル Clef が Jev をベンチマークで上回る」。
@gogo_tanaka「Jev が Cloudflare にボコられてる」。Clef は OSS、特定ベンチで Jev の 2 倍精度 4 倍速。
元ネタ @MiaAI_lab (10/2)。
返信で @singularity_bly が「GLiDE のが上」と主張。

関連: [[jev-system-one-model]]

## Clef とは

- 2026/10/1 Cloudflare 発表。Workers AI で使える。Decision Model (System One モデル) の仲間。
- 2 種類。
  - Clef = 27B (Qwen3.8-27B ベース)
  - Clef-flash = 9B (Qwen3.5-9B ベース)
- 文章作らない。state と質問 (schema) を渡す → 各選択肢の確率が返る。
- 仕組み (Mia の説明 + 二次情報)。
  - 凍結 Qwen で prefill 1 回だけ。
  - 小さい schema head が全選択肢を並列でスコア。
  - トークン生成なし → 速い。
  - LoRA (rank 256) と routing head だけ学習、とする記事あり。
- 重みは Apache 2.0 で Hugging Face (`Cloudflare/clef`)。学習データとパイプラインは非公開 → open source ではなく open weights。
- Jev API とほぼ互換、と書く記事あり (公式未確認)。
- Ollama でローカル実行も可 (0.35.1 以上、18GB)。

## 使い方 (公式 docs 確認済み)

- モデル ID: `@cf/cloudflare/clef`, `@cf/cloudflare/clef-flash`
- 入力: `state` (文字列 or 構造化) + `questions` (1〜64 個)
- question の型: `noul` (真偽の確率), `choice` (多肢選択), `score` (採点)
- 画像: 最大 4 枚、埋め込みのみ (URL 不可)
- 出力: `answers` (question ID ごと)、`usage`
- コンテキスト 64K。長い state は黙って切り詰め。

```ts
const response = await env.AI.run("@cf/cloudflare/clef", {
  model: "clef",
  state: "Checkout has been failing for every customer for the last hour.",
  questions: {
    urgent: { type: "noul", instructions: "Is this support request urgent?" },
  },
});
```

REST は `https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/ai/run/@cf/cloudflare/clef` に Bearer token で POST。

## 比較

数字は各社の自社計測が中心。独立検証は見つからず。

| | Clef | Jev | GLiDE (Fastino) |
|---|---|---|---|
| Decision Index | 61.2 | 57.9 | 64.81 |
| 入力価格 /M トークン | $0.24 (flash $0.09) | $0.042 | $0〜$0.30 (資料でバラバラ) |
| 中央値レイテンシ | 209ms (flash 39ms) | 524ms | 不明 |
| 重み | 公開 | 非公開 | 非公開 |
| コンテキスト | 64K | 32K | 40K |

- 分類系は Clef が強い。BANKING77 94.2 対 79.7、CLINC150 97.4 対 89.3。
- 推論系は Jev が強い。GPQA Diamond 48.0 対 78.3、When2Call 72.4 対 81.0。
- 全社「自社ベンチで Jev に勝った」。Cloudflare は弱い Jev 版と比べた、という批判あり。
- Perplexity の pplx-decider (10/1 発表、Apache 2.0) もいる。Perplexity の 11 ベンチでは Jev 6 勝、pplx 5 勝。
- Decision Index は版が複数ある。GLiDE の数字は版で変わる。Fastino 自身の計測。

## 価格感

1 決定 = 300 入力トークンの試算 (Nadir)。100 万決定あたり:

- Jev: 約 $12.6
- Clef-flash: 約 $27
- Clef: 約 $72
- 参考、LLM を分類器に使う場合。Haiku 4.5 約 $350、Sonnet 5 約 $700。

Jev の 5.7 倍でも LLM 比では激安。差は 100 万決定で約 $60。
差が効くのは次のとき。

- 1 日に数億件以上の大量処理
- state が長い (エージェント監視で毎回全履歴など)

大量分類は Clef-flash に寄せれば差は縮む。

## 判断メモ

- Workers 製品に組み込むなら Clef が便利。バインディングで呼べる。請求も Cloudflare に一本化できる。
- 短いラベル集合 → flash。長い意図リスト、「該当なし」判定、根拠チェック → Clef。
- 多段推論、間接的な質問 → Jev が勝つかも。
- 棄権の選択肢なし。明示的に "other" を作る。
- レート制限は docs に記載なし。負荷試験が必要。
- ファインチューニングは問い合わせ制。セルフサービスは時期未定。
- 自分のラベルで実測してから決める。ベンチは当てにならない。

## 参考

- [Cloudflare Workers AI: Clef](https://developers.cloudflare.com/workers-ai/models/clef/)
- [eesel: Cloudflare Clef explained](https://www.eesel.ai/blog/cloudflare-clef)
- [Nadir: Six Deciders, Sixteen Days](https://getnadir.com/blog/decision-models-compared-clef-perplexity-decider-jev-glide-cost/)
- [Fastino: Introducing GLiDE](https://fastino.ai/blog/introducing-glide-the-first-thinking-decision-model)
- [Morningstar/PR Newswire: GLiDE release](https://www.morningstar.com/news/pr-newswire/20261001sf62340/fastino-labs-releases-glide-the-first-thinking-decision-model-leading-the-decision-indexs-top-model-by-69-points)
- [remio: Cloudflare Clef Decision Models Challenge Jev](https://www.remio.ai/post/cloudflare-clef-decision-models-challenge-jev-with-open-weights-and-an-rl-platfo)
- [X: @gogo_tanaka の投稿](https://x.com/gogo_tanaka/status/2106904728328405458)
