---
title: Quadify Bridge
description: Meshy / Rodin / Tripo の生成結果を Blender に自動取り込み。MCP サーバー付き。リトポ本体は別売の Quadify Ultra。$19 (表示 $14.25)
# permalink:  # don't use
aliases:
  - quadify-bridge
tags:
  - blender
  - superhive
  - retopology
  - mcp
  - cloud
draft: false
date: 2026-11-18
---

# Quadify Bridge

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/quadify-bridge-ai-mesh-importer-for-blender

## TL;DR

- **リトポではなく取り込み橋渡し**。Meshy / Rodin / Tripo (クラウド生成サービス) の結果を Blender に自動で入れる。名前・コレクション整理、PBR ノード配線。
- **リトポ・クリーンアップは別売の Quadify Ultra** が担当 (Ultra 未導入だと生メッシュのまま)。今回の Ultra の中身は未確認。
- **MCP サーバー内蔵** (Claude Desktop / Cursor 登録)。ツール 8 個: `bridge_import`、`bridge_generate`、`bridge_import_url`、`bridge_list`、`bridge_history`、`bridge_send_unreal`、`quadify_remesh`、`quadify_validate`。
- 私の用途 (ローカル生成 + Blender MCP) では、Meshy 等のクラウド有料生成を使わないなら不要。販売 10、評価なし、Blender 5.0〜5.1 まで。見送り寄り。

## 価格・状態

- 作者 Anvil Interactive Solutions ([[weightforge]] と同作者)。$19 (表示 $14.25)。販売 10、公開 6 か月前。
- Blender 5.0〜5.1 (5.2 は未対応表記)。Win / Mac / Linux。
- 要アカウント: Meshy (生成・取り込み)、Rodin / Tripo (取り込み)。クラウド生成の利用料は別。

## 機能

- 生成キュー: Meshy / Tripo に複数プロンプトを投げ、終了次第自動取り込み。画像 → 3D も。
- 履歴ブラウザ: Meshy / Rodin / Tripo の過去生成から Download & Import。バックグラウンドで DL。
- PBR (albedo / normal / roughness / metallic) 自動配線。リネーム・コレクション・スケール正規化。
- バリエーション比較 (並べて表示)、FBX / GLB / OBJ のクイック出力。
- Webhook リスナー (Meshy のゼロクリック取り込み)。Unreal Engine 5 への送信 (LOD プリセット)。
- デモモード: Khronos サンプル 6 種 (アカウント不要)。API キーは Blender ユーザーディレクトリにローカル保存。
- Ultra 導入時: Smart Convert (ML ルーティングでクアッド化)、Quality Pass を自動実行。

## 使い所の見立て (推測)

- Meshy / Tripo のクラウド生成を日常的に使う場合の取り込み自動化。
- MCP からの操作: `quadify_remesh` 等は Ultra が必要。ローカル系 (Bizen3D・Image to 3D) には関係しない。
- Blender MCP 連携としては GenMesh ([[genmesh]]) と同様、個別製品が自前の MCP を持つ例。ただし今の Blender MCP の `generate_3d` と機能が被る。

## 関連

- [[quadmend]] / [[mesh-prep-studio]] (リトポ本体)
