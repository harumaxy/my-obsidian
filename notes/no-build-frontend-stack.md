---
title: no-build-frontend-stack
description: ビルドツールチェーン無しのモダンweb開発、依存最小構成の検討メモ
# permalink:  # don't use
aliases:
  -
tags:
  - web
  - frontend
draft: false
date: 2026-09-13
---

## 問題意識

TypeScript, React, Tailwind, Vite等 ツールチェーン無し、依存最小でデザイン性・コンポーネント性・インタラクティブ性・パフォーマンス・宣言性・カスタマイズ性 兼備 web開発 可能か検討。

## 構成候補

- **Pico CSS**: classless CSS。CDN一行、ビルド不要。CSS変数(`--pico-primary`等)でカスタマイズ、コンポーネント単位の上書きも可。
- **状態管理・インタラクティブ性**: 複数候補比較(下記)
- **Web Components**: ネイティブ`customElements.define` + `<template>`。フレームワーク無しで再利用コンポーネント作成可。Alpine/Preact等と共存可(内側に書く)。
- **ネイティブESM**: `<script type="module">` + `import`。バンドラー不要、ブラウザ標準機能でモジュール分割。npm依存が要る場合もCDN経由ESM(esm.sh, jsdelivr等)で解決、node_modules不要。
- **View Transitions API + CSS**: JS無し画面遷移アニメーション。`@starting-style`, `:has()`等 新CSS機能と組み合わせ、SPA的な画面切替もライブラリ無しで実現可。
- **Deno**: 実行環境でなくエディタLSP用途として採用。`deno.json`の`imports`フィールドでimport map定義、package.json/node_modules 一切不要。esm.sh等が返す`X-TypeScript-Types`ヘッダをDeno LSPが読んで型解決→補完・定義ジャンプ効く。実行はブラウザの`<script type="importmap">`のまま、LSPだけDenoに分離する二枚舌構成が最軽量。

## htm とは

Hyperscript Tagged Markup。タグ付きテンプレートリテラル(ES2015標準構文、Babel不要)を利用しJSX風記法をビルド無しで実現。

```js
html`<div>${x}</div>`
// ↓ 内部で
h('div', null, x)
```

JSXは非標準構文でトランスパイル必須、htmは合法な素のJSでブラウザがそのまま実行。変換処理をビルド時から実行時に移した仕組み。

## 候補比較

| | Alpine.js | Preact + htm | VanJS |
|---|---|---|---|
| 書き方 | HTML属性DSL(`x-data`等) | JS関数、React Hooks相当 | タグ関数、DOM直接構築 |
| 内部 | 独自リアクティブ | VDOM + diff | VDOM無し、fine-grained反応性 |
| Star | 31.6k | 38.6k | 4.2k |
| 週間DL | 約54万 | 約2000万 | 桁違いに小 |
| 強み | Laravel/TALL stack鉄板 | Reactエコシステム丸ごと転用可 | 超軽量(1KB) |
| 弱み | 状態がHTML属性に散り保守性低下しがち | - | 実績薄い、2023年発足 |

**結論: Preact + htm 推奨**。ダウンロード数・star数・Reactエコシステム転用・将来性、すべてで頭一つ抜けてる。JS/フロントオンリー用途、React知識の転用したい場合に最適。

## Preact状態管理 3段階

1. ローカル: `useState`
2. 親子〜近い階層: state持ち上げ + props、面倒なら`Context`(`createContext`+`useContext`)
3. アプリ全体・再レンダリング最小化: `@preact/signals`。モジュールスコープでsignal定義→どこからでも読み書き、値を使ってる箇所だけピンポイント更新(Redux/Zustand相当が要らない)

```js
export const cartCount = signal(0); // モジュールスコープ = グローバル共有
```

## 新興の競合調査(2026-09時点)

- **Datastar**: htmx+Alpineの機能統合、`data-*`属性でsignal管理、SSE経由サーバー駆動UI。htmxからの分家(公式後継ではない)。11.8KB一行導入。star規模はhtmx(47.8k)に及ばずまだpre-release(v1.0.0-RC.8)。SSRサーバーロジック前提の設計なので、フロントオンリー用途だとAlpine相当の部分しか使わず旨味半減。
- **htmx**: 「完成品」宣言、意図的に安定志向(2025年の書き方が2035年も変わらない方針)。廃れるというより変化を止めてる立場。
- **VanJS**: 上記比較参照。ニッチ止まり。

## Web Components の要否

Preact等JSフレームワーク使うなら基本不要。コンポーネント再利用・状態管理・DOM更新、フレームワーク側で完結するため、WC重ねると二重管理(Preactコンポーネント定義+WC wrapper定義)になるだけ。

要る場面: 他フレームワーク/素のHTML環境への部品配布、CMS管理画面等の埋め込みウィジェット、Shadow DOMでのスタイル隔離が要る場合のみ。

Lit等の軽量ラッパー: `observedAttributes`等の定型コード減らせるが、結局「別ライブラリへの依存」に変わるだけ。単一Preact SPA構成では旨味薄い(PreactをLitに置き換えてるだけ)。フレームワーク非依存が目的なら素のCustom Elements APIで書くのが筋、記述量許容できないなら最初からPreactに寄せる方が合理的。

## node_modules/package.json排除したい場合のツール比較

- **Deno**: `npm:`指定子で外部パッケージをnode_modules無しで直接import可能(グローバルキャッシュに取得)。`deno.json`のみで完結、`nodeModulesDir`を明示有効化しない限りnode_modulesは生成されない。要求に一番マッチ。
- **Bun**: `auto-install`という近い機能あるが実験的位置づけ。標準の`bun install`/`bun run`は基本node_modules前提のツール。
- **Node + npm/yarn/pnpm**: package.json/node_modules前提。pnpmもシンボリックリンクで容量削減するだけでnode_modules自体は生成される。今回の要求とは思想が逆。

→ 開発ツールはDeno一択でいい。

## classless CSSフレームワーク比較(Pico/Water以外)

| | CSS変数 | テーマ切替 | コンポーネント | サイズ |
|---|---|---|---|---|
| Pico | `--pico-*`数百、コンポーネント別に細分化 | `data-theme`属性で強制切替可 | modal/tooltip/accordion/dropdown/card等 厚い | 複数バリエーション選択可 |
| Water | `--links`等十数個、シンプル | 自動(`prefers-color-scheme`)、属性切替は自作要 | 基本タグのみ | light/dark/auto 3種 |
| New.css | `--nc-*`約10個×light/dark | 自動のみ | 基本タグのみ | 4.8KB |
| MVP.css | `--color-*`等約20個 | `color-mode="user"`属性でOS明示追従 | dialog(モーダル)・details 対応で地味に厚め | 単一ファイル |
| Simple.css | 約15個 | 自動のみ、dialog活用 | dialog以外は基本タグのみ | 圧縮20KBとやや重め |
| Sakura | **CSS変数非対応**(SCSSビルド時8個のみ) | ファイル切替(8色テーマ、media属性で出し分け) | 基本タグのみ | 4KB |
| Bamboo | `--b-*`10個(Nordテーマ配色) | ファイル切替(dark.min.css/light.min.css) | 基本タグのみ | 5.3KB激軽 |
| Awsm | **CSS変数非対応**(PostCSSビルド時テーマ指定) | ファイル切替(8色×sealed版で36ファイル) | 基本タグのみ | gzip3KBで最軽量 |

CSS変数の動的切替(JS等でランタイムに`data-theme`等トグル)対応: Pico/Water/New.css/MVP.css/Simple.css/Bamboo。Sakura/Awsmはファイル/ビルド差し替え方式でJS動的切替に不向き。

→ 結論変わらず **Pico**。CSS変数の粒度・実装コンポーネント数、この中で頭一つ抜けてる。

## ルーティング

`preact-router`は旧、公式後継は**preact-iso**。`:id`/`:id?`/`*`パスマッチ、`lazy()`でコード分割、prerender/hydrate対応。importmapに1行で導入可(`https://esm.sh/preact-iso@2?external=preact`)。今回規模なら素のhashchangeで足りる、結論変わらず。

## PicoCSSの限界

shadcn/uiのような「コピーしてコード資産化、自由に改造」方式ではなく、完成品CSSをlinkする配布モデル。本格デザイン(独自デザインシステム、細かいバリアント)には力不足、管理画面/プロトタイプ止まりが妥当ライン。

## レイアウト(Grid/Flexbox)

Picoは`.grid`(auto-layoutカラム、768px以下で縦積み)と`role="group"`(横並び、崩れない)の2種のみ。Tailwind的なutilityクラス群は無い(公式も「複雑レイアウトは外部ライブラリ検討を」と明言)。複雑なレイアウトは素のCSS(flex/grid)を直書きすればよく、Web Component化は不要(レイアウトはCSSの責務)。

## CSS Modules代替(ビルドレス)

CSS Modulesの自動スコープは再現不可。代替候補: BEM命名(手動)/**ネイティブCSS Nesting**(2026-06 Baseline Widely Available到達、グローバル対応94.1%、実用十分)/`@scope`/Shadow DOM/`@layer`。
現実解: BEM+Nesting併用。コンポーネントルートにだけ一意なクラス名つけて、中身はネストでタグセレクタ書けば全要素命名の手間が要らない。

## Tailwind併用

Pico公式に併用専用ビルド`pico.conditional.min.css`あり、`.pico`クラスでスコープ分離すれば技術的には共存可能。ただしビルドレスでTailwind使うにはPlay CDN一択で、公式が「開発専用、本番不可」と明言。Tailwindは本質的に「使用クラスを静的解析してパージ」するビルド前提の設計で、ビルドレス思想と根本的に不一致。**不採用**。

## テスト・E2E(Deno)

- **ユニットテスト**: `Deno.test()`組み込み + `@std/assert`(jsr)。node_modules不要、`deno test`一発。DOM単体テストが要るなら`happy-dom`+`@testing-library/dom`をnpm指定子で(node_modules生成なしで動作)。
- **開発サーバー**: `deno serve --watch`組み込み(ファイル変更検知)、`@std/http/file-server`の`serveDir`で静的配信。
- **E2E**: 2択。
  - `npm:playwright` — Deno2以降`node:child_process`周り改善で安定動作するとの報告あり、ただしブラウザインストール等Node.js前提の挙動が一部残る。
  - **Astral**(`jsr:@astral/astral`) — Deno専用に一から書かれたPuppeteer/Playwright的ライブラリ。`launch()`でChromium自動DL、`page.locator()`で要素出現待ち+リトライ(レースコンディション対策)、`await using`でリソース自動クローズ。node_modules概念自体が存在しない。
  - → node_modules排除方針を貫くなら**Astral**が一貫性あり。

## 結論

- 見た目: Pico CSS
- ロジック: Preact + htm(CDN、`esm.sh`経由)
- ルーティング: 素の`hashchange`イベント + 条件分岐で足りる(要るなら公式後継の`preact-iso`)
- スタイル追加分: CSS Nesting + 最小限のBEM命名(ルートのみ)
- エディタ: Deno LSP(`deno.json`の`imports`)でpackage.json/node_modules無しで型補完
- 開発ツール: Deno(`npm:`指定子でnode_modules無しで外部パッケージ利用、devサーバー・タスクランナーも兼務)
- Web Components: 不採用。単一Preact SPA構成では不要、他環境への部品配布要件が出たら再検討
- Tailwind: 不採用。ビルド前提の設計思想がビルドレス方針と不一致
- テスト: ユニット`Deno.test`、E2E`Astral`(jsr、node_modules不要)
