---
title: loop-engineering
description: ループエンジニアリングの概要と実装方法
permalink:
aliases:
  -
tags:
  - AI
  - ClaudeCode
  - AgentSDK
draft: false
date: 2026-06-21
---

# ループエンジニアリング

## 概要

「エージェントにプロンプトを打つ人」から自分を外し、代わりにそれを打ってくれる仕組みを設計すること。

> Loop engineering is replacing yourself as the person who prompts the agent. You design the system that does it instead.
> — Addy Osmani

## 4層構造

下から上へ積み上がる。上ほど管理範囲が広い。

| 層 | 何を管理する |
|---|---|
| Prompt engineering | 一回の指示文 |
| Context engineering | ウィンドウに何を入れるか |
| Harness engineering | 単発実行の装備（ツール、完了条件） |
| Loop engineering | harness を自動で何度も回す |

## ループの5つのアクション

1. 発見（discovery） — この周で何をやるか見つける
2. 受け渡し（handoff） — タスクを隔離して作業役に渡す
3. 検証（verification） — 別エージェントがチェックする
4. 記憶（persistence） — 状態をファイル等に書き出す
5. スケジューリング（scheduling） — 放っておいても回り続ける

## ループの6つのパーツ

| パーツ | 対応する動作 |
|---|---|
| Automations | スケジューリング |
| Worktrees | 受け渡し（並行作業の隔離） |
| Skills | 発見（知識の再利用） |
| Connectors（MCP） | 記憶 / 発見 |
| Sub-agents | 検証（生成役と評価役の分離） |
| Memory | 記憶（ファイルに残る状態） |

## 核心: 検証の分離

- 書く側（生成役）とチェックする側（評価役）を分ける
- 評価役は別の指示・できれば別モデルにする
- これがないと「ただ生成を垂れ流す装置」になる

## Claude Code での実装（3ファイル構成）

### 1. CLAUDE.md — ループ協議

- 変更 → チェック → 失敗なら戻る、のループを定義
- 停止条件を明記（全チェック通過 or 最大N回 or 同じエラー2回）
- 禁止事項: チェック出力なしで完了報告、テスト弱体化

### 2. .claude/settings.json — フック

- `Stop`: 完了宣言時にテスト強制実行
- `PostToolUse`: ファイル編集時に型チェック
- ハーネス側に制約を持たせることで「忘れる」問題を防ぐ

### 3. .claude/agents/fixer.md — 行き詰まり打破

- 別コンテキストで新鮮な視点から修正
- 同じ会話内のロックされた思考を回避

## コンテキスト劣化対策

LLM セッションは長くなると品質が下がる。対策:

1. **ループ1周 = 1セッション** — 最も確実
2. **指示はセッション外に置く** — CLAUDE.md, hooks は毎回読み込まれる
3. **Memory の外部化** — 進捗をファイルに書き出し、次セッションが読む

## 実装の選択肢

### A. シェルスクリプト + `claude -p`

- Max サブスク内で動く
- 毎回新しいセッション（コンテキスト劣化なし）
- 素朴だが確実

### B. Claude Agent SDK（TypeScript / Python）

- `npm install @anthropic-ai/claude-agent-sdk`
- Claude Code CLI のラッパー → Max サブスクで動く
- hooks, subagents, MCP 対応
- `maxTurns`, `maxBudgetUsd` でループ制御可能
- Mastra の代替として有力

### C. Mastra

- 独自フレームワーク（TypeScript）
- API 従量課金（サブスク使えない）
- Goals 機能で judge + maxRuns を設定
- プロダクトにループを組み込む場合向け

## やりたいループ（Issue 自動解決）

```
外側ループ（シェル or Agent SDK）
  ├─ Issue 選択（GitHub API）
  ├─ branch 切って実装（worktree）
  ├─ テスト書いて実行（Stop フック）
  ├─ reviewer エージェントにレビュー x N回
  ├─ PR 作成（gh CLI）
  └─ 次の Issue へ（新しいセッション）
```

cron で定期実行も可能。ただし:
- `permissionMode: "bypassPermissions"` が必要
- 並行実行防止（ロックファイル）
- レート制限に注意

## 回しっぱなしの代価

| リスク | 対策 |
|---|---|
| 検証の積み残し | 作業役とは別の評価役を入れる |
| 理解の劣化 | 定期的にアウトプットを読む |
| 判断の放棄 | 実行は任せても判断は手放さない |
| トークン暴走 | 予算・最大再試行回数の上限を決める |

## 参考

- 元記事: Qiita「入門から実践 - ループエンジニアリング」(@Syoitu, 2026/06/20)
- Addy Osmani のブログ
- Peter Steinberger（OpenClaw）
- Boris Cherny（Anthropic, Claude Code 責任者）
