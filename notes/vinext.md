---
title: vinext
description: Cloudflare 製。Next.js API を Vite プラグインで再実装。Next.js アプリを Vite + Workers で動かす
# permalink:  # don't use
aliases:
  - vinext
tags:
  - nextjs
  - vite
  - cloudflare
draft: false
date: 2026-10-01
---

# vinext

- Cloudflare 作。Vite プラグイン
- Next.js の API 面 (`next/link`, `next/image`, App Router, RSC, Server Actions 等) 再実装
- Next.js 本体コード 使わない。実態 = Vite ベース SSR フレームワーク。ただし独自 API なし、Next.js の書き方そのまま
- 名前 = Vite の `vi` + `next`（推測。公式説明 未確認）
- 目的 = Next.js アプリ Cloudflare Workers に簡単デプロイ。Next.js 公式 Vercel 寄りだから

## 対応済み

- App Router / Pages Router (dev, 本番ビルド)
- RSC, Server Actions, route handlers, middleware
- SSG, ISR, `output: "export"`, standalone Node 出力
- `next/link`, `next/image`, `next/navigation`, `next/headers`, `next/cache`, Metadata API
- Workers デプロイ (bindings, cache adapter, 画像最適化)

## 使い方

```ts
// vite.config.ts
import { defineConfig } from "vite";
import vinext from "vinext";
export default defineConfig({ plugins: [vinext()] });
```

- `app/` か `pages/` 自動検出。`next.config.js` 読む
- scripts: `dev: vite dev` / `build: vite build` / `start: vinext start`

## 移行

- `npx vinext check` = 非対応設定・import 検出
- `npx vinext init` = 互換チェック、依存導入、設定生成、dev 起動 全部自動
- `npx vinext init --platform=cloudflare` = Workers 向け設定生成
- `npx @vinext/cloudflare deploy` = ビルド + デプロイ

## メリット

- Cloudflare Workers 簡単デプロイ。最大の売り
- 既存 Next.js 資産 書き換えほぼ不要
- Vite エコシステム (HMR, プラグイン)
- Vercel ロックイン回避
- 実績例: Vercel App Router Playground, Nextra docs 動く

## 他フレームワーク比較 (自分の整理。公式比較 未確認)

- 勝ち
  - Next.js 資産・知識・ライブラリ そのまま
  - RSC / Server Actions 使える
  - Next.js 前提のサンプル・AI 生成コード 流用可
- 負け
  - 再実装 → 本家との挙動差・未対応リスク。成熟度 低い
  - Next.js の複雑さ (キャッシュ, RSC 境界) 引き継ぐ
  - Cloudflare 対応は Remix, TanStack Start, SvelteKit も可能。独自利点 = 「Next.js のまま」だけ
- 使い分け
  - 既存 Next.js を Cloudflare に移す → vinext
  - 新規 Cloudflare 向け → TanStack Start / React Router v7 / SvelteKit

## 未確認

- ビルド速度・バンドルサイズ数値 (vinext.dev/benchmarks に あるらしい)
- `next` パッケージ 依存に残す必要あるか
- 本家との互換性の穴

## 出典

- Context7: `/cloudflare/vinext`
- https://github.com/cloudflare/vinext
