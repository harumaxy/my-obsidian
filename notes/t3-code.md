---
title: t3-code
description: T3 Code の機能調査まとめ。ソース/docs 読み + 実機確認。herdr/cmux との比較
# permalink:  # don't use
aliases:
  - t3-code
  - t3code
tags:
  - t3-code
  - coding-agent
  - gui
  - mcp
draft: false
date: 2026-11-03
---

# t3-code まとめ

関連: [[herdr-app]] [[herdr-gpui]] [[cmux]]

## 結論

- 端末の置き換えじゃない。agent の「制御盤」。Claude Desktop の Code タブ + マルチベンダー + リモート + agent 間連携
- herdr/cmux = PTY で CLI を並べる。T3 Code = 構造化イベントをチャット UI で描く
- 協業は agent 自身が MCP で行う。人間が pane を並べるのではない
- pane 分割の自由度は低い。画面の俯瞰は herdr/cmux のほうが上
- 計測してない。速度、メモリの評価は推測

## 正体

- リポジトリ `pingdotgg/t3code`。MIT。TypeScript。Effect-TS。サイト t3.codes
- 構成 = apps(server / web / desktop(Electron) / mobile) + packages(provider-*, source-control-*)
- 実体は server。常駐 Node が agent を起動。web/desktop/mobile は WebSocket で繋ぐだけ
- FAQ = 「harness じゃない」。Claude Agent SDK、Codex App Server の上の画面。契約もログインも既存のまま。無料
- provider = Claude, Codex, Cursor, Grok Build, OpenCode, Antigravity, Pi, Muse, Kiro, fx。ACP Registry も可
- 導入 = `curl -fsSL https://t3.codes/install.sh | sh` / `brew install --cask t3-code` / `npx t3@latest`

## 画面と用語

- project ⊃ thread。thread = 1 agent の作業単位
- thread は worktree を持てる(New worktree)。branch は自動命名 `t3/<8桁hex>`
- サイドバー = フラット。1 行 = project 名、時刻、タイトル、branch(worktree はフォルダ+Git アイコン)、provider アイコン
- 区画 = Pinned / Active / Working(折りたたみ) / Snoozed / Settled
- Labs の Boring sidebar = project 別フォルダ表示。worktree 単位の入れ子は無い
- 右パネル = タブ式。diff / files / file / terminal / preview(ブラウザ) / device / PR / side-chat
- 状態管理 = pin / settle / snooze / archive。3 日で自動 settle。PR マージで settle

## Composer(入力欄)

- Markdown がそのまま届く。大きい貼り付けは自動で添付
- 送信中の追加 = Queue か Steer
- Prompt stash = `Cmd+S` で退避、空欄でもう一度 `Cmd+S` で復元。便利。他ツールにも欲しい
- Recall = 空欄で `↑`。送信済みを呼び戻す。テキストのみ
- Edit from here = 過去のプロンプトまで巻き戻し
  - Revert and keep changes / Revert files too
  - ファイル復元は worktree thread のみ。main 直の thread は会話だけ
- thread 参照 = サイドバーの thread をドロップ、`@` + タイトル、Copy thread
  - 参照だけ載る。agent が必要時に履歴を読む。long thread でもコスト 0
  - provider 非依存。Claude の thread を Codex が読む、もあり得る(実証なし)
  - 別マシンの thread は書き起こしファイルの添付になる
- Side chat = `/side` `/btw`。thread を止めず質問。Bring back で持ち帰り
- Quote = 返答を選んで Cite in composer

## agent から使える API(MCP)

- server が `http://127.0.0.1:<port>/mcp`(キー `t3-code`)を持つ
- T3 が起動した agent には自動注入。トークンは thread/session 単位
- 道具 = project、thread、worktree、PR、schedule、preview、device、html_render
- `delegate_task` = 別 provider の子 agent を起動。親の履歴は渡さない。指示文のみ
- 外部 agent も使える。`claude mcp add --transport http t3 <URL>` + `claude mcp login t3`
  - URL = Settings → Environments → Copy MCP URL
  - 承認 = pairing code。既定 Read only。OAuth 必須。`https` か `localhost` のみ
- ホスト上なら `t3 thread start/send/show/list`。署名不要
  - `--wait` の終了コード = 失敗 1、回答待ち 2。`--json`
- できない = 画面操作。diff やファイルのタブを開く道具が無い。リンクを出すだけ
- 試した = clone して読む、図を出す、ブラウザを開く、別 thread を読む。全部通った

## terminal と分割

- terminal あり。`mod+j` で開閉。履歴 5000 行 / 8MiB
- 分割 = 横/縦。ただし方向は 1 つだけ(`splitDirection`)。入れ子不可
  - 実機確認。横分割後に縦分割 → 全体が縦並びになる
  - 「2 分割 → 右を縦 2 分割」はできない
- tmux のような自由度なし
- 複数 thread を並べて同時表示する機能も無い

## ブラウザタブ

- backend = Chromium 系。2 経路
  - server 側 = Playwright(`playwright-core` 1.60)で headless Chrome。初回に約 120MB。Visual replies も同じ
  - desktop 側 = Electron(Chromium)
- UA を通常の `Chrome/<major>.0.0.0` に書き換える。Bot 判定回避の意図
- フローティング表示 = サイズ固定に見えた。サイドパネルで開くと幅追従(レスポンシブ確認可)
  - 既定は自動でフローティング(`DEFAULT_BROWSER_AUTO_SHOW_FLOATING_PREVIEW`)
- viewport = fill / freeform / preset(Pixel 8 など)。ズームは Chromium と同じ刻み
- Chrome 拡張 = 使える記述なし。代わりに Cookie の一度きり取り込み(Settings → Browser)
- PDF = 右パネルのブラウザタブで開く。Chromium 標準の PDF ビューア。日本語 OK
- HTML = ファイルタブ。rendered / source 切替。サンドボックス
- WebKit(cmux) = 軽い。Chromium = 互換性と CDP 制御で有利。性能差は未計測

## Device タブ

- iOS Simulator / Android Emulator を右パネルに表示。人間も触れる
- 設定 = Settings → Integrations → Devices の Use devices と Agent device access
  - 反映は次の agent session。既存 thread には効かない。新規 thread が要る
- agent は `device_*` ツールと `agent-device` CLI で操作
- 別 thread で実機確認(結果は読んだだけ)
  - iOS = 開いて操作 OK。`device_screenshot` は起動直後に 3 回失敗
  - Android = Command-line Tools 導入後に認識。接続待ちが長い。ANR ダイアログ
  - Chrome 起動 → 検索 → 成功。snapshot 1 回 約 10 秒
  - 電源断 = `device_close` の `shutdown=true` はパネルを先に閉じると効かない
- 用途 = モバイル開発の確認・E2E。my-obsidian では出番なし
- 価値 = 操作能力でなく「見える・触れる・設定不要」の統合

## Visual replies

- agent が HTML で図・表を返す。thread 内に表示
- テーマの CSS 変数に追従。ダーク/ライト切替 OK
- サンドボックス。スクリプトは動くが T3 本体とは隔離
- 出す前に内蔵 headless Chrome でスクショ確認

## 設定と project

- 階層 = 組み込み既定 → t3.json → 環境 → project 上書き。層アイコンで出どころを確認
- project 設定 = Name / Icon / Pin / Archive / New threads(Model, Workspace) / Actions / Danger
- Workspace を New worktree にすると、thread ごとに worktree + branch
- Actions = project の command。`t3.json` の `runOnWorktreeCreate` と `runOnSettle`
- worktree 置き場 = T3 home の `worktrees`(`~/.t3/worktrees/<project>/<branch>`)
- Settings → Worktrees = 場所、自動クリーンアップ、branch 命名、submodule

## remote / mobile / 共有

- `npx t3 up` でホスト化。T3 Connect(cloudflared、無料 3 台) / LAN / Tailscale
- iOS / Android アプリ。通知 = 完了、失敗、承認待ち、質問。Live Activity
- Guest links(beta) = アカウント無しで 1 thread を閲覧。ゲストの送信はホスト承認待ち
- Managed policy = 管理者がモードと provider を制限

## ソース管理

- GitHub, GitLab, Forgejo/Gitea, Bitbucket, Azure DevOps, GitCafe
- Diff = ターン単位。Commits ビュー(最新 100 件)
- PR を thread に紐付け。PR マージで thread が自動 settle

## 比較

- herdr = 軽い。端末の延長。状態は画面推測。複数 agent の俯瞰は向こうが直感的
- cmux = macOS ネイティブ。通知リング、ブラウザ(WebKit)、シミュ一体。構造化イベントは無い
- Claude Desktop/Code = 単一ベンダー。機能追従が最速。マルチベンダーとリモート共有は弱い
- T3 Code = provider を選ばず、成果物(差分、PR、ブラウザ、device)を 1 画面で確認
- 向き = 複数 provider 併用、thread 並行、スマホ/リモート、モバイル開発の確認
- 合わない = 端末中心、画面を自由に分割したい

## 良い点

- 構造化イベント。状態判定が正確
- agent が使える API(MCP)が厚い。delegate_task が独自
- Composer の作り込み(stash, Recall, Edit from here, thread 参照)
- ブラウザと device を agent と人間が共有
- リモートとモバイルが標準
- MIT。既存サブスクをそのまま使う

## 悪い点

- 分割の自由度が低い。thread 並列表示なし
- 画面を agent から操作できない(タブを開く道具なし)
- Chrome 拡張なし
- Claude を Agent SDK 経由で使うと 5 時間枠の消費が速い(FAQ。Anthropic 側のバグと明記)
- device は重い。screenshot 失敗、ANR、接続待ち
- beta / Labs が散在。設定の階層が複雑

## agent との相性

- 良い = 操作対象が型付き API。自動化、外部呼び出し向き(`t3 thread --wait`)
- 悪い = UI 状態は動かせない。見せたいものはリンクに頼る
- 実感 = 調査、図示、ブラウザ、thread 読み取りはほぼ滞りなし。device は設定反映待ちで新規 thread が必要

## 未確認・残り

- 速度、メモリ(計測なし)
- Chrome 拡張を Electron 側で隠し実装している可能性
- provider をまたぐ thread 参照の実証
- 触ってない機能 = Goals、Commands and skills、チェックポイントの詳細、スケジュールタスク、Linked environments、MCP apps、Usage、SnapShot、Guest links、Default browser、Prompt links
- 左カードの Changes `+10,036 −2` の正体

## 試すなら

- Side chat、Edit from here(worktree thread)、スケジュールタスク、Goals
- my-obsidian = ノート中心。device は不要。Composer まわりが主な価値
