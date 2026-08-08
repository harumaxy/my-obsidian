---
title: PixiJS 概要
description: PixiJS の基本概念、競合比較、使いどころまとめ
aliases:
  -
tags:
  - pixi
  - webgl
  - canvas
  - 2d
draft: false
date: 2026-08-02
---

# PixiJS

WebGL ベース 2D レンダリングライブラリ。Canvas/WebGL/WebGPU 自動切替。

## 競合比較

- **Three.js** — 3D主体。2D可だが重い
- **Phaser** — ゲームエンジン。物理/音声/シーン管理込み。v3 は独自レンダラー
- **Konva** — Canvas 2D。図形操作・編集ツール向け
- **Fabric.js** — Canvas 2D。低速、編集ツール特化
- **p5.js** — Canvas 2D。クリエイティブコーディング向け。毎フレーム全再描画

## パフォーマンス

WebGL = GPU 並列描画 → Canvas 2D（CPU逐次）より桁違いに速い。

粒子 1 万個: Pixi 60fps / Canvas 系 数fps〜フリーズ。

v8 から WebGPU 対応。WebGPU 環境で自動使用、フォールバックで WebGL → Canvas 2D。

## 基本コード

```ts
import { Application, Sprite, Assets } from 'pixi.js';

const app = new Application();
await app.init({ width: 800, height: 600 });
document.body.appendChild(app.canvas);

const texture = await Assets.load('bunny.png');
const sprite = new Sprite(texture);
app.stage.addChild(sprite);

// 毎フレーム更新
app.ticker.add((ticker) => {
  sprite.rotation += 0.01 * ticker.deltaTime;
});
```

## p5.js との対比

- `setup()` → `app.init()` + オブジェクト生成
- `draw()` → `app.ticker.add(callback)`
- p5: 毎フレーム全再描画。Pixi: 差分更新 → 速い
- `deltaTime` でフレームレート非依存な動き

## シーンツリー

Godot の Node / Unity の GameObject と同じ木構造。

- `app.stage` — ルート
- `Container` — グループ化（Godot の Node2D 相当）
- `Sprite` — 画像
- `Text` — ラベル
- `NineSliceSprite` — リサイズ可能 UI パネル/ボタン背景

親移動で子もついてくる。親の `alpha`/`rotation` 子に継承。

## ticker とシーンは別物

- **stage ツリー** — 「何を描くか」
- **ticker** — 「毎フレーム何をするか」

オブジェクト削除時は両方セットで対処。stage のみ外すと ticker が動き続けてメモリリーク。

```ts
app.stage.removeChild(sprite);
app.ticker.remove(onTick);
sprite.destroy();
```

## UI

コアに Button/Label なし。自作か `@pixi/ui` を使う。

HTML UI を重ねたいなら `DOMContainer` で HTML 要素を canvas に乗せる。

## シェーダー

Filter として任意オブジェクトに適用可能。p5 より統合が綺麗。

```ts
const filter = new Filter({ glProgram: GlProgram.from({ fragment: fragSrc }) });
sprite.filters = [filter];
```

## 使いどころ

- パーティクル大量・リアルタイム高負荷 → **Pixi**
- Web サイト埋め込み 2D エフェクト → **Pixi**
- ゲーム全機能 → Phaser
- シンプルなジェネレーティブアート → p5
- 3D → Three.js
