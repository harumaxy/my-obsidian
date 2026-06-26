---
title: TanStack Start vs Next.js
description: Zenn記事「TanStack Startを試してみたけど、もうNext.jsには戻れない」の要約と考察
aliases:
  - TanStack Start
tags:
  - React
  - Next.js
  - TanStack
  - TypeScript
  - Vite
draft: false
date: 2026-06-25
---

## 元記事

https://zenn.dev/yt4/articles/tanstack-start-next-js  
著者: Yuki Terashima（2025年12月1日）

X（旧Twitter）で「TanStack Start を試したら Next.js に戻れない」という投稿が話題になり、寄せられた議論と著者自身の見解をまとめた記事。

---

## 主な議論

| 観点 | 内容 |
|------|------|
| TanStack Start 支持 | Next.js の「魔法」的な隠蔽ロジックへの不満、Vite エコシステムの評価、ベンダーロックイン回避 |
| Next.js 擁護 | 開発スピードの優位性、AI サポートの圧倒的な充実度 |
| ボイラープレート批判 | TanStack Start の記述量の多さやファイルルーティングの問題 |
| チーム規模論 | 小規模チームは TanStack Start、大規模企業は Next.js が適しているという見方 |
| 代替案 | React Router、SPA、Astro なども選択肢として言及 |

---

## 著者が TanStack Start を選んだ理由

1. **`use client` 不要** — SSR を必要としない個人プロジェクトでは `use client` / `use server` ディレクティブが煩わしい
2. **Vite 選好** — Turbopack より安定性・信頼度が高い
3. **TanStack Router の DX** — 型安全なルーティングなど開発者体験が優秀

---

## 考察

### Next.js の「魔法」問題
Server Components / Client Components の境界、`use server` アクション、キャッシュ挙動など、Next.js は抽象化の層が厚く暗黙の挙動が多い。小規模プロジェクトや個人開発では、その複雑さがオーバーヘッドになる。

### TanStack Start の明示性
Vite ベースで動作が予測しやすく、TanStack Router による型安全なルーティングは DX が高い。SSR が必要ない用途では素直な選択肢。

### AI コード生成の現実
Next.js は学習データが圧倒的に多く、AI（GitHub Copilot / Claude など）によるコード補完・生成の精度で有利。TanStack Start はまだエコシステムが小さい。

### 結論
フレームワーク選択は **開発対象・用途・チームの特性** によって最適解が変わる。  
- 個人・小規模 + SSR 不要 → TanStack Start + Vite
- チーム開発・フルスタック・AI 補助重視 → Next.js
