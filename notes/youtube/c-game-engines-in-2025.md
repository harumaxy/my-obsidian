---
title: C++ Game Engines in 2025
description: 2025年のC++ゲームエンジンの包括的なガイド。3D・2D双方のエンジンを比較
aliases:
  - C++ game engines 2025
tags:
  - gamedev
  - c++
  - engines
draft: false
date: 2026-06-22
---

## 概要

2025年時点で利用可能なC++ゲームエンジンとフレームワークの包括的なレビュー。3D・2Dの両カテゴリをカバーし、商用エンジンからオープンソースプロジェクトまで網羅している。

## 3D エンジン

### メインストリーム

| エンジン | 特徴 | ライセンス |
|---------|------|----------|
| **Unreal Engine** | 最も有名な3Dエンジン。無料で開始、100万ドルまで収益化可能 | 商用 |
| **Godot** | オープンソース。GDScriptが主流だがC++でも開発可能 | MIT |
| **Flax Engine** | Unrealの小型版。学習曲線が緩い | 商用（ソース開示） |
| **Unigene** | 強力なレンダリング、フル機能のエンジン | 商用 |

### オープンソース・中堅

- **O3DE** — Amazon傘下、CryEngineの派生。改善中
- **Wicked Engine** — 1人開発のため驚異的な機能量
- **Spartan Engine** — 個人開発、Vulkan、MIT ライセンス
- **Rebel Fork (rbfx)** — Hero 3D の後継
- **Lumix Engine** — MIT ライセンス、Editor搭載

### 古参・ニッチ

- **Cry Engine** — 過去作多数だが開発停滞中
- **Torque 3D** — 歴史あるオープンソースエンジン
- **C4 Engine** — 1999年から存在する長寿エンジン
- **Ultra Engine** — 高性能（Unity比10倍速を主張）
- **Spring Engine** — RTS ゲーム特化

### フレームワーク・ライブラリ

- **Ogre 3D** — レンダリングライブラリ（単体エンジンではない）
- **Vulkan Scene Graph** — Ogre の後継
- **The Forge** — プロ向けレンダリングフレームワーク

## 2D エンジン・フレームワーク

### マルチメディアライブラリ

| ライブラリ | 特徴 |
|-----------|------|
| **SDL 3** | Steam採用。モダンシェーダ対応 |
| **SFML 3** | シンプルで使いやすい。最近v3リリース |
| **Allegro** | 40年の歴史、継続更新 |
| **Oxygen** | Web 2D ゲーム向け |

### ゲームエンジン

- **Torque 2D** — Torque 3D の2D版
- **Orcs** — データ駆動型、ECS アプローチ
- **Axel** — Cocos2D フォーク、継続開発中

## 特記事項

### ライセンスの注意

- **GPL v3 / LGPL v3** — 自分の作品をオープンソース化する必要がある（商用化に不利）
- **MIT / BSD** — 商用利用でも制約が少ない
- **商用** — Unreal 等は利益が一定以下なら無料

### 選択のポイント

1. **オープンソースが豊富** — 無料で高機能なエンジンが多数
2. **Unreal 一択ではない** — Godot、Flax、Hazel などが実用的
3. **個人開発プロジェクトの質が高い** — Wicked Engine、Spartan など
4. **フレームワークか完全エンジンか** — SFML/SDL は低レベル、Godot/Unreal は高レベル

## 非推奨・検討対象外

- **Hazel Engine** — Patreon限定（10$/月）、オープンな試用版がない
- **Storm Engine** — GPL3、モディング用
- **Liman** — LGPL v3、開発状況不明
- **Cocos2D** — Cocos Creator に注力中

## 動画参考資料

[gamefromscratch.com: C++ Game Engines in 2025](https://gamefromscratch.com/c-c-game-engines-in-2025/)

