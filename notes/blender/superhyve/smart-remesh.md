---
title: Smart Remesh 3
description: Milad (3DRedbox Studio) のリメッシュアドオン。有機は Instant Meshes、ハードサーフェスは頂点を動かさず n-gon 化。$17、Windows のみ
# permalink:  # don't use
aliases:
  - smart-remesh
tags:
  - blender
  - superhive
  - retopology
  - ai-mesh-cleanup
draft: false
date: 2026-11-18
---

# Smart Remesh 3

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/smart-remesh — $17

## 状態

- 販売 2700+、評価 19件、公開3か月前。Blender 4.2〜5.2 (4.0〜4.1 用レガシー版が同梱)。GPL。
- **Windows 64bit のみ** (有機エンジンが Windows 実行ファイル)。macOS / Linux は未対応。
- 25%オフクーポンあり (3日間)。

## 2つのモード

### 有機 (Organic)

- **Instant Meshes** (Jakob ら、3-clause BSD) を無改変で同梱。向きフィールド方式のクアッド化。
- 面数を正確に指定できる (1万を指定すれば約1万)。
- 曲面・スカルプト・スキャン向き。

### ハードサーフェス

- 純 Python。実モデルの「本物のエッジ」を検出し、平面パネルを1つの n-gon に再構築。形を担わないループを除去。
- **結果の全頂点は元モデルが持っていた頂点**。表面を動かさず、シルエット・フィレット・パネル境界は元のまま。
- 面数は結果として決まる (有機のような目標面数指定とは性質が違う)。
- Keep Circles Round、Fill Missed Gaps、Mirror Retopology。プリセット3種 (Balanced / Detail / Flat Panels) + 保存可。

## 共通機能

- 元オブジェクトは触らず隣に新規生成。設定変更はライブ反映。Restore Original で元に戻せる。
- ベイク: 全 PBR チャンネル + 法線 (1K/2K/4K)。UDIM・既存 UV へのベイク、ワンクリック Unbake。
- UV / UDIM / マテリアルを維持。
- Smart Cleanup、Erase Useless Loops (軸ごと、マーク済みエッジ・UV シームは保護)。
- 衣類モード: UV 島ごとにリメッシュし境界を溶接。
- Subdiv Cage Builder: 軽いオールクアッドのケージ + クリース + Subdiv モディファイア。
- Merge Shells: AI / スキャンの分離シェルを溶接してからリメッシュ。
- スキャン法線のシェーディング自動修正。
- 「AI 生成モデル向け」と明記。

## 限界

- キャラの関節周りのエッジループは意図的に作らない。静的プロップ・敵・メカ向き。
- ハードサーフェスは元の頂点を使うので、AI 生成特有のノイズ (うねり) は残る。
- 向きフィールド系は閉じた多様体が前提 (推測)。

## 関連

- 前段: [[image-to-3d-milad]] / [[bizen3d]]
- 後段: [[auto-unwrap]]
- 同作者: [[mk-smart-segment]]
- 比較: [[bizen3d]] の Remesh into Quads (手法の記載なし)
