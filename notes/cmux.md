---
title: cmux
description: cmux(macOS ネイティブ端末)の機能調査まとめ。実機で試した結果と tmux/herdr との比較
# permalink:  # don't use
aliases:
  - cmux
tags:
  - cmux
  - coding-agent
  - terminal
  - macos
draft: false
date: 2026-11-03
---

# cmux まとめ

関連: [[herdr-app]] [[herdr-gpui]]

## 結論

- agent 並列 + 1 ウィンドウ完結の macOS 専用作業机
- 端末の出来より、端末の外の機能が厚い
- 主力にするなら 1〜2 週間並行運用で安定性を見る

## 正体

- Swift / AppKit のネイティブアプリ。Electron ではない
- 端末コア = libghostty。GPL-3.0
- 階層 = Window ⊃ Workspace(サイドバー 1 行) ⊃ Pane(分割) ⊃ Surface(tab)
- Surface 種類 = 端末、ブラウザ、Markdown、iOS シミュ、agent session

## 機能と試した結果

- 通知リング = `cmux notify`、OSC 9/99/777。どの workspace が待ってるか見える
  - `--workspace` 指定は無視された。`--surface <UUID>` で当たる
- アプリ内ブラウザ = WKWebView。`cmux browser ...` で agent が操作
  - 試した = x.com 表示、スクロール、ツイート読み、いいね。全部動いた
  - Chrome cookie 取り込み = `--domain x.com` に絞って OK
  - 別 profile(`agent`)で独立ログインも可。パスワードは人間が入力
- iOS シミュ = `cmux new-pane --type simulator`
  - tap / swipe / type / accessibility が動く。E2E の足場になる
  - Enter 入力は送信されなかった
- Markdown viewer = フロントマターも認識
- Dock = 右サイドバーの surface 置き場。UI は描けない
- カスタムサイドバー = `~/.config/cmux/sidebars/*.js`。ホットリロード
  - import 不可、プロセス起動不可。Todo 程度まで
- `claude-teams` = tmux shim で teammate を分割 pane 起動
  - 3 pane 出たが起動失敗(Socket closed before reply)。原因不明
- cmux-cua = フォーカスを奪わない computer use
  - Accessibility と Screen Recording の許可は未付与
  - 録画は main display のみ。マルチディスプレイは弱い

## ブラウザ周り

- CDP なし。JS 注入 + ネイティブ入力合成。`isTrusted === true`
- agent-browser(Vercel)とは別物。コマンド体系を参考に Swift で一から実装
- 新しい `cmux browser repl` = Playwright 風。`[ref=eN]` の a11y snapshot
- snapshot = LLM 向けに加工した a11y ツリー。`read_page` と同系統
- リポジトリの `cmux-browser/` = Chromium 版。未リリース

## automation

- `~/.cmuxterm/automations.json`
- 構成 = `when`(event / category) → `where`(絞り込み) → `then`(action)
- action = `notify` / `rpc` / `run`(任意シェル) / `webhook`
- 無限ループ防止あり。`cmux automation test` で dry run
- イベント = agent.hook.*(Stop, Notification, UserPromptSubmit ほか)、feed.item.*、notification.*、workspace/window/pane/surface.*、browser.*
- `workspace.prompt.submitted` は機微。外部転送は明示同意が前提
- `cmux events` でライブ観測。ログは `~/.cmuxterm/events.jsonl`
- `agent.needs_input` はドキュメント例のみ。実在未確認

## 拡張性

- UI を足す = 弱い。サイドバー 1 枚の制限付き JS だけ
- 外から操作する = 強い。CLI / ソケット / events / automation / `cmux.json`
- herdr の mods(exec, fetch, 窓、端末埋め込み)のほうが UI 自由度は高い
- 二段構え = 普段は外から拡張、足りなければフォーク
- フォーク = 上限は Swift が最高。手軽さは Electron が上。維持コストは重い

## 比較

- tmux = 永続性、SSH、どこでも動く。cmux は GUI、ブラウザ、通知で勝つ。層が違う
- herdr-app = シンプル、worktree が堅い。cmux は組み込みブラウザ、シミュ、automation で先
- herdr-gpui = 差分レビュー、ファイル閲覧、Teleport、使用量表示は向こうが上
- 向き = 調べ物と実装を 1 窓で回す、通知、シミュ確認
- herdr-gpui 向き = 複数 worktree で並列、差分で 1 つに絞る
- tmux 向き = リモート、常駐

## 良い点

- ブラウザ統合の完成度が突出(往復が消える)
- agent 前提の設計(通知、automation、全操作 CLI)
- サーフェスの種類が多い
- ネイティブで軽い

## 悪い点

- 安定性が荒い(teams 失敗、profile 削除エラー、Dock の空 pane)
- 機能が広すぎて焦点がぼやける
- macOS 専用
- cmux-cua は未成熟
- セッション永続性は tmux に劣る
- ブラウザは WebKit のみ。CDP 前提ツールは不可

## 未解決・残り

- `agent` browser profile の削除エラー
- Dock の空 pane
- iPhone 16 シミュが Booted のまま(`xcrun simctl shutdown`)
- teams の起動失敗の原因

## アイデア(未着手)

- 埋め込み = Chrome は CEF で可能(`cmux-browser/` が着手済み)
  - Godot はウィンドウ丸ごと不可(macOS)。ミラー、ライブラリ化、共有メモリ描画のどれか
- ゲーム開発 = 左に agent、右にプレビュー。まずは別窓 + 通知で足りる
- design-mode の Godot 版 = ゲーム内 autoload が `Control` をクリック選択 → ノードパス + プロパティを JSON 出力 → cmux 側で拾って agent へ
  - `.tscn` はテキストなので agent が直接編集できる
- Slack 監視 = `agent.hook.Stop` を起点にメタ情報だけ送る。本文は送らない

## 評判・採用傾向(2026-11-03 調査)

- 母数小さい。Reddit の実スレッドは見つからず。HN、Product Hunt、個人ブログ、X 3 件が根拠
- 比較記事は競合運営が書いたものが多い。割り引く

### X の 3 件

- mizchi = cmux は Orca か自作へ移行予定。自宅ゲーミング PC を codex のリモートにして Mac の発熱を抑制
- りょうま = cmux → Orca で Mac が軽くなった。神機能 = スマホリモート、worktree 並列、複数モデル/アカウント切替、UI/UX
- 名人 = 変遷 cmux → herdr → orca → t3 code。合間に公式 App 期が入る
- 乗り換え組というより、渡り歩く層の発言

### cmux

- HN Show HN で好評。最高 #2(公式の主張)。Hashimoto も共有
- 好評 = 縦タブ、libghostty、ブラウザ、CLI/ソケット API。Electron 系より軽い
- 要望 = リモート/SSH、ペインズーム、キー設定、worktree 連携
- 批判 = 初期の不安定さ、エディタ追加への警戒、macOS 専用でリモート不可
- HN 直近で「macOS 専用とリモート不可」を理由に離脱した声あり
- ライセンス表記ゆれ = Show HN は AGPL、手元のリポジトリは GPL-3.0。どちらが現行か未確認
- 月 30 ドルの有料プランの書き込みあり。内容未確認

### Orca

- Product Hunt 5.0(2 件のみ)。販促色あり
- 「cmux から移って出力 3 倍」= 本人いわく主因は権限設定。Orca は `--dangerously-skip-permissions` が既定。ツールの差ではなく設定の差
- 作業モデル = Orca はタスク/worktree 単位。cmux はセッション単位
- note ブログでは Orca のほうが重いとの報告。りょうまの「軽い」と逆。環境差か時期差か不明
- 欠点 = スクロール遅延、表示乱れ、SSH 入力、1 worktree 1 リポジトリ、内蔵エディタに LSP なし、リモート未成熟、更新が速く安定性にムラ
- 疑問 = worktree 大量時のディスク(`node_modules`)。回答なし
- MIT。macOS / Windows / Linux 対応

### herdr

- HN に専用スレッドなし。関連スレッドで「今のところ良い」
- 弱点 = ペイン移動/並べ替え不可(次回対応と開発者)。既定 `ctrl-b` が不評でキー見直し
- heise が tmux 競合として紹介。ターミナル内で動き、永続化、SSH 先でも可
- cmux が弱いリモートを押さえる

### T3 Code

- 好評 = worktree、差分レビュー、ワンクリック PR
- 批判 = 初期バグ、Claude Code の皮という見方、エディタ代替にならない、TUI の細部が隠れる
- 古い批判は解消済みの可能性

### 読み取り

- 分かれ目 = リモート対応。mizchi の自宅 PC リモート、りょうまのスマホリモートも同方向
- cmux = 端末側。Orca = worktree/タスク側。乗り換えより用途の移動
- 「軽い」評価は割れる
- ツール寿命が短い。決定版なし(「whiplash」)
- HN で一番求められる = agent 向け CLI。ここは cmux の強み
- 次に Orca を見るとき = リモートの仕組み、ディスク消費、実負荷、権限の既定値
