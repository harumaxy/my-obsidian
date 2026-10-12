---
title: DeepSeek Harness と Ollama Cloud
description: DeepSeek 公式 OSS ハーネス dsh の中身、Ollama Cloud、本家 API との料金比較
# permalink:  # don't use
aliases:
  - dsh
  - deepseek-harness
tags:
  - ai
  - agent
  - llm
  - deepseek
  - ollama
draft: false
date: 2026-10-11
---

# DeepSeek Harness (dsh)

## なにもの

- DeepSeek 公式の OSS エージェントハーネス。MIT。2026年8月 developer preview。
- repo: `deepseek-ai/deepseek-harness`。スター 20万超。話題性でかい。
- Claude Code / Codex 相当。Cordis (イベントバス型プラグインカーネル) 上に作ってある。
- 起動: `npx @deepseek-ai/dsh web` → `http://127.0.0.1:3080`
- preview。互換性壊れる変更あり。`SAFETY.md` 先に読む。

## 中身 (clone して読んだ)

- **everything-is-a-plugin**。モデルアダプタ、ツール、セッションログ、エージェントループ本体、サンドボックス、UI、全部プラグイン。特権コアなし。
- profile + bundle + `cordis.patch.yml` で合成。YAML パッチで好きな行を差し替え。
  - 出荷 profile: `web` `headless` `sdk` `sdk-minimal` `acp`
  - `dsh --profile web --dump-config` で起動ツリー確認
- セッションログ (追記専用 `SessionEvent`) が唯一の真実。モデルに見せる履歴はログから `deriveMessages()` で導出。fork/resume/transcript 全部ここから派生。
- 1 ターン: `turn/start → agent/pre-step → request → stream → tool/call → tools/pre-execute → execute → post-execute → step/end`。各所に waterfall イベント、リスナーが割り込める。
- 機能最初から多い: sandbox (bwrap/Landlock/Seatbelt)、compaction、goal (`/goal`)、subagent、workflow、jobs、schedule、ptc-runtime、mcp、lsp、skill、browser-use、computer-use、ssh。
- 配布: Web / Electron / headless / TS・Python SDK (JSON-RPC) / ACP。

## システムプロンプト

- ペルソナは 1 行だけ: `You are a coding agent powered by the {{model}} model.`
- あとはプラグインが `PromptSection` (order 付き) を登録して連結。同名スコープ登録は global を上書き。`complete: true` で丸ごと差し替え可。
- 動的情報 (cwd、sandbox 方針、承認ポリシー、subagent 委譲) は `PromptContext`。履歴の後ろに user ロールで追記、変化時のみ記録。→ キャッシュ壊れにくい。
- plan mode の文面は YAML 直書き。「ツール一覧は mode 間で同じにする (キャッシュ安定のため)」と明記。
- 文面が Claude Code より優秀かは未比較。設計上の差はキャッシュ配慮と差し替え自由度。

## 乗り換える利点

- 既に Claude Code / Codex 使ってるなら劇的に便利ではない。
- 差別化は「ループ内部まで差し替え可能」。圧縮方式、system プロンプト根本、ループ判定。
- hooks + スキル + MCP で届く範囲はそっちで足りる。個人のメモ整理では動機薄い。
- 刺さる人: ハーネス自作・組み込み、安いモデルで大量回し、fork して自分用改造。

## 時雨堂の fork 記事

- <https://voluntas.ghost.io/deepseek-harness-fork/>
- 公式を fork、1 コミット足して社内メインツール化。OpenCode2 から乗り換え。
- 変更: 日本語化、日本語フォント、Ollama Cloud 追加、**公式モデル API 時のセッションログアップロードをデフォルトオフ化**、UI 改善 (プロジェクト名・ブランチ・時間)。
- 評価: DeepSeek V4.1 Flash との組み合わせが良い。繰り返しレビューさせると Opus 4.8 と大差なし。速くて安い。
- 注意: 公式の dsh はログ送信デフォルトオン。使う前に確認。

# Ollama Cloud

## なにもの

- ローカル LLM ツール Ollama のクラウド版。重いオープンウェイトモデルを自前 GPU なしで使う。2025-09 preview 開始。
- 競合 (推論ホスティング): Together AI (総合)、Fireworks (速度)、OpenRouter (ルーター)。Ollama は定額プラン + `ollama launch` で直結が特徴。

## 使い方

- API キー作成 → `https://ollama.com/api/chat` に Bearer で POST。Ollama インストール不要。
- OpenAI / Anthropic 互換クライアントも可 (一部)。
- モデル一覧: `https://ollama.com/api/tags`。CLI は `ollama run gemma4:cloud` 形式。
- `ollama launch claude` / `codex` / `opencode` でコーディングエージェントを Cloud モデルに接続。

## 料金

- Free $0 (同時 1) / Pro $20 (月 $60 分、同時 3) / Max $100 (月 $300 分、同時 10) / Team $500 (月 $1000 分、共有) / Enterprise 要相談
- 繰り越しなし。同時実行超過はキュー、満杯で拒否。
- 従量はトークン単価。オフピーク半額 (平日 12-18 UTC 以外 = 日本時間だと 21時〜翌3時がピーク)。
- データ: プロンプト・応答はログ保存も学習もなし (公式明記)。提携先 NCP にもゼロ保持を要求。独立検証は未確認。

## 速い理由 (推測)

- 公式説明なし。GPU 種類も非公開。
- 確実: V4 Flash は MoE (総 284B / 動作 13B) で元々軽い。
- 推測: 混雑が少ない、サービング最適化。時雨堂の 600 tok/s 超は最良値。常時とは限らない。

## ローカルとの違い

- 載ってるのはオープンウェイト。ローカルでも理論上動く。
- 重量級 (V4 Flash 284B、Pro、Kimi、Qwen3-Coder 480B) は数百 GB メモリ要る。普通の Mac や RTX 4080 (16GB) では無理。→ Cloud の価値はここ。
- 軽いモデル (7B〜30B) はローカル、重いのは Cloud、の使い分け。

# 本家 DeepSeek API vs Ollama Cloud

## 単価 (100万トークン、Flash)

- 入力 (miss) $0.30 / オフピーク $0.15
- キャッシュ入力 $0.006 / $0.003
- 出力 $1.20 / $0.60
- Pro: 入力 $1.32 / $0.66、出力 $3.96 / $1.98
- 本家と Ollama で **単価は同じ**。

## 違い

- 課金: 本家は残高チャージの従量。Ollama Pro は月 $20 固定で $60 分 (約 3 倍)、使い切れば得、失効なら損。
- ピーク: 本家は平日 UTC 01-04 / 06-10 = 日本の昼間 (10-13時、15-19時) がピーク。Ollama は夜がピーク。日本の昼間なら Ollama が半額。
- 同時実行: 本家 flash 2500、Ollama Pro 3。大量並列は本家。
- データ: Ollama はログ・学習なしと明記。本家は料金ページに記載なし (未確認)。
- 速度: 本家 約 152 tok/s (Artificial Analysis 引用)。Ollama は記事で最大 600 tok/s 超 (未裏取り)。

## 自分の使用量での試算

このリポジトリの Claude Code セッションログ (127 件) を実測。

- 重めセッション (`5fac0f3d`): 呼び出し 63 回、最大コンテキスト 17.6 万、キャッシュ入力 756 万、miss 入力 19 万、出力 1.8 万。
- 1 セッション: ピーク $0.125 / オフピーク $0.06。
- 1 日 4〜5 回 × 30 日: **ピーク $15〜19 / オフピーク $7.5〜9.5**。
- 外れ値 (`800d142b`): 317 回、コンテキスト最大 48.6 万、キャッシュ入力 7250 万。1 回 約 $1.2。毎日 4〜5 回続けば月 $150 級。通常は無い。
- Ollama Pro $20 は使用量が月 $20 超えないと割高。この使用量なら本家従量の方が無駄ない。
- 注意: Claude のトークン数を流用。トークナイザ差、思考モード (出力増)、キャッシュ判定の差で誤差あり。

## 結論

- 金額はごく小さい。コストだけで乗り換える理由にはなりにくい。
- 差が出るのは、プライバシー (Ollama 有利)、日本の昼間のピーク回避 (Ollama 有利)、並列度 (本家有利)。
- 試すなら `npx @deepseek-ai/dsh web` を 10 分。

# 導入メモ (2026-10-12 実際に試した)

## インストール

- `npm i -g @deepseek-ai/dsh` (0.2.0-rc.2)。`dsh web` で `http://127.0.0.1:3080`。
- npm が install スクリプト (node-pty, koffi 等) をブロックする警告が出る。動かなければ `--allow-scripts=...` を付けて入れ直す。
- 先に空のワークスペース (`~/dsh-playground`) を作って試すと安全。

## Ollama Cloud をつなぐ

- Settings → Models → Custom model API。Provider ID は任意、Base URL `https://ollama.com/v1/` (末尾 `/v1/` 必須)、API protocol は OpenAI Chat Completions、API key は Ollama の発行キー。
- モデルは Add model で ID を手入力してもよい。カスタムプロバイダーはモデルが最低 1 つ必要。
- Free プランでは `deepseek-v4.1-flash` が 402 (`this model is not included in your free usage`) で通らない。`gpt-oss:20b` は通った。
- 軽いモデル (Usage: Low) は Free で通る可能性が高い。gpt-oss、nemotron-3-nano、gemma4 など。Medium 以上は未確認。

## 分かったこと

- Claude Code の `~/.claude/skills/` のスキルを自動で拾っているように見える (xlsx、yomiyasu など。モデルの自己申告なので要検証)。
- Web UI 右上の「Open in…」は、ワークスペースを Finder / VS Code / Zed / Ghostty などで開くボタン。
- TUI は無い。`dsh tui` はヘルプの例文にあるだけで、出荷プロファイルは web / headless (/ sdk / acp)。`@deepseek-ai/dsh-tui` は npm に無い。
- CLI は `dsh headless "タスク"` の単発実行のみ。`--session-id` で継続、`--json` でイベント出力、`-` で stdin。
