---
title: PR TIMES が Next.js から React Router に移行
description: PR TIMES 開発者ブログ要約と、Next.js / TanStack Start 周りの会話メモ
aliases:
  -
tags:
  - react
  - nextjs
  - react-router
draft: false
date: 2026-11-06
---

元: https://developers.prtimes.com/2026/10/06/migrate-from-nextjs-to-react-router/ (2026-10-06)

## 要約

- PR TIMES (月間 9000 万 PV) が Next.js (Pages Router) から React Router へ移行。
- 動機
  - 新機能は App Router 中心。Pages Router のままだと更新の恩恵が少ない。
  - HTML は `getServerSideProps` で生成し Fastly でキャッシュ。API で即時削除でき、キャッシュ層が 1 つで挙動を把握しやすい。App Router のキャッシュ / RSC の利点が薄い。
  - webpack で dev 起動とビルドが遅い。Turbopack は挙動が変わる箇所があり見送り。
- 移行先選定 (2026-05 頃、Next 15 / React 18 / React Router 7 / Vite 8 / TanStack Start 1 RC)
  - 条件: Vite が使える (v8 は Rust 製 Rolldown)、React 資産を使い続けられる (2021 年から jQuery→React 移行中)。
  - TanStack Start を選ばなかった理由: RC だった、ECS 前提で Portable Application Model の利点が小さい、Nitro でサーバをビルドする分 React Router より遅い、サーバー機能が不要。
- 移行方法
  - 最初の 1 ページは人が手で移行 → 同じ方針で Claude Code 等に横展開。
  - `eslint-plugin-no-next-restricted` で `next/image` など Next 固有 API を以前から lint 禁止していたので、`getServerSideProps` → `loader` 程度の変更で済んだ。
  - 既存の Playwright VRT を流用。Next のスナップショットを正にして React Router 版に同じテストを実行。`webServer.command` を環境変数で切替。
  - Fastly VCL の `randombool` で ECS への振り分けを 1 → 10 → 50 → 100%。キャッシュは共有なので、割合は「キャッシュミス時にオリジンへ送る分」。実際の閲覧は New Relic の PageView (Application ID を分けて) で確認。
- 効果
  - ビルド 37 秒 → 3 秒 (Next 側に有利な条件: lint / 型チェック skip、`.next/cache` あり。React Router 側は Vite キャッシュなし)。
  - Docker イメージ 231.76MB → 92.69MB (Dockerfile・multi-stage は変更なし)。
  - ECS デプロイ 6分46秒 → 4分30秒。
- 問題
  - 静的アセットが `/assets/` 配下になる。PHP が HTML を配信する箇所もあり広いスコープを避けたい。`assetsDir: '_react-router/assets'` に変更し、カスタム Express サーバーで配信。
  - `react-router-serve` が `/assets` に付ける immutable キャッシュを、新パスに合わせてカスタムサーバー側で付け直す。

## 会話メモ

### 小規模サイトでは Next.js 不要、という話ではない

- 大規模サイトでも、使う機能次第で Next は不要になる。PR TIMES は「SSR + loader」だけで足り、Next の強み (RSC、App Router のキャッシュ、ISR、画像最適化、Vercel 連携) を使っていなかった。
- 使っているなら Next のままが妥当。記事も Next 全般を否定してはいない。

### CDN 側がページキャッシュを担う件

- ページキャッシュは Fastly が担当 → Next は HTML を作るだけ。Cloudflare / CloudFront / Akamai でも同様に言える (パス単位キャッシュ + purge API)。
- 画像最適化は記事に記載なし。`next/image` は lint で禁止していたが、代替が CDN かは不明。
- CDN の画像リサイズで `next/image` のサーバー側リサイズは代替できる。ただし srcset 生成、遅延読み込み、レイアウトずれ防止などのコンポーネント側は別途必要。

### 自前で動いているなら Next は不要か

- 判断軸は「使っている Next の機能を、外した後に持ち続けるコストが払えるか」。React Router + Vite も薄いフレームワークで、完全自前ではない。
- PR TIMES は痛み (Pages Router の停滞、webpack の遅さ) があり、VRT と段階リリースの仕組みも整っていた。
- 痛みがなければ動機がない。移行自体がコスト。
- 事前に Next 固有 API を lint で禁止していたのが、移行コストを下げた最大の要因。

### Next のビルドが遅い理由 (推測。未計測)

- 記事で確実なのは webpack (JS 製) と Vite 8 (Rust 製 Rolldown) の差まで。
- 加えて `next build` の工程が多い: ページの静的 / 動的解析と事前レンダリング、サーバー / クライアント複数バンドル、ルート manifest、実行ファイルのトレース。React Router はバンドル生成が中心。
- Turbopack を使えば差は縮む可能性。ただし記事では挙動差で見送り済みで、移行コストなしで得られる改善ではない。

### TanStack Start (公式 docs で確認)

- 「SPA にサーバー機能を足す」より、TanStack Router の上に載った SSR 前提のフルスタックフレームワーク。
- SSR + hydration がデフォルト。ルート毎に full / data-only / SSR なしを切替 (selective SSR)。専用 SPA モードもあり。
- 型安全な server functions (GET / POST)、server routes、ミドルウェア、Validator API。ルーティングは TanStack Router に 100% 依存。Vite / Rsbuild でビルド。
- RSC は実験的 opt-in。Next は RSC 中核、React Router は loader / action 中心、Start は型安全 RPC 中心。
- ISR 相当は HTTP キャッシュ + プロバイダー固有設定。Next のような一体型キャッシュはない。
- PR TIMES の用途 (SSR + loader) には過剰だった。型安全な RPC や Router の型推論を活かす新規フルスタックなら有力。
