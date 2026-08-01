---
title: GitHub スタック型PR (gh stack)
description: 大きな変更を小さなPR列に分割して数珠つなぎにするGitHub公式機能
aliases:
  - stacked PR
  - gh-stack
tags:
  - github
  - git
  - cli
draft: false
date: 2026-08-01
---

## 何これ

2026-07-30 public preview 開始。GitHub公式のスタック型PR機能。

大きな変更 → 小さなPR列に分割 → 順番に積み上げ。各PRのdiff = 1つ下の層との差分だけ。

```
main
 └── PR1 (マイグレーション)
      └── PR2 (Repository実装)
           └── PR3 (APIエンドポイント)
```

## 手動数珠つなぎの辛さ（解決済み）

- PRのbase設定が面倒 → `gh stack submit` で自動
- descriptionに「3つのうち2番目」と手書き → UI上で可視化
- PR1修正 → PR2/PR3に手動rebase & force push → `gh stack sync` 1発

## インストール

```bash
gh extension install github/gh-stack

# AIエージェント用スキル（Claude Code等から自然言語操作）
gh skill install github/gh-stack
```

## 主要コマンド

```bash
gh stack init <branch>   # スタック起点作成
gh stack add <branch>    # 層追加
gh stack submit --auto   # 全PR一括作成（ドラフト）
gh stack sync            # fetch → rebase → push 全自動（神）
gh stack view            # スタック状態確認
```

## 制限

- 線形スタックのみ。木構造（1親→複数子PR）非サポート
- 木構造が必要なら Graphite（有料）
- Web UIは表示・マージのみ。作成はCLI必須

## 実運用

コマンド覚えるより `gh skill install github/gh-stack` → Claude Codeに「スタックPR作って」が楽。

