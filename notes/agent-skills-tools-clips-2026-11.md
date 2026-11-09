---
title: エージェントスキル・ツール クリップ 2026-11
description: Chrome タブに溜めてたエージェント系スキル・ツール・記事の要約
aliases:
  - agent-skills-clips
tags:
  - agent
  - skill
  - clip
draft: false
date: 2026-11-06
---

Chrome タブ整理の一環。README・公式ページを読んだ範囲の要約。中身の深掘りはしてない。

## スキル (Claude Code 等に入れるもの)

### jakubkrehel/skills
- UI 作り用スキル集。better-interface / better-ui / better-typography / better-colors / better-accessibility など。
- better-interface は画面全体をアクセシビリティ・配置・文章・色・仕上げで見て、順位付きレポート 1 本。better-ui は角丸・影・アニメの具体数値まで指定。
- [jakubkrehel/skills](https://github.com/jakubkrehel/skills)

### humanlayer/skills
- HumanLayer 製スキル。`rpi` = 調査 → 設計 → 実装。各フェーズ 新セッションで進める。設計議論 / PRD+TDD / 技術設計 を選べる。
- `show-me` = 図・コード形状スケッチ・HTML で説明。`visual-pr` = PR 作成・更新用。
- `npx skills add humanlayer/skills --skill 名前` で入れる。
- [humanlayer/skills](https://github.com/humanlayer/skills/tree/main)

### kitze/council
- 手元にある他のエージェント CLI を呼び出し、X ターン議論させてから計画を出させるスキル。
- 複数モデルの意見を 1 つの計画に束ねる狙い。
- [kitze/council](https://github.com/kitze/council)

### ayghri/i-have-adhd
- 答えを埋もれさせないスキル。結論先、手順は番号付き、「お役に立てば」系の定型句なし。ルール 10 個。
- Before/After 例: 前置きだらけの説明 → 「`src/auth.ts:42` を直す。1. 開く 2. 置換 3. テスト実行」。
- [ayghri/i-have-adhd](https://github.com/ayghri/i-have-adhd)

### mizchi/explainer
- AI → 人 への説明用プラグイン。スキル 5 個。
- 思想: コード生成が速すぎて「理解」が律速 (Geoffrey Litt の話を引用)。読者がまだ知らないことだけ書く。主張・数値はツールで検証。
- `/plugin marketplace add mizchi/explainer` で入れる。
- [mizchi/explainer](https://github.com/mizchi/explainer)

### neilsonnn/image-blaster
- 画像 1 枚 → 3D 環境 / SFX / メッシュ。Claude スキル + World Labs + FAL (Hunyuan) 使用。
- 面数 (既定 50000)、PBR 有無、LowPoly などオプションあり。ゲームのレベル案・映画ロケハン・建築レンダ用途を謳う。
- [neilsonnn/image-blaster](https://github.com/neilsonnn/image-blaster)

## ツール・サービス

### Ultracite
- 保存時に整形 + lint 自動修正。貼り付け時も整形。VS Code の codeActionsOnSave 利用。
- AI にコード規約を守らせる用途でも使う。
- [Usage - Ultracite](https://www.ultracite.ai/docs/usage)

### getdesign.md
- 実在サイトの DESIGN.md を 550 件以上集めたカタログ。AI に渡すと色・文字・余白が揃い、「AI っぽい汎用レイアウト」を避けられる。
- Google 公式の DESIGN.md 仕様準拠。Claude Code / Cursor / Codex など対応。
- [getdesign.md](https://getdesign.md/)

### plannotator
- エージェントの計画・仕様・HTML・diff をブラウザで注釈レビュー → コメントをエージェントに送り返す。
- Claude Code / Codex / Copilot CLI / Gemini CLI / Pi など多数対応。git / jj / p4 / GitHub / GitLab の差分も見れる。
- [backnotprop/plannotator](https://github.com/backnotprop/plannotator)

### Ledge
- 実行できる Markdown ノート。コードブロックをその場で実行 → 出力が下に流れる (SQL / Python 例)。
- 無料 OSS。Mac / Linux / Windows / iOS / Android。
- [Ledge](https://ledge.sh/)

### TypeLLM
- 「workflow model」。1 回の API 呼び出しに `depends_on` / `when` / 並列を詰める。Chat=生成、Decision(Jev)=判断、Workflow=実行 の位置づけ。
- 自社計測: サポートチケット workflow で chat+decision 構成より 53% 安く 1.9 倍速い。JevBench(231 問) 精度 思考オフ 84.4% / オン 98.7%。数字は提供元の主張。
- 関連: [[qiita/decision-models-2026-10]]
- [TypeLLM](https://typellm.ai/)

### google/ax
- Agent Executor。Kubernetes 風 YAML (Workspace / Task) でエージェント作業を宣言 → サンドボックスで大量実行。`ax apply` / `ax ssh`。
- Agent Substrate の上で動く。数百万タスク規模が目標。開発初期、破壊的変更あり (README 警告)。
- [google/ax](https://github.com/google/ax)

## 記事

### AI 使うなら入れる Agent Skill 4選 (セカヤサAIブログ)
- 選定基準: 汎用・陳腐化しにくい・環境依存が薄い。モデル側の標準機能に飲まれるスキルは避ける (PPT/PDF 操作スキルは標準化済みの例)。
- 4 つ: japanese-tech-writing + cognitive-rhythm-writing (日本語文章、ラムダノート鹿野氏作)、grill-me (計画の穴埋め)、Context7 (最新ドキュメント)、ax (Web ページ取得)。
- [記事](https://ai.itokoba.com/archives/861/)

### 実装コードから仕様を吸い出して Z3 / TLA+ でバグを払い出す (mizchi)
- コードを「事実上の仕様」とみなす。吸い出し → 形式化して反例探索 → 意図かバグか人に確認、の 3 段。
- Z3 = 全入力に対する一瞬の整合性 (矛盾設定など)。TLA+ = 全順序・並行・クラッシュ後。有限で決定的なら素の全列挙が一番安い。
- 反例は「バグ報告」であり「認識合わせの起点」。
- [gist](https://gist.github.com/mizchi/db7817e6fc077d567c41cd9d41bb1c53)

### Building agents: subagent を main loop に畳む (Anthropic)
- 複数 subagent 構成より、skills で文脈を段階的に開示する単一エージェントのほうが、品質同等以上・低コスト・低遅延なことが多い。
- 理由: 文脈共有で答えが良くなる / system prompt が太らない / モデルが賢くなった。例: 遅延 約 2 倍改善、Claude Code の system prompt を 80% 以上削減。
- 向く subagent: 検証・並列作業・権限分離。単一ループは system prompt・スキル・ツール説明の規律が要る。
- [記事](https://claude.com/ja/resources/articles/building-agents-when-to-fold-subagents-into-your-main-agent-loop)
