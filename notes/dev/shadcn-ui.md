---
title: shadcn-ui
description: shadcn/ui チートシート
# permalink:  # don't use
aliases:
  - shadcn
tags:
  - ui
  - react
  - tailwind
draft: false
date: 2026-06-30
---

# shadcn/ui チートシート

## 概念

- **コンポーネントライブラリではない**
  - npm パッケージではなく、ソースコードをプロジェクトにコピーして使う方式
  - 自分のコードとして所有・編集できる

- **Open Code**
  - コンポーネントのソースが `components/ui/` に置かれ、直接編集できる
  - スタイルのオーバーライドやラッパー不要

- **Distribution（Registry）**
  - CLIでコンポーネントを追加: `npx shadcn@latest add button`
  - フラットファイルのスキーマ + CLI でどのフレームワークにも対応

- **Composition**
  - 全コンポーネントが統一インターフェース設計で一貫性がある

- **Beautiful Defaults**
  - 追加デザイン作業なしで完成度の高いUIが作れるデフォルトスタイル

- **AI-Ready**
  - コードが手元にあるので LLM が読みやすく、生成・補完との相性が良い
  - v0.dev（Vercel の AI UI 生成）との統合が代表例

## 技術スタック

- **Tailwind CSS** — スタイリング
- **Radix UI** — アクセシビリティ・プリミティブ
- 80以上のコンポーネント、ダークモード・RSC対応

## Registry（自作ライブラリの公開・利用）

### 自作コンポーネントライブラリを公開する

**公開手順（最短）:**

1. `registry.json` をリポジトリルートに作成
2. コンポーネントをアイテムとして定義
3. HTTP で JSON を配信できる場所にホスト（Next.js / Vercel など）
4. 利用者は `npx shadcn add https://your-registry.com/r/button.json` で取得

```json
{
  "$schema": "https://ui.shadcn.com/schema/registry.json",
  "name": "my-ui",
  "homepage": "https://my-ui.com",
  "items": [
    {
      "name": "button",
      "type": "registry:ui",
      "files": [{ "path": "src/components/button.tsx", "type": "registry:ui" }]
    }
  ]
}
```

### 社内限定（プライベート）公開

認証付きサーバーにホストし、利用側の `components.json` でトークンを設定するだけ。

**利用側 `components.json`:**

```json
{
  "registries": {
    "@company": {
      "url": "https://internal.company.com/r/{name}.json",
      "headers": {
        "Authorization": "Bearer ${REGISTRY_TOKEN}"
      }
    }
  }
}
```

**`.env.local`:**

```sh
REGISTRY_TOKEN=your_secret_token
```

```sh
npx shadcn@latest add @company/button  # トークン付きで自動リクエスト
```

### 外部（サードパーティ）レジストリを利用する

**URL 直指定（一番手軽）:**

```sh
npx shadcn@latest add https://magicui.design/r/magic-card.json
```

**ネームスペース設定（繰り返し使う場合）:**

`components.json` に追加しておくと短いコマンドで使える。

```json
{
  "registries": {
    "@magicui": "https://magicui.design/r/{name}.json"
  }
}
```

```sh
npx shadcn@latest add @magicui/magic-card
```

> `registry.json` は自分がコンポーネントを**公開するとき**のカタログ。`components.json` は**利用するとき**の設定。役割が異なる。

## サードパーティ Registry

- **Aceternity UI** — アニメーション重視。LP・ポートフォリオ向け
- **Magic UI** — 150以上のアニメーションコンポーネント
- **Motion Primitives** — Framer Motion ベースのモーション特化
- **Origin UI** — モバイルファースト設計
- **Assistant UI** — チャットUI特化（AIアプリ向け）
- Registry は現在 149以上登録済み。追加は `npx shadcn add @<registry>/<component>`

> サードパーティはコードがそのままプロジェクトに入るので、インストール前にコードを確認すること

## CLI

基本は `init → add → コードを直接編集` で完結。

```sh
npx shadcn@latest init           # プロジェクト初期化
npx shadcn@latest add button     # コンポーネントを追加
npx shadcn@latest add --all      # 全コンポーネントを一括追加
npx shadcn@latest add --dry-run  # 追加せずプレビューだけ確認
```

その他（存在だけ把握）:

```sh
npx shadcn@latest view button    # 追加前にソース確認
npx shadcn@latest search input   # レジストリ検索
npx shadcn@latest apply [preset] # テーマプリセット適用
npx shadcn@latest build          # Registry JSON 生成
npx shadcn@latest migrate        # バージョンアップ変換
npx shadcn@latest eject          # Tailwind CSS 依存をプロジェクトに取り込む
```

## Form 統合（React Hook Form + Zod）

>react-hook-form は 「非制御コンポーネント (uncontrolled) ベース」 の設計で、入力値を React の state に都度詰めず、ref 経由で管理します。


- **React Hook Form** — フォーム状態を `ref` で管理（uncontrolled）し、キー入力のたびに再レンダリングが走らない
- **Zod** — スキーマ定義 + バリデーション。`@hookform/resolvers` で RHF に接続
- shadcn/ui の `Form` コンポーネントは RHF の `Controller` を薄くラップしたもの

**流れ:**
1. Zod でバリデーションスキーマを定義
2. `useForm` に Zod リゾルバーを渡して初期化
3. `Controller` で各フィールドを RHF の状態に接続
4. バリデーション成功時のみ `onSubmit` が実行される

> 「状態管理は RHF、バリデーションは Zod、UI は shadcn/ui」と役割が明確に分離されている

## Form 統合（TanStack Form）

- **状態駆動型**のフォームライブラリ。RHF より柔軟だが複雑
- `form.Field` のレンダープロップパターンでフィールドごとの状態（値・エラー・タッチ）を細かく制御
- バリデーションタイミングを `onChange` / `onBlur` / `onSubmit` から選択・組み合わせ可能

| | React Hook Form | TanStack Form |
|---|---|---|
| 方式 | uncontrolled（ref）| 状態駆動型 |
| 向き | シンプルなフォーム | 複雑な状態制御が必要な場合 |
| API | `register` + `Controller` | `form.Field` レンダープロップ |

## MCP サーバー

- CLI でできること（検索・追加）を AI が会話の中で直接実行できるようにするサーバー
- 「ログインフォームを作って」→ 必要コンポーネントの判断・インストール・コード生成を一発で完結
- Skills（知識インプット）との併用で「知識 + 操作能力」がそろう

```sh
pnpm dlx shadcn@latest mcp init --client claude  # Claude Code 向け設定
```

## Skills（AI コーディングアシスタント連携）

- AI（Claude Code など）に shadcn/ui の知識を注入するプラグイン
- プロジェクトのフレームワーク・インストール済みコンポーネント・CSS変数などをコンテキストとして渡す
- 「ログインフォームを追加して」などの指示で shadcn/ui パターンに沿ったコードを生成できるようになる
- インストール: `pnpm dlx skills add shadcn/ui`

## Theming

- **CSS変数ベース**
  - `background`, `primary`, `accent` などセマンティックなトークンで色を管理
  - Tailwind ユーティリティ（`bg-primary`, `text-foreground`）に自動マッピング

- **トークン構造**
  - Tailwind の仕組みを使って、shadcn/ui が独自に作ったトークン。ユーティリティベースではなく、役割ベース
  - 各トークンは基本色 + `-foreground` サフィックスのペア構成
  - `border`, `input`, `ring`, `chart-1〜5` などUI固有トークンも存在

- **ダークモード**
  - `.dark` クラスを切り替えるだけで全体のカラースキームが変わる
  - 同じトークン名でダーク用の値を上書きする仕組み

- **カスタマイズ**
  - `components.json` の `tailwind.cssVariables: true` で CSS変数モード有効（デフォルト）
  - `--radius` を基準に sm / md / lg など各サイズを自動導出
  - 新トークンは CSS で定義後、`@theme inline` で Tailwind に公開

- **カラーパレット**
  - Neutral / Zinc / Stone / Slate などのベース色から選択
  - OKLch 形式で知覚的に均一な色空間を採用
  - `shadcn/create` で色・フォント・アイコンをビジュアルプレビューしてプリセット生成可能
