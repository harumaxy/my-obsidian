---
title: jev-lint-typesafe
description: TypeSafe社のJev(System One Model)とjev-lintの仕組み・料金・競合まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - ai
  - llm
  - lint
draft: false
date: 2026-09-22
---

## jev-lint とは

TypeSafe社製 Jev モデル使う lint ツール。コード自己主張と実態の矛盾検出担当。型検査・構文解析で拾えん論理矛盾狙う。

例: 「nullを返す」コメントあるのに例外投げる実装、みたいな矛盾。

- リポジトリ: https://github.com/mizchi/jev-lint/blob/main/README-ja.md

### 仕組み

1. ast-grep がコードパターンマッチ箇所特定（ローカル実行）
2. マッチ箇所を一文の問いに変換（「このコメントは実態と違う主張してるか?」）
3. 問いを Jev API に送信 → 0〜1の確率スコア返却

判定対象コードのみAPI送信。98ルール・47問い用意。関数名↔実装、コメント↔コード、テスト↔実装、エラー処理(silent fail)、シェルスクリプトのセキュリティ、マークダウン品質、コミットメッセージ↔diff、など幅広く検査。

### 使用法

```bash
npx jev-lint check src           # 全体検査
npx jev-lint review --base main  # 差分検査
npx jev-lint commits --base main # コミット検証
```

設定はESLint同様YAML、ルール単位有効/無効切替可能。

### 特性

- 非決定的。実行毎スコア変動、偽陽性率約20%
- 自動修正でなく候補提示、人間判断の補助役
- TS/Rust第一級対応、Python/Go他、カスタム言語も可
- キャッシュあり、`--retry`で再現性向上
- 既存ツール(コンパイラ・型検査)で決定できることはやらん設計

### 依存・料金

- Node 24+ と npx あればインストール不要で試せる
- 本格導入: `npm install --save-dev jev-lint` → `npx jev-lint init`
- APIキー必須(typesafe.ai取得)、環境変数 `TYPESAFE_API_KEY` か `TYPESAFEAI_API_KEY` から読む(configには書かない設計)
- キーなしでも `--dry-run`(見積り)、`jev-lint rules`(ルール一覧)、`jev-lint replay`(再採点)、CI(コミット済みキャッシュ利用)は動く
- 料金実測: 2ファイル・6 finding で0.1セント

## Jev / System One Model とは

TypeSafe社(typesafe.ai)が出した新モデルクラス「System One Models」の第一号。

名前の由来、ダニエル・カーネマン『ファスト＆スロー』の二重過程理論。System 1(直感・高速思考) vs System 2(熟慮・低速思考)の対比から命名。従来LLMをSystem 2的、Jevを意図的にSystem 1的に設計した、という立て付け。

### 従来LLM(GPT/Claude/Gemini)との違い

| 項目 | 従来LLM | Jev |
|---|---|---|
| 出力 | テキスト生成 | 型付き構造化値(確率・選択肢) |
| 処理方式 | トークン逐次生成 | 並列で一気に確定 |
| 応答速度 | 3〜329秒 | 70〜500ミリ秒 |
| 自信度 | 過信気味・不安定 | 較正済み確率を常時提供 |
| 幻覚 | 起こりうる | 起こらない(選択肢が事前定義された閉集合だから) |

訓練手法は RLCD (Reinforcement Learning for Calibrated Decisions)。「較正済み決定を出す」こと自体を報酬目標にした強化学習。

性能主張: 通常LLM比193.6倍高速、444.6倍安価。入力トークン$42/10億トークン。

### 3つのプリミティブ(問いの型)

- **Choice** ── リストから1つ選ぶ。最大255選択肢まで対応
- **Score** ── ルーブリックに対してスコアリング
- **Noul** ── 「この陳述は真か」を0〜1で判定

### 得意・不得意(公式ドキュメント記載の弱点)

得意: 直感的・意味的判断、閉じた選択肢からの選択

不得意:
- 計算・数値演算(計算機ではない)
- 個数カウント
- 日付の順序比較
- 低レベル表現(RGB値・16進数など)
- 多段階/間接的推論(二重否定など)
- 無関係情報が多い長い文脈
- 敵対的入力(プロンプトインジェクション的文言)
- 矛盾する指示
- 肯定/否定の確率が相補的にならないケースあり

### 較正精度について

公式ベンチマーク数値は非公開。「保守的な閾値からスタート→自分のデータで実測→調整」が公式推奨。リスクの高さ(資金移動 vs 残高表示など)で閾値変えるべき、とも言ってる。

### 大量カテゴリ分類の実例(SEC年次報告書→75業界分類)

- Choiceで75選択肢を1問で処理(240選択肢まで確実動作との仕様)
- 2階層設計: 第1階層=75業界グループ、第2階層=10部門(自動マップ)
- confidence≥0.9なら細分類報告(正解率約90%)、未満なら大分類にフォールバック(正解率約70%)
- 位置バイアス対策: 選択肢をソート済み固定順で提示

```python
def classify(filing: dict) -> dict:
    answer = ask(filing["id"], filing["text"])
    sure = answer["confidence"] >= 0.9
    return {
        "level": "group" if sure else "division",
        "label": answer["group"] if sure else division(answer["group"]),
        "confidence": answer["confidence"],
        "group": answer["group"]
    }
```

精度実測: 強制細分類65%正解 → confidence戦略併用で80%が有用な結果に改善。

### 使い方(Python SDK)

```bash
pip install typesafe-sdk  # Python 3.10+
export TYPESAFE_API_KEY=your_api_key_here
```

```python
from typesafe_sdk import Noul, TypeSafeClient

client = TypeSafeClient()

response = client.system_one(
    state="Hi, I've been trying to connect my Stripe account for 3 days...",
    questions={
        "is_urgent": Noul(
            instructions="The message conveys urgency or time-sensitivity"
        ),
    },
)

print(response.answers["is_urgent"].noul)
```

### ユースケース候補

コードレビュー(jev-lint)以外にも、「大量のファジーなデータを安く高速に分類したい」場面全般に効く:

- モデレーション/スパム判定
- RAG検索結果の関連性再ランキング
- LLMエージェントのガードレール(自信高いとき自動実行、低いとき人間レビュー)
- データパイプラインのバリデーション
- カスタマーサポートのトリアージ
- 求人サイト等の業種・カテゴリ分類(大量データ、多カテゴリ、位置バイアス問題の回避にも有効)

### 競合・代替

- **フロンティアLLM軽量版** ── Claude Haiku 4.5, GPT-5.6 Lunaなど。単純分類ならこれでも十分安い
- **自前ファインチューニング小型モデル/勾配ブースティング木** ── ラベル付きデータとラベル集合固定なら安くて予測可能
- **OSS版System One(ローカル実行)**:
  - **poorjev** ── Choice/Score/Noulインターフェース再現、zero-shot NLIモデル利用、ローカルファースト
  - **von** ── 395Mパラメータ非自己回帰モデル、sub-15ms推論。精度Jev同等以上の実測あり(0.769 vs Jev 0.727)
  - **Laya** ── 非自己回帰モデル、多言語対応、最速(30〜32.8ms)だが精度は低め(0.590〜0.766とベンチ次第)

ローカル実行は速度面で問題なし(むしろマネージド版より数倍速い)。ただしモデル選定で精度に大きな差出る。精度要求あるタスクはvon寄り、速度・処理量優先ならLaya寄り、が判断基準になりそう。

## 出典

- https://github.com/mizchi/jev-lint/blob/main/README-ja.md
- https://typesafe.ai/
- https://docs.typesafe.ai/
- https://typesafe.ai/blog/introducing-system-one-models-and-jev
- https://docs.typesafe.ai/cookbooks/classification_using_confidence.md
- https://docs.typesafe.ai/model-jaggedness/jev-1.13.md
