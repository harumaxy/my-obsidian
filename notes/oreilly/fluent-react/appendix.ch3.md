---
title: "Fluent React - Chapter 3 補足: 仮想DOMレスフレームワークとトレードオフ"
description: "Chapter 3 を読んで議論した内容。SvelteとSolidの仮想DOM不使用アプローチ、Solidのリアクティビティモデルの制約とトレードオフ"
aliases:
  - fluent-react-ch3-appendix
tags:
  - react
  - solid
  - svelte
  - frontend
  - virtual-dom
  - oreilly
draft: false
date: 2026-06-28
---

# Chapter 3 補足: 仮想DOMレスフレームワークとトレードオフ

## 仮想DOMレスフレームワークの主張

SvelteやSolidは「仮想DOMを使わないことでパフォーマンスが高い」と主張する。

仮想DOMは「直接DOM操作よりは速い」という話であって「最速」ではない。Reactでは状態が変わるたびに：

1. 仮想DOMツリー全体（JSオブジェクト）を新規生成
2. 旧ツリーとdiff比較
3. 差分を実DOMに適用

このdiff計算自体がCPUコストで、大きなコンポーネントツリーほど重くなる。

## Svelte — コンパイラアプローチ

```svelte
<script>
  let count = 0;
</script>
<button on:click={() => count++}>{count}</button>
```

ビルド時にコンパイラがテンプレートを解析して、**「countが変わったらこのテキストノードだけ更新せよ」** という命令的なDOMコードを生成する。実行時に仮想DOMも差分計算も存在しない。

## Solid.js — 細粒度リアクティビティ

```jsx
const [count, setCount] = createSignal(0);
<button onClick={() => setCount(c => c + 1)}>{count()}</button>
```

`createSignal` が「このDOMノードはcountに依存している」という購読関係をセットアップ時に構築する。状態変化時はdiffなしで**直接そのDOMノードだけを更新**する。コンポーネント関数は初回レンダリング時に1度だけ実行されれば十分。

## フレームワーク比較

| | React (仮想DOM) | Svelte | Solid |
|---|---|---|---|
| 更新の仕組み | 差分計算 | コンパイル済み命令 | 細粒度サブスクリプション |
| ランタイムコスト | 毎回diff | 最小限 | 最小限 |
| トレードオフ | 柔軟・動的 | ビルド時解析が必要 | テンプレート制約あり |

## Solidのテンプレート制約

Solidのコンポーネント関数は**初回1度しか実行されない**という前提があるため、Reactで当たり前に書けるパターンが壊れる。

### 1. propsの分割代入でリアクティビティが消える

```jsx
// React — 問題なし（再レンダリングのたびに関数が再実行される）
function Counter({ count }) {
  return <div>{count}</div>;
}

// Solid — countは初回の値で固定されてしまう
function Counter({ count }) {
  return <div>{count}</div>; // 更新されない！
}

// Solid — 正しい書き方
function Counter(props) {
  return <div>{props.count}</div>; // propsオブジェクトごと渡す
}
```

### 2. 制御フローに `.map()` や `&&` が使いにくい

```jsx
// React — 普通に書ける
{items.map(item => <li key={item.id}>{item.name}</li>)}

// Solid — これだとリスト全体が毎回再生成される
{items().map(item => <li>{item.name}</li>)}

// Solid — For コンポーネントを使うのが正解（差分更新になる）
<For each={items()}>{item => <li>{item.name}</li>}</For>
```

```jsx
// React
{isLoggedIn && <Dashboard />}

// Solid — Show コンポーネントを使う
<Show when={isLoggedIn()}><Dashboard /></Show>
```

### 3. シグナルを変数に取り出すと追跡が切れる

```jsx
// Solid でやりがちなミス
function Component() {
  const value = count(); // ← ここで値を取り出してしまうと...
  return <div>{value}</div>; // 更新されない
}

// 正しくはJSX内でシグナルを呼び出す
function Component() {
  return <div>{count()}</div>;
}
```

## 本質的なトレードオフ

ReactのJSXのメンタルモデルは「**毎回再実行される関数**」で、普通のJavaScriptの感覚とほぼ一致している。変数に入れても、分割代入しても、早期returnしても、JavaScriptとして正しければ動く。

SolidのJSXのメンタルモデルは「**サブスクリプションの宣言**」で、このモデルをReactのJSXモデルに上乗せして理解する必要がある。JavaScriptとして正しいコードがSolidとしては間違いになるケースが生まれる。

ただ擁護すると：

- **バグの出方がわかりやすい** — 「更新されない」という形で即座に気づける。Reactの「なぜ再レンダリングが多い？」系のバグより原因が明快
- **パフォーマンスを意識したコードが自然と書ける** — `<For>` を使うのが正解、というガイドレールがある
- **Reactの `memo` / `useMemo` / `useCallback` を考えなくていい** — その分の認知負荷は減る

結局「**どの複雑さを払うか**」の違いで：

- React → **実行時の最適化という複雑さ**（memo、useMemo、useCallback）
- Solid → **リアクティビティのメンタルモデルという複雑さ**（サブスクリプション追跡の意識）
