---
title: LLM 比較 2026-10 (性能・コスパ・速度・OSS・Ollama Cloud)
description: 2026年10月時点の LLM 性能/コスパ/速度比較。OSS モデル、プロバイダ別速度、Ollama Cloud、Workers AI、GLM-5.3 まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - llm
  - open-weights
  - ollama
  - cloudflare
  - glm
draft: false
date: 2026-10-12
---

数字、Artificial Analysis (AA) 中心。計測、主に米国から。日本の速度、データなし。サイト間でズレあり。傾向だけ見る。

## クローズド系 (Index / Cost per task / tok/s / 初回待ち)

- Opus 5.5 max: 58 / $5.98 / 96 / 752s
- Opus 5.5 high: 54 / $1.82 / 82 / 44s
- Sonnet 5.5 xhigh: 52 / $2.01 / 106 / 36s
- Sonnet 5.5 high: 47 / $0.88 / 105 / 13.5s
- GPT-6 Astra max: 53 / $3.26 / 63 / 384s
- GPT-6.1 Sol high: 50 / $0.32 / 58 / 65s
- GPT-6.1 Sol medium: 48 / $0.21 / 55 / 7.6s
- Muse Spark 1.3 max: 48 / $1.60 / 121 / 43s
- Gemini 4 Argon high: 53 / $1.99 / 速度データなし

初回待ち、思考時間込み。思考上げるほど遅い。

- 最高性能: Opus 5.5。max は待ち長すぎ
- コスパ: GPT-6.1 Sol high。Opus high の 1/6 の費用
- 速さ重視: Sonnet 5.5 high。105 tok/s、待ち 13.5s

## オープンウェイト (Index / Cost per task / tok/s / 初回待ち)

- MiMo-V2.6-Pro: 46 / $0.13 / 43 / 4.1s
- GLM-5.3 max: 45 / $2.01 / 83 / 2.6s
- Kimi K3 max: 44 / $2.00 / 41 / 3.5s
- GLM-5.3-Flash: 42 / $0.25 / 53 / 3.0s
- Ling 3.1 Flash: 41 / $0.99 / 214 / 1.8s
- Qwen3.8-Flash-Next: 40 / $0.37 / 56 / 2.5s
- DeepSeek V4.1 Flash max: 39 / $0.27 / 217 / 1.2s
- DeepSeek V4 Pro 0813 max: 36 / $0.67 / 89 / 1.6s
- MiniMax-M3: 29 / $0.51 / 92 / 1.7s

- OSS 最上位、Sonnet 5.5 high (47) 並み。費用、約 1/7
- Opus / GPT-6 上位 (52〜58) には 6〜12 ポイント届かない
- OSS の初回待ち、1〜4s。クローズドより短い
- Kimi K3、独自ライセンス。重み公開状況、情報混在。要確認

## プロバイダ別速度 (AA)

GLM-5.3:
- Z.ai 直 83 tok/s / 2.65s
- DeepInfra 78 / 1.38s ($0.56/$2.50)
- Together 120 / 0.78s
- Baseten 123 / 1.21s、FAST 286 / 0.49s
- Databricks 182 / 0.99s
- LithosAI FP4 425 / 0.60s (blended $0.68)
- Supernova FAST 614 / 1.34s

DeepSeek V4.1 Flash:
- DeepSeek 直 217 / 1.16s
- DeepInfra 73 / 0.80s ($0.14/$0.42)
- Together 280 / 0.35s
- Baseten 288 / 0.48s
- Nebius 328 / 1.33s
- Inco 997 / 1.44s

Kimi K3:
- Kimi 直 41 / 3.52s
- Together 66 / 1.01s ($2.70/$13.50)
- Fireworks 112 / 0.97s
- Baseten 131 / 0.85s
- Databricks 132 / 0.94s
- Bedrock 102 / 2.67s
- Nebius 194 / 1.09s

読み取り:
- 直 API 遅い (DeepSeek 除く)。第三者ホスティング速い
- LithosAI / Inco / Supernova 速いが新興。FP4 量子化あり。精度と安定性、未知
- 大手で無難: Together / Fireworks / Baseten / Databricks
- 日本リージョン速度、混雑度、公開データなし。実測必要

## Ollama Cloud

- 料金: クレジット制 (2026-08 末移行)
  - Free $0: starter クレジット、同時 1
  - Pro $20/月: $60 分、同時 3
  - Max $100/月: $300 分、同時 10 (新規停止説あり、未確認)
  - Team $500/月 (early access)
- クレジット使い切り → 購入クレジットで per-token 課金
- 同時リクエスト超過 → キュー待ち。キュー満杯 → 拒否。キュー長、HTTP ステータス、公式記載なし
- サブエージェント並列多いと、スロット取り合い → 待ち。Pro なら 2〜3 並列まで
- ZDR (ログなし、学習なし、公式主張)。ホスト、主に米国 (欧州に振る場合あり)。日本リージョンなし
- 時雨堂ブログ、Ollama Cloud 採用の話。記事自体は未確認
- 「使う人少ない + 同時実行制限 → 混雑しにくい」口コミあり
  - 投稿: https://x.com/Iamwonderingif/status/2108235435457855588
  - 「爆速」、実感ベース。tok/s 数値なし。人気出れば混む可能性
- モデル (単価 in/out per 1M):
  - glm-5.3 $1.40/$4.40、glm-5.3-flash $0.15/$0.50
  - kimi-k3 $3.00/$15.00、kimi-k2.7-code / k2.6 $0.95/$4.00
  - deepseek-v4.1-flash $0.30/$1.20、deepseek-v4-pro $1.32/$3.96
  - minimax-m3 $0.60/$2.40、mistral-large-4 $0.68/$2.09
  - gpt-oss $0.07/$0.30〜、gemma4、nemotron-3 系
- Qwen、MiMo、載ってない
- Opus 5.5 級 (Index 54) なし。最上位 GLM-5.3 で 45

## Cloudflare Workers AI

- LLM API あり。テキスト生成 36 本
- Kimi K2.6 / K2.7-code (K3 なし)、GLM-5.3 / 5.3-flash / 5.2、DeepSeek V4 Pro / Flash、gpt-oss、Qwen3.8 27B、Llama 4 Scout、Nemotron 3 120B など
- $0.011 / 1,000 Neurons。無料 1 日 10,000 Neurons
- 第三者換算: GLM-5.3 $1.40/$4.40、DeepSeek V4 Pro $1.32/$3.96、gpt-oss-120b $0.35/$0.75 (公式未確認)
- Workers バインディング + AI Gateway 連携。エッジ網あり
- 弱点: K3 未対応。速度公開データなし

## GLM-5.3

- Z.ai (旧 Zhipu AI)。2026-08 リリース。GLM-5.2 と同じベース、後学習で強化
- 約 753B (MoE)。1M context。独自ライセンス (MIT 近い。売上 $100 億超の MaaS 事業者は安全審査義務)
- `reasoning_effort`: low / high / max (デフォルト max)
- ローカル実行 GPU 8 枚級。実質 API 向け
- AA Index 45。OSS 112 モデル中 1 位 (9 月時点)。今は MiMo-V2.6-Pro 46 と並ぶ
- 自己申告: Terminal-Bench 3.0 4.6→28.3、DeepSWE 46.2→66.9、CyberGym 84.5%
- 強み: コーディング、ツール使用、サイバー。Kimi K3 に Toolathlon で負け
- 画像入力、できない (tools + thinking のみ)
  - 画像可: GLM-5.3-Flash、Kimi K3 / K2.x、DeepSeek V4.1 Flash、MiniMax-M3、Mistral Large 4、Gemma 4
  - DeepSeek V4 Pro、GLM-5.2 も不可
  - 回避: 別 vision モデルで画像→文章化してから渡す

## 結論

- 最高精度、Claude 残す (Opus 5.5)
- 日常の軽〜中作業、GLM-5.3 (Ollama Cloud Pro $20 で試す) 有力。Sonnet 級より少し下、費用大幅安
- 速さ最優先、DeepSeek V4.1 Flash。Index 39 だが 217 tok/s、待ち 1.2s
- サブエージェント多用しないなら、Ollama Cloud の同時実行制限は許容範囲
- 日本からの実速度、自分で測る。TODO: deno で TTFT / tok/s 実測スクリプト (Ollama Cloud / Workers AI / Together の GLM-5.3)

## Sources

- https://artificialanalysis.ai/leaderboards/models
- https://artificialanalysis.ai/models/glm-5-3/providers
- https://artificialanalysis.ai/models/deepseek-v4-1-flash/providers
- https://artificialanalysis.ai/models/kimi-k3/providers
- https://ollama.com/cloud
- https://ollama.com/search?c=cloud
- https://ollamatps.com/limits/
- https://developers.cloudflare.com/workers-ai/models/
- https://developers.cloudflare.com/workers-ai/platform/pricing/index.md
- https://huggingface.co/zai-org/GLM-5.3
- https://www.morphllm.com/glm-5-3
- https://benchlm.ai/llm-speed
