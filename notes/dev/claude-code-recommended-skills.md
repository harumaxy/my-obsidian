---
title: Claude Code 定番スキル・プラグイン集
description: superpowers/mattpocock以外の定番Claude Codeスキル・プラグインまとめ
# permalink:  # don't use
aliases:
  - claude-code-skills
tags:
  - claude-code
  - ai
  - dev-tools
draft: false
date: 2026-08-01
---

# Claude Code 定番スキル・プラグイン

土台: `superpowers` + `mattpocock/skills` + `context7` で十分。追加は用途ドリブンで。

## 鉄板

### superpowers
- ブレインストーミング→計画→実装の構造化ワークフロー
- TDD、サブエージェント並列実行
- インストール: `claude plugins install superpowers`

### mattpocock/skills
- Real Engineers向け。Vibe Codingでなく本番開発フロー
- `/grill-me` `/tdd` `/wayfinder` `/code-review` 等41スキル
- 19万★超、GitHubトレンド1位経験あり
- インストール: `claude plugins install mattpocock-skills`

## ドキュメント系

### context7 (MCP)
- ライブラリの最新ドキュメントをリアルタイム取得
- 学習データ頼りでなく実際のdocsを参照 → 古い構文・廃止APIを避けられる
- 経験者が「最初に入れるやつ」として最多言及
- Next.js/Prisma/Tailwind等よく更新されるライブラリで特に有効
- インストール: MCP設定で `context7` サーバーを追加

## 開発効率系

### hookify
- hooks設定を `settings.json` 手書きせず対話式で管理
- チームでガードレール設定するときに便利

### backlog (plugin)
- セッション跨ぎの永続タスク管理（Claude Codeのタスクは会話内限定なので補完）
- 24個のMCPツール + スタンドアップ・ハンドオフ用スキル7本

### understand-anything
- コードベース全体を知識グラフ化
- 大規模リポジトリのオンボーディングや全体把握向け

## UI/ブラウザ系

### claude-in-chrome (MCP)
- Chrome自動操作。クリック・フォーム入力・スクリーンショット・コンソールログ読取
- フロントエンド開発のデバッグに有用

### ui-ux-pro-max
- フロントエンドデザイン特化
- 見た目がちゃんとしたUIを出す

## 注意

- スキル入れすぎ → コンテキスト汚染 → エージェント混乱（2026年多発パターン）
- "345スキル集"系の大型コレクションは玉石混交。用途ドリブンで選ぶ
- サプライチェーンリスク: スキルはエージェント行動を形成するファイル → レビュー・バージョン管理必要
