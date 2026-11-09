---
title: plannotator 要約
description: エージェントの計画・ドキュメント・diff をブラウザで注釈レビューし、コメントをエージェントに送り返すローカルツール
aliases:
  - plannotator
tags:
  - agent
  - review
  - claude-code
  - tool
draft: false
date: 2026-11-09
---

plannotator。エージェントの計画、ドキュメント、diff をブラウザで注釈レビュー。コメントをエージェントに送り返す。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/backnotprop/plannotator (ローカル: `~/ghq/github.com/backnotprop/plannotator`)
- 公式: https://plannotator.ai/
- 星 約 9.9k。2025-12-28 作成、最終コミット 2026-11-08 (活発)。バージョン 0.28.x。
- ライセンス: MIT または Apache-2.0。

## 何をするか

1. **計画レビュー**: エージェントが計画を出すと、自動でブラウザが開く。範囲選択でコメントし、承認か却下。却下すると構造化フィードバックがエージェントに戻る。修正後は計画の差分が見える。
2. **注釈**: `/plannotator-annotate` でローカルの Markdown、フォルダ、URL、HTML を注釈。`/plannotator-last` はエージェントの直前の返答を注釈。
3. **コードレビュー**: `/plannotator-review` で未コミットの変更、GitHub の PR、GitLab の MR を、サイドバイサイドの diff で見る。行コメントとコード提案ができ、結果はエージェントに戻る。Git のほか、GitButler、Jujutsu (`jj`)、Perforce にも対応。
4. **AI 補助**: レビュー中の内容についてエージェントに質問できる。レビュー用エージェントが diff にコメントを付ける機能もある。
5. **Inbox** (新機能): 複数エージェントからの質問、ファイルを 1 つのウィンドウに集める。セッションを止めずに、後でまとめて返信。

## 仕組み (Claude Code)

- `ExitPlanMode` の `PermissionRequest` hook で、ローカルサーバーが計画を受け取り、ブラウザを開く。承認でエージェントが進み、却下でフィードバックが戻る。
- Claude Code 2.1.287 以降は、エージェントが待たずにターンを終え、判断が次のメッセージとして届く。`PLANNOTATOR_CLAUDE_MOD=0` で従来の待機方式に戻る。

## 導入

- `curl -fsSL https://plannotator.ai/install.sh | bash`: バイナリを入れ、入っているエージェントを自動検出して hooks、スキル、スラッシュコマンドを設定する。
- バイナリだけなら `--minimal`。アンインストールは `plannotator uninstall` (`--purge` でデータも削除)。
- Claude Code: プラグイン (`/plugin marketplace add backnotprop/plannotator`) か、`~/.claude/settings.json` に hook を手書き。
- 対応エージェント: Claude Code、Codex、Copilot CLI、Gemini CLI、OpenCode、Kiro、Droid、Amp、DeepSeek Harness、Pi。

## 連携

- **Obsidian**: 承認した計画を frontmatter、タグ、バックリンク付きで Vault に自動保存できる。このリポジトリの運用と相性が良い。
- Bear、Notion、VS Code 拡張にも対応。

## プライバシー

- 利用統計の収集なし。計画、diff、注釈は既定でローカルに留まる。
- 例外: 起動時に GitHub へ最新リリースを確認 (オプトアウト設定なしと README が明記)。URL 注釈は Jina Reader 経由で取得。「Ask AI」は設定したプロバイダへ文脈を送る。
- 共有リンク: 小さい Markdown は URL のフラグメントに圧縮。大きいものは AES-256-GCM で暗号化して置く (7 日で失効)。ただし共有機能は廃止方向で、チーム共有は有料予定の Workspaces (ウェイトリスト) に移行中。

## 所感

- 狙い: 「エージェントの計画を自分で読んで直す」手間を、ブラウザの注釈 UI で短くする。ターミナルのテキストより、範囲選択でコメントできるほうが楽。
- 既に Plan モードを使っているなら導入は軽い。ただし hooks の自動設定と `curl | bash` で入れる点は、「既製ツールは慎重に入れる」方針と要確認。試すなら `--minimal` が無難。
- 機能が急速に増えている (Inbox、Workspaces など)。コア (計画レビューとコードレビュー) だけ使うなら十分。
- 導入判断: 未定。Plan モードを多用する場面が増えたら試す。

## 未確認

- 実際に動かしていない。README とリポジトリの構成の確認に基づく。
- Inbox、Workspaces、AI レビューエージェントの実際の使い心地は未確認。
