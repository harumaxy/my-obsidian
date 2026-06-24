---
title: gtr
description: Git Worktree Runner - 複数のブランチを並行して作業
aliases:
  - git-worktree-runner
tags:
  - git
  - cli
  - tool
draft: false
date: 2026-06-23
---

# gtr - Git Worktree Runner

複数のブランチを同時にチェックアウトして作業できるツール
原理的にはコピーを作る。
gitignore された開発ファイルもコピー可能

## 基本コマンド

### セットアップ

#### グローバル設定（初回のみ）

```bash
# AIツール・エディタを設定（グローバル）
git gtr config set gtr.editor.default cursor --global
git gtr config set gtr.ai.default claude --global
```

#### プロジェクトレベル設定
--global を付けないとローカルスコープ。 .gtrconfig ファイルに記録

```bash
git gtr config set gtr.editor.default vscode
git gtr config list
```

### ワークツリー作成・管理

```bash
git gtr new my-feature
git gtr new my-feature --editor
git gtr new my-feature --ai
git gtr new my-feature -e -a

git gtr list
git gtr rm my-feature
```

### エディタ・AI ツールで開く

```bash
git gtr editor my-feature
git gtr ai my-feature
```

### その他

```bash
git gtr run my-feature npm test  # コマンド実行
git gtr go my-feature # パス取得
# マージされたワークツリーをクリーンアップ
git gtr clean --merged
```

## シェル統合

```bash
# Fish に追加
set -l _gtr_init (test -n "$XDG_CACHE_HOME" && echo $XDG_CACHE_HOME || echo $HOME/.cache)/gtr/init-gtr.fish
test -f "$_gtr_init"; or git gtr init fish >/dev/null 2>&1
source "$_gtr_init" 2>/dev/null
```

これで以下が使える：

```bash
gtr new my-feature --cd  # 作成して移動
gtr cd my-feature       # ワークツリーに移動
```

## .gtrconfig - チーム設定

リポジトリルートに `.gtrconfig` を配置してチーム設定を共有

```toml
[copy]
    include = **/.env.example
    exclude = **/.env
    includeDirs = node_modules

[hooks]
    postCreate = npm install

[defaults]
    editor = cursor
    ai = claude
```

### 設定項目

- `copy.include` - コピーするファイルパターン
- `copy.exclude` - コピーを除外するパターン
- `hooks.postCreate` - ワークツリー作成後に実行するコマンド
- `hooks.postCd` - シェル統合で移動後に実行するコマンド
- `defaults.editor` - デフォルトエディタ
- `defaults.ai` - デフォルト AI ツール

### 信頼とセキュリティ

`.gtrconfig` で定義されたコマンドは最初に承認が必要：

```bash
git gtr trust  # .gtrconfig を確認して承認
```

ローカルの `git config`（`.git/config`）は常に信頼される

## メリット・ユースケース

### コンテキストスイッチの削減
通常は `git stash` → ブランチ切り替え → `git pop` を繰り返すが、gtr なら別フォルダで並行作業できる

### 並行テスト実行
main ブランチのテストを別フォルダで走らせながら、開発フォルダで新機能実装を継続

### AI エージェントの並行実行
複数の `gtr new --ai` で異なるブランチ上で複数のエージェント（Claude Code など）を同時実行
- ドキュメント作成と実装を同時進行
- 複数の機能を並行開発

### PR レビューの非侵襲的実施
現在の開発を中断せず、別フォルダで PR をチェックアウトしてレビュー

### 環境ファイルの安全な管理
`.gtrconfig` で `.env.example` だけコピー対象にしつつ、各ワークツリーで環境固有設定を独立管理
