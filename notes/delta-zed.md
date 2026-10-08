---
title: Delta (Zed)
description: Zed 製 エージェント開発プラットフォーム Delta まとめ
# permalink:  # don't use
aliases:
  - delta
  - DeltaDB
tags:
  - ai
  - coding-agent
  - zed
draft: false
date: 2026-10-04
---

# Delta (Zed)

https://delta.dev/docs/getting-started

## これ何

Zed Industries 作った「みんなで使うエージェント作業場」。
2026-09 public beta。ネイティブアプリ + ブラウザ版 (WebAssembly/WebGL)。

- 人間 タスク言う → エージェント 隔離したリポジトリ checkout で作業 → 人間 レビュー
- 狙い: PR 置き換え。会話が主役、コミットが従
- SDK / REST API ドキュメント なし。UI 操作前提

## 使い方

1. インストール、サインイン
2. プロジェクト開く、スレッド作る (スレッドごと リポジトリ別コピー = worktree)
3. エージェント 編集させる
4. 差分と会話 コメントで修正頼む

Claude Code ターミナルセッション → Delta スレッドに同期できる。

## 中核: DeltaDB

- コミット間の編集と会話 全部記録。変更ごと stable ID
- CRDT worktree。人間も複数エージェントも同時編集
- 既存 Git と連携。Delta 使わない人 普通の Git 履歴見える
- コメント コードの進化に追従。古い snapshot に貼りつかない

## なぜ作った

- 従来 PR = コード書いた後に議論。「GitHub 着く頃 大事な会話 もう終わってる」
- AI 時代 エージェントとの会話 = 本当のソース。Git コミットだけ 残らない
- Delta 会話と編集 並べて記録。エージェントに「説明して」「直して」言うとき diff から意図 再構築 不要

## 置き換え範囲

- GitHub: 一部のみ。PR レビュー + コード議論。Git 本体 残る。Issue / CI は不明
- Slack: 一部のみ。コードに紐づく議論だけ。雑談 / 通知 対象外
- Atlassian (Jira / Confluence): 対象外。機能 出てこない
- 結論: 「GitHub の PR + コード用 Slack」代替候補。全面置換 まだ早い

## 料金

- Personal: 無料。自前 API キー or 外部エージェント
- Pro: $10/月。$5 分トークン込み、超過 従量課金。Zed ホストモデル使える。2週間トライアル ($5 クレジット、カード不要)
- Business: チーム向け。Zed Business の組織プライバシー制御
- Delta 内 edit prediction 使えない

## 経緯 (Nathan Sobo ブログ)

- 2026-06-11 [Software Is Made Between Commits](https://zed.dev/blog/introducing-deltadb) — DeltaDB
- 2026-08-12 [Introducing Delta](https://zed.dev/blog/introducing-delta)
- 2026-09-01 Xanadu Was Waiting for Agents

流れ: 最高のコード執筆場所 → 最高のコード議論場所 → 会話ごとバージョン管理。

## 競合

- Conductor (Melty Labs, YC S24): 無料 macOS 専用。Claude Code / Codex / Cursor / OpenCode を worktree 並列実行。diff viewer、PR フロー、BYOK。Git / PR 前提のオーケストレータ。Delta = VCS 層ごと作り直す、より大きな賭け
- Codex app (OpenAI): 自社エージェント中心
- Zed 本体: エディタ + ACP で外部エージェント対応。Delta = 会話中心の別アプリ
- Claude Code: CLI 単体。Delta 上に載せられる。競合というより補完

## 所感

- 強み: 会話と差分 紐づく。リアルタイム共同編集
- 懸念: 独自 DeltaDB 依存。beta。API なし
