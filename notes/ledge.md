---
title: Ledge 要約
description: コードブロックをその場で実行できる Markdown ノートアプリ。機能、注意点、導入見送りの判断
aliases:
  - ledge
tags:
  - tool
  - markdown
  - note
  - runbook
draft: false
date: 2026-11-09
---

Ledge。コードブロックをその場で実行できる、開発者・DevOps 向けの Markdown ノートアプリ。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- 公式: https://ledge.sh/
- repo: https://github.com/ledgesh/ledge (ソースは未読、README とサイトのみ)
- 作者: Dan Stevens (LICENSE の記載から)。
- Apache-2.0。無料、アカウント不要と書いてある。有料プランの記載は見当たらない。
- 星 355、コミット 374、Issues 2。小規模で新しい。リポジトリの説明文は空。
- 土台: Electrobun (Bun プロセス + システム WebView 上の React + CodeMirror)。

## 機能

- コードブロックで ⌘↩ → 直下に出力がストリーミング表示。⇧⌘↩ はノートごとのターミナルに送る。
- 実行できるもの: Python、Node、Ruby、PHP、TypeScript (同梱の Bun)、`sh` / `bash` / `zsh`、`redis` (redis-cli に渡す)。
- SQL は既定の設定なし。`psql "$DATABASE_URL" -f` のような実行コマンドを、自分で設定に足す。mysql、sqlite3、duckdb も同様。
- `prompt` ブロック: 既定で `claude -p` にテキストを送り、返答を表示。デイリーノートのテンプレートで毎朝の要約にも使える。
- ノートは普通の `.md` ファイル。frontmatter で `cwd`、`env`、`host`、`confirm` などを指定。
- Obsidian 風: `[[wikilink]]`、バックリンク、タグ、全文検索、デイリーノート、ペイン分割、ライブプレビュー。
- `ledge` CLI あり。`ledge run` で CI からも実行できる。
- MCP サーバー同梱: `claude mcp add ledge -- ledge mcp` で、ノートの読み、書き、検索、作成、編集。削除はできない。ロック済みノートの本文は返さない。

## 仕組みと注意点

- **永続カーネルなし**。シェルのブロックは、ノートごとに 1 つの永続シェル。Python、Node は実行のたびに新プロセスで、変数は残らない。
- **サンドボックスなし**。ブロックは自分の権限で動く。`confirm` による実行前確認は、サイト自身が「a speedbump, not a lock」と書いている。他人のノートの実行は危険。
- `host:` を書くと、そのブロックが SSH 経由で別マシンで動く。サーバー型の構成もあり、スマホはサーバーへの窓になる。
- サーバー導入は `curl -fsSL https://ledge.sh/server.sh | sh`。使う前にスクリプトを確認する。
- 対応: macOS (Apple Silicon、13 以降)、Linux (x64 / arm64)、Windows 11 (WSL 必須)、iOS、Android (ベータ)。

## 実行付き Markdown vs スクリプト + コメント

- 基本はスクリプト + コメント。実行付き Markdown は、人が 1 ステップずつ判断しながら進める手順に限る。
- スクリプトが向く: 毎回通しで実行、CI や cron から呼ぶ、テストや lint やレビューの対象にしたい、分岐やエラー処理が複雑。
- 実行付き Markdown が向く: 障害調査、運用手順書 (runbook)、データ探索。各コマンドの出力をその場でノートに残したい。説明が主でコードが従。
- 実行付き Markdown の弱点: 状態の扱いが弱い、通し実行が前提でない、説明とコードの乖離、安全性、対応アプリへの依存。
- 折衷: 実体はスクリプトにして、Markdown からは呼ぶか説明だけを書く。

## 導入判断: 見送り

- ターミナル作業が多く、md のコードブロックを **ターミナルにコピペして実行すれば足りる**。専用アプリで実行する利点がほぼ無い。
- 専用アプリとサーバー側の設定が増える分、依存ツールが増えるだけで損。
- このリポジトリの運用 (エディタで md を書き、Quartz で閲覧) とも別物。
- 再検討する条件: ノートのコマンドを繰り返し動かし直す手間が痛くなったとき。

## 未確認

- ソース、価格ページ、Changelog、「Agents and Ledge」の章は未読。実際には動かしていない。
- 「Free」の範囲 (有料機能の有無) は未確認。
