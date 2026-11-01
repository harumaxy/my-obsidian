---
title: Jev (TypeSafe AI) - System One モデル
description: 文章作らない高速判断モデル Jev。流行った理由、ユースケース狭い説、話題消えた説のメモ
# permalink:  # don't use
aliases:
  - Jev
  - TypeSafe Jev
tags:
  - ai
  - llm
  - system1
draft: false
date: 2026-10-28
---

## きっかけ

X で「もう誰も Jev の話してない」(@realmpyw)。
引用元 @kmzk_dev「AI 普及期なら革命的だったはず。プロダクト短命」。
発表 1 ヶ月ちょっとで話題消えた、という嘆き。

## Jev とは

- TypeSafe AI の「System One」モデル。2026/9/15 early access。
- 名前の由来 = カーネマン System 1 / System 2。
  - GPT, Claude = System 2。熟考、遅い。
  - Jev = System 1。直感、速い。
- LLM ちがう。文章生成しない。確率つき型付き回答だけ返す。
  - 真偽度 (どれだけ true か)
  - 採点 (rubric)
  - 選択 (多肢選択)
- 出力は事前にスキーマ定義。
- 速度 70〜500ms。frontier LLM 比 40〜200 倍速、40〜400 倍安 (会社発表。193.6 倍速 / 444.6 倍安という数字もあり)。
- 値付け変わってる。出力トークン無料、入力は 10 億トークン単位課金。
- 構造非公開。transformer ベース。外部は open-weight LLM 上に作ったと推測。合成データのみで学習とされる。

## 流行った理由

- 創業者 Diogo Almeida = 元 OpenAI。ChatGPT 関与、RLHF 考案者と書かれてる。約 2 年前に退社。
- 「System 1 / System 2」の説明きれい。数字派手。
- Vercel が OpenAI モデルから Jev に置換。コマンド安全性分類器で 5〜18 倍速、精度も向上 (会社側発表)。
- アクセス殺到、一時 API 提供不能。

## ユースケース狭い説

たぶん当たってる。

- 想定用途 = 分類、ルーティング、エージェント監視、脱獄ガード。LLM の代替ちがう。LLM の前段の部品。
- Bryo AI のメール分類。精度は Gemini が少し上。Jev はコスト 10〜20 倍安。確率スコアが良い点。
- 確率の解釈は使う側の仕事 (Armin Ronacher)。50% のとき捨てるか、自分で決める。
- 「ハルシネーションなし」 = 不正形式の出力なし、の意味。答えが正しい保証ちがう。HN でも突っ込まれた。
- 敵対的入力に弱い。偽の事前承認メモで block 確率 0.76 → 0.48 (VentureBeat、二次情報)。
- 判断理由残らない。監査、規制業務で弱い。
- 多段推論、二重否定、間接的な質問が苦手。
- ベンチは自社作成中心。独立検証データ少ない。
- 制約付き出力は既存 LLM でもできる。差は速度とコストだけ、という見方もある。

## なぜ話題消えたか (推測)

- 「革命」より「便利な部品」だった。部品は話題が続かない。
- 使う人は静かに使い続ける。SNS に出てこない。
- 観測は発表から 1 ヶ月ちょっと。「誰も話してない」は SNS 上の体感。実際に使われなくなったかは別。
- 「消えた」を裏付ける資料は見つからず。上記は推測。

## その後の動き (2026/10/31 追記)

- 9/30 OpenAI が Decisions API (GPT-6 Luna) 発表。10/22 GA。Jev に同ジャンルで追従。
  - 比較は [[openai-decisions-api]] 参照。
- 10/9 TypeSafe AI が $870M 調達、評価額 $7.5B。主導 a16z、Sequoia も参加。
  - 「話題消えた」でも資金面は逆。発表から 1 か月足らずで巨額調達。
  - 採用数は自己申告 (TypeSafe「Fortune 500 の約 3 分の 1」、a16z「25%」)。独立検証なし。
- 10/14 Jev 1.14 安定版。画像入力 (実験的)、Box 質問タイプ、262K 長コンテキスト。
  - 上の「テキストのみ」「64K」は 1.13 時点の話。
- 価格据え置き。入力 $0.042 / 100 万トークン、出力無料。
- Decisions API への TypeSafe の公式反応は見つからず。
- 「話題が消えた」= SNS 上の体感。事業の失速とは別。むしろ「静かに使われる部品」説を裏づける。

## 参考

- [A new kind of AI model from a ChatGPT inventor is thrilling developers - TechCrunch](https://techcrunch.com/2026/09/18/a-new-kind-of-ai-model-from-a-chatgpt-inventor-is-thrilling-developers/)
- [Why Everyone Is Talking About Jev - Forbes](https://www.forbes.com/sites/ronschmelzer/2026/09/22/why-everyone-is-talking-about-jev-the-ai-that-doesnt-chat/) (403 で取得不可、検索抜粋のみ)
- [Jev (AI model) - Wikipedia](https://en.wikipedia.org/wiki/Jev_(AI_model))
- [What is Jev (2026)? - DigitalOcean](https://www.digitalocean.com/resources/articles/what-is-jev)
- [Jev creator TypeSafe closes $870M round at $7.5B valuation - SiliconANGLE](https://siliconangle.com/2026/10/09/jev-creator-typesafe-closes-870m-round-at-7-5b-valuation/)
- [TypeSafe AI Releases Jev 1.14 - MarkTechPost](https://www.marktechpost.com/2026/10/14/typesafe-ai-jev-1-14-images-box-long-context/)
- [Jev decision model touted as quicker, cheaper LLM alternative - TechTarget](https://www.techtarget.com/it-infrastructure/news/366650696/Jev-decision-model-touted-as-quicker-cheaper-LLM-alternative)
- [TypeSafe Jev explained - Requesty](https://www.requesty.ai/blog/typesafe-jev-explained)
- [What "System One Models" Actually Are - TrueFoundry](https://www.truefoundry.com/blog/typesafe-ai-jev)
- [Jev Enterprise Security Guide - NeuralTrust](https://neuraltrust.ai/blog/jev-typesafe-ai-security)
