---
title: Shaders (WebGPU エフェクト部品ライブラリ)
description: WebGPU エフェクトをコンポーネント化した OSS。リポジトリ調査と Astro LP デモ作成のメモ
# permalink:  # don't use
aliases:
  - shaders
  - shaders.com
tags:
  - webgpu
  - react
  - astro
  - frontend
draft: false
date: 2026-10-08
---

# Shaders

X 投稿 (@npm_i_shaders) で OSS 化告知。
「200+ WebGPU コンポーネント、自分の作品で使え」。

- GitHub: https://github.com/shader-effects-inc/shaders
- 公式: https://shaders.com
- npm: `shaders`

## WebGPU コンポーネントとは

- WebGPU = ブラウザから GPU 直接使う Web API。WebGL の後継。compute shader も使える
- コンポーネント = GPU エフェクトを部品化したもの。`<Shader>` の中に置くだけ
- 普通は GLSL/WGSL 自前で書く。それが宣言的に使える。これが売り

## リポジトリ要約

- React / Vue / Svelte / Solid / 素の JS 対応。props 共通
- `<Shader>` = canvas。子 = レイヤー。上から順に GPU 上でブレンド
- コンポーネント 199 個 (`packages/core/src/shaders/`)
  - グラデ: MeshGradient, LinearGradient, ConicGradient
  - ノイズ: Perlin, Simplex, Worley, Curl
  - 質感: Glass, Chrome, LiquidMetal, Marble
  - ライト: Glow, Godrays, Aurora, Nebula
  - 歪み: Bulge, Swirl, Ripples, Liquify
  - トランジション: Wipe 系, PagePeel, Shatter
  - レトロ: CRTScreen, VHS, Glitch, Halftone
  - カーソル: CursorTrail, CursorRipples
  - 入力: ImageTexture, VideoTexture, WebcamTexture
- 周辺: デザインエディタ (shaders.com, 無料)、CLI、MCP、agent skill、llms.txt
- 自作: `defineShader` + WGSL

```jsx
import { Shader, LinearGradient, CursorTrail } from 'shaders/react'

<Shader className="w-full h-64">
  <LinearGradient colorA="#0f172a" colorB="#7c3aed" />
  <CursorTrail />
</Shader>
```

## 依存

- three, pixi 使わない。自前エンジン
- ランタイム依存は 2 つだけ
  - `typegpu` 0.12.3 = WebGPU 型安全ラッパー
  - `colorjs.io` = 色変換
- FW は peerDependencies (react, vue, solid-js, svelte)
- `navigator.gpu` なし → `GpuUnavailableError` を投げる。SSR は安全
- `onReady` / `onUnavailable` コールバックあり

## 料金

- Free: エンジン、200+ コンポーネント、エディタ、コード書き出し、CLI、MCP。MIT。商用 OK
- Pro: $199/年 or 買い切り
  - プリセット 750+ (README は 1000+ で食い違い)
  - サイト用セクション 55+
  - 透かしなし HD 動画・画像書き出し
  - Framer プラグイン、履歴、Discord
- 結論: コードで使うだけなら Pro 不要

## ユースケース

- LP ヒーロー背景 (本命)
- 画像・動画エフェクト
- 画面遷移トランジション
- カーソル連動演出
- ガラス・金属の質感 UI
- 動画・画像素材の書き出し (Pro)
- Webcam リアルタイム加工

向かない:

- 重い背景を何枚も置く (モバイル)
- WebGPU 非対応ブラウザ
- ブログ、ドキュメントなど内容主体のページ

## デモ作成: Lumen LP

場所: `workspace/shaders-react-demo`

架空製品 Lumen (AI 議事録ツール)。ダーク基調 LP。

### 技術スタック

- Astro (SSG, `output: 'static'`)
- React アイランド
- Shaders (`shaders/react`)
- Tailwind CSS v4 (`@tailwindcss/vite`)
- TypeScript, pnpm
- Shaders だけアイランド。他は静的 HTML、JS ほぼ無し

### 構成

- ヒーロー: MeshGradient + Aurora (`blendMode="screen"`) + FilmGrain。`client:only="react"`
- CTA: MeshGradient + FilmGrain。`client:visible`
- 機能 3 つ、料金 3 プラン、FAQ (`<details>`)

### ハマりどころ

- WebGPU 依存。サーバー描画できない。`client:only` 必須
- 背景 JS チャンクが 2.5MB 弱。読み込み + WebGPU 初期化 + シェーダーコンパイルで待つ
- 準備完了時、CSS 代替グラデと色違いで **急に切り替わる** → 違和感
- 対策: `onReady` まで `opacity: 0`、準備完了で 1 秒フェードイン
- 代替グラデは捨てた。真っ黒から現れる方が自然。非対応環境は黒のまま
- `pnpm dev` は JS 30 ファイル未バンドル。本番ビルドの方が速いはず

```tsx
const [ready, setReady] = useState(false)
<Shader
  className="absolute inset-0 h-full w-full transition-opacity duration-1000"
  style={{ opacity: ready ? 1 : 0 }}
  onReady={() => setReady(true)}
>
```

### 注意

- Astro 7 / TypeScript 7 が入った。`astro check` は TS 7 非対応で失敗。TS 6 に下げれば動く
- `motion` は入れたが未使用
- dev 計測は操作タブが hidden でタイマー間引き。準備完了の秒数は未実測

## 感想メモ

- 重さ (2.5MB) が LP 向きかは微妙。ヒーロー限定の演出と割り切る
- Aurora を外せば軽くなる余地あり
- プリセット無しでも MeshGradient 単体で十分いい見た目
