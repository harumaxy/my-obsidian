---
title: 意思決定モデル比較 2026年10月版
description: Qiita 記事要約。Jev / Clef / d1 など System One モデル
aliases:
  -
tags:
  - ai
draft: false
date: 2026-11-06
---

元: https://qiita.com/nogataka/items/a2f89a94d243b1b715cb (2026-10-02 時点)

## 要点

- 意思決定モデル (System One) は文章を生成しない。state + 質問 + 選択肢を渡すと、各選択肢の確率が返る。
- 形式を作ったのは TypeSafe AI の Jev (2026-09-15 初公開)。他社が同形式 API を出してる。
- 通常 LLM の構造化出力 enum でも候補は絞れる。違いは「確率が返る」ことと「出力の課金方式」(出力トークン課金なし)。

## モデル

- API のみ (重み非公開): Jev (TypeSafe AI, 入力 $0.042/MTok)、d1 (Liquid AI, 無料枠 d1:free)、Solar Decide (Upstage)、OpenAI Decisions API (報道のみ、limited preview)
- 重み公開: Clef 27B / Clef-flash 9B (Cloudflare, Workers AI $0.24 / $0.09 /MTok, 画像可)、Jeff 1 (4B)、Jeff (firelex)、Kev (0.8B〜27B)、Laya (322M〜421M)
- Jeff 1 / Kev 小型版は Qwen に重ねる LoRA + ヘッドだけ配布。ベースは別途入手。

## 注意点

- 応答時間 (Cloudflare 計測): Clef 209ms、Clef-flash 39ms、Jev 524ms。Jev 公称上限 500ms 超え。測定者・条件が違う数字は直接比較不可。
- Liquid AI の「Jev 超え」は同社主張。公式ベンチ未確認。
- 数値は提供元の公表値。筆者の追試なし。

## 構成案

特定モデルに依存しないよう、インターフェースを1つ挟む。確信度が低いときだけ上位モデルに回す。
