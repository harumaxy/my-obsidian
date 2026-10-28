---
title: Chrome タブ整理 + chrome-devtools-mcp + 自作タブグループ MCP
description: タブ150枚超を整理。devtools-mcp 導入、playwright-mcp 比較、タブグループ操作不可で拡張機能+MCP 自作
aliases:
  - chrome-tab-cleanup
tags:
  - chrome
  - mcp
  - claude-code
  - bun
draft: false
date: 2026-10-25
---

## 発端

chrome タブ 150 枚超。整理したい。Claude に任せたい。

## 最初の壁: claude-in-chrome は既存タブ見えない

- claude-in-chrome は自分用タブグループ内のタブだけ。既存タブ 0 枚。
- 回避: Chrome セッションファイル (`Default/Sessions/Session_*`) を python でパース → title/URL 取得。147 件。
  - SNSS 形式。ナビゲーション entry (command id 6) の URL と UTF-16 title 読む。
  - 読み取り専用。ただしバイナリ解析で、閉じたタブ混入の恐れあり。
- 結論: 本命は DevTools MCP で既存 Chrome に繋ぐ方法。

## 既存 Chrome を操作する MCP

3 系統あり。

- 拡張機能ブリッジ型: Playwright MCP `--extension`、Browser MCP、Blueprint MCP 等。既存タブ・ログイン状態そのまま使う。
- CDP 接続型: Chrome DevTools MCP `--autoConnect`、Stagehand。デバッグポート必要。
- 別ブラウザ起動型: 標準 Playwright MCP、Puppeteer MCP。既存タブ触れない。

## Playwright MCP vs Chrome DevTools MCP

- 重心が違う。Playwright = 操作する側、DevTools = 調べる側。
- 人気 (2026-10-24 時点):
  - GitHub star: DevTools 54,064 / Playwright MCP 38,568
  - npm 週間 DL: Playwright MCP 約 380 万 / DevTools 約 226 万
  - star は DevTools、実利用は Playwright が上。
- Playwright MCP:
  - スナップショット操作でトークン効率良い
  - `browser_tabs` で list/new/close/select
  - `--caps` で vision/pdf/network/storage/devtools 追加
  - Chromium/Firefox/WebKit 対応
  - 通信先許可リスト、タイムアウト、セッションログなど運用設定が豊富
- Chrome DevTools MCP:
  - emulate (ネットワーク・CPU 絞り・位置情報・UA)
  - ネットワークリクエスト詳細、本文ファイル保存
  - 性能トレース、Lighthouse、ヒープスナップショット、コンソール
  - Chromium 専用
  - `--autoConnect` は Chrome 144+、`chrome://inspect/#remote-debugging` 有効化、接続時に許可ダイアログ
- Chrome だけで開発・性能調査・監視 → DevTools MCP。業務の自動操作・E2E → Playwright MCP。両方入れても競合しない。
- 今回は「star 多い・多機能」で DevTools MCP 選択。

## DevTools MCP 導入

```sh
claude mcp add chrome-devtools --scope user -- npx -y chrome-devtools-mcp@latest --autoConnect --no-usage-statistics
```

- `--no-usage-statistics`: Google への利用統計送信を止める (既定 ON)。
- Chrome 側で `chrome://inspect/#remote-debugging` 有効化。Claude Code 再起動。
- `list_pages` で 151 タブ取得成功。title も URL もセッションファイルより正確。
- 注意: 繋ぐと普段使い Chrome 全体が操作範囲。業務で使うなら専用プロファイル推奨 (`--userDataDir` / `--browserUrl`)。

## 分類と書き出し

- 全タブを 14 セクションに分類。`web-tabs.local.md` (リポジトリ直下、`.local` 付きで git 管理外) に書き出し。
- セクション: AI画像生成 / 3D・Blender / Coding Agent / Web開発 / GIGAZINE / YouTube / ゲーム / X 各種 (5) / 生活・お金 / ブラウザ内部。
- 書き出し中に URL 誤記・タイトル改変を自分で見つけて修正。件数は 151 で一致。

## 壁その2: タブグループは DevTools MCP で操作できない

- `chrome.tabGroups` API は拡張機能専用。CDP にタブグループ API なし。DevTools MCP にもツールなし。
- claude-in-chrome は自分用グループのみ。computer-use はブラウザが read tier でクリック不可。
- 既製品: MCP Chrome Bridge、chrome-agent-mcp、Browser MCP (Wrick 版) など。ただし「エージェント専用グループ」用途が中心で、既存タブの任意グルーピングできるか不明。素性不明コードに全タブ権限渡すのも嫌。
- 結論: 自作。

## 自作 1 世代目: クリック実行型拡張機能

- `rules.json` に URL → セクション対応をハードコード。ツールバーのアイコンをクリックで全グループ解除 → 再グループ。
- 動いた。ただしルール固定。LLM が判断するわけではない。

## 自作 2 世代目: 拡張機能 + MCP サーバー (Bun)

- 構成: Claude Code が `server.ts` を MCP (stdio) として起動 → `127.0.0.1:17613` で WebSocket 待ち受け → 拡張機能が接続して命令実行。
- ツール 5 個: `list_tabs` / `list_groups` / `group_tabs` / `update_group` / `ungroup_tabs`。
  - タブを閉じる命令は意図的に入れない。
- 依存パッケージなし。MCP プロトコル (改行区切り JSON-RPC) を手書き。`package.json`・`node_modules` 不要。
- 安全対策: 拡張機能に固定 ID (manifest に `key` 埋め込み) を持たせ、WebSocket の Origin がその拡張機能のときだけ受け付ける。Web ページからの接続は 403。ただしローカル別プロセスの Origin 偽装は防げない。
- MV3 の service worker が寝る問題: 20 秒ごとに ping、`chrome.alarms` で 30 秒ごとに再接続。MCP 起動前は `ERR_CONNECTION_REFUSED` が拡張機能のエラーに溜まるが仕様通り。
- 自己チェック `check.ts`: 拡張機能を偽装した WS クライアントで MCP 全体を検証。
- 登録: `claude mcp add tabgroup --scope user -- bun <path>/server.ts`
- 弱点: Claude Code セッションを複数同時に開くと 2 つ目以降はポート競合でエラー。

## 動作確認

- 全タブ 1 グループ「未分類」にまとめる → 元の 15 グループに復元、を MCP ツールで実行。成功。
- 復元はスナップショット (`snapshot.json`) を再生しただけで、分類判断は含まない。LLM が分類を決める流れは `list_tabs` → 判断 → `group_tabs` で、次回以降に試す。

## 付随作業

- `CLAUDE.local.md` の「deno を仕様」を「bun を使用」に修正。deno のサ終予定が理由。

## 未解決・次にやること

- 各タブの内容を確認し、不要なものを閉じる。別セッションで実施。
  - 閉じる命令は自作 MCP に無い。DevTools MCP の `close_page` を使う想定。
- 自作ファイルは scratchpad (一時領域) にある。常用するなら恒久的な場所に移す。
  - `tabgroup-ext/` (拡張機能)、`tabgroup-mcp/` (`server.ts`、`check.ts`、`snapshot.json`)
  - 登録パスも変更要。
- 不要になった秘密鍵 `tabgroup-mcp/key.pem` は削除してよい。
- `claude mcp list` の出力に context7 の API キーが平文で出る。共有しない。
