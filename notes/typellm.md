---
title: TypeLLM 要約
description: 複数ステップの判断・抽出を 1 回の API 呼び出しに宣言する workflow model。仕組み、料金、ベンチの検証メモ
aliases:
  - typellm
tags:
  - llm
  - api
  - structured-output
  - saas
draft: false
date: 2026-11-09
---

TypeLLM。複数ステップの判断・抽出を、1 回の API 呼び出しにまとめて宣言する。スキーマに沿った出力を、既存の LLM に強制する。
元ネタ: [[agent-skills-tools-clips-2026-11]]
関連: [[qiita/decision-models-2026-10]] (判断モデル / System One の流れ。TypeLLM は Jev の後追い兼拡張)

- 公式: https://typellm.ai/
- repo: https://github.com/TypeLLM/TypeLLM (Apache-2.0、星 約 981、コミット 241)
- 推論基盤は SGLang。README に「TypeSafe AI の Jev に着想」とあり、Jev 互換のエンドポイント (`/v1/systemone`、`/v1/decisions`) も提供。
- **運営会社、創業者、所在地は、読んだどのページにも書かれていない**。ブログは 2 本だけで、創業の経緯なし。
- 更新履歴の推測: 2026-09 に Jev 公開直後に開発開始、2026-10 に API 公開 ($5 の無料クレジット付き)。

## workflow model

- 主張: チャット API を 1 ステップずつ呼ぶと、プレフィックスキャッシュが効かず、同じ入力を何度も読む。ワークフローをグラフで一度に宣言し、サーバーが実行計画を立てる。
- 1 回の `generate` に `context` (入力文) と `questions` (質問のグラフ) を渡す。
- 並列: フィールドは既定で並列に動く。専用キーワードなし。
- `depends_on`: 依存先の答えを見て答える。
- `when`: 他の答えへの条件。満たさないフィールドは skip され、`skipped` に入る。
- 型: enum、boolean、number、string、object、array など。人間の入力待ち (`"source": "user"`) で止め、`resume()` で再開する機能もある。
- 例 (docs): チケットから `category`、`urgent`、`handling_advice` (前 2 つに依存)、`refund_amount` (billing のときだけ) を一度に取る。
- トップの「Chat / Decision / Workflow model」は、製品ラインアップではなく概念表。Chat = GPT (Generate)、Decision = Jev (Decide)、Workflow = TypeLLM (Execute)。

## 使い方

- `POST https://api.typellm.ai/v1/generate`、認証は Bearer の `tl-sk-...`。
- Python SDK (`pip install typellm`) あり。JS/TS SDK は、読んだドキュメントに見当たらず、REST の curl 例のみ。
- 制限: 1 リクエストの質問数 64、入力 128K トークン、タイムアウト 60 秒 (最大 90 秒)、1 分あたり 200 リクエスト、同時実行 4。チャージ額で上がる。
- 公開モデル名は `typellm-latest` の 1 つ。ホスト型の中身のモデルは明記なし。自前運用の例は Qwen3.8-27B (SGLang)。

## 料金

- 従量。入力 $0.05/MTok、thinking $0.50/MTok、**答え (型付き出力) は無料**。
- 新規ユーザーは $5 の無料クレジット。永続の無料枠は見当たらない。企業向けは個別見積もり。

## クリップの数字の検証 (すべて提供元の主張、独立検証なし)

- **「53% 安く、1.9 倍速い」**: 支払額の比較ではない。サポートチケット 1 件で、TypeLLM 1 回 (入力 149 トークン、中央値 1.38 秒) と、**TypeLLM 自身が設計した**直列 4 回 (320 トークン、2.60 秒) を比べたもの。53% は入力トークン数の差、1.9 倍は中央値の時間比。測定は 15 回。ハードウェアとベースラインのモデル名、価格は書かれていない。
- **JevBench 84.4% (thinking なし) / 98.7% (thinking あり)**:
  - 公開サブセット 231 問 (全体は 534 問で、全体スコアは主張していない)。
  - TypeLLM 自身が Qwen3.8-27B + SGLang (RTX PRO 6000 Blackwell) で実行。追加学習なし。
  - 1 回の実行で、有意差の主張なし。thinking の実行は、既存サービスのキャッシュを再利用していて、cold-cache の比較ではない。
  - 比較表は、LoRA 学習済みの Open-Jev 27B とだけ。Jev や GPT の再測定は含まれない。
  - 回答ファイルと集計スクリプト (`verify.py`) は公開。ただし生の通信記録と推論トレースは無く、第三者の監査ではない。
- トップの表では、GPT-6 Astra (low) が 100%、Jev が 86.58%、GPT-5.6 Luna (none) が 89.18%。98.7% は最上位ではない。Jev と GPT の数値の出典は確認できなかった。
- そのほか「2.5 倍速い」「再現率 +34%」「512 クラス」なども、README に「TypeLLM が 2026-10 に測定」とあるだけ。データと手順は未確認。
- 「No out-of-schema hallucinations」はスキーマ強制による設計上の主張。独立した評価なし。

## 位置づけと競合 (私の知識、今回は検索していない)

- 近いもの: 構造化出力 (JSON Schema 強制) と制約付きデコード。OpenAI や Anthropic の structured outputs、Outlines、XGrammar、guidance など。
- ワークフローの組み立て: LangGraph や DSPy が近い。ただし複数の API 呼び出しを組む方式で、1 回に畳む TypeLLM とは設計が違う。

## 所感と判断

- 狙いは理解できる。分類、抽出、ルーティングなど、複数の小さな判断を 1 回で済ませ、プレフィックスキャッシュを活かしてコストと遅延を下げる。
- ただし、運営の実体が不明、数字は自社測定、JS/TS SDK なし。**採用の判断材料にはまだ弱い**。
- 自前運用 (Apache-2.0、SGLang) もできるので、仕組みの参考として読む価値はある。
- 判断: 見送り。まず手元の LLM の構造化出力で足りるかを確かめる。独立した評価や、運営情報が出てきたら再検討。

## 未確認

- `/about`、`/examples`、`/cookbook`、`/docs/changelog` など、一部ページは未読。
- ホスト型の基盤モデル名、運営会社、JS/TS SDK の有無は確認できなかった。
- 実際には動かしていない。
