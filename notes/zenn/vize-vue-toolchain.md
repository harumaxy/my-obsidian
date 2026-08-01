---
title: Vize — Rust製 Vue.js ツールチェーン検証
description: ユニークビジョンによる Vize 実プロダクト検証レポートまとめ
aliases:
  -
tags:
  - vue
  - rust
  - toolchain
  - vize
draft: false
date: 2026-08-01
---

元記事: https://zenn.dev/uniquevision/articles/4359e64b17b028

## Vize とは

Rust製 Vue.js 統合ツールチェーン。コンパイラ・リンタ・型チェッカー・フォーマッタ・LSP → 同一 Rust 解析基盤共有。Oxc プロジェクト上に構築。現在 Real World Testing フェーズ（フィードバック募集中）。

## なぜ Vue は専用ツールチェーンが必要か

`.vue` SFC（Single File Component）は独自フォーマット → 専用パーサー必須。

```vue
<template>  ← HTML-like テンプレート → render() 関数に変換
<script>    ← JS/TS ロジック
<style>     ← CSS（scoped 対応）
```

JSX/TSX は JS 拡張構文 → Babel/SWC/esbuild が直接処理可。`.vue` は専用ブロックパーサーで先に分割 → 各ブロック個別処理 → vue-loader / @vitejs/plugin-vue が従来必要だった理由。

## 導入変更点

```
# package.json
"type-check": "vize check --tsconfig tsconfig.app.json"
"lint-check": "vize lint --type-aware"
```

Vite プラグイン: `@vitejs/plugin-vue` → `@vizejs/vite-plugin`

## 速度比較（SFC 150件、TS 187件）

型チェック（キャッシュなし）:
- `vue-tsc`: 42.88秒
- `vize`: 5.38秒 → **約8倍高速**

Lint: **約74〜78倍高速**
ビルド: 約1.1倍（微増）

## React は不要か

React（JSX）は JS 拡張構文 → 既存ツールで十分速い → Vue ほどの痛みなし。

現実的スタック:
- 型チェック: `tsc`（十分速い）
- lint+format: `biome`（Rust製）
- バンドル: `vite`（Rolldown 移行後さらに高速化予定）

## Rust 系 JS ツール整理

- **Biome** — lint + format 統合（prettier + eslint 代替）
- **SWC** — トランスパイル高速化（Next.js 採用）
- **Rolldown** — Vite 内部バンドラー移行予定（Rollup → Rust）
- **Oxc** — Vize 基盤。linter/parser/transformer 単体でも使える
- **Turbopack** — Vercel製、Next.js 専用バンドラー

## 結論

Vize → 速度・検出精度 両面で大幅改善。ただし試験段階 → 本番大規模投入は要注意。Vue プロジェクトの型チェック・lint ボトルネック解消の有力候補。
