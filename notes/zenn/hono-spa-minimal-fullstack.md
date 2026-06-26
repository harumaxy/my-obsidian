---
title: Hono だけで最小フルスタック SPA を作る
description: Zenn記事「Building a Minimal SPA with Hono Only」の要約と、SPA機能・Tailwind・配信・ディレクトリ構成の考察
aliases:
  - Hono SPA
tags:
  - Hono
  - SPA
  - TypeScript
  - Vite
  - フルスタック
draft: false
date: 2026-06-25
---

## 元記事

https://zenn.dev/yasu888/articles/3075e8d7c93afa  
著者: Yasu（2025年11月29日）

Gemini API モデルのテストツールを題材に、Next.js を使わず **Hono だけ** でフルスタック SPA を構築した体験記。

---

## プロジェクト構成

ソースファイルはたった **5ファイル**、依存パッケージは **3つ** のみ。

```
src/
├── app.tsx      # サーバー
├── client.tsx   # SPA クライアント
├── server.ts    # エントリポイント
├── style.css
└── types.ts
```

依存: `hono` / `@hono/node-server` / `@google/genai`

---

## `hono/jsx/dom` — React 代替の SPA 機能

Hono には `hono/jsx/dom` というクライアントサイド JSX ランタイムが内蔵されている。

```tsx
import { useState } from 'hono/jsx'
import { render } from 'hono/jsx/dom'

function Counter() {
  const [count, setCount] = useState(0)
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  )
}

render(<App />, document.getElementById('root'))
```

| | React | `hono/jsx/dom` |
|---|---|---|
| JSX | ✅ | ✅ |
| `useState` など | ✅ | ✅（同じ API） |
| バンドルサイズ | 大きい | 大幅に小さい |
| サーバー統合 | 別途必要 | Hono 本体で完結 |

---

## Tailwind との組み合わせ

Tailwind は Hono と独立して動くので普通に使える。

- **CDN**: `<script src="https://cdn.tailwindcss.com">` を挿入するだけ
- **Vite**: `@tailwindcss/vite` を追加して `vite.config.ts` に `plugins: [tailwindcss()]`

---

## 配信の仕組み

Hono サーバー 1つが API もフロントも全部まかなう構成。

```
GET /api/*  → API 処理
GET /*      → index.html（SPA）
/static/*   → ビルド済み JS/CSS
```

React + Vite の一般的な構成（フロントは Nginx 等で別配信）と異なり、**1サーバーで完結**するのが特徴。

---

## `vite.config.ts` — サーバー・クライアント同居型

`--mode client` フラグで出力を切り替えるパターン。Vite では一般的な書き方。

```ts
import devServer from '@hono/vite-dev-server'
import { defineConfig } from 'vite'

export default defineConfig(({ mode }) => {
  if (mode === 'client') {
    return {
      esbuild: {
        jsxImportSource: 'hono/jsx/dom',
      },
      build: {
        rollupOptions: {
          input: './src/client.tsx',
          output: {
            entryFileNames: 'static/client.js',
          },
        },
      },
    }
  } else {
    return {
      plugins: [
        devServer({ entry: 'src/index.tsx' }),
      ],
    }
  }
})
```

```json
// package.json
"scripts": {
  "dev": "vite",
  "build": "vite build --mode client && vite build"
}
```

---

## ディレクトリ構成の選択肢

| | 同一パッケージ | モノレポ |
|---|---|---|
| セットアップ | 簡単 | Turborepo 等が必要 |
| 向いてる規模 | 小〜中 | 中〜大 |
| RPC 型共有 | `import` で直参照 | `tsconfig` の project references が必要 |

小規模ツールは同一パッケージで始め、規模が大きくなったらモノレポへ移行が現実的。

---

## 結論

Next.js が不要な小規模ツール・個人開発では Hono 1本で完結できる。  
フロント・バックを同じフレームワーク・同じリポジトリで管理できるシンプルさが最大の魅力。
