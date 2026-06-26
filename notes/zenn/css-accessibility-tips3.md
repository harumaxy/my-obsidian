---
title: モダンCSSでのアクセシビリティ対応テクニック3選
description: prefers-contrast / scroll-margin-top / order の落とし穴を解説したZenn記事の要約
aliases:
  -
tags:
  - css
  - accessibility
  - frontend
draft: false
date: 2026-06-25
---

元記事: https://zenn.dev/gemcook/articles/css-accessibility-tips3

## 1. `prefers-contrast` — ハイコントラストモード対応

OS 側でユーザーがコントラスト設定を上げている場合に、CSS で検知してスタイルを動的に調整できる。

```css
@media (prefers-contrast: more) {
  :root {
    --color-text: #000000;
    --color-link: #0000ee;
  }
  em, i, small { font-weight: bold; }
}
```

- CSS 変数でまとめて上書きするのが効率的
- プレースホルダーや `disabled` 要素など、デフォルトでコントラストが低い要素にも対応必要
- 根本的には「デフォルトから十分なコントラスト比を確保する」のが最重要

## 2. `scroll-margin-top` / `scroll-padding-top` — 固定ヘッダーとアンカーリンクの問題

固定ヘッダーがあるとアンカーリンク先がヘッダーに隠れる問題。`padding-top + margin-top` でのハックはレイアウトに悪影響が出やすかったが、CSS プロパティで解決できる。

```css
/* html 全体に一括指定 */
html { scroll-padding-top: 80px; }

/* または個別要素に */
[id] { scroll-margin-top: 80px; }
```

レスポンシブ対応は CSS 変数 + メディアクエリで管理するのが clean。

## 3. `order` プロパティとアクセシビリティの落とし穴

Flexbox / Grid の `order` は **視覚的な順序だけ**を変え、DOM 順序はそのまま。スクリーンリーダーやキーボードナビゲーションでは DOM 順に処理されるため、視覚と操作順が乖離して混乱を招く。

- **基本方針:** HTML の記述順を視覚的な順序に合わせる（CSS で逆転させない）
- **Chrome 137 以降:** `reading-flow: flex-visual` で視覚順とフォーカス順を同期できる新プロパティが使用可能

## 検証ツール

| ツール | 用途 |
|--------|------|
| Chrome DevTools | `prefers-contrast` のエミュレート |
| Accessibility Insights for Web (Microsoft 製拡張) | フォーカス順序の可視化 |
