---
title: kitze/council 要約
description: 他の agent CLI (codex, gemini など) に計画を独立レビューさせ、X ターン議論してから最終計画を出させるスキル
aliases:
  - council-skill
tags:
  - agent
  - skill
  - multi-agent
draft: false
date: 2026-11-08
---

kitze/council。SKILL.md 1 枚 (115 行) だけのスキル。星 221 (2026-11-08 時点)。作者 Kitze (React Hanger, Sizzy などの人)。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/kitze/council
- ローカル: `~/ghq/github.com/kitze/council`
- 入れ方: `git clone https://github.com/kitze/council ~/.claude/skills/council` (プロジェクト単位なら `.claude/skills/council`)

## 何をするか

「council, 2 turns: Express から Hono に移行すべき?」のように頼むと、リード役のエージェントが次を行う。

1. 計画 v1 を書く。
2. マシンに入っている**他の agent CLI** (claude / codex / cursor-agent / gemini / grok / opencode のうち自分以外) に、計画を**独立に**見せる。各メンバーはターンごとに返事 1 回。結論は `SHIP IT` / `SHIP WITH CHANGES` / `RETHINK` + 強い指摘から順に。
3. 返事を吟味して計画を直す (採用・却下は理由付き)。何が変わったかをメンバーに伝え、指定ターン数だけ繰り返す。
4. 議論全体を会話形式で、最後に最終計画を出す。**実装はしない** (頼まれた時だけ)。

## 仕組み

- 外部の追加 API キーやデーモンは不要。各 CLI を 1 回限りの非対話モードで呼ぶだけ (ログイン済みの CLI をそのまま使う)。
- メンバー呼び出しは並列。各 300 秒で打ち切り。タイムアウト・エラー・空返答は「no reply」と記録して続行。
- 全メンバーは読み取り専用: claude は print モード、codex は read-only サンドボックス、cursor と gemini は plan モード、opencode はプロンプトでの指示のみ (強制ではない)。
- メンバーは互いの返事を見ない。リードの計画と変更点のみ見る。ターン数 X は厳密 (全員一致でも打ち切らない、増やさない)。
- 変更点の文書にはメンバー名を書かず、内容で書く (全員が読むため)。
- 記録は `~/.council/<日時>-<slug>/` に残る (task.md, plan-vN.md, 各ラウンドのプロンプトと返事)。
- 他の CLI が 1 つもなければ「council なしの単独案」と明記して出す。偽装しない。
- grok 対策: ヘッドレスだとツール呼び出しで黙ってキャンセルされるので、システムプロンプト上書き + 「ツールなし」の指示が必須。grok はリポジトリを読まずに助言する唯一のメンバー。
- 最終出力は `# 🏛 Council on: …` の見出しで、ターンごとの議論と最終計画。「意見を変えた点 / 譲らなかった点」を添える。

## 所感

- 中身はプロンプトと手順書だけ。同じことは自分で書ける。ただし各 CLI の非対話フラグ (cursor `--trust`、gemini `--skip-trust`、grok の回避策など) は調べる手間が省ける。参考価値あり。
- 狙いは「別モデルの意見で計画の盲点を潰す」こと。複数モデルを持っている人向け。トークン・時間コストは CLI の数 × ターン数で増える。
- 実際に効くかは未検証。同じ会話内の自己レビューより、独立した別モデルのほうが盲点は拾いやすい、という前提の設計。
- 自分の環境では、確認した範囲で `claude` と `opencode` だけが入っている (codex, cursor-agent, gemini, grok は見つからない)。claude がリードなら、メンバーは opencode の 1 つだけ。council としては成立しにくい。
- ハーネス非依存 (SKILL.md の記述から。動作は未確認)。
  - リードになれる: claude / codex / cursor / gemini / grok / opencode。SKILL.md を指示として渡せば他のエージェントでも可。
  - メンバーとして呼べる: 上と同じ 6 つ。opencode は `opencode run "$(cat "$PF")"`。
  - 注意: opencode だけ読み取り専用が機械的に強制されない (プロンプトで編集禁止と頼むだけ)。他は print モード・サンドボックス・plan モードで強制。
  - `opencode run` の出力形式やモデル指定の挙動は未確認。使う前に試す。
- ベンダー混合とコスト (私の知識に基づく所感、未検証)。
  - 同一モデル複数は誤りが相関する。別ベンダー混合は盲点を拾いやすい。ただし議論形式が単純な自己一貫性を一貫して上回るとは限らない。
  - 複数ベンダーのサブスクを重ねると月額が積み上がる。従量課金のほうが、たまに使う用途に合う。
  - **試すなら opencode + OpenRouter**: 前払いクレジットでキー 1 本、複数ベンダーのモデルを呼べる。5〜10 ドル程度で 1 回あたりのコストを実測してから続けるか決める。
  - OpenRouter 経由だと各ベンダー CLI 固有の機能は使えない。リポジトリを読む部分は opencode のツール機能に依存する。
- 導入判断: 見送り。既製スキルは必要時にプロジェクト単位で、という方針どおり ([[humanlayer-skills]] と同じ判断)。他モデル CLI を複数使う場面が出たら、SKILL.md を参考に自作する。
