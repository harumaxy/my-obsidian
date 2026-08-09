---
title: fluent-react-nextjs-remix-architecture
description: Next.js(RSC)とRemixのアーキテクチャ差整理。SSR/CSR誤解の解消
# permalink:  # don't use
aliases:
  -
tags:
  - react
  - nextjs
  - remix
  - ssr
draft: false
date: 2026-08-09
---

出典: 『流暢なReact』(Tejas Kumar, O'Reilly) 第8章 フレームワーク + 対話整理

## 境界の粒度が根本的差

- Next.js: サーバ/クライアント境界 = **コンポーネント単位**(RSC採用。デフォルト全部サーバコンポーネント、`"use client"`付けたものだけクライアントバンドル行き)
- Remix: 境界 = **ルートファイル単位**(`loader`/`action` export vs デフォルトexportコンポーネント。RSC不使用)

## なぜNext.jsはコンポーネント内`await db.list()`OK

サーバコンポーネントはクライアントバンドルに一切含まれない仕組み(RSC)。DB SDKや秘密鍵混じっててもクライアントに漏れない。この判定は専用バンドラー/コンパイラがコンポーネント単位で静的解析してる。

## なぜRemixは`loader`にデータ取得を分離必須か

Remixは全コンポーネントがクライアントバンドル対象(フルハイドレーション)。コンポーネント本体に直接DB呼び出し書くとクライアントにも漏れる。なので同一ファイル内で`loader`という別exportに分離、ビルド時に**export名という単純な規約**でクライアントバンドルから機械的に除去。RSCのような実行時境界判定は不要。

## 誤解: Remix = SPA CSR + APIサーバー？ → 違う

`loader`がサーバ専用扱いされてるせいで「クライアントが毎回API叩いてるだけの薄いラッパー」に見えるが誤り。

- 初回リクエスト: `loader`関数を**同一プロセス内で直接呼び出し**(HTTP経由でない)→結果を`renderToPipeableStream`でHTMLに焼き込んで返す。完全SSR。SEO/TTFBの恩恵そのまま享受
- ボット判定(`isbot`)で出し分け: ボット→`onAllReady`(コンテンツ確定待ってから返す)、通常ブラウザ→`onShellReady`(シェル先出しストリーミング)
- 2回目以降のナビゲーションのみ`loader`をfetchでデータ取得→クライアント側で通常のReact再レンダリング(ここは確かにSPA的)

= 伝統的「SSR + フルハイドレーション + 以降SPACSRナビゲーション」という古典的ユニバーサルReactモデル。Next.js pages routerや昔のisomorphic Reactと同系統。

## Next.js(App Router/RSC)のナビゲーションモデル

初回ロードで受け取る3アーティファクト:
1. **HTML** → 即座に非インタラクティブなプレビュー表示
2. **RSCペイロード**(HTMLに同梱) → コンポーネントツリー再構築(reconcile)用
3. **JS** → Client Componentsのハイドレーション用

2回目以降のナビゲーション: HTMLは送らずRSCペイロードだけfetch(`rsc`ヘッダーで要求)。Server Componentsの出力は**サーバ側で再実行されてペイロードにシリアライズ**、クライアントはそれをツリーに差し込むだけ。Client Componentsはクライアントで通常にレンダリング。

RSCペイロード = Reactの仮想ツリーをシリアライズしたJSON風ストリーミングフォーマット(React Flight)。要素・データ・Client Componentモジュール参照が混在。

## 対比表

| | 初回 | 以降ナビゲーション |
|---|---|---|
| Remix | フルHTML(SSR) | `loader`データだけfetch→クライアントで通常React再レンダリング(コンポーネント自体はクライアント実行) |
| Next.js | フルHTML + RSCペイロード同梱 | RSCペイロードのみfetch。Server Component分はサーバ側で毎回再実行、結果をペイロードとして受信 |

最大の違い = **2回目以降、サーバ側コンポーネントの再実行が発生するか**。RemixはHTMLレンダー用コンポーネントもクライアントで動かす。Next.jsはServer Componentをナビゲーション毎にサーバで再実行してその結果を送る。

## トレードオフまとめ

- Next.js: 粒度細かい(コンポーネント単位でco-locate可能)。代わりにRSCという新しい実行モデル・`"use client"`/`"use server"`境界の理解コスト背負う
- Remix: 粒度粗い(ルート単位、`loader`に集約必要)。代わりに普通のReactのメンタルモデルのまま、境界はビルドツールの静的export分離だけで理解しやすい

## `useEffect`はSSRで実行されない

React公式: *"Effects only run on the client. They don't run during server rendering."*

SSRは「コンポーネント関数呼んでJSX→HTML文字列変換」だけの処理。`useEffect`はコミット(DOM反映)後にスケジュールされるが、サーバにDOM自体存在しない→コミットフェーズ発生しない→`useEffect`丸ごとスキップ。

だから`useEffect`内`fetch`はSSR結果のHTMLに反映されない。ハイドレーション完了後、クライアントで初めて発火→そこでfetch→再レンダリングでデータ反映(2段階)。エラーにはならないが、その部分だけSSRの恩恵(SEO/初期表示にデータ入り)を得られない。

SSRでデータ入りHTML返すには`useEffect`でなく別経路必須:
- Remix: `loader`(レンダリング前にサーバでawait済ませておく)
- Next.js: サーバコンポーネント本体で直接`await fetch()`(コンポーネント関数自体が非同期関数としてサーバ実行される)

いずれも共通点: **レンダリング(JSX→HTML変換)より前にデータ取得を完了させておく**設計。`useEffect`はレンダリング後発火なのでSSRのタイミングに本質的に間に合わない。

## `useLoaderData`自体はサーバ/クライアントで分岐しない

`useLoaderData`の実体 = 「今のルートのloaderデータをルーター内部状態から**同期的に読むだけ**」の薄いフック。フック自体にサーバ/クライアント分岐コードはない。変わるのは**データが用意される経路**の方:

- 初回SSRレンダー時: Remixが`loader`を先に`await`済ませ、ルーターのコンテキストに積んでおく → レンダリング中`useLoaderData`はそこから取り出すだけ
- クライアント遷移時: ルーターが遷移先の`loader`をサーバへfetch(裏で`loader`関数実行→JSON返す)→結果到着後ルーター状態更新→再レンダリング→`useLoaderData`は更新後の状態を読むだけ

常に「すでに用意済みのデータを読む」という単一動作。

### 例外: `clientLoader`併用時

`clientLoader`を追加exportすると経路が変わる:
- 初回SSRハイドレーション時: `clientLoader`は走らない(`loader`のSSR結果そのまま使用)
- クライアント遷移時: `loader`でなく`clientLoader`が使われる(例: サーバ遷移時はDB直叩き、クライアント遷移時は公開APIエンドポイント経由、という出し分け可能)

デフォルト(`clientLoader`未使用)なら常に同じ`loader`が呼ばれ続ける。

## 関連

[[fluent-react-ssr-hydration-resumability]]
