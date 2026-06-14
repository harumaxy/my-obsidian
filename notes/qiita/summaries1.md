---
title: AWSの新しいAIエージェント搭載IDE「Kiro」のSpecモードを使用して開発する
description: Qiita記事の要約
permalink:
aliases:
  -
tags:
  - AWS
  - IDE
  - Claude
  - AIエージェント
  - Kiro
draft: false
date: 2026-06-13
---

# Kiro 概要

2025年7月14日にAWSがパブリックプレビューとして公開したAIエージェント搭載IDE。VSCodeのフォーク。

## 主な機能

### Steeringファイル
プロジェクト開始時に自動生成される3つのドキュメント：
- `product.md` — 製品概要・機能
- `structure.md` — アーキテクチャ・フォルダ構成
- `tech.md` — 使用技術スタック

### 2つのモード

**Vibeモード**
- Cline / Claude Code のような自由なVibe Coding
- Claude Sonnet 4.0 使用

**Specモード（Kiroの売り）**
仕様駆動開発を体現する中核機能。以下のフローで進める：

1. **要件定義** → `requirements.md` 自動生成
2. **設計** → `design.md`（TypeScriptインターフェース、UXフローなど）
3. **実装計画** → `tasks.md`（タスクリスト）
4. **タスク実行** → タスク単位でコード生成（Start Task ボタン）

### その他
- **Agent Hooks** — ファイル保存などのイベントで自動化処理をトリガー
- **MCPサーバ**との統合
- パブリックプレビュー期間中は**無料**

## 所感

### KiroがVSCodeをフォークした理由
GUIにワークフローを焼き込むことで：
- 開発プロセスをスキップできない構造にする
- 非エンジニア・AIコーディング初心者が迷わず使える
- チーム・企業向けにガバナンスが効く開発フローを提供

ターゲットは個人上級者ではなく、**チーム・組織への普及**。

### CLI + Agent Skillとの比較

| | Kiro | Claude Code + Skills |
|---|---|---|
| 対象 | チーム・組織・初心者 | 個人・上級者 |
| プロセス強制 | GUIで強制 | スキルは任意呼び出し |
| カスタマイズ性 | 低い | 高い |
| エディタの自由 | VSCodeフォーク固定 | 何でも使える |

Superpowers skillsを使えば同等フローは再現可能：
- `brainstorming` → 要件定義
- `writing-plans` → 設計
- `executing-plans` → タスク実行

### エディタの自由
Zed / Vim / Emacs 使いには「そのためだけにVSCodeフォークを入れるか？」という問題がある。
CLI系ツール（Claude Code等）は「エディタは好きなものを使い、AIはターミナルで走らせる」という関心の分離が保たれている点が強み。
