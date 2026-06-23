---
title: USAGI Engine - 新しい2Dゲームエンジン
description: PICO-8、LÖVE、Dragon Rubyの思想を組み合わせた軽量で使いやすいLua 2Dゲームエンジン
aliases:
  - USAGI
  - usagi-engine
tags:
  - gamedev
  - lua
  - game-engine
  - tools
draft: false
date: 2026-06-22
---

# USAGI Engine - 新しい2Dゲームエンジン

> 動画: [USAGI Engine - New Stupidly Easy 2D Game Engine](https://www.youtube.com/watch?v=yGW1M1LbnLc) by Game from Scratch

## 概要

**USAGI Engine** は、PICO-8、LÖVE、Dragon Rubyの思想を組み合わせた、フリー・オープンソースのLua 2Dゲームエンジン。ピクセルアート風のゲーム、プロトタイピング、ゲームジャム向け。

- **言語**: Lua 5.5
- **ライセンス**: Unlicense（非常に自由度が高い）
- **バージョン**: 1.0（2026年5月末リリース）
- **ファイルサイズ**: 2MB（超軽量）
- **対応OS**: Mac、Windows、Linux、Web

## 主な特徴

### 🎯 設計理念
「**制約を通じた創造性**」
- デフォルト解像度：320×180
- デフォルトスプライトサイズ：16×16
- Small、Fixed なAPI（できることが限られている）
- 60 FPS を想定した設計

### ⚡ 開発効率
- **ライブリロード**: コード保存時に自動的に実行中のゲームに反映
- **ワンコマンドエクスポート**: Linux、macOS、Windows、Webに一度に出力
- **組み込み機能**: ポーズメニュー、入力リマッピング、ゲーム保存

### 🔧 セットアップが簡単
```bash
# 1. インストール（itch.ioから）
# 2. PATH に追加
# 3. プロジェクト作成
usagi init

# 4. 開発サーバー起動（ライブリロード）
usagi dev

# 5. エクスポート
usagi export
```

## API 構成

### ライフサイクルコールバック
- `configure()` - プロジェクト設定
- `init()` - ゲーム開始時の初期化
- `update(dt)` - 毎フレーム実行（ゲームロジック）
- `draw()` - 描画処理

### 主要API
- **グラフィックス**: `gfx.rectangle()`、`gfx.circle()`、スプライト描画
- **入力**: キーボード、ゲームパッド
- **サウンド**: 音楽、効果音
- **シェーダー**: Fragment shader サポート（Game Boy風フィルタなど）
- **セーブ機能**: ゲーム状態の保存

### ファイル構成
```
my-game/
├── main.lua          # エントリーポイント（必須）
├── assets/
│   ├── sprites.png   # 全スプライトをまとめたテクスチャ
│   ├── music/        # 音楽ファイル
│   └── sfx/          # 効果音ファイル
├── shaders/          # カスタムシェーダー
└── data/             # ゲームデータ
```

## プロジェクト例

### Tetris
- サウンド、入力処理、ゲームロジック
- シンプルなスプライト構成
- 基本的な全機能を網羅

### Shader Examples
- Fragment shader による視覚効果
- Game Boy 風フィルタ
- スキャンライン効果

### Bunnymark
- パフォーマンステスト例
- 大量のスプライト描画テスト

## LÖVE（love2d）との比較

| 項目 | USAGI | LÖVE |
|------|-------|------|
| **成熟度** | 新しい（1.0） | 成熟している |
| **ファイルサイズ** | 2MB | より大きい |
| **デフォルト解像度** | 320×180（固定） | 自由 |
| **API規模** | Small、Fixed | 大規模、拡張可能 |
| **プラットフォーム** | Win、Mac、Linux、Web | Win、Mac、Linux、Android、iOS |
| **ライブリロード** | ✅ 組み込み | ❌ 別途ツール |
| **ワンコマンドエクスポート** | ✅ | ❌ |
| **物理エンジン** | シンプル | LÖVE Physics 搭載 |
| **コミュニティ** | 小さい | 大規模（ライブラリ豊富） |

### 使い分け
- **USAGI**: ゲームジャム、プロトタイピング、Webゲーム、ピクセルアート風
- **LÖVE**: 本格的なゲーム開発、複雑な物理、モバイルリリース、大規模プロジェクト

## 利点

✅ **完全無料**（PICO-8と異なり）
✅ **オープンソース**（Unlicense）
✅ **超軽量インストール**
✅ **クロスプラットフォーム対応**（Webも）
✅ **ライブリロード**で迅速なイテレーション
✅ **充実したドキュメント**
✅ **豊富なサンプル**
✅ **シェーダーサポート**
✅ **初心者向け**

## 欠点・制限

❌ 新しいプロジェクト（サポートがまだ少ない）
❌ モバイル対応なし（AndroidやiOS）
❌ 制約された仕様（カスタマイズ性が低い）
❌ コミュニティが小さい

## 参考リンク

- [公式サイト](https://usagiengine.com)
- [GitHub リポジトリ](https://github.com/usagi-engine/usagi) 
- [itch.io ダウンロード](https://itch.io)
- [ドキュメント](https://usagiengine.com)（usagiengine.com に統約）

## まとめ

USAGI Engine は「**制約の中で素早くゲームを作る**」というコンセプトの、非常に使いやすいエンジン。PICO-8の思想（制約）と LÖVE の実用性、Dragon Ruby の開発効率を組み合わせている。ゲームジャムやプロトタイピング、学習用途に最適。

