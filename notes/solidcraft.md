---
title: SolidCraft (Rust 製 3D CAD)
description: Rust 製パラメトリック 3D CAD SolidCraft。MCP/CLI あり。ゲーム用途と 3D プリント用途の向き不向きメモ
# permalink:  # don't use
aliases:
  - SolveCraft
tags:
  - cad
  - rust
  - mcp
  - 3d-printing
draft: false
date: 2026-10-12
---

## 元ネタ

- X: https://x.com/studio_yebisu/status/2109469902272946665
  - 「3D CAD に高いライセンス料払う時代終わり」「Rust 製 Auto CAD クローン」と紹介
  - 投稿者 AI 商材系インフルエンサー自称。話 大きめ。割り引いて見る
- GitHub: https://github.com/bherbruck/solidcraft (v0.3.2, MIT OR Apache-2.0, Star 492)
- ドキュメント: https://bherbruck.github.io/solidcraft/
- Web 版: https://bherbruck.github.io/solidcraft/app/

## 何者か

- 実際は **Autodesk Fusion 360 のクリーンルーム再実装**。AutoCAD ではない (AutoCAD 系は兄弟 `cadcraft`)
- 旧名 SolveCraft。crate 名 `solvecraft-*`、`.solvecraft` ファイル、`solvecraft-cli` は旧名のまま
- 自己評価 "early but usable for simple parts"。基準 76 部品で体積・面積・位相一致。完全等価ではない
- 2D 図面・CAM 未対応
- Rust 約 15.5 万行。AI エージェント主導で開発 (CLAUDE.md に自律運用プロトコルあり)
- 「クラッシュしない」最優先。`unwrap` / `panic` / `unsafe` 禁止

## できること

- スケッチ + 自前拘束ソルバー (damped Gauss-Newton)
- パラメトリック・タイムライン: extrude / revolve / sweep / loft / fillet / shell / draft / hole / thread / pattern
- 式付きパラメータ (`2 * width + 5 mm`)、コンフィギュレーション
- アセンブリ、板金 (フラットパターン・DXF)
- 出力: STEP / IGES / 3MF / STL / OBJ。入力: STEP / IGES / 3MF / STL / OBJ。設計は JSON (`.solvecraft`)
- GUI: egui + wgpu。Web は WASM

## 構成

- L0 `geom` → L1 `sketch` / `kernel` / `render` → L2 `doc` → L3 `io` → L4 `engine` → L5 `ui-egui` / `mcp`
- 全機能が「コマンド」。UI / CLI / MCP / スクリプトが同じコマンドを叩く
- B-rep カーネルは `truck` (vendor に patch 版同梱) の上に自前 API

## AI 連携 (MCP / CLI)

- `solvecraft-cli mcp` が stdio の MCP サーバー
- `--connect 127.0.0.1:PORT` で起動中アプリ (`solvecraft --control PORT`) を操作。AI の作業を目で追える
- ツール: `list_commands` `execute` `batch` (失敗でロールバック) `inspect_design` `measure` `body_topology` `set_parameter` `screenshot` `export` `undo` `redo` `new_design` `open` `save`
- 導入: `claude mcp add solvecraft -- solvecraft-cli mcp`
- CLI: JSON コマンドスクリプト実行、measure、export、PNG スナップショット

AI 向きな理由:
- screenshot + measure + set_parameter で自己修正ループが閉じる
- batch ロールバックで壊れた状態が残らない
- 設計が JSON なので git 管理、パラメータ違い量産が楽
- 無料、商用可

比較: CadQuery / build123d / OpenSCAD は「コードで CAD」。AI 学習データ多い。SolidCraft の差別化は GUI と MCP が同じコマンド体系で、人間が手直しできる点

## ゲーム開発に使えるか

基本は不向き。

- CAD は B-rep (数式の曲面)。ゲームはポリゴンメッシュ。出力時に三角形化される
- 三角形が不均一、頂点数が多い、UV 無し、法線フラット、単位 mm
- ゲーム向け glTF / FBX 出力は無い。OBJ → Blender 経由
- 自動リトポ (Quad Remesher) は有機物向け。ハードサーフェスは角が崩れる
  - CAD 由来の綺麗な形状は Decimate (Planar) / Limited Dissolve で余分な分割を溶かす方が効く
- ゲーム資産が目的なら最初から **Blender MCP** で直接モデリングする方が良い
  - 頂点数、エッジフロー、UV、法線を直接制御。glTF 出力まで同じ環境で完結
  - 弱点は厳密寸法・パラメトリック性 (ゲームでは通常不要)
- 使い分け: 見た目重視 → Blender / 実寸・組み付け・3D プリント → CAD

## 3D プリントに使えるか

CAD 本来の用途。SolidCraft が一番向く領域。

- 寸法精度、パラメトリックでクリアランス調整が楽
- STL / 3MF がそのままスライサー (Bambu Studio, PrusaSlicer, Cura) へ
- README のデモが電子機器エンクロージャ (USB 穴、ボス 4 本)。Raspberry Pi ケースに近い
- 用途別:
  - Raspberry Pi ケース: 基板寸法公開済み。相性良い。最初の題材に最適
  - スマホケース: 機種寸法の実測要。曲面多く fillet 重い。難易度 中〜高
  - ソケット: 嵌合相手の実測値 + クリアランス微調整。パラメトリックの恩恵最大
- 流れ: 実測 → AI に寸法渡してモデル生成 → screenshot / measure 確認 → STL / 3MF 出力 → 試し刷り → 調整
- 注意: 薄壁・小さい面で fillet / shell 失敗の可能性。オーバーハング・サポートはスライサー側で確認

## 結論

- 今は使わない (保留)
- 3D プリント小物 (Pi ケース等) が必要になったら再検討。ビルド: `cargo run --release -p solvecraft -- --control 7878` と `solvecraft-cli mcp --connect 127.0.0.1:7878`
- ゲーム資産は Blender MCP で
