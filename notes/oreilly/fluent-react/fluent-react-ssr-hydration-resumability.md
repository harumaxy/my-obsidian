---
title: fluent-react-ssr-hydration-resumability
description: SSR/ハイドレーション/resumability の対比整理
# permalink:  # don't use
aliases:
  -
tags:
  - react
  - ssr
draft: false
date: 2026-08-09
---

出典: 『流暢なReact』(Tejas Kumar, O'Reilly) 第6章 サーバ側React

## CSR限界

- SEO: JS未実行クローラー存在 → インデックス漏れリスク
- パフォーマンス: JS DL→解析→実行→レンダリング で time to interactive 遅延
- セキュリティ: 全コードクライアント配布 → CSRF脆弱性。サーバ管理下ならSSR追加で対策強化

## SSR利点

初回ペイント高速・SEO向上・処理能力低いクライアント救済。ただし初期HTML静的、インタラクティブ性なし。

## ハイドレーション

サーバHTMLにイベントリスナー等アタッチする過程。

流れ:
1. サーバHTML生成→クライアント送信(静的)
2. クライアントJSバンドル全DL・解析・実行
3. React仮想DOM構築→実DOM突き合わせ→リスナー再アタッチ

= サーバ側で計算済UIツリーをクライアントが**ゼロから再構築**。ここがコスト源、遅いと批判あり。

DOM構造とReactコンポーネント構造の不一致は不可(不一致→リスナー誤アタッチ)。

## 対 resumability

1. サーバでレンダリング+インタラクティブ挙動もシリアライズしHTML埋め込み
2. クライアントはデシリアライズのみ→サーバの続きから「再開」
3. JS実行はユーザ操作発生時点まで遅延(fine-grained lazy loading)

再構築でなく**再開**。クライアント側「ゼロから作り直す」工程を省略、TTI短縮狙い。

書籍では実装複雑さがコストに見合うか、コミュニティ内議論継続中と紹介(結論は出してない)。

## 複雑さの所在: 実装側の話

`resumability`実装フレームワーク側(利用アプリ側でない)の複雑さ:

- 全インタラクティブ状態・イベントハンドラをシリアライズ可能形に変換する仕組み必要(クロージャ内部までシリアライズ対象)
- どのJSをいつ・どの単位で遅延ロードするか、fine-grained依存追跡機構必要
- サーバ・クライアント間で同一実行状態再構築するプロトコル設計必要

## 実装例: Qwik (QRL)

resumability提唱・実装する実フレームワーク。React系には標準API採用されていない。書籍内には固有名詞言及なし(一般知識で補足)。

**やってること = evalではない**。コード文字列evalでなく、コードをchunk分割しデータだけシリアライズする方式。

- ビルド時コンパイラが各クロージャを別JSファイルに分割抽出
- HTML側には実行コードでなく参照(QRL: Qwik URL)埋め込み

```html
<button on:click="./chunk_a3f.js#Component_onClick_x8k">
```

- シリアライズ対象はクロージャが捕捉した値(状態・props)のみ。コード本体は対象外
- クリック発生時、`import()`で該当chunkのみ動的ロード→実行

eval方式との違い:

- eval: コード文字列埋め込み→`eval()`/`new Function()`実行→静的解析不可→セキュリティリスク
- QRL: ファイルパス参照+捕捉データ埋め込み→静的`import()`→静的解析可能→通常importと同等の安全性

複雑さの正体 = どのクロージャがどの変数を捕捉してるか、ビルド時コンパイラが正確解析しchunk境界を決める工程。ハイドレーションにはない工程。

## ReactサーバレンダリングAPI比較

| API | 特徴 |
|---|---|
| `renderToString` | 同期・ブロッキング。小規模向け。ストリーミング非対応→TTFB遅い |
| `renderToPipeableStream` | React18〜。Node.jsストリーム返却。Suspense完全対応、チャンク単位配信 |
| `renderToReadableStream` | ブラウザストリーム版。API自体は`renderToPipeableStream`類似 |

`renderToPipeableStream`はSuspense境界を`<template>`+HTMLコメント+`$RC`関数(難読化JS)でマーキング、データ到着後DOM差し替え。クライアント側React未ロードでもこの入替可能。

## 結論(書籍の主張)

自前サーバレンダリング実装非推奨。Next.js/Remix等フレームワーク推奨理由:

- エッジケース(非同期fetch・コード分割)対応済み
- セキュリティ(キャッシュのユーザ間漏洩防止等)組み込み済み
- パフォーマンス最適化(自動コード分割等)組み込み済み
