---
title: Tailwind CSS vs Pure CSS vs OpenProps
description: Zenn記事「標準CSSの進化でTailwind不要説」への検証と考察
aliases:
  - Tailwind評価
tags:
  - CSS
  - Tailwind CSS
  - OpenProps
draft: false
date: 2026-06-25
---

## 記事の主張

Zenn記事「UIをTailwind CSSからネイティブCSS+OpenPropsに移行した」では、標準CSS機能の進化によってTailwind CSSが不要になったと主張している。

### 標準CSSの新機能
- ネスト構文 - SCSS的な書き方が標準で可能
- `:has()` セレクタ - 親要素への条件付きスタイリング
- `:is()` / `:where()` - 詳細度管理
- カスタムプロパティ - CSS変数による統一管理

### 記事で提案されるアプローチ
OpenPropsライブラリを組み合わせた純粋CSS活用

## 検証と考察

### OpenPropsの実体は「別のユーティリティ層」
記事の推奨例：
```css
.card {
  border-radius: var(--radius-2);
  padding: var(--size-fluid-3);
  box-shadow: var(--shadow-2);

  &:hover {
    box-shadow: var(--shadow-3);
  }
}
```

この実装自体が、CSS変数を使ったユーティリティ化に過ぎない。Tailwindを避けて、別のユーティリティフレームワーク（OpenProps）を使っているだけ。

### Tailwind + @apply の方が実装としては優れている

**同じことをTailwindで書く場合：**
```css
@layer components {
  .card {
    @apply rounded-[--radius-2] p-[--size-fluid-3] shadow-lg hover:shadow-xl;
  }
}
```

または直接HTMLに書いても問題ない：
```html
<div class="rounded-2 p-3 shadow-lg hover:shadow-xl">
```

### Tailwindの実質的なメリット

| 項目 | OpenProps + CSS | Tailwind |
|------|------------------|----------|
| デザイントークン管理 | CSS変数で分散 | `tailwind.config.js` で一元化 |
| ビルド最適化 | なし | 未使用クラス自動削除 |
| 統一性 | 低い（ファイル分散） | 高い（config一元化） |
| DX | 補完が弱い | IDE補完・ホバー時の動作確認可 |

## 結論

記事の「標準CSS機能を活用しよう」という提案は妥当だが、その実装方法として提案されているOpenPropsは結局ユーティリティ化されたCSSでしかない。

**むしろTailwindを使った方が**
- 実装がシンプル
- デザイントークン管理が統一的
- ビルド最適化がある
- DXが良い

「標準CSSの新機能 vs Tailwind」という二項対立ではなく、「CSS変数 + Tailwind」のような組み合わせが実用的だと考える。
