---
title: humanlayer/skills 要約
description: HumanLayer 製 Claude Code スキル 7 個。rpi (調査→設計→実装) を軸にした開発ワークフロー系
aliases:
  - rpi-skill
tags:
  - agent
  - skill
  - workflow
draft: false
date: 2026-11-07
---

HumanLayer 製スキル 7 個。UI ではなく開発プロセス系。星 約 5.6k。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/humanlayer/skills
- ローカル: `~/ghq/github.com/humanlayer/skills`
- 入れ方: `npx skills add humanlayer/skills --skill 名前` (1 個ずつ)

## スキル一覧

- `rpi` ... 本命。Research → Design → Implement。ユーザーが名前で呼んだ時だけ動く。
- `show-me` ... 今の話題を図・擬似コード・コール木・コンポーネント木・浅いファイル木・HTML で見せる。前置きなし。ユーザー呼び出し専用。
- `visual-pr` ... PR を作成・更新。本文は「なぜ(1 文)」「特記事項(1〜3 点)」「変更の輪郭」。輪郭は散文やファイル別変更履歴でなく、構造図 (型・SQL・ファイル木・呼び出し木)。`gh pr edit --body-file` で反映。
- `improve-claude-md` ... CLAUDE.md を `<important if>` ブロックで書き直し、指示の遵守率を上げる。
- `narrow-react-prop-types` ... React の props 型を、Storybook やテストやモックだけで使われる状態でなく、実際に通る経路に合わせて絞る。
- `build-iterated-agentic-loop` ... リポジトリ内スキル + GitHub Actions の反復エージェントワークフロー・プロンプト・メモリファイルを生成。
- `design-control-loop` ... 制御ループ (センサー・コントローラー・アクチュエーター・外乱) を対話で設計し、ローカル実行部品 + 定期実行ワークフローとして構築。

## rpi の中身

- 4 つの開始フロー。どれも調査質問 → 調査から始まる。
  - 設計議論: 製品面と技術面を 1 文書で議論。選択肢が数個ある変更向け。
  - PRD → TDD: ユーザー向け結果と技術方針を分離。未決の製品論点がある大きい機能向け。
  - TDD: 技術方針に直行。挙動が明確な修正・整理・リファクタ向け。
  - 調査のみ: 既存システムの質問に答えて、そのまま実装。
- フェーズごとにレビュー点がある。
  - 調査質問: 範囲を絞る。
  - 調査: 事実確認。
  - 設計: 選択を確定。
  - アウトライン: 順序付き段階、テスト可能な結果、対象ファイル、検査。
  - 実装。
- **各フェーズは新セッション (新コンテキスト) が既定。** 決定事項・承認・未解決の質問を文書に保存して引き継ぐ。次のコマンドは文書のディレクトリ付きで提示される。
  - 例: `/rpi research .agents/artifacts/task-retries; next: PRD then TDD`
  - 例: `/rpi implement .agents/artifacts/task-retries`
- 文書置き場: `.agents/artifacts/<ブランチ名>` (main の場合は短い slug)。
- 実装後は別スキル `visual-pr` で PR を書く。
- Codex では `$rpi`。既定サンドボックスだと `.agents` が読み取り専用になるので書き込み許可が要る。

## 所感

- 「文書を介して新セッションに引き継ぐ」設計。長いセッションでコンテキストが腐るのを避ける狙い。Anthropic の「文脈を段階的に開示する」方向とは別アプローチ。
- 大きめの機能・リファクタなら試す価値あり。小さな変更には重い。
- `visual-pr` と `show-me` は単体で使いやすそう。PR 本文を構造図で書く発想が面白い。
- `improve-claude-md` は、このリポジトリの CLAUDE.md のように指示が増えてきた時に試せる。
- `narrow-react-prop-types` は React プロジェクト専用。ここでは不要。
- **導入判断: 見送り。** 開発プロセス系は自分で考えて書けるし、最近のモデルは素の指示でも十分良い。既製品に頼ると柔軟性が落ちる。
  - 使うなら「自分のプロジェクト用スキルを書く時の参考」。新セッション分離 + 文書引き継ぎの発想と、`visual-pr` の PR 本文の型は参考になる。
  - どうしても試すなら、実タスク 1 つを素 (プランモード) と `rpi` で比べる。見る点は手戻り回数・レビュー時間・設計の見落とし・所要時間。
