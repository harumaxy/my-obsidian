---
title: fluent-react-memoization-and-state-patterns
description: Fluent React 第5章要約 + React状態管理エコシステム雑談まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - react
  - performance
  - state-management
draft: false
date: 2026-08-09
---

出典: Fluent React（O'Reilly, learning.oreilly.com）第5章「よくある質問と強力なパターン」

## メモ化（再レンダリング抑制）

- `React.memo`: props浅い比較で同一なら再レンダリングスキップ。あくまでReactへのヒント、context変更等では無視される
- 非スカラー型（配列・オブジェクト・関数）のprops渡す時、毎回新規参照だとメモ化無効化する。親側で`useMemo`/`useCallback`必要
- `useMemo`: 高コスト計算のキャッシュ。スカラー値には不要、オーバーヘッドの方が高くつく
- `useCallback`: 関数版useMemo。子が`React.memo`されてて、かつその子に渡す場合のみ意味あり。ホスト要素（`<button>`等）に渡すだけなら基本不要
- **React Compiler**（旧称React Forget）: `React.memo`/`useMemo`/`useCallback`を不要にする自動最適化コンパイラ。ただしReact 19にデフォルトで入ってるわけではなく、`babel-plugin-react-compiler`を自分のビルドパイプラインに導入する必要あり（opt-in）。導入すれば手動メモ化不要になる方向、現状はまだ普及途上

## 遅延ロード

- `React.lazy` + `Suspense`で必要になるまでコンポーネントをダウンロードしない
- Suspenseはtry/catchに近い挙動、ラップ範囲は最小限に（全体ラップするとロード中UIが全部隠れる）

## 状態管理パターン（useState / useReducer / Immer）

- 再レンダリング抑制とは別軸の話。「状態をどう構造化・更新するか」の設計論
- `useState`は内部的に`useReducer`で実装可能（単純代入reducer）
- `useReducer`が有利な場面: 更新ロジックの分離＆単体テスト可能化／更新経路の明示化／イベントソーシング的拡張（undo-redo、監査ログ）
- 複雑でなければ`useState`で十分、`useReducer`は過剰になりがち
- Immer: ネストしたstate更新を「ミュータブルに書いてるように見えて実際はイミュータブル」にするライブラリ。`produce()`や`useImmerReducer`でspread地獄回避

## デザインパターン（本の内容、現在の位置づけ込み）

| パターン | 概要 | 現状 |
|---|---|---|
| Presentational/Container | UI担当と状態担当を分離 | Hooksでほぼ代替可能、小規模アプリでは過剰設計扱い |
| HOC | コンポーネントを受け取り拡張版を返す関数。loading/error等の横断的関心事の共有に有効 | `React.memo`/`forwardRef`は今も現役HOC。それ以外はHooksに押され気味 |
| Render Props / Function as Children | propsや`children`に関数渡してstate外部委譲 | ほぼHooksに置き換えられた過去パターン |

## React状態管理エコシステム（本には無い、雑談で出た話）

本の出版時期以降に定着した動きとして:

- **クライアント状態**
  - Redux Toolkit: 昔のボイラープレート地獄はRTKで解消済み、複雑な状態遷移には今も現役
  - Zustand: `create((set) => ({...}))`で1オブジェクトにstate+action同居。dispatch/action type不要、`set`の関数呼び出しだけ。`set`はshallow merge
  - Jotai（atomベース）: 状態を最小単位「atom」に分割して個別購読。あるatomの変更で無関係なatom購読者は再レンダリングされない
    - 複数atomの合成は基本read-onlyのderived atom（computed value）にする方針が壊れにくい
    - write可能な派生atomを使えばreducer的パターンもatom内に持ち込める
- **サーバー状態**
  - TanStack Query / SWR: fetchデータのキャッシュ・再検証・loading/error状態を肩代わり。本のHOC例（loading/data/error手動管理）は今はこれ一発で解決するのが主流
  - クライアント状態とサーバー状態を分けて考える発想がここ数年で定着

使い分け目安: 値の種類が多くて互いに独立 → atom分割（Jotai）。1つの状態が複雑に遷移 → reducer系（Redux/ステートマシン）。素朴にstate+action詰め込みたい → Zustand。
