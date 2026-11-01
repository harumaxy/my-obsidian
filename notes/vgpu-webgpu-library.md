---
title: vgpu - WebGPU ライブラリ (Vercel Labs)
description: WebGPU 薄ラッパー。ブラウザ/Node 両対応。エージェント向け docs/CLI/MCP 付き
# permalink:  # don't use
aliases:
  - vgpu
  - vgpu.sh
tags:
  - webgpu
  - wgsl
  - graphics
  - vercel
draft: false
date: 2026-11-01
---

https://vgpu.sh/
https://github.com/vercel-labs/vgpu

## これ何

- WebGPU の TypeScript 薄ラッパー。Vercel Labs 製。MIT。
- 生 WebGPU のボイラープレート (adapter/device, pipeline, bind group, encoder) を畳む。
- three.js みたいな scene graph 無し。frame と pass 明示。生 WebGPU より楽、three.js より低レベル。
- `.wgsl` import で型付き。リフレクションで binding 手書き不要。
- gzip 25KB 予算 (CI 強制。実測値じゃない)。three.js は gzip 150KB 超 (記憶ベース概算)。
- 若い。v0.5.0 (2026-09 時点の記事)。star 約 2.6k。
- 料金なし。Blog/About なし。

## 使い方

```sh
pnpm add vgpu
pnpm add -D @webgpu/types
npx vgpu            # CLI。docs, examples, check, doctor, MCP
npx vgpu examples
```

```ts
import { init, effect, frameLoop, surface } from "vgpu";
import waveShader from "./wave.wgsl";

const gpu = await init();
const s = surface(gpu, canvas, { dpr: [1, 2] });
const wave = effect(gpu, waveShader, { set: { speed: 2 } });

frameLoop(gpu, (frame) => {
  wave.set({ time: t });
  frame.pass(s, wave);
});
```

## コア概念

- `init()` → `Gpu`。surface, target, effect, frame 全部この 1 デバイス共有。
- `effect(gpu, shader)` → fullscreen fragment shader。fragment だけ書く。
- `geometry` + draw → 自前 vertex/fragment。instancing 可。
- pass → frame 内の render pass。target 1、clear color、draw 複数。
- `frame` → 全 pass を 1 encoder に積んで 1 回 submit。callback が throw なら GPU に何も送らない。
- `frameLoop` → 毎 tick frame。
- render bundle → draw 一度記録、毎 frame 再生。uniform は `set()` で更新可。
- compile は lazy。`compile()` で事前暖機。
- compute, GPU テンソル, occlusion query も有り。

## エントリポイント

| import | 用途 |
|---|---|
| `vgpu` | ブラウザ。`navigator.gpu` |
| `vgpu/node` | ヘッドレス Node。Dawn で実 GPU。canvas 無し、target に描いて pixel 読む |
| `vgpu/mock` | GPU 無し決定的単体テスト |

`init()` の形同じ。import 先変えるだけ。

## Dawn って何

- Google (Chromium) 製 WebGPU ネイティブ実装 (C++)。Chrome の WebGPU の中身。
- Metal / Vulkan / D3D12 に変換。WGSL コンパイラ Tint 含む。
- 他: wgpu (Rust, Firefox), WebKit 内蔵 (Safari)。
- vgpu/node はこれの Node バインディング使用。ネイティブバイナリ → prebuild 必要。

## Node / サーバー

- Node 22 で確認済 (docs の主マトリクス、Docker も Node 22)。
- `vgpu doctor` で診断。`vgpu install-dawn` で Dawn。
- GPU 無し環境: `vgpu install-software-renderer` (CPU、Mesa lavapipe 系)。
- Linux ARM64 は glibc 2.38 以上。
- Bun / Deno / Cloudflare Workers: docs に記述無し。未検証。Dawn ネイティブなので Workers は無理そう。
- Lambda: コンテナイメージなら可能性あり。ただ glibc、Mesa 同梱、コールドスタートが懸念。未検証。
- 確実なのは ECS/Fargate か EC2 (docs の Docker 構成そのまま)。
- トップページの "serverless runtimes" は宣伝文句。中身はヘッドレス Node + Dawn。

## サーバー/CLI で動かす意味

- OGP/サムネ/背景画像の生成。連番書き出し → ffmpeg で動画化も。
- シェーダー回帰テスト (pixel 比較)。CI。
- エージェントが自分で描画結果を検証。`doctor`, `check` CLI はそのため。
- GPU 計算 (compute)。onnxruntime-web 連携の記述有り。
- シェーダーデバッグ (内部値を pixel で取り出す)。

## WebGL フォールバック

- 無い。WebGPU 専用。
- WebGPU 不可は `VGPU-RING1-UNSUPPORTED`。docs 推奨: 静的フォールバック (poster 画像, CSS グラデ)。
- GLSL / Shadertoy 資産は手動で WGSL に移植。
- WebGL 必要なら three.js (WebGPURenderer は WebGL2 自動フォールバック)。
- `vgpu/three`: vgpu の WGSL 関数を three.js TSL ノードとして使うアダプタ有り (未検証)。

## ブラウザ対応状況 (2026-11 時点)

caniuse で全世界約 88% 対応。

- Chrome/Edge: デスクトップ 113〜。Android 121〜 (Android 12 以上、Qualcomm/ARM GPU)。caniuse は Android 156 と表示。数字割れ。
- Safari: 26.0〜 (2025 秋)。macOS/iOS/iPadOS/visionOS。caniuse はデスクトップ partial、iOS full。
- iOS は Chrome も中身 WebKit → 同条件。
- Firefox: 情報割れ。web.dev 系は Windows 141〜、macOS ARM 145〜。caniuse はデフォルト無効。未対応扱いが安全。Android 未対応。
- 懸念: iOS 26 未満、古い Android → フォールバック必須。演出用途なら雑でも実害小さい。

## ゲームは作れる？

- 描画層だけ。エンジンではない。
- 使える: draw/geometry、instancing、bundle、compute、深度、数学ヘルパー、wgsl-std。
- 自前: シーン管理、物理、衝突、音、入力、glTF ローダー、スケルタルアニメ、UI。
- 向く: シェーダー主体、ジェネラティブ、パーティクル多数、ボクセル、レイマーチ、シンプル 2D。
- 向かない: モデル読み込む普通の 3D ゲーム → Babylon.js / three.js / PlayCanvas。

## 派生ライブラリ (npm)

ゲームエンジン級は見つからず。UI 向けエフェクト部品が主流。

- `vgpu-render`: debug draw, gizmo, 無限グリッド, テキスト
- `vgpu-react`: React バインディング
- `shadertown`: シェーダー背景集
- `@vfx-ui/react`, `@vfx-ui/core`, `vfx-ui-vue`: シェーダーエフェクトコンポーネント
- `@gpuc/core`: gpu-components 用ランタイム
- `@glass-sdk/liquid-glass`: Liquid Glass 風
- `@mudah-cli/vgpu`: ターミナルに WGSL エフェクト (Kitty graphics)
- 競合: TypeGPU (最も近い)、Paper Shaders (プリセット系) ← ブログ比較記事より

## 所感

- fullscreen fragment shader 系 (背景, ノイズ, 波, ポスプロ) は `effect` 1 個で済み相性良い。
- LLM で自作ラッパー書くの簡単な時代。ライブラリ価値は「コード量」より「踏んだ罠の蓄積 + 検証基盤 (Node ヘッドレス, mock, doctor)」に移ってる。
- 未確認: 三者比較 (three.js / TypeGPU)、Bun 動作、Lambda 動作、Firefox 実状。`llms-full.txt` は 170 万字で先頭 10 万字しか読んでない。
