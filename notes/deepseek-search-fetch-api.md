---
title: DeepSeek 検索API・フェッチAPI
description: DeepSeek が公開した Web 検索 API / URL→Markdown 取得 API の要約と、内部実装・Claude WebSearch との比較考察
# permalink:  # don't use
aliases:
  - deepseek-search-api
tags:
  - deepseek
  - web-search
  - llm
  - api
draft: false
date: 2026-10-28
---

# DeepSeek 検索API・フェッチAPI

元記事: https://gigazine.net/news/20261019-deepseek-search-fetch-api/

## 概要

- 2026/10/17 公開。同日 `DeepSeek-V4.1-Flash-1017` も出た
- 検索API: DeepSeek AI が使う独自検索エンジン、外から呼べる。1日数億リクエスト処理と主張
- フェッチAPI: URL 渡す → ページ内容 Markdown で返る
- 料金: 1,000 成功リクエスト = $0.75 (約118円)。検索とフェッチ別々に課金。1回 約0.12円
- 競合より安い (Artificial Analysis のグラフ。数値は記事に無い)
- DeepSeek API 経由の DeepSeek Harness / Claude Code / Codex は、サーバー側でもう使ってる。JST 2026/11/1 1:00 まで無料、以降課金
- 記事に呼び出し方、コード例、レート制限なし。公式: api-docs.deepseek.com/guides/search/

## Claude Code WebSearch との関係

- WebSearch = Anthropic サーバー側の検索ツール。DeepSeek 検索API は同じ役割を単体 API にしたもの
- Claude Code 本体 (2.1.312) はネイティブバイナリ。`grep -a` で埋め込み JS 見えた
  - `{type:"web_search_20250305", name:"web_search", allowed_domains, blocked_domains, max_uses:8, search_profile}` を server tool として渡すだけ
  - 1回の呼び出しで内部最大8検索。別 Claude モデルに検索させる構造
  - Foundry (Azure) では "Web search is not available on this Foundry deployment."。プロバイダ依存 = サーバー側機能
  - 検索エンジン呼ぶコードはクライアントに無い。`brave` 文字列はブラウザ起動パスだけ
- 検索バックエンドは Brave Search が有力 (公式声明は無い)
  - 2025/3 subprocessor リストに Brave 追加、`BraveSearchParams` パラメータ、Willison が結果一致を確認
  - 2026 の再検証 (Profound) で引用の重複率 約79% (公開時 約87%)。小サンプル、二次情報

## Google / DuckDuckGo との違い

- Google: LLM 向け汎用 Web 検索 API ほぼ無い。Custom Search は用途限定、Gemini grounding は高い
- DuckDuckGo: 公式検索 API 無し。スクレイピングは不安定、規約も怪しい
- Bing Search API は 2025 年に終了
- AI 向け検索 API (Brave, Tavily, Exa, DeepSeek): JSON 返す、広告なし、従量課金、fetch と組で本文 Markdown まで一気通貫

## 内部実装の推測 (記事に記載なし、全部推測)

- 独自フルクロールは重い。独立インデックス持ちは Google, Bing, Brave, Yandex, Baidu くらい
- 「1日数億リクエスト」は自社チャット由来の可能性。基盤を API 化しただけと思われる
- 構成案: インデックス (自前クロール or ライセンス調達、不明) → 逆インデックス BM25 → 埋め込み検索で候補 → 自社 LLM で再ランク・クエリ書換
- 価格 $0.75/1000 は、Google スクレイピング転売 (SerpAPI 系 $5〜15/1000) より安い。他社結果の再販では出にくい価格 → 自前か安い部分インデックスの示唆
- 確認方法: 公式ドキュメント、ニッチ/最新クエリで Google/Bing/Brave と一致度比較、日本語精度

## メリットの考察

- フェッチは LLM 処理と限らない。「Markdown で取得」としか書いてない → 本文抽出 + HTML→Markdown 変換だけの可能性高い
- 価値は「検索インデックス + 取得の面倒の安価な外注」
  - ナビ・広告除去、JS レンダリング、bot ブロック/CAPTCHA 回避 (一番の価値)、文字コード/PDF
  - Markdown 化でトークン減る
- 効く場面: 自作エージェントや RAG に検索を入れたい、DeepSeek モデルで Claude Code 等を動かす、大量に安く検索・取得
- 薄い場面: Claude 公式でそのまま使う (内蔵 WebSearch で足りる)、単発取得 (WebFetch / curl)、検索品質重視 (Brave / Exa と比較してから)

## 未確認

- 検索品質、特に日本語
- インデックスの鮮度・規模
- レート制限
