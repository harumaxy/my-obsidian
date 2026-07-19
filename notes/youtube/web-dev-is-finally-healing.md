---
title: "Web dev is finally healing"
description: Astro 7 リリースと Web 開発の HTML ファースト回帰についての動画メモ
# permalink:  # don't use
aliases:
  -
tags:
  - astro
  - web-dev
  - javascript
  - rust
draft: false
date: 2026-07-12
---

# Web dev is finally healing

- 動画: https://www.youtube.com/watch?v=A2JTsIeNqow
- チャンネル: Awesome (2026-07-06)

## タイトルの意味

「Web 開発がようやく（JS 過多の病から）回復してきた」という皮肉と希望が混ざった表現。

ここ数年、SSR / Edge runtime / Partial hydration / Islands / Streaming など複雑な概念が乱立し、「ブログ記事を表示するだけ」なのに何 MB もの JS をブラウザに送る状態が続いていた。Astro のような HTML ファースト思想の台頭がその回帰を象徴している。

## Astro とは

2021 年登場。「ブラウザに不要な JavaScript を送らない」HTML ファースト思想で Next.js の代替として人気に。今年初め Cloudflare に買収。

**Islands アーキテクチャ**: ページの大部分はゼロ JS の静的 HTML、インタラクティブな部分だけ React/Vue/Svelte 等で動的化。

**得意なユースケース**: ドキュメントサイト・ブログ・マーケティングサイト・コンテンツプラットフォームなど、「ほとんど HTML で JS はちょっとだけ」なサイト。

## Astro 7 の主な変更点

### コンパイラの Rust 化
- Go コンパイラ → Rust に完全移行
- Markdown / MDX 処理も Rust 製パイプライン（Saturation）へ
- ビルド時間 **15〜61% 改善**
- 副作用: 壊れた HTML の暗黙修正がなくなり、不正 HTML はハードエラーに

### キュー型レンダリング（安定化）
- 従来の再帰的レンダリング → キュー/スタック方式に変更
- メモリ使用量と描画速度が改善

### 高度なルーティング `fetch.ts`
- Cloudflare Workers・Deno・Bun と同じ fetch ハンドラーパターンを採用
- リクエストパイプラインを完全制御可能（認証・ロギング・バックエンドプロキシ等）

### ルートキャッシング（安定化）
- `Astro.cache` / `context.cache` でキャッシュ動作を宣言的に定義
- max-age、stale-while-revalidate、キャッシュタグ等に対応

## Cloudflare の動き

- Astro を買収（2026年初）
- **VoidZero**（Vite 作者 Evan You の会社）も買収
  - Vite は Vue・SvelteKit・Astro・Nuxt・SolidStart など主要フレームワークの開発基盤
  - OSS の持続可能な資金調達が課題だったところを Cloudflare が解決
- 独立した Vite エコシステム基金に **$1,000,000** を拠出
- ローカル開発 → ビルド → デプロイのワークフロー統合を目指している
