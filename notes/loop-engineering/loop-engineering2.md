---
title: loop-engineering2
description: Addy Osmani の Loop Engineering 記事の要約
permalink:
aliases:
  -
tags:
  - ai
  - coding-agent
draft: false
date: 2026-06-21
---

# Loop Engineering

Addy Osmani (元 Google) による記事 (2026/06/07)。
AIコーディングエージェントの使い方が「手動プロンプト」から「エージェントを動かすループの設計」へ移行しているという考察。

> "You shouldn't be prompting coding agents anymore. You should be designing loops that prompt your agents." — Peter Steinberger

> "I don't prompt Claude anymore. I have loops running that prompt Claude." — Boris Cherny (Head of Claude Code, Anthropic)

---

## 1. 導入 — プロンプトからループへ

2年間のAIコーディングは「良いプロンプトを書いて結果を読み、次を書く」の繰り返しだった。
ループエンジニアリングでは、仕事を見つけ、配分し、チェックし、記録し、次を決めるシステムを作り、そのシステムがエージェントを動かす。

関連概念の階層:
- **Agent Harness Engineering** = 単一エージェントの実行環境を整える
- **Loop Engineering** = ハーネスの上に、タイマー・並列ヘルパー・自己フィードバックを載せる

**実践ポイント**:
- ツール固有の知識よりもループの「形」を理解する方が重要。Codex でも Claude Code でも同じ構造が使える
- まずは手動プロンプトで十分な作業を特定し、それをループ化する候補にする

---

## 2. ループの5+1の構成要素

| 要素 | 役割 |
|------|------|
| **Automations** | スケジュールで自動発見・トリアージ |
| **Worktrees** | 並列エージェントのファイル衝突を防ぐ git worktree |
| **Skills** | プロジェクト知識の文書化（毎回説明し直さない） |
| **Plugins/Connectors** | MCP 経由で外部ツール（Slack, Linear 等）と接続 |
| **Sub-agents** | 作る側(maker)とチェックする側(checker)を分離 |
| + **Memory** | 会話の外にある永続的な状態管理（Markdown, Linear 等） |

Memory について: モデルは実行間で全てを忘れる。状態はディスク上に置く必要がある。
> "The agent forgets, the repo doesn't."

### Codex と Claude Code の対応表

| Primitive | Codex app | Claude Code |
|-----------|-----------|-------------|
| Automations | Automations tab, /goal | cron, /loop, /goal, hooks, GitHub Actions |
| Worktrees | Built-in worktree per thread | git worktree, --worktree, isolation: worktree |
| Skills | Agent Skills (SKILL.md) | Agent Skills (SKILL.md) |
| Plugins | Connectors (MCP) + plugins | MCP servers + plugins |
| Sub-agents | TOML in .codex/agents/ | .claude/agents/, agent teams |
| State | Markdown / Linear connector | Markdown (AGENTS.md) / Linear via MCP |

---

## 3. Automations — ループの心臓部

ループを「一回きりの実行」ではなく「本当のループ」にするもの。

- Codex: Automations tab でプロジェクト・プロンプト・頻度・実行環境を設定。結果は Triage inbox へ。何も見つからなければ自動アーカイブ
- Claude Code: `/loop`, cron, hooks, GitHub Actions で同等のことを実現

### `/loop` と `/goal`

| | `/loop` | `/goal` |
|---|---|---|
| 駆動 | 時間間隔（cron） | 条件が満たされるまで連続 |
| 用途 | 定期的な監視・トリアージ | 目標達成まで自律作業 |
| 終了 | 7日で期限切れ or 手動停止 | 条件達成 or 手動停止 |
| 判定 | N/A | 作業モデルとは別のモデルが条件判定 |

`/goal` の例:
```
/goal all tests in test/auth pass and lint is clean
```
→ 条件が真になるまで自律的にコード修正を続ける。条件判定は別モデルなので自己採点にならない。

**実践ポイント**:
- `/loop` で定期巡回する対象例: CI 失敗チェック、デプロイ監視、PR レビュー催促
- `/goal` は「テストを全部通す」「lint エラーをゼロにする」のような検証可能な条件に使う
- 自動化の Automation が仕事を「発見」し、残りの構成要素がそれに「対処」する

---

## 4. Worktrees — 並列作業の衝突を防ぐ

2つのエージェントが同じファイルを書くと壊れる。git worktree で別ブランチ・別ディレクトリに隔離する。

- Codex: スレッドごとに worktree が自動作成
- Claude Code: `git worktree`, `--worktree` フラグ, sub-agent に `isolation: worktree` を設定

**実践ポイント**:
- 並列エージェントを走らせるなら worktree は必須
- ただし**レビュー帯域がボトルネック**になる。ツールの並列数ではなく、自分のレビュー能力が上限（orchestration tax）
- 実際に並列で走らせるのは、独立性が高いタスク（別モジュール、別ファイル群）に限定する

---

## 5. Skills — 毎回の文脈説明を排除する

Skill = フォルダ内の SKILL.md + オプションのスクリプト・参照資料。プロジェクト固有の規約・ビルド手順・「なぜそうしているか」を一度書けば、毎セッションで読み込まれる。

- スキルがないと、ループは毎サイクルでプロジェクト知識をゼロから推測する
- スキルがあると知識が複利で蓄積する

**Intent debt（意図の負債）**: エージェントは意図の空白を自信満々の推測で埋める。Skill はその意図を外部化して固定するもの。

**実践ポイント**:
- SKILL.md には「何をするか」だけでなく「なぜそうするか」「なぜそうしないか」も書く
- description は短く退屈に書く（巧妙より正確が重要。自動マッチングに使われるため）
- 繰り返し説明していることに気づいたら、それを Skill にする
- Plugin は Skill の配布形式。チーム共有したい場合に使う

---

## 6. Plugins/Connectors — 外部ツールとの接続

ファイルシステムしか見えないループは小さいループ。MCP 経由で issue tracker, DB, staging API, Slack 等に接続する。

- Codex も Claude Code も MCP を喋るので、片方用に書いた connector はもう片方でも動く
- Plugin = Skill + Connector のバンドル

**実践ポイント**:
- 「修正はこれです」と言うだけのエージェント vs PR作成・チケット更新・Slack通知まで自動でやるループ、の差がここ
- MCP サーバーを用意することで、ループが実環境の中で自律的に行動できるようになる
- まずは読み取り系の connector（issue 取得、CI ステータス確認）から始めると安全

---

## 7. Sub-agents — maker と checker の分離

ループで最も重要な構造パターン。コードを書いたモデル自身に自己採点させない。

- Codex: .codex/agents/ に TOML で定義（名前、説明、指示、モデル、reasoning effort）
- Claude Code: .claude/agents/ に定義、agent teams で連携

典型的な分担:
1. **Explorer** — 調査（軽量・read-only）
2. **Implementer** — 実装
3. **Verifier** — spec とテストに照らして検証（強いモデル・high effort）

**実践ポイント**:
- ループは無人で走るので、信頼できる verifier がないと離席できない
- sub-agent はトークンを消費する。全部に使うのではなく「セカンドオピニオンに金を払う価値がある箇所」に集中する
- `/goal` も内部的にこの maker/checker 分離を使っている（停止条件の判定を別モデルが行う）
- セキュリティ関連のレビュー、データマイグレーション等のリスクが高い作業に verifier を配置する

---

## 8. 具体的なループの全体像

```
[毎朝 Automation 起動]
  → triage skill が CI 失敗・open issues・最近のコミットを読む
  → findings を Markdown / Linear に記録
  → 各 finding に対して:
      → isolated worktree を作成
      → sub-agent A が修正をドラフト
      → sub-agent B が Skills + テストに照らしてレビュー
  → Connectors で PR 作成・チケット更新
  → 対処できないものは triage inbox に残す
  → state file が進捗を記録 → 翌朝のループが続きから再開
```

**実践ポイント**:
- 一度設計すれば、その後はプロンプトしない。これが「ループを設計する」の意味
- state file（進捗ファイル）がループの背骨。これがないと毎回ゼロからやり直しになる
- 小さく始める: まずは「CI 失敗の通知」だけのループから始めて、段階的に自動修正・PR作成を追加する

---

## 9. ループが解決しないこと

ループは仕事を変えるが、エンジニアを不要にはしない。むしろ3つの問題はループが良くなるほど**鋭くなる**。

### 検証は依然として人間の仕事
- ループの「完了」は主張であって証明ではない
- verifier sub-agent を入れても、最終的な品質責任は人間にある

### Comprehension debt（理解の負債）
- ループが高速にコードを出すほど、自分が書いていないコードとの理解ギャップが広がる
- ループが作ったものを読まないと負債は膨らむ一方

### Cognitive surrender（認知的降伏）
- ループが自動で回ると、意見を持たずに結果を受け入れる誘惑が生まれる
- 判断力を持って設計すれば加速装置、思考を避けるために使えば品質崩壊の加速装置

**実践ポイント**:
- ループの出力を定期的にレビューする時間をスケジュールに組み込む
- 「ループが作ったPR」と「自分が作ったPR」の品質差を定期的に比較する
- ループに任せる範囲を意図的に制限する（全部任せない）
- 理解を保つために、ループが生成したコードの重要部分は手動で読む習慣をつける

---

## まとめ — 実践チェックリスト

1. [ ] 繰り返している手動プロンプトを洗い出す → ループ化候補
2. [ ] SKILL.md にプロジェクト規約・ビルド手順・「なぜ」を書く
3. [ ] `/loop` で定期巡回を設定（CI監視、PR催促など）
4. [ ] `/goal` で検証可能な完了条件を使った自律作業を試す
5. [ ] MCP connector で外部ツール（issue tracker, Slack）を接続
6. [ ] 並列作業が必要なら worktree + sub-agent で隔離
7. [ ] verifier sub-agent を高リスク作業に配置
8. [ ] state file（Markdown）でループの進捗を永続化
9. [ ] ループ出力のレビュー時間を確保する（comprehension debt 対策）

> "Build the loop. But build it like someone who intends to stay the engineer, not just the person who presses go."
