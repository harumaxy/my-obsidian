---
title: claude-code-skills-context-window
description: Claude Code のスキルがコンテキストウィンドウ・トークン消費に与える影響まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - claude-code
  - skills
  - context-window
draft: false
date: 2026-08-01
---

# Claude Code Skills とコンテキストウィンドウ

## スキルのロード方式

- スキル一覧（名前+1行説明）→ セッション開始時に system-reminder へ自動注入
- スキル本体（詳細内容）→ `Skill` ツール呼び出し時のみ展開。未使用 = ゼロ消費

## コンテキスト消費の実態

セッション開始前オーバーヘッドの内訳:
- system prompt / CLAUDE.md / MCP tool schemas / スキル一覧 / auto memory
- 重い設定だと初回プロンプト前に **62,000 tokens** 消費した例あり（1Mウィンドウの6.2%）
- コンテキスト60%超 → 出力品質が体感で落ちる

## グローバル vs ローカル

- `~/.claude/skills/` → 全プロジェクト共通
- `.claude/skills/` → プロジェクト固有

## スキル数の目安

- ~25個（現状）→ 問題なし
- 100個超 → 体感できる影響
- 1スキル ≈ 数十トークン（名前リスト分のみ）

## 推奨戦略

- 汎用・頻用スキル → グローバル
- プロジェクト固有スキル → ローカル
- 使ってないスキル → 削除
- CLAUDE.md は 300〜500行以内に抑える

## 参考

- [MindStudio: Claude Code Token Usage](https://www.mindstudio.ai/blog/how-to-manage-claude-code-token-usage)
- [spacecake: Context Window Performance Cliff](https://www.spacecake.ai/blog/claude-code-context-management/)
- [Superpowers plugin解説](https://www.builder.io/blog/claude-code-superpowers-plugin)
