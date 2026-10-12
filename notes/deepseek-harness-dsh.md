---
title: DeepSeek Harness (dsh) と V4.1 Flash、GLM / Kimi 比較
description: dsh は何者か、Claude サブスクで使えるか、V4.1 Flash の料金試算、GLM / Kimi との比較
# permalink:  # don't use
aliases:
  - dsh
  - DeepSeek Harness
tags:
  - ai
  - harness
  - deepseek
  - llm-pricing
draft: false
date: 2026-10-12
---

## きっかけ

- X で「DeepSeek Harness 良い」見た。何が良いか調べた。
- 数字、二次ブログ多い。公式モデルカード未確認。ベンチ、ベンダー自己申告多い。


## dsh 何者

- DeepSeek 公式 OSS (MIT) エージェント実行基盤。コマンド `dsh`。モデルでない。ハーネス側。
- 起動 `npx @deepseek-ai/dsh web` → `127.0.0.1:3080`。デスクトップ版もある。
- 全部プラグイン (基盤 Cordis)。モデルアダプタ、ツール、セッション、サンドボックス、ループまで差し替え可。
- Claude Code ループ固定。dsh ループごと変えられる。
- モデル DeepSeek 以外もいける。Anthropic、OpenAI、OpenAI互換。
- セッション追記型イベントログ。再開、フォーク、検索、リプレイ。
- 4 モード: Standard / PTC / Minimal / Creator。
- 弱点: 開発者プレビュー、API 壊れる、セキュリティ監査なし、学習コスト高い。
- 注意: Elixir forum に「Yoke (former DSH)」スレッド。改名か別物か未確認。

### ツイート所感 (AM09:21、2026-10-07)

- DeepSeek Harness: トークン使用量多め。でも「キャッシュヒット率」アホ高い。キャッシュ料金異様に安いモデルは dsh で動かすと良い。
- Pi: ミニマル、トークン少なめ、素の性能出る。自作ハーネス基盤。
- Amp: API 料金そのまま払う。高い。UX 最強。
- Claude Code: 垢 BAN なし。Extra Usage でないサブスク枠を一番安定して使える。渋々使用。
- OpenCode: OpenCode Zen のフリーモデル使える唯一のハーネス。
- Codex: 謎機能多い。Ultra 使わないなら subagent 無効化が良さげ。

→ dsh の良さ = キャッシュ効率。性能アップでなく「コスト最適化ツール」。ハーネス変えただけで賢くならない。


## Claude Max サブスクで dsh 使える？

- 公式: 組み込み Anthropic provider は API キー方式。Max OAuth 公式対応の記述なし。
- 非公式: プラグイン `dsh-plugin-subscriptions` (V1ki/dsh-plugin-subscriptions)。ChatGPT(Codex) / Claude / Grok サブスクを provider 化。dsh web UI の Settings → Subscriptions で OAuth ログイン。
- 星 78、セキュリティスキャン未完了。非公式小規模。
- リスク: Anthropic 規約上サードパーティから使ってよいか未確認。アカウント制限の恐れ。
- 確実なのは API キー。ただし従量課金、Max 定額枠は使えない。


## DeepSeek V4.1 Flash

- 2026-09 リリース。552B MoE、active 8B/16B、1M コンテキスト、画像対応。
- 2026-09-14 から `deepseek-v4-pro` API 呼び出しは V4.1 Flash にルーティング。
- 性能 (DeepSeek 報告): DeepSWE v1.1 = 74.2 (旧 V4 Flash 54.4)、Terminal-Bench 2.1 = 90.6。
- Vals Index 57.86% でオープンウェイト 1位級。Kimi K3 (57.81%) とほぼ同点。テスト単価 約 $0.30 (K3 は $6.47)。
- 弱点: 純粋推論。HLE 36.8 (Opus 5 は 56.3)、GPQA Diamond 90.9 (Opus 5 は 93.4)。Terminal-Bench 3.0 / 4.0 は Opus 5 にかなり劣る報告。実コーディング体感とベンチにギャップの指摘。
- AA (Artificial Analysis) スコア未発見。

### 料金 (1M トークン)

- 入力ミス: off-peak $0.15 / peak $0.30
- 入力キャッシュヒット: off-peak $0.003 / peak $0.006
- 出力: off-peak $0.60 / peak $1.20
- ホスト先 (LM Studio) は入力 $0.30 / キャッシュ $0.03 / 出力 $1.20。公式より高い。どこで使うかで変わる。
- 定額プラン見つからず。従量のみ。


## Max $100 全力と同等使用の料金試算

- 基準: ccusage 1 例。月 3.3B トークン、Claude API 換算 $6,739。個人 1 例。標準値でない。
- 内訳 (仮定): キャッシュヒット 3.0B / ミス入力 0.25B / 出力 0.05B。ヒット率は Claude と同じと仮定。
- off-peak: $9 + $37.5 + $30 = 約 $77
- peak: $18 + $75 + $60 = 約 $153
- 結論: 月 約 $80〜150。Max $100 と同じ桁。「1/50」にならない。
- キャッシュヒット分は無視できる。費用の大半はミス入力と出力。
- 使用量減れば比例して安くなる。全力の 1/3 なら $25〜50、1/10 なら $8〜15。Max は使わなくても $100 固定。
- 注意: dsh はトークン多め → 試算より増えるかも。Flash のヒット率が低ければ上がる。品質差でやり直し増えると差が縮む。従量は上限なし → チャージ上限設定したい。
- おすすめ: Max 残して軽い用途だけ Flash、月 $5〜10 チャージで 1 か月試す。


## GLM (Z.ai)

- 最新 GLM-5.3 (2026-08-14)。AA Intelligence Index 60。Kimi K3 と並ぶ。5.2 から +7。
- GLM-5.3-Flash は 57。
- API: 入力 $1.40 / 出力 $4.40。
- Coding Plan (定額): 月払い Lite $18 / Pro $80 / Max $168。年払い 実質 $12.60 / $56 / $117.60。旧表記 Pro $72 / Max $160 残っている。
- Lite 上限: 5 時間 約 80 プロンプト、週 400。対応ツール内のみ。返金不可。
- 出力長め。タスクあたり 約 18,700 トークン (5.2 比 +20%)。


## Kimi K3 (Moonshot)

- 2.8T パラメータ、1M コンテキスト、画像対応。
- API: 入力 $3 (ヒット $0.30) / 出力 $15。
- AA: Intelligence 約 57〜60、Coding Index 76.2。バージョンで値違う。
- Terminal-Bench 2.1 = 88.3 (自己申告)。GPT-5.6 Sol とほぼ同等。Opus 5 / Fable 5 / GPT-5.6 Sol よりは下。
- Semgrep 検証: コードセキュリティ精度低い。
- 出力トークン多い。ある評価で他モデル平均の約 2 倍 → 実コスト単価より膨らむ。
- Coding Plan 見つからず。


## まとめ

- 性能順の目安 (推測、直接比較なし): Kimi K3 ≒ GLM-5.3 > GLM-5.3-Flash > V4.1 Flash。
- 価格: V4.1 Flash 最安 → GLM → Kimi (単価高い、出力多い)。
- 定額なら GLM Coding Plan。Max 代わりに月 $18〜80。上限あり、対応ツール限定。
- 完全従量で最安は V4.1 Flash。
- hype の部分: 「dsh 入れたら凄くなる」空気。
- 本物の部分: 安いのに実用水準。
- Max 使い切れてないなら GLM Coding Plan Lite ($18) 1 か月試すのが手軽で安全。
- 試すなら自分の実タスクで Claude と並べて比較。


## 出典

- [DataCamp: What Is DeepSeek Harness?](https://www.datacamp.com/blog/what-is-deepseek-harness)
- [GitHub: deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)
- [dsh plugin subscriptions](https://skillsllm.com/skill/dsh-plugin-subscriptions)
- [Apidog: DeepSeek Harness vs Claude Code](https://apidog.com/blog/deepseek-harness-vs-claude-code/)
- [DeepSeek V4.1 Flash 公式ニュース](https://api-docs.deepseek.com/news/news260910/)
- [DataCamp: DeepSeek V4.1 Flash](https://www.datacamp.com/blog/deepseek-v4-1-flash)
- [MindStudio: V4.1 Flash Pricing](https://www.mindstudio.ai/blog/deepseek-v4-1-flash-pricing)
- [Morph: Claude Code API Cost](https://www.morphllm.com/claude-code-api-cost)
- [GLM-5.3 AA 60 (Unite.ai)](https://www.unite.ai/glm-5-3-scores-60-on-artificial-analysis-intelligence-index-matching-kimi-k3/)
- [GLM Coding Plan 料金](https://www.aipricing.guru/z-ai-subscription-pricing/)
- [Kimi K3 (DataCamp)](https://www.datacamp.com/blog/kimi-k3)
- [Kimi K3 Semgrep](https://semgrep.dev/blog/2026/kimi-k3s-code-security-results-lack-precision/)
