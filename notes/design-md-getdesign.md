---
title: DESIGN.md と getdesign.md
description: DESIGN.md 形式の仕様 (Google) と、実在サイトの DESIGN.md を集めた getdesign.md カタログ。使い所と限界のメモ
aliases:
  - design-md-getdesign
  - getdesign.md
tags:
  - agent
  - design
  - design-md
  - frontend
draft: false
date: 2026-11-09
---

DESIGN.md 形式と、getdesign.md カタログ。web 開発の視点で、使い所を整理。
元ネタ: [[agent-skills-tools-clips-2026-11]]

## DESIGN.md 形式 (Google Labs)

- repo: https://github.com/google-labs-code/design.md (ローカル: `~/ghq/github.com/google-labs-code/design.md`)
- 目的: 見た目のアイデンティティを、コーディングエージェントに渡す書式。
- バージョン `alpha`。最終コミット 2026-11-06。形式は変わりうる。
- 発端は Google Stitch (getdesign.md の About による)。Stitch 公式ドキュメントのページは JS 描画で本文を取れず、未読。

### 構成 (2 層)

- 上: YAML トークン。`colors`、`typography`、`rounded`、`spacing`、`components`。値の正確さ担当。
- 下: Markdown 散文。Overview、Colors、Typography、Layout、Elevation & Depth、Shapes、Components、Do's and Don'ts。順序固定 (省略は可)。理由と意図担当。
- 散文からトークン参照: `{colors.primary}`。

### 思想 (`PHILOSOPHY.md`)

- **散文が本体**。トークンは文脈であって、描画の命令ではない。
- 「Modern, clean」のような形容詞は凡庸な出力を生む。具体的な参照 (「1970 年代の大学の講義ハンドアウト」) のほうが多くを伝える。
- 禁止事項 (Do's and Don'ts) は意図的に書くと効く。長い禁止リストは、記述が曖昧な印。

### 公式 CLI (`npx @google/design.md`)

- `lint DESIGN.md`: 参照切れ、WCAG コントラスト比、セクション順、未使用トークンなど 11 ルール。JSON 出力。エージェントが読んで直せる。
- `diff A B`: トークン差分と、悪化の検出。
- `export --format css-tailwind | json-tailwind | dtcg`: Tailwind v4 の `@theme`、Tailwind v3 の設定、W3C DTCG に変換。
- `spec`: 仕様をプロンプトに差し込む。
- 注意: `lint` が見るのは `DESIGN.md` 自身の整合性だけ。コードや Figma が違反していないかは見ない。

## getdesign.md

- サイト: https://getdesign.md/
- repo: https://github.com/VoltAgent/awesome-design-md (MIT、ローカル: `~/ghq/github.com/VoltAgent/awesome-design-md`)
- 運営: VoltAgent チーム (AI エージェントフレームワークの会社)。About は「独立したコミュニティのディレクトリ」と自称。
- 実在サイト (Linear、Stripe、Apple など) のデザインを解析した DESIGN.md を集めたカタログ。
- 使い方: `npx getdesign@latest add linear.app` をプロジェクトのルートで実行 → エージェントに「UI は DESIGN.md を使って」と頼む。手動コピーも可。
- 件数: サイトは「550+」、リポジトリの `design-md/` は **84 件** (clone して数えた)。550+ が有料分を含むかは未確認。
- 料金: カタログ、CLI、GitHub は無料。有料は Catalog Pass が月額 $99 (選定 45 件、毎月 5 件以上追加)、特定サイトの解析依頼 (Private)、動画テンプレート ($29)。
- 免責: 「公式の分析ではない、提携していない、商標は各所有者のもの」。商用での扱いは利用者側で確認。法的判断はしていない。
- 解析の方法 (手書きか自動抽出か) は明記なし。README は「公開 CSS の値から抽出」。
- 実ファイル (Linear): 548 行。YAML フロントマター + Overview、Colors、Typography、Layout、Elevation & Depth、Shapes、Components、Do's and Don'ts。README が言う 9 節 (Agent Prompt Guide 含む) とは見出しが少し違う。
- 解析元はマーケティングサイト。アプリ内 UI とは違う場合がある (Linear も「marketing canvas」と書いてある)。

## 使い所 (web 開発の視点)

- **効く**: エージェントに画面を **新規生成** させるとき。毎回同じ雰囲気になる。デザインが無い所から作る用途。
- **効きにくい**: バグ修正、既存コンポーネントの微修正、Figma のフレームを写す実装。
- 現行ワークフロー (非デザイナーが作った Figma → Figma MCP → コード) では、効果は小さいと見ている (推測、未検証)。
  - Figma が画面ごとの真実の源。DESIGN.md が補えるのは、Figma に無い部分 (hover、エラー、空状態、レスポンシブ) と、翻訳ルール (生の hex を書かない、既存コンポーネントを使う)。
  - 翻訳ルールは `CLAUDE.md` に数行書いても同じ。DESIGN.md を別に作る必然性は薄い。
  - まず CLAUDE.md に数行足し、ルールの有無で出力を比べる。違いが出なければ不要。

## 組織のトークンの違反チェックに使えるか

- できる。ただしチェック処理は自作。DESIGN.md は基準と、LLM への説明役。
- コード側: CSS や TSX から生の hex、px、フォント名を抜き出し、トークンと突き合わせる。または `export` した `@theme` 経由でしか色を指定させない (生の hex 禁止)。意図の違反は LLM レビュー。
- Figma 側: 変数にバインドされていない生の値を探す。Figma の REST API で変数を取るには Enterprise 限定の制約があった記憶 (未確認)。MCP 経由のほうが制約が少ない可能性。
- 基準だけなら DTCG の `tokens.json` のほうが、他のツールと連携しやすく無難かも (DESIGN.md は alpha)。Figma の変数が整理済みなら、そこから直接 `tokens.json` を作るほうが手間が少ない。
- 「違反」の定義 (完全一致か、近い値を許すか) を先に決める。

## getdesign.md の使い方 (決定)

- **そのまま使うとサイトのクローンになる**。商標や権利の面もあり、業務ではそのまま流用しない。
- 参考にする使い方:
  1. **書式の見本**: 何をどの粒度で書くか (Overview の書き方、`{colors.primary}` の参照、Do's and Don'ts) を実物で学ぶ。一番価値が高い。
  2. **雰囲気の出発点**: 方向性 (ダークで高密度、アクセントは 1 色だけ) を選び、トークンを自分の好みに差し替える。
  3. **ブレンド**: A 社の Layout と B 社の Typography を組み合わせる。
- カスタマイズの勘所: まずトークン (色、フォント、角丸) を差し替える。散文の意図 (「ラベンダーは装飾に使わない」など) は自分のブランドに合わせて書き直す。元の会社名や固有の表現は残さない。
- 書式を学ぶなら、公式 `examples/` (3 つ: atmospheric-glass、paws-and-paths、totality-festival) と Linear の DESIGN.md を並べて読む。公式の例は未読。

## 未確認・やること

- 「DESIGN.md を渡すと出力が安定する」という効果は、検証していない。
- Stitch 側のワークフロー、公式 `examples/` の中身、getdesign.md の有料版の内容は未確認。
- 手元の web プロジェクトで、既存 CSS から DESIGN.md を逆起こし → 同じ画面を生成して比べる実験をしたい。
