---
title: React いらない論と Signals 極小フレームワーク
description: kenn氏ツイート起点。AI時代に React 重い。Signals + CSS + Web Components で薄いFW作れるか。
# permalink:  # don't use
aliases:
  -
tags:
  - javascript
  - react
  - signals
  - web-components
draft: false
date: 2026-10-11
---

# 元ネタ

- kenn氏ツイート (2026-10-11): https://x.com/kenn/status/2109093582514913675
- 注意: 取得は fxtwitter 経由の要約。原文そのままでない。引用ツイート・画像は未確認。

# ツイート要旨

- AI開発すると React 余計な負担に感じる。
- SSR ほぼ必須。hydration, Shadow DOM, Hooks 壊れやすく過剰。
- Remix 3 は思想良い。でも `update()` 手動 invalidate は後退。
- やりたいこと = HTML/JS/CSS 凝集させた再利用パーツ。それだけ。
- CSS 進化: `@scope`, `:state()`, invoker commands, anchor positioning。状態 CSS に持てる。JS 減る。
- TC39 Signals 正式化したら、極小FW作れる。
  - 状態 = DOM と CSS
  - JS = 値と DOM の結合だけ
  - JSX 不要。テンプレートリテラルで足りる
- Lit と Solid 近い。新キラーFW 出ると予測。

# 結論

- 「React 不要」ちがう。「自分の用途で React 過剰」。
- 「Vanilla JS 回帰」ちがう。極小FW は残る。
- FW 不要論ではない。FW の厚い部分 (仮想DOM, Hooks, hydration, JSX変換) が薄くなる話。
- 氏の構想は将来予測。Signals 標準化など前提まだ。

# 普及問題

- Solid, Lit は求人ほぼ無し。AI の学習量も React が桁違い。
- Solid は React の癖を AI が混ぜがち (分割代入で reactivity 壊れる等)。
- 皮肉: AI 開発では「AI が書き慣れた技術」が楽。氏の前提と逆の力が働く。
- 反論: 薄い仕組み・標準寄りなら、API をコンテキストに貼れば AI 書ける。
- 使い分け
  - 仕事・チーム: React 一択
  - 個人・小パーツ・実験: Lit/Solid/自作 試す価値あり

# Signals とは

- 値の入れ物。依存関係を自動追跡。値変わると、読んでた所だけ再計算。
- 部品: state (元の値) / computed (派生値) / effect (変化で動く副作用)

## Preact Signals (ライブラリ)

```js
import { signal, computed, effect } from "@preact/signals-core";

const name = signal("Jane");
const surname = signal("Doe");
const fullName = computed(() => name.value + " " + surname.value);

effect(() => console.log(fullName.value)); // "Jane Doe"
name.value = "John"; // "John Doe" 自動で出る
```

- `.value` で読み書き。
- Preact コンポーネントは `{count.value}` 書いた所だけ再レンダリング。

## TC39 Signals (言語標準の提案)

```js
import { Signal } from "signal-polyfill";

const count = new Signal.State(1);
const doubled = new Signal.Computed(() => count.get() * 2);
count.set(2);
```

- API: `Signal.State` / `Signal.Computed` / `get()` / `set()`
- effect は標準に入らない。低レベル `Signal.subtle.Watcher` だけ提案。FW 側が effect 自作する設計。
- 今は `signal-polyfill` で試せる。
- Preact, Solid, Vue, Angular, Svelte 5 は各自 signal 系を持つ。TC39 はそれらを標準化して共通基盤にする試み。
- 正式化のステージは未確認。TC39 proposal リポジトリで要確認。

# 標準機能だけの極小FW

## 4部品

1. Custom Elements: コンポーネント単位。`customElements.define`。バンドル不要。
2. Signals: 状態と依存追跡。
3. タグ付きテンプレートリテラル: JSX の代わり。
4. ES Modules + import map: `<script type="module">`。バンドラ不要。

## スケッチ (未検証)

```js
import { Signal } from "signal-polyfill"; // 標準化後は不要

// effect: Watcher を包むだけ
const w = new Signal.subtle.Watcher(() => queueMicrotask(flush));
const flush = () => { for (const s of w.getPending()) s.get(); w.watch(); };
export const effect = (fn) => { const c = new Signal.Computed(fn); w.watch(c); c.get(); };

// コンポーネント基底: 状態変わった所だけ再描画
export class El extends HTMLElement {
  connectedCallback() { effect(() => (this.innerHTML = this.render())); }
}
```

```html
<my-counter></my-counter>
<script type="module">
  import { Signal } from "signal-polyfill";
  import { El } from "./el.js";
  const count = new Signal.State(0);
  customElements.define("my-counter", class extends El {
    render() { return `<button>${count.get()}</button>`; }
  });
</script>
```

- `innerHTML` 全置換の粗い版。実用には差分更新が要る。

## 実用に足りない所

- DOM 差分更新: innerHTML 全置換だとフォーカス・入力値が飛ぶ。Lit はテンプレートの「穴」だけ更新して解決。ここが一番手間。
- イベントバインド・属性・リスト: Lit/Solid が数KBでやってる部分。
- SSR: Shadow DOM と相性悪い。氏が不満に挙げた所。
- 型チェック: TypeScript はビルド要る。JSDoc 型ならビルドなしで型チェックだけ可。

## ビルド不要になる範囲

- 不要: JSX 変換、バンドル、`node_modules` 依存 import (CDN / import map で代替)
- 残る: TypeScript、minify、tree shaking、本番最適化
- 小規模なら不要。大規模はビルド残る。
- 今でも Lit や素の Web Components はビルドなしで動く。足りないのは Signals 標準化だけでなく、差分更新テンプレートの標準化。後者は提案段階にも乏しい。

# Svelte / Solid / Qwik が流行らない理由 (自分の見立て)

- React との差が乗り換えコストを上回らない。
- エコシステム: UIライブラリ、フォーム、認証、テスト、デザインシステムが React 集中。
- 採用と AI の偏り。選ぶ側が安全策を取る。
- ネットワーク効果。新技術は「10倍良い」でないと覆せない。
- Next.js: React 選ぶとルーティング・SSR・デプロイ一式ついてくる。

## 位置づけ

- Svelte: シェア小さいが満足度高い。Svelte 5 は Runes で signal 系に寄せた。
- Solid: シェアより思想で業界に効いた。Signals 波及の源流の一つ。
- Qwik: resumability という別発想。Astro 寄りの層に刺さる。

# 氏の構想の違い

- 「新しい良いFW」を売るのでなく、標準 (Signals, CSS) に寄せて FW の差別化部分を薄くする。
- 標準に乗れば FW 間の移行コスト下がる。普及の壁は少し低くなるかも。
- でもエコシステムは標準化で移せない。React の優位が崩れるかは別問題。

# 見通し

- 当面 React 主流のまま。
- 氏の方向は React の外側 (個人開発、コンテンツサイト、Web Components 系) で徐々に効く。
- 5年スパンで React 独占が緩むかは、AI がどの技術を書きやすいかにも左右される。
