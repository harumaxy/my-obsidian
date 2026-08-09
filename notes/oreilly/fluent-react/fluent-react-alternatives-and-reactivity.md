---
title: fluent-react-alternatives-and-reactivity
description: Reactの代替フレームワーク比較とReactのリアクティビティモデルの本質理解メモ
# permalink:  # don't use
aliases:
  -
tags:
  - react
  - reactivity
  - vue
  - svelte
  - solid
draft: false
date: 2026-08-09
---

参考: 『流暢なReact』(Tejas Kumar, O'Reilly) 第10章 Reactの代替案

## 各フレームワーク概要

- **Vue.js**: Evan You作、Angular軽量版狙う。Proxy傍受でリアクティブ実現。仮想DOMは今も使用、Vaporモードで脱却模索中
- **Angular**: Google製。仮想DOM差分でなく変更検出(Zone.js)方式。Signal API導入し細粒度化進行中
- **Svelte**: コンパイラ型、仮想DOM無し、DOM直接操作コード生成。Svelte5でRunes(`$state`/`$derived`/`$effect`)導入、実行時トラッキングに移行
- **Solid**: Ryan Carniato作。細粒度リアクティビティの代表格。`createSignal`でgetter関数返す、仮想DOM不使用
- **Qwik**: 「resumability」核。初期JS ~1kB固定(O(1)フレームワーク)、ハイドレーション不要

## Reactは伝統的リアクティブでない

伝統的リアクティブ = 依存関係自動追跡 + 変更自動伝播(pub/sub)。Signal読取時に自動購読、書込時に購読者へ自動通知。起源はKnockout.js(2010年代)、Solidが再流行らせた。

Reactは`v = f(s)`型。state変更で自動更新されず、**関数丸ごと再実行**して仮想DOM差分計算(粗粒度リアクティビティ)。VueやSolidの細粒度と対照的。

### コード比較: `count` vs `count()`

```jsx
// React: countはただの値。setCount呼ばれるとCounter関数が丸ごと再実行
const [count, setCount] = useState(0);
return <p>{count}</p>;

// Solid: countは値を返す関数。count()呼び出し自体が「ここ購読登録」の合図
const [count, setCount] = createSignal(0);
return <p>{count()}</p>; // Counter関数自体は初回のみ実行、以後pタグだけ更新
```

検証法: `Counter`内に`console.log("rendered")`置く。Reactはクリック毎にログ出る、Solidは初回のみ。

## 実装差の一覧

| | 自動追跡の仕組み | 実DOM更新方法 |
|---|---|---|
| Solid | getter経由の実行時サブスクリプション | 仮想DOM無し、直接操作 |
| Svelte | コンパイル時解析(`$:`) or Runes(実行時) | コンパイラがDOM操作コード生成 |
| Vue | Proxyでget/set傍受、依存track | 仮想DOM差分(Vapor除き) |
| Angular | 従来は変更検出全コンポーネント総なめ、Signal導入で部分細粒度化中 | - |
| React | 無し(手動memo必須) | 仮想DOM差分 |

## React粗粒度のデメリット

state変更に無関係な子コンポーネント(`<ComponentWithExpensiveChildren />`等)まで再レンダー範囲に巻き込む。`memo()`で個別に囲まないと防げない、忘れると性能劣化。Solid/Svelteは依存登録されてない要素は最初から再計算対象外。

## なぜReactはこの設計を選んだか

2013年当時の比較対象はSolid/Svelte型でなく**jQuery的手動DOM操作**。Backbone/Knockout流の手動subscribe/unsubscribeは:
- 購読解除忘れでメモリリーク
- 依存関係複雑化で更新順序バグ(diamond problem)
- デバッグ困難

Reactの「state渡せば仮想DOM差分で当てる」は当時としては十分な改善だった。加えて意図的トレードオフ:
- **バッチ処理**: 複数`setState`を1回の再レンダーにまとめられる
- **原子性・予測可能性**: state更新とUI更新が1トランザクション、ある時点の状態を推論しやすい
- 細粒度リアクティブは依存グラフ複雑化で逆に見通し悪化するケースあり(Svelte旧`$:`が`multiplyByHeight(width)`経由の`height`変更を検知できない例が象徴的)

アプリ巨大化で粗粒度コストが顕在化 → `useMemo`/`useCallback`/`memo`を後付け。

## React Forget

Reactチームはシグナルに「興奮せず」、コンパイラ最適化路線選択。`--fix`付きlinterのようなツールチェイン、純関数ルールを利用し不変値を自動メモ化。執筆時点未OSS、Meta社内評価中(Instagram/WhatsAppで好成績)。

著者の指摘: Forgetでも「更新毎にツリー全体を歩いてprops比較」構造は残る → シグナル方式(ツリー走査ゼロ)より原理的に遅い可能性は消えない。

## エコシステムロックインの現実

Solid/Svelteが技術的に優れても普及しない理由は技術より**ネットワーク効果**:
- 求人市場のReact経験者供給量
- コンポーネントライブラリ資産(MUI, shadcn/ui, Radix等)
- Next.js/Remix等フレームワーク層がReact前提
- 既存コードベースの乗り換えコスト(サンクコスト)

## React性能問題が実際に効くケース

大半のCRUD/管理画面/ブログでは粗粒度リアクティビティの影響は体感差にならない(ネットワーク待ちが支配的)。効いてくるのは:
- 大規模データグリッド/スプレッドシート(数千行、セル編集)
- リアルタイム高頻度更新(チャット、株価ティッカー、コラボ編集)
- 複雑な動的フォーム(数百フィールド)
- ドラッグ&ドロップ/アニメーション多用UI

現場で「Reactが遅い」の多くは設計限界でなく実装ミス(Context誤用、`useCallback`忘れ、`key`ミス)。`memo`正しく使えば大体解決。エコシステムロックインの方がSolid/Svelte不採用の主因、性能は言い訳程度なのが実態に近い。
