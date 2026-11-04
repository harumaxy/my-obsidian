---
title: herdr-gpui
description: Herdr 本家と非公式 GUI (herdr-gpui) の違い、構成、使い方、状態検知の仕組みを実機で調べたメモ
# permalink:  # don't use
aliases:
  - herdr
  - Herdr UI
tags:
  - tool
  - coding-agent
  - terminal
draft: false
date: 2026-11-03
---

# herdr / herdr-gpui

コーディングエージェント (Claude Code, Codex 等) 複数並列で動かす管理ツール。
エディタ置き換えじゃない。エージェント監督する場所。

## 登場人物 (名前紛らわしい)

- `herdr` (TUI 版デーモン)
    - herdr.dev 本家。`~/.local/bin/herdr`。`herdr server` が常駐。端末とセッション持つ。
    - 入れ方: `curl -fsSL https://herdr.dev/install.sh | sh` か `brew install herdr`
- `herdr-core` (`hc`)
    - 本家公式デスクトップアプリ (`herdr-app`) 用の別デーモン。TUI 版と別物。
    - herdr.dev トップのコマンド (`releases.herdr.dev/app/install.sh`) で一緒に入る
- `herdr-app`
    - 本家公式デスクトップアプリ。`~/Applications/Herdr.app`。機能少なめ。2026-10-31 時点
- herdr-gpui (herdrui.dev)
    - 非公式。作者 Fabien Penso (`penso/herdr-gpui`)。Apache-2.0。
    - TUI 版デーモンの GUI クライアント。デーモン入れも更新もしない。
    - 入れ方: `brew install penso/tap/herdr-gpui` → `/Applications/Herdr.app`

落とし穴:

- 公式アプリも gpui も表示名 `Herdr`、アイコンもそっくり。Raycast で区別つかない → Raycast で alias 付けるのがよい
- gpui 起動して "Herdr must be installed" 出たら `herdr` (TUI 版) 未インストール。入れて Terminal > Reconnect
- 公式アプリ入れても gpui に必要な `herdr` は入らない
- issue で名前・アイコン批判は検索した範囲で見つからず (調べきれてはない)

## 結論: gpui のほうが高機能

公式アプリ: space / tab / pane、エージェント状態サイドバー、SSH マシン、JS mod。
gpui だけにあるもの:

- worktree 管理、fan-out (同じプロンプト複数エージェントに投げて比較)
- Teleport (worktree を別 SSH ホストへ丸ごと移動)
- Review Changes (差分レビュー、行にメモ → Send to agent)
- ブラウザタブ + 注釈 (HTML 草案にメモ付けて返す)
- PR / Issues / Security (Dependabot) 一覧、Automations、Usage (Claude/Codex 残り枠)
- Windows ARM64, macOS Intel, WSL 対応

懸念: 個人プロジェクト、デーモンのプロトコルが変わると追従待ち。乗り換えコストは低い (デーモン共通)。

## 何が嬉しいか (VSCode / Zed との違い)

- 常駐: 端末の実体はデーモン。ウィンドウ閉じても更新してもエージェント動き続ける
- 状態一覧: Working / Blocked / Done / Idle をサイドバーで一覧。タブ巡回不要
- SSH 先のエージェントも同じ一覧
- 1 エージェントだけなら旨味薄い。複数並列で効く

## 技術スタック (gpui)

- 全部 Rust。Cargo workspace 27 crate、約 67 万行。`unsafe` / `unwrap` は lint で禁止
- UI: GPUI (Zed と同じ GPU 描画)。Electron じゃない
- デーモンとは Unix ソケット + bincode フレーム
- ブラウザタブ: wry (WKWebView / WebView2)。Linux 未対応
- Git: gix (git コマンド起動しない)。差分色: syntect。自動化: mlua (Luau)
- iOS 補助アプリ (Swift) も同梱

## 状態検知の仕組み (Claude Code)

調べたら予想と違った。ファイル監視じゃない。

- プロセス名でエージェント識別 (`claude` / `claude-code`)
- ペイン下端の画面テキストをパターン照合 (`detect/manifests/claude.toml`)
- working の主権威は PTY 出力活動
- Claude の hook は SessionStart だけ (session_id 報告用)。旧 hook は削除対象に
- 手元 `~/.claude/settings.json` に herdr の hook は入ってない。hook なしでも動く
- 粒度は working / blocked / idle。thinking と tool 実行の区別なし
- `herdr-core` 側は OSC 7501 でエージェント自己申告。TUI 版 src には出てこない

## 画面の見方 (gpui)

左アイコンバー上から: ターミナル / Overview / Pull requests / Issues / Security / Automations / Usage、一番下が設定。

- サイドバー: Spaces (ワークスペース)、Agents (状態ドット)、最下部 All Devices
- メニューバー File: New Workspace ⇧⌘N, New Worktree ⌘N, New Tab ⌘T, Go To ⌘P
- メニューバー Terminal: 分割 ⌘D / ⇧⌘D, Pane Zoom ⇧⌘E, Find ⌘F, Copy Mode ⇧⌘C, Toggle Sidebar ⌘B, Reconnect
- フッター: Claude / Codex 使用量、CPU / MEM、Theme、Shortcuts、Report issue
- 右上アイコン (鉛筆、分割、Git ブランチ、GitHub) の役割は未確認

## 最初に試す流れ

1. ワークスペース作る (`new`)
2. 端末で `claude` 起動 → Agents に状態ドット出る
3. 変更させて Review Changes → 行メモ → Send to agent
4. worktree / fan-out / Teleport / SSH は後から

## 自動インストールされるスキル

gpui 初回ダイアログで Install すると `~/.claude/skills` に入る:

- `herdr-gpui-browser`: ブラウザタブ表示、注釈、PR/CI、クラウドマシン操作など広範囲
- `herdr-automations`: Luau スクリプトで定期実行。承認はユーザーのみ
- どちらも Herdr UI が自動更新し続ける。中身が将来変わる点に注意
- Herdr のペイン内 (`HERDR_ENV=1`) のエージェントだけ対象
- 破壊的操作はアプリ側ダイアログでユーザー確認が入る設計

## 公式アプリの削除メモ

間違って公式アプリ入れた場合:

- `~/Applications/Herdr.app` と `~/.local/bin/herdr-app` 削除
- 不要なら `herdr-core`, `hc`, `~/.config/herdr-app`, `~/.config/herdr-core` も削除
- `/Applications/Herdr.app` (gpui) と `~/.config/herdr` (TUI 版) は消さない
- 削除後も gpui は問題なく動作

## 参考

- https://herdr.dev/
- https://herdrui.dev/
- https://github.com/herdrdev/herdr (TUI 版デーモン)
- https://github.com/herdrdev/herdr-app
- https://github.com/herdrdev/herdr-core
- https://github.com/penso/herdr-gpui
