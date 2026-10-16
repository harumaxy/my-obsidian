---
title: Notion 代替 Wiki と Zed 共同編集
description: Notion/Confluence の代替候補、JTC での現実解、Zed 標準共同編集の単位と限界
# permalink:  # don't use
aliases:
  - Notion 代替
  - Zed collab
tags:
  - notion
  - wiki
  - zed
  - collaboration
draft: false
date: 2026-10-15
---

## きっかけ

- yutkat の X 投稿 (2026-10-12) 「使いこなせなかったもの一覧: Notion / Jira / dvorak / jj / ポモドーロ / OKR」
  - https://x.com/yutkat/status/2109477198109512162
  - 35.7万表示、いいね 2,492。リプは Notion 重い共感多い
- 自分も Notion 微妙。レスポンス遅い

## Notion の本当のメリット

- DB ビュー (テーブル/カンバン/カレンダー/ガント切替)。最大の売り
- 非エンジニア巻き込める。GUI ブロックエディタ
- 共同編集 + 権限管理。社内 Wiki 向き
- 連携 (Slack/GitHub/Jira/Figma)、Notion AI
- 弱点: 遅い、設計しないと散らかる、Markdown 完全互換でない、ロックイン

## 代替候補

- Outline (OSS, Markdown ネイティブ, リアルタイム共同編集, API) ← 一番近い
- Docmost (OSS, Confluence/Notion 代替, 新しめ)
- HackMD / HedgeDoc (Markdown 直書き。非エンジニアに記法が壁)
- AFFiNE (Notion + Miro 風, local-first, 速い)
- Cosense (旧 Scrapbox)。軽い。独自記法
- Google Docs。共同編集最強。非エンジニアも定着しやすい

GitHub star (2026-10-15 時点): AFFiNE 7.3万 / Outline 4.1万 / Docmost 2.2万

## 知名度問題

- Outline は海外エンジニア界隈では中堅。日本の一般層ほぼ無名
- JTC (大きい上場企業) は OSS やマイナー SaaS、審査・稟議・保守担当で落ちる
- 既存契約の延長が現実解
  - Microsoft 365 → SharePoint + Loop + Copilot
  - Google Workspace → Docs + Gemini
  - Atlassian → Confluence + MCP/Rovo
- 自分の会社は Atlassian 契約済み → 我慢して使う
- AI に編集させる用途は Git + Markdown に分ける

## エンジニア向け: エディタ内共同編集

- Zed 標準 (拡張不要)
- VS Code Live Share (セッション型。ホスト落ちたら終了)
- JetBrains Code With Me は終了/縮小の話あり。要確認
- Obsidian + Relay 等プラグインは未確認

## Zed 共同編集の仕組み

出典: Zed 公式 docs (zed.dev/docs/collaboration/channels)

- 単位 = **チャンネル**。GitHub リポジトリ単位ではない
  - 永続ルーム。共有プロジェクト + 音声通話 + チャンネルノート
  - 階層化可。公開リンクで誰でも参加も可
- 共有プロジェクト
  - ホストがローカルフォルダを `Share`。参加者はホストのファイルを直接編集
  - clone されない。git コミット不要。未コミットもそのまま共有
  - 参加者は自分の Zed 設定・言語サーバ・AI 使える
  - ホストが Zed 閉じたら終了
- チャンネルノート
  - チャンネル 1 つに Markdown 文書 1 つ
  - Zed 側サービスに保存。git 無関係。**永続**
  - 参加しなくても閲覧可
- 権限: ゲスト = 閲覧のみ。通話中だけ書き込み許可を出せる

## Zed で Wiki は作れるか → 向かない

- ページ階層、バックリンク、リンク切れ検出、検索 UI、閲覧画面ない
- ノート 1 チャンネル 1 文書。複数ページにならない
- エンジニア Wiki なら Git + Markdown + Quartz/MkDocs/Docusaurus/VitePress が自然
  - 編集 = 好きなエディタ + PR

## リモート・S3 は？

- SSH リモート開発は公式で確認済。ソース・言語サーバ・ターミナルがリモート側で動く
- リモートプロジェクトをチャンネルで複数人共有できるかは **未確認**。要 docs 確認
- S3 直接開く = 不可。s3fs/rclone mount で見せる手はあるが遅い・整合性なし。非推奨

## 結論

- Zed 共同編集 = ペアプロ・モブプロの場。ドキュメント管理ツールではない
  - 各自が自分の画面・設定のまま同じファイルを編集。操作を渡す必要なし
  - 軽いメモはチャンネルノート (作業ごとの共有ホワイトボード)
- 常設の文書管理 = Git + Markdown (+ Quartz)
- 同時に書きたい時だけ Zed チャンネル共有
