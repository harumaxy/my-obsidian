---
title: ZenStack
description: TypeScript向けフルスタックデータレイヤー。ORM+認可+API自動生成セット
# permalink:  # don't use
aliases:
  - zenstack
tags:
  - orm
  - typescript
  - access-control
  - web
draft: false
date: 2026-08-03
---

# ZenStack

GitHub: https://github.com/zenstackhq/zenstack  
⭐ ~2,900 | MIT | TypeScript

## 何者

Prisma互換ORM + 認可ロジック + CRUD API自動生成 のオールインワン。  
「Prismaにアクセス制御とAPI生成が内蔵されたもの」。

## 主機能

- スキーマ（`.zmodel`）にアクセス制御直書き
- Kyselyベースの自前ORMエンジン（V3〜、Pure TypeScript）
- Next.js等アダプタでREST API自動生成
- TanStack Query hooks自動生成
- Zod schema生成

## スキーマ例

```zmodel
model Post {
  id     String @id @default(cuid())
  title  String
  author User   @relation(fields: [authorId], references: [id])

  @@allow('read', true)
  @@allow('all', auth() == author)
}
```

認可ロジックをスキーマに集約 → サービス層に手書き不要。

## 競合比較

- **Prisma/Drizzle** — ORM only。認可は自前
- **PostgREST** — DBレベルAPI生成、PostgreSQL専用
- **Supabase** — 近い立ち位置。PostgREST+Auth+RLSをホスト型で提供

ZenStack = 「Supabaseのセルフホスト・フレームワーク統合版」に近い。

## 採用判断

**アリ:**
- 個人/小チームプロジェクト
- SaaSで認可ロジックが複雑
- TypeScriptエコシステム統一したい

**ナシ:**
- チーム開発（学習コスト、知ってる人いない）
- 長期プロダクション（OSS廃止リスク、V3刷新直後で安定性未知数）
- 認可シンプルならoverkill

## 代替構成（メジャーツール）

- ORM → Drizzle / Prisma
- 認可 → Casbin / Oso / 手書きミドルウェア
- API → tRPC / Hono
