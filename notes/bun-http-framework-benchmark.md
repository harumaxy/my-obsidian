---
title: bun-http-framework-benchmark
description: SaltyAom の JS HTTP フレームワーク比較ベンチ。uWS、TechEmpower との比較、実用フレームワーク選定の整理。
# permalink:  # don't use
aliases:
  - Bun HTTP Framework Benchmark
tags:
  - benchmark
  - javascript
  - backend
  - bun
  - elysia
draft: false
date: 2026-10-12
---

https://github.com/SaltyAom/bun-http-framework-benchmark

## これ何

- JS HTTP フレームワーク スループット比較。作者 = Elysia 作者 (SaltyAom)
- ツール bombardier。`bun benchmark` で実行
- 対象 Bun / Node / Deno の 3 ランタイム、26 構成
- Go / Rust は入ってない。JS ランタイム内の比較だけ

### テスト 4 種

- Ping: `GET /` → `Hi`
- Query: `GET /id/:id?name=bun` → `1 bun`。query は動的パース必須
- Body: `POST /json` → JSON パースして再シリアライズ
- Video: `GET /video` → 14MB mp4 ストリーム。同時接続 10
- 背景ルートを全実装に同数登録。ルーター規模を揃える
- 保守要件: 最終リリース 9 ヶ月以内。Express は例外

### 結果 (平均 req/s)

- uws (node) 267k
- elysia-aot (bun) 214k
- elysia (bun) 211k
- h3 (bun) 175k
- bun 素 173k。起動 4ms、メモリ 27MB
- hono (bun) 171k
- Node 勢は Bun の約半分
- 最下位 express 44k〜63k、koa 44k、nest 34k、oak 24k、acorn 10k
- Video は Bun 約 1,600 req/s、Node / Deno は 220〜440。Bun のストリーム強い
- 計測機 i7-13700K、Bun 1.4.2、Node 26.1.0、Deno 2.9.4

## Elysia すげー宣伝か？

- 半分正解。作者本人のベンチなので利益相反あり
- でも 1 位は Elysia じゃない。bun 素・h3・hono も近い
- Node 上の Elysia は 96k で普通。Elysia 自慢というより Bun 自慢
- Hello World 級。DB 入れば差は縮む
- 自機材で自己計測。第三者再現なし
- ルールとコードは公開。話半分で見れば OK

## uWS (uWebSockets.js)

- フレームワークじゃない。C++ 製 HTTP / WebSocket サーバーを V8 ネイティブアドオンで公開したもの
- 作者 Alex Hultman。Bun の `Bun.serve` の土台にも使われてる
- 速い理由: パースもソケットも C++。Node の `http` 通らない
- ベンチの `DeclarativeResponse`: 固定レスポンスを C++ 側だけで返す。JS 一切走らない
  - Ping / Query 410k 超はこれのおかげ
  - `/json` と `/video` は普通のハンドラ。Body 230k は Deno 素 (233k) と同じ
- 弱点: npm 配布なし (GitHub から直接)、OS・CPU ごとビルド、ルーティングとミドルウェア最低限
- hyper-express、ultimate-express = uWS を Express 風 API で包んだもの
- 結論: 順位表の uWS は「上限の目安」。フレームワークとの勝負じゃない
- 同じ構図が bun 素 (Bun.serve)。素の API が上限、FW は上限からどれだけ落ちるかを見る

## TechEmpower Framework Benchmarks

- 言語横断の定番。Round 23 = 2025-02-24 公開
- リポジトリは 2026-03-24 アーカイブ済み。Round 23 が最後の可能性大
- 2026-03 ブログ = Spring + MongoDB が想定外に遅かった件。調査で MongoDB が 25 倍改善
- テスト 6 種: JSON、Single query、Multiple queries、Cached queries、Fortunes、Data updates、Plaintext
- 今回見たのは Fortunes (DB + テンプレート) だけ。他は未確認
- 公式結果ページは JS 描画。WebFetch は空。Chrome で取得

### Fortunes (523 件、req/s)

- 1 位 may-minihttp (Rust) 1,327k
- 2 位 h2o (C) 1,227k
- 3〜7 位 ntex、xitca-web、axum (Rust)
- 15 位 just-js (JS) 982k
- 17 位 fasthttp-prefork (Go) 959k
- 35 位 aspnetcore 742k
- 69 位 uwebsockets.js 483k。Rust 首位の 36%
- 149 位 elysia 285k
- 166 位 fastify 266k
- 172 位 hono 252k
- 179 位 spring 244k
- 219 位 express 173k
- 396 位 rails 43k
- 424 位 django 32k
- 472 位 laravel 16k

### 気付き

- Bun ベンチの「Elysia 上位」は JS 内だけの話。DB 挟むと Rust 首位の約 21%
- Hello World で uWS 430k、DB 込みで 483k。DB が律速
- 同言語でも差が大きい。Go: fasthttp-prefork 959k、echo 190k、gin 111k
- Rust でも ORM 次第。axum 生 SQL 1,114k、axum sqlx 39k。30 倍差
- Rust だから速い、は成り立たない

## 上位に無名 FW が多い理由

- 上位はベンチ特化の最小実装。`Cls` が Mcr (マイクロ) か Plt (プラットフォーム)、DB は Raw (ORM なし)
- may-minihttp、ntex の `async-std,db` などはベンチ用バリアント
- 認証・バリデーション・ORM・OpenAPI は全部自前になる。生産性低い
- 実アプリの律速は DB と外部 API。25 万 req/s あればほぼ足りる
- 採用理由は速度より人材、ライブラリ、保守、習熟
- マーケ不足は主因じゃない。axum は宣伝なしでも Rust 標準級
- 上位は「最小 HTTP サーバー」。普及する Web FW とは別物

## 実用 FW だけの順位 (Fortunes、Round 23)

- 1M 前後: axum (生 SQL) 1,114k、quarkus + vert.x 1,028k、quarkus + postgresql 917k
- 500k〜850k: fiber-prefork (Go) 848k、aspnetcore 742k、goravel-fiber 549k
- 200k〜450k: fasthttp 442k、asp.net core minimal 446k、quarkus (ORM) 431k、elysia 285k、fastify 266k、hono 252k、spring-webflux-r2dbc 246k、spring 244k、rocket 220k、echo 190k
- 100k〜180k: phoenix 176k、express 173k、nestjs-fastify 160k、gin 111k、fastapi 109k
- 100k 未満: rails 43k、django 32k、symfony 26k、laravel 16k
- 注意: 生 SQL と ORM 混在、実装ごとにチューニング差、データは 2025-02、Fortunes のみ

## 言語選定の考え

- Spring (244k) 以上なら実務で困らない。Spring は業務標準
- 高性能グループ = Go、Rust、Java、C#、Bun、Node。C# と Node も入る
  - fastify 266k は Spring 並み。Elysia 285k との差は約 7%
- 遅いグループ (Rails、Django、Laravel) も本番で普通に動く
  - 1 台 4 万 req/s は国内の大半のサービスのピーク超え
  - 避ける理由は大規模での台数コストとレイテンシ要件
- グループ内の差は体感に出ない。選択はチーム習熟、採用、ライブラリで決める
- 性能理由でグループ跨ぎ乗り換えは、実測で律速確認できた時だけ

### 自分の好み

- 動的型付け (Rails、Django、Laravel) は避けたい
  - 型の後付けはある (Sorbet、mypy、PHPStan)。強制力は弱い
- C# は .NET Framework / .NET Core の分裂が気になる
  - 2020 の .NET 5 で統合済み。今は単に ".NET"。新規は ASP.NET Core だけ見ればいい
  - 分裂の印象が残る理由 = 古い記事と既存業務システム、Unity が Mono / IL2CPP で別物
  - 最新バージョン状況は未確認
- Java / C# の SIer 臭が嫌。好みなので否定しない
  - Kotlin など現代的な書き味の選択肢もある
- 消去法の候補: Go (単純、運用楽、ORM とエラー処理がやや不便)、Rust (最速級、学習コスト大)、TypeScript (言語統一、実行時は型消える)、Kotlin (Ktor、表で 247k)
- 個人開発なら TS か Go、性能詰めるなら Rust

## h3

- Nuxt の HTTP 層として作られた最小 TypeScript 製 HTTP FW
- Nitro (Nuxt のサーバーエンジン) と Nuxt の土台。単体で使う人少ない = 無名な理由
- 作者 UnJS コミュニティ (Pooya Parsa)。これは記憶ベースで未確認
- v2 は Web 標準 `Request` / `Response` / `fetch` が中心。Bun、Deno、Cloudflare Workers で同コード動く
- `app.fetch` を `Bun.serve` に直接渡せる

```ts
import { H3 } from 'h3'
const app = new H3().get('/', () => 'Hi')
Bun.serve({ port: 3000, fetch: app.fetch })
```

- ベンチ: Bun 175k (4 位)、Node 99k、Deno 131k。バンドル 31KB (Elysia 187KB)
- Hono との違い: 設計思想は近い。Hono = Cloudflare 寄りでミドルウェア豊富。h3 = Nuxt/Nitro 前提
- Nuxt 使わないなら Hono が無難。コミュニティも大きい
