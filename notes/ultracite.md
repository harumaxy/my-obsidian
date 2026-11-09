---
title: Ultracite 要約
description: JS/TS 向け linter・formatter のゼロコンフィグ プリセット + エージェント連携 CLI。ルール方針と使いどころのメモ
aliases:
  - ultracite
tags:
  - agent
  - lint
  - oxlint
  - javascript
  - typescript
draft: false
date: 2026-11-09
---

Ultracite。JS/TS 向け。linter と formatter の設定プリセット + CLI。AI エージェントが書くコードを揃える狙い。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- 公式: https://www.ultracite.ai/
- repo: https://github.com/haydenbleasel/ultracite (ローカル: `~/ghq/github.com/haydenbleasel/ultracite`)
- 作者: Hayden Bleasel。MIT 形式。最終コミット 2026-11-01 (活発)。
- 料金: 公式ドキュメントに記載なし。無料 OSS とみられる。
- 要件: Node 22.22.2 以上 / 24.15 以上 / Bun。

## 要するに

- 自前のルールエンジンは持たない。Oxlint + Oxfmt (推奨、`init` の既定)、Biome、ESLint + Prettier + Stylelint の **設定プリセットと CLI ラッパー**。
- 3 つ面倒見る: (1) プロジェクトセットアップ、(2) 既存プロジェクトへの導入時の一括整形、(3) 導入後の編集ごとの整形 (hooks)。
- 過去は Biome 専用の時期あり。その後 Oxlint/Oxfmt が推奨に変わった。

## コマンド

- `npx ultracite init`: 設定、エディタ設定、`AGENTS.md`、hooks を生成。
  - フラグ: `--linter` (oxlint | biome | eslint)、`--frameworks`、`--agents`、`--hooks`、`--integrations` (husky / lefthook / lint-staged / pre-commit)、`--type-aware`、`--yes`。
- `check` (検査)、`fix` (自動修正)、`fix --unsafe`、`doctor`、`upgrade`。
- `fix --claude` / `fix --codex`: 自動修正で直らなかった診断だけ、Claude Code / Codex の CLI に渡して修正。1 ファイル最大 3 回。シェル許可なし (`acceptEdits`)。

## エージェント連携

- ルール: 全エージェント共通で `AGENTS.md` に書く (v8.0.0 以降)。CLAUDE.md があれば `@AGENTS.md` を追記。
- **Agent hooks** (`--hooks`): 編集のたびに `ultracite fix --hook` を実行。
  - Claude Code は `.claude/settings.json`。ほか Cursor、Codex、Copilot なども対応。
  - 編集したファイルだけ fix。直せない問題は stderr + exit code 2 で返し、エージェントが読んで次の手で直す。
- エディタ: 保存時 fix、ペースト時整形。VS Code 系 (Cursor、Zed など)。

## ルールセットの方針 (ソース確認)

oxlint の `core` プリセット (`packages/cli/config/oxlint/core/index.mjs`):

- **ほぼ全ルールを error、気に入らないものだけ off**。error 約 476、off 約 64、warn 0 (grep の概算)。
- oxlint のデフォルトは `correctness` カテゴリのみ (私の知識、未確認)。Ultracite は style、pedantic、restriction まで有効化。
- 有効プラグイン: eslint、typescript、unicorn、oxc、import、jsdoc、node、promise。
- 厳しめ (error): `typescript/no-explicit-any`、`no-non-null-assertion`、`eqeqeq`、`curly`、`no-nested-ternary`、`no-plusplus`、`no-param-reassign`、`no-inline-comments`、`no-warning-comments` (TODO も error)、`complexity`、`import/no-cycle`、`oxc/no-barrel-file`、`no-await-in-loop`、`require-await`。
- 緩め (off): `no-console`、`no-ternary`、`no-undefined`、`no-magic-numbers`、`max-params`、`sort-imports`、`import/no-default-export`、`unicorn/no-null`。
- 好みが分かれる所: `no-console` は off なのに `no-inline-comments` と `no-warning-comments` は error。
- 型情報を使う重いルール (`no-floating-promises` など) は core に入れず、`--type-aware` で有効化。

oxfmt:

- 2 スペース、行幅 80、セミコロンあり、ダブルクォート、末尾カンマ `es5`。
- import 並び替え (昇順、グループ間空行)、`package.json` 並び替え、Tailwind クラス並び替え (`clsx` `cva` `cn` など) を有効。Prettier 風の既定との違いは、並び替え系を全部有効にしてる点。

オプトインのプリセット:

- フレームワーク別: react、next、vue、svelte、astro、vitest、jest、playwright など。
- **`anti-slop`**: 別プロジェクト由来の JS プラグイン。根拠の薄い型アサーション、`unknown` の漏れ、`Reflect` 参照、モジュールのモックなど、AI が書きがちな逃げのパターンを禁止。lint は遅くなる。エージェント向けを名乗る部分は、これが一番それらしい。

## 所感

- ルールセットは「エージェントのため」というより、**厳格で好みの強い汎用プリセット**。エージェント向けの色は `anti-slop` と hooks。
- 厳密な開発をするなら、**推奨 tsconfig セットのような「厳格ベースライン」** として使える。
- 既存プロジェクトに入れると大量の違反が出る可能性が高い。`fix` で直る範囲は限られる。そこで一括整形 + LLM 補助が売りになる。
- 自前でも同じことはできる。差は手間と保守だけで、能力の差ではない。
  - 向く: 新規プロジェクトを頻繁に作る人、複数エージェントやエディタが混在するチーム、ルール選びに時間を使いたくない人。
  - 向かない: 既に設定が固まっている、エージェント 1 種類だけ、ルールを細かく調整したい、依存を増やしたくない。
- 導入判断: 見送り (既製ツールは慎重に入れる方針)。hooks の「編集後に fix を走らせ、残りを stderr で返す」発想だけ、必要になったら自前の hook に写す。

## 未確認

- oxlint のデフォルト範囲は知識ベース。ルール数は grep の概算。
- ライセンス全文、npm 側の情報は未確認 (リポジトリの `license.md` は MIT 形式)。
- `docs/ai/skills`、`presets`、`upgrade`、`faq` ページは未読。
