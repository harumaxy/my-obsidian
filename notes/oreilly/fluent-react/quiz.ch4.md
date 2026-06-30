---
title: "Fluent React Chapter 4: 復習問題"
description: Chapter 4「内部 Reconciliation」の復習問題と解答
aliases:
  -
tags:
  - react
  - fluent-react
  - reconciliation
  - quiz
draft: false
date: 2026-06-28
---

# Chapter 4 復習問題

## Q1. React Reconciliation（リコンシリエーション）とは何か？

**A.** ReactがJSXから生成した仮想DOM（望ましいUI状態）を受け取り、実際のDOM環境（ブラウザなど）に効率よく反映するプロセス全体のこと。差分計算・バッチ処理・コミットまでを含む。

---

## Q2. Fiber データ構造の役割は？

**A.** コンポーネントツリーを表すステートフルで長寿命なノード。React要素（一時的・ステートレス）とは異なり、Props・State・子コンポーネント情報に加え、ツリー内の位置情報（親・子・兄弟の参照）も保持する。これにより更新の**優先度付け・中断・再開**が可能になる。

---

## Q3. なぜ2本のツリー（current / workInProgress）が必要なのか？

**A.** グラフィックスのダブルバッファリングと同じ原理。`current` ツリーは現在画面に表示されている状態、`workInProgress` ツリーは次の状態を構築中のもの。2本を分離することで：
- レンダリング中に現在のUIを壊さずに済む
- 途中で中断・破棄しても現在のUIはそのまま維持できる
- 準備完了後に `commitRoot` でポインタを切り替えるだけで即座に反映できる

---

## Q4. アプリケーションが更新されるとどうなるのか？

**A.** 以下の流れで処理される：

1. **レンダリングフェーズ**（割り込み可能）
   - `beginWork` でツリーを下りながら変更フラグを設定
   - `completeWork` でオフスクリーンにDOMツリーを構築
   - `renderLanes` で優先度を管理し、高優先度の更新があれば割り込み
2. **コミットフェーズ**（割り込み不可）
   - ミューテーションフェーズ：変更を実DOMに適用・不要ノード削除
   - レイアウトフェーズ：新しいレイアウトを計算（`useLayoutEffect` 実行）
   - ブラウザペイント後：パッシブエフェクト（`useEffect`）を実行
3. **`commitRoot`** で `workInProgress` を `current` に切り替え、次の更新はこのツリーを基準に行われる
