---
title: Hono × Inertia.js による型貫通 SPA 体験
description: Hono と Inertia.js を組み合わせてサーバーからクライアントまで型が一気通貫する SPA を実現する方法
# permalink:  # don't use
aliases:
  -
tags:
  - hono
  - inertia
  - typescript
  - react
  - spa
draft: false
date: 2026-06-25
---

# Hono × Inertia.js による型貫通 SPA 体験

> 元記事: https://zenn.dev/ashunar0/articles/d4a23d3579331a
> 著者: あさひ / 公開日: 2026年4月27日

## Inertia.js とは

- API レイヤを排除した SPA フレームワーク
- サーバーが「コンポーネント名 + props」を JSON（page object）として返し、クライアントが描画
- Laravel や Rails でも採用されている言語非依存プロトコル

## 型貫通の仕組み（4段階）

| フェーズ | 内容 |
|---|---|
| 1. `c.render` の戻り値型宣言 | 関数が `TypedResponse` として型情報を保持 |
| 2. `ExtractSchema` による収集 | Hono が全ルートの出力型を集約 |
| 3. `AppRegistry` での登録 | module augmentation で疎結合に型を結合 |
| 4. `PageProps` で型抽出 | `Extract` ユーティリティでページ固有の props を取得 |

サーバー側で `c.render('Posts/Show', { post })` と書いたデータ型が、クライアントの React コンポーネントで `PageProps<'Posts/Show'>` として自動推論される。

## 他技術との比較

- **Laravel/Rails 版 Inertia**: PHP と TypeScript の二重定義が必要で手動アノテーションが必須
- **tRPC との違い**: tRPC は個別 API 関数レベルの型付け、Inertia はページ全体の props レベル

## まとめ

- わずか **60行のアダプター**で実現
- TypeScript ネイティブ実装でのみ成立する優位性
- 2026年4月28日に `@hono/inertia` として公式 middleware に正式リリース
