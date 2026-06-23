---
title: I Hated Monorepos, Now I Can't Build Without Them
description: Ben Davisがモノレポの実践的な構築方法とツールについて解説
aliases:
  - monorepos-ben-davis
tags:
  - monorepo
  - bun
  - turborepo
  - typescript
draft: false
date: 2026-06-22
---

# I Hated Monorepos, Now I Can't Build Without Them

## 概要

Ben Davis による、モノレポの実践的な活用方法についての動画。以前は複雑で面倒だったモノレポが、現代のツール（Bun、Turbo Repo）により完全に実用的になり、すべてのプロジェクトで採用するまでに至った。

## モノレポへの考え方の変化

- **過去**: セットアップが難しい、依存関係管理が煩雑、ローカルパッケージのインポートが複雑で敬遠していた
- **現在**: Bun と Turbo Repo の成熟により実用的に。全プロジェクトがモノレポ構成

## 実践例

### 1. PikThing 2.0
複数の異なるコンポーネントを統一管理:
- **Web アプリ** (Spellkit)
- **Raycast 拡張** (画像資産へのアクセス)
- **Cloudflare Worker** (背景削除機能)

メリット: 3つのプロジェクトを1つのリポで管理、Convex を複数アプリで共有

### 2. Better Context
- CLI (npm 発行)
- Raycast 拡張
- サーバー実装
- Spelt ウェブアプリ

すべて同一リポで管理でき、`bun dev-web` で複数サーバーを同時起動

### 3. R8y (チャネル管理システム)
- 共有 DB パッケージ (Drizzle ORM)
- Web アプリ
- バックグラウンドワーカー (20分ごとの YouTube API 同期)

## 主要ツール

### Bun
- パッケージマネージャー、ランタイム、スクリプトランナーを統一
- Workspace 宣言で複数パッケージを管理
- ローカルパッケージを npm 風に import: `@pik/convex`
- `bun install` で自動リンク

### Turbo Repo (Vercel製)
- `turbo dev --ui=true`: 複数プロジェクトのサーバーを UI で同時管理
- `turbo run build`: キャッシング機能で高速化
- `--filter <package>`: 特定パッケージのみ実行
- `turbo prune`: Docker ビルド時に必要な依存関係のみを抽出

## 開発体験の向上

- 型定義変更がリアルタイムで全体に伝播
- `turbo dev --ui=true` で複数プロジェクトのログを統一 UI で管理
- キャッシングにより繰り返しの build/check が高速化
- エージェント利用時に AGENTS.md で検証スクリプトを指定可能

## 所感

従来のモノレポの複雑さは解消され、Raycast 拡張や Cloudflare Worker など個別に管理していた煩雑なプロジェクトを統一できるメリットが非常に大きい。モダンツールにより「モノレポはもう実用的」という段階に到達している。
