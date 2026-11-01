---
title: OpenAI Decisions API (GPT-6 Luna) と Jev の比較
description: OpenAI の Decisions API の仕様、価格、速度。Jev との違い。System 1 型モデルが大手に追従された話
# permalink:  # don't use
aliases:
  - Decisions API
  - OpenAI Decisions
tags:
  - ai
  - llm
  - system1
  - openai
draft: false
date: 2026-10-31
---

## きっかけ

X トレンド「OpenAI DevDay で Decisions API プレビュー発表、Jev に追従」。
Jev = [[jev-system-one-model]] 参照。

- 9/30 OpenAIDevs 発表。限定プレビュー。76.9 万表示。
- 10/7 public beta。
- 10/22 GA。
- Jev 発表 (9/15 early access) から約 2 週間で大手が同ジャンル参入。早い。
- apolinario「Jev は全 LLM に取り込まれる。Jev mode 標準搭載」(9/18) → 9/30「思ったより早かった」。
- 平大志朗「AI 時代に SaaS やモデル作るのはリスク大。ビッグテックが入らないニッチに集中」。

## Decisions API とは

- LLM ちがう。文章作らない。質問と選択肢を渡す → 型付き回答 + 確率が返る。
- 用途 = 分類、ルーティング、エージェントの次アクション選択。Jev と同じ。
- 判断あとのアクションはアプリ側の仕事。自由文や任意 JSON ほしいなら Responses API。
- 対応モデルは `gpt-6-luna` のみ。
- `POST /v1/decisions`。

### 質問タイプ

- `predicate` = 真偽判定。`probability` (0〜1) だけ返る。
- `choice` = 多肢選択。選んだ値 + `probabilities` + `confidence`。
- `score` = 2〜10 段階評価。確率重み付け平均の `score` (小数あり) + `probabilities` + `confidence`。
- 1 リクエストで質問 1〜400 個 (ベータは 200)。

### 入力

- テキスト、画像 (`input_image`、base64 か公開 URL)、JSON (`input_json`、user ロールのみ)。
- 質問ごとに別の画像を持たせられる。
- 会話履歴、ツール呼び出しも評価できる。
- 非対応: `file_id`、音声、ファイル、アイテム参照。

### 価格

- 入力 100 万トークン $0.10。出力無料。Jev と同じ「出力無料」方式。
- プロンプトキャッシュあり (共有プレフィックス 1,024 トークン以上)。書き込みは課金。
- リージョン処理の割増、長コンテキスト倍率あり。
- Jev の入力単価 $0.042。単価は Jev が安い。

### 速度

- 公式 =「Responses API の約 10 倍速」。ms は非公開。
- DevDay スライド = 150ms vs 1.6s (二次情報)。
- Speak 社 CTO = 次アクションまで 1.4s → 0.13s (顧客発表)。
- 独立ベンチ (下記) = 平均 144ms (定義のみ)、194ms (例つき)。

### 運用

- ZDR、HIPAA は対象顧客で利用可。
- リージョン処理 = 米国、EEA + スイス。Private Link あり。
- 利用量取得 `GET /v1/organization/usage/decisions` (admin キー必要)。

## Jev との比較

同じ点:

- 文章作らず型付き確率つき回答。LLM の前段の部品。
- 出力トークン無料。
- 速さが売り。

違う点:

- 提供元 = Decisions は OpenAI。Jev は TypeSafe AI (創業者は元 OpenAI)。
- 入力 = Decisions はテキスト + 画像 + JSON。Jev 1.13 はテキストのみ。Jev 1.14 (10/14) で画像入力 (実験的) と Box 質問タイプ追加。
- 入力上限 = Decisions は文書上 922K トークン。Jev 1.13 は合計 64K トークン。Jev 1.14 は 262K の長コンテキスト選択肢あり。
- 速度 = Decisions が速い (144ms vs 298ms)。
- 単価 = Jev が安い。
- 精度 = Jev がわずかに上。
- レスポンス形式 = Decisions は `{value, probability}` の配列。Jev はマップ。切替にアダプタ必要。
- 選択肢上限 = 両方とも 1 質問 255 件 (ベンチ記事による。公式ガイドに明記なし)。

## 独立ベンチ (Stacktoheap、BANKING77 770 件)

著者 1 人、未再現、測定日が別。参考程度。

- 正解率 (定義のみ): Jev 81.2% / Decisions 79.0%。
- 正解率 (例 2 件つき): Jev 85.3% / Decisions 84.2%。
- ECE (確率の信頼性): Decisions が良い (4.4% vs 9.3%)。
- Brier: Jev が良い。
- 例を足すと Decisions はレイテンシ +35%、トークン費用 2.86 倍。
- ファインチューン済み MiniLM 分類器は 89.9%。両方とも負けてる。

## 注意点

- 拒否応答: HTTP 200 のまま回答なし (770 件中 2〜5 件)。理由も確率も付かない。
- 入力上限の実測: 約 692K は成功、約 1.08M は拒否。700K〜900K 付近でタイムアウトやエラーあり。
- 判断理由は残らない。監査、規制業務で弱い (Jev と同じ弱点)。
- 確率の校正は使う側の仕事。閾値は実データで決める。
- 日本からのレイテンシは未計測。

## Zenn 記事「Jev 所感」(meijin、2026/9/18) の要点

Decisions API が出る前に書かれた記事。予想がだいぶ当たってる。

- 本質はルーティング。LLM ワークフローのフローチャートで分岐やループになってる所が置換しやすい。
- 有望: 品質ゲート、入力バリデーション、プロンプトインジェクション対策、エージェント振り分け、LLM as a Judge、Sentry の新規エラー 1 次分類、hooks への組み込み。
- 判断の言語化できないならやるな。
- ツール選択、スキル選択、モデル選択に入れるのは筋悪。全体精度への影響大、evals が面倒。
- 決定的な処理を非決定的にしてよいか。Mastra の入力層は OK。普通の Nest.js コントローラーは NG。
- 懸念 = ネットワーク往復、マルチモーダル未対応、大手の追従。→ 追従は 12 日後に現実化。画像入力も Decisions は対応済み。

## 金のニワトリ (@gosrum) の指摘

- Jev で 10 個以上アプリ実装した経験者。
- 画像入力対応はデカい。でも問題はレイテンシ。タスクによっては通信遅延が致命的。
- 日本から 100ms 以内は物理的に難しそう。
- こういうモデルこそオープンウェイトになってほしい。

## Jev 側の動き (Decisions API 発表後)

- 10/9 TypeSafe AI が $870M 調達、評価額 $7.5B。Jev 発表から 1 か月足らず。
  - 主導 a16z。Sequoia、既存の DCVC も参加。Martin Casado が取締役入りの報道あり。
  - 使途 = モデル追加と enterprise features。
  - pre-money / post-money は報道では不明。
- 採用の主張は自己申告で食い違う。TypeSafe =「Fortune 500 の約 3 分の 1」、a16z =「25% が統合済み」。
- Vercel、Cloudflare が Jev 追加に動いた (Forbes 9/19)。
- 10/14 Jev 1.14 が安定版。画像入力 (実験的)、Box 質問タイプ、262K 長コンテキスト。
- 価格据え置き。入力 $0.042 / 100 万トークン、出力無料。値下げなし。
- Decisions API への TypeSafe の公式反応は見つからず。
- ※ 上の比較表 (入力形式、上限、精度、速度) は 1.13 時点のベンチ。1.14 で再測定してない。

## Jev は死ぬか

- 単体は厳しい、という当初の見立ては撤回。巨額資金と a16z / Sequoia がついてて、当面は資金切れしない。
- ただし資金調達 ≠ 需要の証明。評価額は期待値、採用数は自己申告。
- 画像、長コンテキストで Decisions API との差は縮まった。残る差 = 単価 ($0.042 vs $0.10)、精度わずかに上、先行実績。
- 大手参入はジャンルの正当化にもなる。投資家には追い風。
- 未確認: 実際の売上、採用数の独立検証、Decisions API 後の価格戦略。

## 所感

- Decisions API = Jev のコンセプトを OpenAI が自社製品化したもの。速度、入力サイズ、既存プラットフォームが強み。
- Jev の優位 = 単価、わずかに高い精度、先行実績 (Vercel 等)、潤沢な資金。
- 長期は単体モデルより LLM の一機能に吸収される方向、という予想 (apolinario) は有力。ただし吸収される前に Jev が別の形に伸びる可能性もある。
- 使う側の課題は変わらない。判断軸の言語化、閾値の実データ校正、拒否応答のフォールバック。
- 未確認: `choice` 選択肢上限の公式値、日本からの実測、Jev 最新版との再比較。

## 参考

- [Decisions - OpenAI 公式ガイド](https://developers.openai.com/api/docs/guides/decisions)
- [OpenAIDevs 発表ポスト](https://x.com/OpenAIDevs/status/2105003318917697873)
- [金のニワトリ ポスト](https://x.com/gosrum/status/2105113738567417877)
- [Jev 所感 ダラダラと書く - Zenn (meijin)](https://zenn.dev/meijin/articles/jev-impressions)
- [OpenAI Makes Decisions API Generally Available - Unite.ai](https://www.unite.ai/openai-makes-decisions-api-generally-available-with-gpt-6-luna/)
- [OpenAI launches Decisions API public beta - AI Weekly](https://aiweekly.co/alerts/openai-launches-decisions-api-public-beta-on-gpt-6-luna)
- [OpenAI Decisions API: How Does Jev's Big-Lab Competitor Fare? - Stacktoheap](https://stacktoheap.com/blog/2026/10/08/jev-the-decisions-strike-back/)
- [OpenAI's Decisions API vs Jev - Firecrawl](https://www.firecrawl.dev/blog/openai-decisions-api-vs-jev)
- [Jev vs OpenAI Decisions API - Valyu](https://www.valyu.ai/blogs/jev-vs-decisions-api)
- [Jev creator TypeSafe closes $870M round at $7.5B valuation - SiliconANGLE](https://siliconangle.com/2026/10/09/jev-creator-typesafe-closes-870m-round-at-7-5b-valuation/)
- [TypeSafe AI Releases Jev 1.14 - MarkTechPost](https://www.marktechpost.com/2026/10/14/typesafe-ai-jev-1-14-images-box-long-context/)
- [Jev Cuts AI Decision Costs 100x And Vercel, Cloudflare Rushed To Add It - Forbes](https://www.forbes.com/sites/josipamajic/2026/09/19/jev-cuts-ai-decision-costs-100x-and-vercel-cloudflare-rushed-to-add-it/)
- [What Is OpenAI Decisions API? - SmartScope](https://smartscope.blog/en/blog/openai-decisions-api-competitor-jev-similarities-constrained-choice-2026/)
