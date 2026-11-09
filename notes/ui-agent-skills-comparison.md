---
title: UI 系 agent skill 比較
description: jakubkrehel/skills・impeccable・frontend-design・ui-ux-pro-max・web-design-guidelines の役割と重複の比較
aliases:
  - ui-skills-comparison
tags:
  - agent
  - skill
  - ui
  - frontend
  - comparison
draft: false
date: 2026-11-07
---

UI 系 skill 5 種、役割ちがう。重複ある。Web 開発プロジェクト始める時、どれ入れるか選ぶ用メモ。
星数は 2026-11-07 時点 (`gh api`)。星 = 人気。品質ちがう。

関連: [[jakubkrehel-skills]] / [[agent-skills-tools-clips-2026-11]]

## 一覧

- **anthropics/skills の `frontend-design`** (リポジトリ全体 188k)
  - 役割: 新規 UI を「作る」。公式。
  - 中身: SKILL.md 1 枚の指示文。データなし。「テンプレ臭い AI デザインを避けろ」が主題。AI が出しがちな型 (クリーム背景 + セリフ + テラコッタ、SaaS カード、全部大文字 eyebrow など) を名指しで禁止。
  - 流れ: 計画 (色 4-6 個・書体・レイアウト) → レビュー → 実装 → 批評。
- **nextlevelbuilder/ui-ux-pro-max-skill** (146k) ← 導入済み
  - 役割: 作る。辞書から選ぶ。
  - 中身: CSV データベース (スタイル 50+、配色 97、フォント 57、UX ルール 99、チャート 25、9 スタック) + 検索スクリプト。案件種別に合う「スタイル + 配色 + フォント」を返す。
  - 弱み: 出力が無難な SaaS 風になりやすい、と複数記事。説明文のトリガー語が多く、無関係な場面でも発火しやすい。
- **pbakaus/impeccable** (105k)
  - 役割: 作る + 直す + レビュー。既存 UI を反復改善するのが得意。
  - 中身: 24 コマンド。`bolder` `quieter` `polish` `harden` など「操作語彙」で指示。`critique` (UX 採点)、`audit` (技術品質 P0〜P3)。62 個の決定的ルールで AI 臭さ検出 (LLM 不要)。`init` で `PRODUCT.md`、`document` で `DESIGN.md` を作り、以後それを読む。
  - 導入: `npx impeccable install` → `/impeccable init`。Claude Code 以外にも Cursor, Codex など多数対応。CLI・ブラウザ拡張・VS Code 拡張もあり、規模大きい。
- **vercel-labs/agent-skills の `web-design-guidelines`** (リポジトリ 34k)
  - 役割: 既存コードの監査のみ。
  - 中身: SKILL.md はごく薄い。毎回 GitHub から最新のガイドライン (100 項目以上) を WebFetch で取得し、対象ファイルを検査、`file:line` 形式で出力。
  - 注意: 実行のたびにネット取得。オフラインだと動かない。同リポジトリに `react-best-practices` `composition-patterns` など React 系もある。
- **jakubkrehel/skills** (11k)
  - 役割: レビュー + 開発補助。作る側は担当しない。
  - 中身: 15 スキル。ドメイン知識 7 (`better-*`)、動詞 4 (`break` `state-machine` `variant` `interface-review`)、他。詳細は [[jakubkrehel-skills]]。

## 機能別の重複

- 新規 UI を作る: `frontend-design` / `ui-ux-pro-max` / impeccable
  - 方向性が逆。`frontend-design` と impeccable = 「ありがちを避けろ」。`ui-ux-pro-max` = 「カタログから選べ」。
- 既存 UI をレビュー: impeccable (`critique` `audit`) / `web-design-guidelines` / jakubkrehel (`better-interface` `interface-review`)
  - 一番重複する所。
  - `web-design-guidelines` = 軽い・ルール固定・行単位。
  - jakubkrehel = ドメイン別に深い・差分 (PR) 単位あり。
  - impeccable = 採点 + 優先度付き + 自動検出。
- アクセシビリティ・配色・文字組: `better-accessibility` `better-colors` `better-typography` ↔ impeccable の `typeset` `colorize` `audit`
- 案出し比較: `variant` ↔ impeccable の `live` `generate`
- 文言: `better-writing` ↔ impeccable の `clarify`
- jakubkrehel だけの機能 (確認できた範囲):
  - `break` (全シナリオ壊し)
  - `state-machine` (全状態並べ)
  - `interface-review` (差分単位レビュー)
  - 競合の中身まで全部は読んでない。

## 所感・方針

- 評判・規模重視 = 作る側は impeccable か `frontend-design`、監査は `web-design-guidelines`。
- jakubkrehel は `break` / `state-machine` / `variant` / `interface-review` の 4 つだけ入れる手あり。レビュー系は impeccable とかぶる。
- `ui-ux-pro-max` は導入済みだが主力にするほどでない。無関係な場面で発火するので、Web プロジェクト側に移す方が良い。
- 比較記事は「1 本のテストでスコア割れる」「サイト種別で勝者変わる」。参考程度。自分のプロジェクトで試して決める。
- 全部入れると指示が衝突する。**1 プロジェクトに作る系 1 つ + レビュー系 1〜2 つまで** が無難。

## 出典

- [20 Best Claude Code Skills for UI/UX Design](https://pasqualepillitteri.it/en/news/576/claude-code-skills-design-uiux-guide)
- [Claude Code Frontend Design Skills Compared — SkillGild](https://skillgild.dev/learn/claude-code-frontend-design-skills)
- [Best Frontend Design Skills for Claude Code (2026)](https://claudeskills.info/best/frontend-design-skills/)
- [ui-ux-pro-max と frontend-design の比較](https://note.com/ai_smallbiz_lab/n/n64e2c6f8de5a?hl=en)
- 各リポジトリの README / SKILL.md (ローカル clone: `~/ghq/github.com/{pbakaus/impeccable,vercel-labs/agent-skills,anthropics/skills}`)
