---
title: orca
description: Orca (stablyai/orca) の機能調査まとめ。ソース/docs 読み + 実機ウォークスルー。herdr/cmux/t3-code との比較
# permalink:  # don't use
aliases:
  - orca
  - stablyai-orca
tags:
  - orca
  - coding-agent
  - gui
  - worktree
draft: false
date: 2026-11-03
---

# orca まとめ

関連: [[herdr-app]] [[herdr-gpui]] [[cmux]] [[t3-code]]

## 結論

- 正体 = 「Agent Development Environment」。1 タスク = 1 git worktree。worktree 毎に terminal + browser + diff が付く
- Electron 重い、でも許容範囲。コードは AI に書かせる前提なので Monaco 組み込みで困らない
- 強み = worktree ネイティブ、組み込みブラウザ(Grab/Annotate)、CLI(`orca`)で agent が操作、プラグイン
- 弱み = pane 配置が worktree 毎。worktree 横断の俯瞰なし。CLI で agent/chat タブの配置指定不可(ドラッグ必須)
- Agent Dashboard (kanban) は刺さらなかった。実験機能
- Computer Use は実機で動かず(下記)
- 計測してない。速度・メモリ評価は推測なし

## 正体

- OSS (MIT)。Stably 製 (YC)
- Electron 43 + React 19 + zustand
- terminal = node-pty + xterm.js (WebGL)
- エディタ/diff = Monaco (monaco-editor 0.55, DiffEditor)
- ブラウザ = Electron `<webview>` = Chromium

## worktree 中心モデル

- worktree 置き場 = `~/orca/workspaces/<repo>/`
- 起点 = origin/main がデフォルト
- agent から作ると親子関係が自動で付く。避けるなら `--no-parent`
- サイドバーに親子ツリー表示
- fan-out = 3 モデルに同じ課題 → 3 worktree 並列。比較しやすい
  - 落とし穴: プロンプトが既存 `notes/index.md` を上書きした。worktree 隔離なので無害。プロンプト側の不備
- pane レイアウトは worktree 毎。tmux 的に worktree 横断で同一タブに並べる機能なし

## 組み込みブラウザ

- worktree 毎に Chromium。ボタン: Grab / Annotate / Markup(ペン) / DevTools / 既定ブラウザで開く / cookie import
- プロファイル切替 = `orca tab profile`
- Grab = 要素情報を Markdown で agent に渡す
- Annotate = コメント付き。出力は Markdown。`**Intent:**` (fix | change | question | approve)、`**Selector:**`、`**Feedback:**`
  - Intent が agent への指示種別になる
- 位置づけ = web 開発で「ここ直して」を図で伝える機能。テキストサイトならコピペで足りる
- SNS 閲覧 = `orca tab create` + `orca snapshot` で X のツイート本文を agent が読めた
- ペン = スクリーンショットに書き込み

## Chat UI (native chat)

- Claude = `@anthropic-ai/claude-agent-sdk`
- Codex = `codex app-server`
- その他 = ACP (`<agent> acp`)
- Markdown: KaTeX、Mermaid(ストリーム完了後)、画像
- HTML = `::orca-visual{file="x.html"}` のみ(512 KiB 以下、1 メッセージ 8 個まで)。生 HTML はテキスト表示
- Office ビューアなし
- ファイルビューア = HTML(sandbox)、PDF、Mermaid .mmd、画像、CSV/TSV、ipynb(beta)、Markdown
- 制限: `orca terminal send` は PTY のみ。Chat ハンドルは `terminal_handle_stale`。既存 chat セッションへ CLI でプロンプト送信は不可
- 制限: `orca agent launch` に配置/分割オプションなし。`--split` は browser tab と `terminal split` のみ。chat タブはドラッグで配置

## CLI (`orca`)

- worktree、terminal、browser、agent 起動、automations、plugin を操作
- agent が自分で worktree 作成 / 別 agent 起動できる
- 配置系の操作だけ不足。issue 候補(未投稿)

## その他機能(docs 確認のみ・未試用含む)

- Agent Dashboard (実験、kanban) — 試用、微妙
- Agents feed、通知、使用量トラッキング
- hibernation (実験)、session history
- モバイルコンパニオン
- SSH worktree、Remote Orca Server (beta, Tailscale)
- Orchestration (実験)
- Scheduled automations (`orca automations create`)
- worktree checkpoints、skills registry

未試用: SSH worktree、Orchestration、automations、mobile、hibernation

## Computer Use

- `orca computer list-apps | get-app-state | click | set-value | type-text`
- macOS helper = `Orca Computer Use.app`。background 動作、tree diff
- 実機結果: `list-apps` は動く。`get-app-state` が `permission_denied` (Accessibility)
  - `orca computer permissions --json` は accessibility/screenshots とも `granted`。食い違い
  - システム設定で切替 + Orca 再起動でも直らず
  - 原因 = helper プロセス内 `AXIsProcessTrusted()` が false。TCC の許可が実際に動く helper の署名/パスと不一致の疑い(未検証)
  - エラー文は `orca computer permissions` を案内するが、それは granted 表示。案内が堂々巡り
- 結論: 今回は未成功。使い勝手は弱い

## プラグイン

- 種類 = theme / terminal-theme / icon-theme / syntax / language-pack / editor / panel / components / worker-panel / hook
  - 見た目系はコード不要・承認不要
- 言語 = TypeScript/TSX。独自言語なし
- 実行レベル 4 段階 = data / declarative / sandboxed-ui / trusted-worker。上げる毎に承認
- 承認 = ファイル内容に紐づく fingerprint。dev フォルダは編集で再承認不要。新権限・高レベル・コマンド変更で再承認
- capability = workspace:read / workspace:write / agent:read / agent:launch / terminal:send / terminal:read / notifications:show / storage:own / secrets:own / settings:own
  - `terminal:send` は trusted-worker のみ
- components の部品 約 40 個
  - レイアウト = Box Stack Row Grid Separator Tabs Collapsible Toolbar
  - 表示 = Text Heading Code Link Badge Card Markdown CodeView Image KeyValue RelativeTime Callout EmptyState Skeleton Spinner Progress
  - データ = Table Tree List
  - 入力 = Button IconButton Input Textarea Select Checkbox RadioGroup Switch Slider Field
  - 状態 = `atom` / `read` / `set` / `update` / `derived`
- グラフ部品なし。自由な HTML/CSS は panel (サンドボックス iframe) で
- 「Electron だから何でもできる」ではない。サンドボックスで host API 経由のみ
  - 公開 host API 例 = `workspace.readContext`、`agents.list`、storage、secrets、notifications、`shell.openExternal`、`files.saveAs`、`plugin.request`(worker 呼び出し)
  - 全 worktree 一覧 API なし。見えるのはフォーカス中 workspace のみ
- 試作 = フォーカス中 workspace の agent 一覧パネル(`agents.list` を 3 秒ポーリング、Table 表示)
  - 約 50 行 TSX、ビルド不要、保存で自動リロード。承認 2 回(最初の sandboxed-ui、capability 追加時)で動作
  - `orca plugin shot` で表示確認。claude が `working` / `done` で出た
  - 小バグ: `orca plugin create` で `orca-components.d.ts` の ENOENT (型定義書き出し失敗)。実行影響なし
- 未確認: iframe からの外部通信範囲、trusted-worker の権限範囲

## 比較(herdr / cmux / t3-code)

- herdr = gpui ネイティブ app。軽い。mods(JS)で拡張
- cmux = ネイティブ。pane/タブで CLI を並べる。Swift 系で拡張(記憶ベース、要再確認)
- t3-code = 構造化チャット UI。agent 自身が MCP で協業
- orca = Electron。worktree + ブラウザ + diff が一体。拡張は宣言的 TSX + 承認制
- 思想の違い
  - herdr/cmux = PTY を並べる。pane の俯瞰が強い
  - t3-code = チャット UI 中心
  - orca = worktree 単位の作業場。ブラウザ連携が最強。横断俯瞰は弱い

## 未整理・次

- SSH worktree (Windows ComfyUI 機)、Orchestration、automations を試す
- 試用 worktree 4 個 (orca-walkthrough, fanout-* 3 個) 未削除
- issue 候補: CLI から agent/chat タブの配置指定
