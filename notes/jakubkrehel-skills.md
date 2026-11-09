---
title: jakubkrehel/skills 要約
description: UI 品質チェック系エージェントスキル集 15 個の要約。Web 開発プロジェクト単位で導入する想定
aliases:
  - better-interface
  - interfaces-skills
tags:
  - agent
  - skill
  - ui
  - frontend
draft: false
date: 2026-11-07
---

jakubkrehel/skills。UI 作り用スキル集。15 個。フロントエンド向け。バックエンド関係なし。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/jakubkrehel/skills
- 作者サイト: jakub.kr / 雑誌 interfaces.dev
- ローカル: `~/ghq/github.com/jakubkrehel/skills` (ghq get --shallow)

## 入れ方

- `npx skills add jakubkrehel/skills` (skills CLI)
- Claude Code plugin: `/plugin marketplace add jakubkrehel/skills` → `/plugin install interfaces@interfaces`
  - plugin 経由だと呼び出し名 `/interfaces:better-interface`。CLI 経由は `/better-interface`
- **方針: グローバル導入しない。Web 開発プロジェクトで必要な時にプロジェクトレベルで入れる。**
- 既存 `ui-ux-pro-max` と守備範囲かぶる。

## 設計思想

- 2 種類。ドメインスキル = 知識 (何が正しいか)。動詞スキル = 手順 (レビューする・案を出す)。
- 「証拠であって好みじゃない」。プロジェクトが意図した選択は指摘しない。壊れてる証拠あるものだけ報告。
- 動詞スキルは `disable-model-invocation: true` 多め = ユーザーが明示呼び出しした時だけ動く。
- 各 SKILL.md は 85〜165 行。短い。

## ドメインスキル (知識・レビュー)

- `better-interface` ... 総合レビュー。各 better-* に振り分け、証拠集めて、順位付きレポート 1 本。範囲広すぎる時は 1 フローに絞って「見てない所は見たと言わない」。
- `better-ui` ... 角丸入れ子・光学的ずれ・影・アイコン状態・アニメの具体数値。
- `better-typography` ... 文字スケール・行間・折り返し・省略・約物。
- `better-colors` ... パレット生成・セマンティックトークン・形式変換・コントラスト計測。
- `better-accessibility` ... キーボード・フォーカス・ARIA・フォーム・読み上げ・モーション・ズーム。WCAG 2.2 基準。
- `better-layout` ... グルーピング・整列・読み順・レスポンシブ。翻訳・RTL でも崩れないか。
- `better-writing` ... ラベル・エラー・空状態・確認ダイアログの文言。

## 動詞スキル (手順)

- `interface-review` ... ブランチ / PR / 未コミット差分を UI 観点でレビュー。「新規」「退行」「既存」を区別。ユーザー呼び出し専用。
- `break` ... **注目。** コンポーネント 1 個を、実際に到達しうる全シナリオ (長文・ゼロ件・エラーなど) で一時ページに並べて壊しにいく。
  - 手順: 範囲 1 コンポーネント → props/slots から必要な軸だけ推論 (`scenarios.md`) → アプリ内に捨てルート作成 (本物のコンポーネントを import、独自スタイルなし) → 1 回だけ目視 → 壊れた所を表で報告 (シナリオ / 観察 / 担当ドメインスキル)。
  - 判定は出さない。「見て壊れた」事実だけ。数分で終わる設計。
  - テスト工数割けない UI の視覚テストを AI に投げる用途で便利。
- `state-machine` ... コンポーネントの全状態をモックデータ + 切替 UI で捨てページに並べる。状態ごとに作り込む用。
- `variant` ... コンポーネントの案を複数作って比較・選択。実ページ上で見る (break と違い文脈込み)。
- `build-design` ... Figma / 画像から、既存トークン・コンポーネントを使って実装。

## 周辺スキル

- `explain-interface` ... URL かスクショから、サイトや演出の作りを解説。
- `teardown` ... 物体の技術イラスト作成。色設定して SVG / PNG / PDF 出力。独自アセット・スクリプト・テスト (`scripts/test-*.cjs`) あり。
- `away` ... 留守中に自走。証拠集め → アイデア多数 → 強い数個をローカルブランチに実装 → 2 分で読めるレポート。「使う人にとって本当に良くなるか」を基準にする。

## 感想

- 入れる価値高い: `break`, `interface-review`, `better-interface`, `better-accessibility`。
- React 等のフロント開発プロジェクトを始めたら、そのプロジェクトに入れる。この vault には不要。
