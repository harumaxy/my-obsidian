---
title: Hono公式 Inertia アダプタ — @hono/inertia リリース
description: yusukebe 作の @hono/inertia 公式リリースによる「the modern monolith」体験レポート
# permalink:  # don't use
aliases:
  -
tags:
  - hono
  - inertia
  - react
  - spa
  - zod
draft: false
date: 2026-06-25
---

# Hono公式 Inertia アダプタ — @hono/inertia リリース

> 元記事: https://zenn.dev/ashunar0/articles/cc351badf8681c
> 著者: あさひ / 公開日: 2026年4月28日

## 概要

Hono 作者 yusukebe さんが正式リリースした `@hono/inertia` の実装体験レポート。

## SPA 開発から消えるもの

| 消えるもの | 理由 |
|---|---|
| API エンドポイント | JSON を返すだけのルートが不要になる |
| React Router | ルーティングがサーバー側に集約される |
| `useEffect` + `fetch` | データ取得パターンが不要 |
| データ用 `useState` | 状態管理がサーバー主導になる |

## 嬉しいポイント

**修正箇所が 2 箇所に絞られる**
- `src/server.tsx`（サーバーロジック）
- `app/pages/`（React コンポーネント）

**Zod スキーマ 1つから 3つが派生する**
- TypeScript の型定義
- サーバー側のランタイムバリデーション
- クライアントのエラーメッセージ表示

バリデーション失敗時もエラーを「props の一種」として扱うため、ユーザーの入力値も自動保持される。

## テンプレートエンジン SSR との違い

```
Laravel Blade/Rails ERB  →  サーバー主導だが UI はレガシー
Next.js App Router       →  モダン UI だが API 設計が必要
Hono × Inertia           →  サーバー主導 + モダン React UI + 型安全
```

- ページ遷移が SPA（フルリロードなし）
- React / Tailwind など フロントエンドエコシステムがそのまま使える
- サーバーの型がクライアントまで自動で流れる

## まとめ

「**the modern monolith**」— Laravel 的なサーバー主導モデルを Hono + React で現代に蘇らせた設計思想。API 設計の認知負荷をゼロにしつつ TypeScript の型安全性は失わない。
