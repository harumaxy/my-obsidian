---
title: herdr-app
description: Herdr 本家デスクトップアプリ(herdr-app)の設定・mods・gpui との比較まとめ
# permalink:  # don't use
aliases:
  - herdr-app
tags:
  - herdr
  - coding-agent
  - terminal
  - mods
draft: false
date: 2026-11-02
---

# herdr-app まとめ

[[herdr-gpui]] と比べて使った記録。結論: 本家 herdr-app を主力にする。

## 結論

- シンプル。困らない。足りないものは mods で足す
- 端末コア = libghostty(Ghostty)。gpui は alacritty_terminal
- `░▒▓` 描画 = 本家は図形(透明度 25/50/75%)、gpui はフォント任せ。本家のほうがなめらか
- Ghostty 系は macOS で評判が良い
- gpui のほうが強いところ = 差分レビュー、ファイル閲覧、ブラウザ tab、Teleport、Automations。最初から入ってる

## 用語

- space = 1 マシン 1 リポジトリが普通。サイドバー 1 行
- tab = space 内の画面
- pane = tab を分割した 1 区画。端末か mod パネル
- 階層は space ⊃ tab ⊃ pane
- 閉じると、ウィンドウは端末を残す。pane/tab を閉じると端末も終わる

## 設定の場所

- `~/.config/herdr-app/` 以下。全部ファイル
- `keys.json` = キー割り当て。保存で即反映
- `settings.json`、`layouts/`、`mods/`、`themes/`
- `AGENTS.md` = 公式ガイド。起動のたび書き出される。mods を書くとき読む
- 場所変更 = `HERDR_APP_HOME` か `XDG_CONFIG_HOME`

## キー

- 既定は repo の `defaults/keys.macos.json`
- 覚えるのは 2 つ。`cmd-shift-p` パレット、`cmd-/` キー一覧
- `cmd-t` 新規 tab、`cmd-d` 右分割、`cmd-shift-d` 下分割、`cmd-b` サイドバー、`cmd-n` 新規 space
- `cmd-shift-l` layout 切替、`cmd-,` 設定
- セクション = `global` / `terminal` / `layout:<名>` / `mod:<名>`
- 値 = コマンド(`pane.split:right`)、`send:<文字>`、`terminal`(キーを端末へ素通し)
- 壊したら `ctrl-alt-shift-escape` で既定に戻る
- 自分の変更 = `cmd-w` を pane.close、`cmd-shift-w` を tab.close に入れ替え

## layout

- 3 種 = Herdr(左サイドバー)、Terminals(端末中心)、Herdr 98(Win98 風)
- テーマは layout ごとに別々に持つ
- 標準 layout は読み取り専用。`layout.clone` で複製してから編集
- 自分用 = `main-plus`(main の複製)

## CLI

- `herdr-app do <コマンド>` = アプリ操作。`herdr-app commands` で一覧(約 60 個)
- `herdr-app ls` / `status` / `check <mod>` / `shot`
- `hc` = 端末とエージェントの操作。`run` `read` `send` `wait`
- `herdr-app --skill` = agent 向けマニュアル
- 引数名に注意。`space.close` は `--id` と `--confirmed true`

## worktree

- 素の `git worktree add` はサイドバーに出ない
- space の右クリック → New worktree で作る。保存先 `~/.herdr/worktrees/<repo>/<branch>`
- 中身は `git worktree add -b` + `space.new`。agent も同じ 2 手で再現できる
- mod `worktree` のダイアログは CLI から引数を渡せない(`mod.open` は name のみ)

## mods

- ウィンドウ内パネルを描く JavaScript。gpui-kit(GPUI の要素記述)
- 標準 mods 21 個。layout が使う、アプリが必要時に呼ぶ、のどちらか。ON/OFF スイッチは無い
- できる = パネル、ダイアログ、フローティング窓、端末埋め込み、アニメ、全アプリコマンド実行、`exec`、`fetch`、ファイル読み書き
- できない = HTML/CSS/WebView/Node API、端末の文字描画の変更、他 mod の中身の実行時操作
- mods は信頼されたコード。通信と外部プログラム実行が無制限。入れる前に中身を読む
- 共有 = herdr.dev/mods。GitHub トピック `herdr-mod` で探せる
- 入れ方 = `mods/<名>/` にコピー → `herdr-app check` → layout に置く(または `tab.new --mod`)
- mod だけの tab は端末が無く、フォルダが `~` になる。`--props '{"folder":"..."}'` で指定

### 導入した mods

- reviewer(vytasgavelis) = diff を PR 風にレビュー、コメントを agent へ送る。layout の changes と差し替え
- git-graph(rabeeh-ta) = コミットグラフ。`tab.new --mod git-graph --props '{"folder":...}'`
- quota(Lakris2407/herdr-mods) = Claude/Codex の枠をステータスバーに。`quota-axi`(npm -g)が必要
  - Claude 枠はキーチェーン許可が要る(`quota-axi --allow-keychain-prompt`)。未実行
  - 旧 repo herdr-quota はアーカイブ済み
- system = CPU/メモリ/GPU をステータスバーに。macOS 標準コマンドだけ

## 端末の描画・画像

- 本家は罫線・ブロック・点字を図形で描く(`src/sprites.rs`)
- gpui は shade だけ「意図した形を変えない」ためフォント任せ(`terminal_painter/graphics.rs`)
- Kitty 画像プロトコル = 端末に画像を出す仕様。両方で表示できた
- chafa が送る解像度は端末が返すセルのピクセル数で決まる
  - 本家 1760×1064、gpui 880×546(同じコマンド)
  - gpui に元画像をそのまま送るとくっきり出る。描画側の制限ではない
- Claude Code の画像貼り付けは Kitty ではない。`ctrl-v` → `terminal.paste_image`。両方で動く

## キー比較(gpui との違い)

- 同じ = `cmd-t` `cmd-d` `cmd-shift-d` `cmd-shift-enter` `cmd-alt-矢印` `cmd-shift-[` `]` `cmd-1`〜`9` `cmd-b` `cmd-,` `cmd-/` `cmd-shift-p` `cmd-q`
- 同じキーで動作が違う
  - `cmd-w` = 本家は tab を閉じる、gpui は pane。自分の設定は gpui に合わせた
  - `cmd-n` = 本家は新規 space、gpui は新規 worktree(新規 workspace は `cmd-shift-n`)
  - `cmd-[` `cmd-]` = 本家は前後の agent、gpui は戻る/進む
  - `cmd-alt-[` `]` = 本家は前後の space、gpui は前後の pane
  - `cmd-p` = 本家は mod ピッカー、gpui は workspace ピッカー
- 本家だけ = `ctrl-1`〜`9` space 選択、`f2` tab 改名、`cmd-alt-shift-矢印` pane 入れ替え、`cmd-shift-l` layout 切替、端末内の行頭/行末/単語移動
- gpui だけ = 検索 `cmd-f`、`cmd-k` クリア、`cmd-shift-c` コピーモード、`cmd-shift-a` 注釈、`cmd-shift-t` 閉じた tab を戻す、`cmd-o` ファイルへ、`cmd-shift-b` ブラウザ tab、`cmd-shift-s` セッション、Zen モード、`cmd-alt-n` 通知先を開く
- 本家の keys.json に検索と閉じた tab の復元は見当たらない

## 他アプリの機能を mod で足す

- cmux は Claude の通知を `cmd+i` で一覧、`cmd+u` で最新通知へ飛べる。本家に専用キーは無い
- 本家にあるもの = 完了/入力待ちで音と toast、space/tab の状態集約(blocked > done > working > idle)、`cmd-]` `cmd-[` で agent 巡回
- 本家に無いもの = 通知の履歴一覧、「待っている agent へ直接飛ぶ」キー
- だから mod で足した(下の attention)

### 自作 mod: attention

- 置き場所 = `~/.config/herdr-app/mods/attention/`(main.js 約 40 行、mod.json)
- ステータスバーにバッジ。blocked / done の数を色つきで出す。いなければ `all clear`
- `cmd-u`(`keys.json` の `"cmd-u": "attention.jump"`)で待ってる agent へ飛ぶ
  - blocked と done のうち、最近変化した順(`AgentInfo.seq` の降順)
  - 押すたび次へ巡回。見た done は idle になって一覧から消える
  - 自分の tab が応答したら、また `cmd-u` で戻れる(動作確認済み)
- バッジのクリックでも同じ動作
- 仕組み = mod が `nextCommand()` でコマンドを待つ。キーは keys.json 側が持つ
- 動かすには mod が layout のどこかに置かれている必要がある。status 行に `status-attention`(150px)を足した
- 注意 = 見てる最中に終わった agent は done にならず idle のまま。試すときは別 tab に居る
- 未作成 = 通知履歴パネル(`cmd+i` 相当)。通知イベントの記録が要る

### mod とショートカット

- keys.json に `<mod名>.<コマンド名>` と書く。mod が `nextCommand()` で受ける
- セクション = `global` / `mod:<名>` / `layout:<名>` / `terminal`。狭いほうが優先
- 配布する mod は keys.json を同梱できる。入れる側は既存キーとの衝突を見て統合
- `ctrl-c` `ctrl-d` `ctrl-r` など端末内プログラムが使うキーは割り当てると奪う

## 所感

- 他の候補(gpui、cmux)にある機能で本家に足りないものは、だいたい mod で補える
- 実際に reviewer(差分)、git-graph、quota、system、attention を入れて確認した
- mod は agent に頼めば書ける。型定義(`herdr.d.ts` `gpui-kit.d.ts`)を見て `herdr-app check` まで回る
- 弱点 = 端末の描画そのもの(文字、フォント)は mod で変えられない。本家の仕様に任せる

## 残り

- quota の Claude 枠(キーチェーン許可)は未実行
- gpui 側デーモンに削除済み worktree の workspace が残った場合は閉じる
- 元に戻す = `cmd-shift-l` で main へ。`rm -rf ~/.config/herdr-app/mods/{reviewer,git-graph,quota,system} ~/.config/herdr-app/layouts/main-plus.json`
