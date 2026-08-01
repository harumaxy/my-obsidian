---
title: oxc-ecosystem-2026
description: oxc/Rolldown/Vite8/TanStack Start/PowerSync 2026年現状まとめ
aliases:
  -
tags:
  - frontend
  - oxc
  - vite
  - cloudflare
  - tanstack
draft: false
date: 2026-08-01
---

# oxc エコシステム + モダン Web スタック 2026

元記事: https://zenn.dev/dress_code/articles/d655cd7a43b936  
（oxlint/oxfmt/tsgo 導入で CI 爆速化した話）

---

## oxc エコシステム

Rust 製 JS/TS ツールチェーン群。**共通パーサー/AST を核に全ツールが動く**。

- **oxc-parser** — 高速パーサー。全ツール AST 共有
- **oxlint** — linter（ESLint 互換、660+ ルール、type-aware 対応）
- **oxfmt** — formatter（Prettier 互換）
- **oxc-transform** — トランスパイラ（Babel 互換）
- **Rolldown** — バンドラー（Rollup 互換）→ **Vite 8 に統合済み**
- **Ezno** — 型チェッカー（開発中）

既存スタックとの比較:
```
既存: ESLint + Prettier + Babel + Rollup + tsc  ← 別々にパース
oxc: 共通AST再利用 → 根本的に処理量が少ない
```

速度感:
- oxlint: ESLint 比 50〜100倍
- oxfmt: Prettier 比 30倍
- Rolldown: ビルド 4〜20倍（プロジェクト規模依存）

---

## Biome との差

- **Biome** — linting + formatting 統合。type-aware linting **なし**
- **oxlint** — `--type-aware` フラグで型情報を使った lint 可能
- oxc は Rolldown/バンドラーまで含む大きなエコシステム。Biome は lint/format 止まり

---

## 2026 年ステータス

- **Rolldown 1.0** — 2026年5月リリース
- **Vite 8** — Rolldown + Oxc 統合済み本番リリース。esbuild + Rollup 完全置換
- **Cloudflare が VoidZero 買収**（VoidZero = oxc/Rolldown/Vite 開発元）
  - MIT ライセンス維持・ベンダー中立性公約
  - $100万ドル Vite エコシステム基金設立

### Vite+（vite-plus）

oxc 全部入りツールチェーン。2026年3月 Alpha → 現在 Beta。

```bash
vp dev    # Vite + Rolldown 開発サーバー
vp check  # Oxlint + Oxfmt + 型チェック
vp test   # Vitest
vp build  # Rolldown ビルド
```

含まれるもの: Vite・Rolldown・Vitest・Oxlint・Oxfmt・tsdown・Vite Task

---

## Cloudflare Workers + React 構成

### フレームワーク推奨: TanStack Start

- Cloudflare が**公式パートナー**（スポンサー）
- `@cloudflare/vite-plugin` で dev 時も workerd（本番と同一ランタイム）で動作
- TanStack Router ベースの型安全フルスタック

セットアップ:
```bash
bunx create-cloudflare@latest my-app --framework=tanstack-start
cd my-app
bun install
bun run dev
bun run build
bunx wrangler deploy
```

SPA のみなら:
```bash
bunx create-cloudflare@latest my-app --framework=react
```

---

## TanStack CLI アドオン一覧メモ

カテゴリ別:

**認証**
- WorkOS — Enterprise SSO/SAML/ディレクトリ同期。B2B向け
- Clerk — ユーザー管理・ソーシャルログイン
- Better Auth — OSS 認証。NextAuth 後継ポジション。自前ホスト可

**DB / ORM**
- Prisma — TypeScript ORM 定番
- Drizzle — 軽量 ORM。SQL 近い書き方。Cloudflare D1 相性◎
- Neon — サーバーレス Postgres
- Convex — リアルタイム DB + バックエンド BaaS
- TanStack DB — クライアント内組み込み DB（後述）

**API**
- tRPC — 型安全 API（定番）
- oRPC — tRPC 似の軽量 RPC
- Apollo Client — GraphQL

**UI / テスト**
- Shadcn — Tailwind ベース UIコンポーネント
- TanStack Table — 高機能テーブル
- TanStack Form — 型安全フォーム
- Storybook — コンポーネントカタログ
- Vitest（Query 等に内包）

**ビルド / 環境**
- T3Env — 型安全な環境変数
- React Compiler — 自動メモ化（useMemo/useCallback 不要化）
- Paraglide — 型安全 i18n

**分析 / 外部サービス**
- PostHog — プロダクト分析・セッション録画
- Sentry — エラーモニタリング
- Shopify — EC 統合
- Strapi — ヘッドレス CMS

**おすすめ Cloudflare 鉄板構成**: Drizzle + Better Auth + TanStack Query + Shadcn + T3Env

---

## TanStack DB

API データをクライアント側で正規化コレクション保持 + ライブクエリで UI 反応。  
TanStack Query の進化版ポジション。現在 **Beta**。

- サブミリ秒のライブクエリ・リアクティブ
- 楽観的書き込み（即時反映、永続化は裏で追いつく）
- v0.6: SQLite バックエンドで永続化・オフライン対応追加
  - ブラウザ / React Native / Cloudflare Durable Objects 対応

---

## PowerSync

**Local-First / オフライン対応**のためのバックエンド DB ↔ クライアント SQLite 同期レイヤー。

```
Postgres（サーバー）
  ↓ WAL 論理レプリケーション
PowerSync Service（クラウドかセルフホスト）
  ↓ WebSocket ストリーム
SQLite WASM（ブラウザ内）← PowerSync SDK が内包
```

- 読み取り同期: PowerSync Service が担当。自前エンドポイント不要
- 書き込み: 自前の Workers API → Postgres
- 同期ルール: YAML 設定（誰に何を同期するか）

**対応バックエンド DB**: Postgres / MySQL / MongoDB / SQL Server  
**D1 は使えない**（WAL の外部公開なし）

### Cloudflare 環境での推奨構成

```
ブラウザ SQLite WASM
  ↕ PowerSync Service
Neon（サーバーレス Postgres）
  ↑ Cloudflare Workers（ミューテーション API + JWT発行）
```

Neon 推し理由: Hyperdrive 対応・サーバーレス・Workers 親和性高い

### 得意 / 不得意

得意:
- フィールドワーカー・モバイルのオフライン対応
- 大量データの部分同期
- コラボ編集（低頻度更新）

不得意（Firestore 的リアルタイムとの差）:
- 同期レイテンシ: 数百ms〜1秒以上（Firestore は 50〜150ms）
- チャット: できるが最適ではない
- リアルタイムゲーム（FPS等）: 不向き

---

## リアルタイム用途の正解

```
オフライン対応 / Local-First → PowerSync
リアルタイムチャット・コラボ → Convex / Supabase Realtime
マルチプレイゲーム           → PartyKit（Cloudflare Durable Objects）
```

PartyKit は Cloudflare Workers 環境で WebSocket セッション管理を丸ごと担う。
