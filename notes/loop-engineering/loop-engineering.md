---
title: loop-engineering
description: AIコーディングエージェントを自律的に動かすオーケストレーションパターン
permalink:
aliases:
  - ループエンジニアリング
tags:
  - AI
  - Claude Code
  - coding-agent
draft: false
date: 2026-06-22
---

https://thenewstack.io/loop-engineering/

## ループエンジニアリングとは

人間が逐一プロンプトを打つ代わりに、スケジュール実行・隔離ワークスペース・検証エージェント・永続メモリを組み合わせて、コーディングエージェントを自律的に動かす設計パターン。

Claude Code の開発者 Boris Cherny が「もうプロンプトは書かない。ループを書き、ループが仕事をする」と発言したことで話題になり、Google の Addy Osmani がこのパターンに「loop engineering」と名前をつけた。

## 従来との違い

旋盤を操作する人 → 旋盤が載る生産ラインを設計する人、という比喩がわかりやすい。

- **prompt engineering**: モデルへの入力を最適化する
- **context engineering**: モデルに渡すコンテキストを設計する
- **harness engineering**: エージェントの実行環境を整備する
- **loop engineering**: エージェントの自律的なワークフロー全体を設計する

18ヶ月でこの4段階を経て進化してきた。

## ループの6つの構成要素

| 要素 | 役割 | Claude Code での実装 |
|---|---|---|
| **Automations** | スケジュール実行でタスクを発見・トリアージ | scheduled tasks, `/loop`, hooks, GitHub Actions |
| **Worktrees** | 並列エージェントの隔離 | `git worktree`, worktree isolation for subagents |
| **Skills** | プロジェクト固有の知識をコード化 | `SKILL.md` agent skills |
| **Connectors** | 外部ツールとの接続 | MCP servers, plugins |
| **Sub-agents** | 作る側とチェックする側の分離 | `.claude/agents/`, agent teams |
| **Memory** | 実行間の状態永続化 | `CLAUDE.md`, auto memory |

### Automations（自動化）

スケジュールに基づいてタスクを発見・トリアージする起点。例えば毎朝CIの失敗を検出して修正タスクを起動する、といった使い方。cron ジョブとの違いは、固定スクリプトではなくモデルが現在の状態を読んで次のアクションを選択する点。

### Worktrees（ワークツリー）

git worktree を使い、各エージェントが独立したブランチで作業する。メインブランチを壊さずに複数タスクを同時処理できる。

### Skills（スキル）

`SKILL.md` にプロジェクトの規約やパターンを記述し、エージェントがそれに従って動けるようにする。プロジェクト固有の知識の形式化。

### Connectors（コネクタ）

MCP サーバーやプラグインを通じて GitHub, Linear, Slack などの外部サービスとエージェントを連携させる。

### Sub-agents（サブエージェント）

最も重要な設計判断。コードを書くエージェントと検証するエージェントを分離する。モデルが自分の出力を採点すると甘くなるため、異なる指示を持つ第二のエージェントが失敗を検出する。

### Memory（メモリ）

`CLAUDE.md` や auto memory に学習内容や進捗を書き込み、次回の実行が前回の続きから再開できるようにする。

## 注意点

- **トークンコスト**: 無人で動くループはトークン消費が大きく変動する
- **無人運転のリスク**: 無人で動くループは無人でミスもする
- **理解負債 (comprehension debt)**: 自分が読んでいないコードが出荷される危険性。同じループでも、仕事を理解している人は加速し、理解を避ける人は負債を積む

## 出典

- [The New Stack - Loop Engineering](https://thenewstack.io/) (2026-06-10)
- Boris Cherny (Claude Code 開発者) の発言
- Addy Osmani (Google) の投稿
