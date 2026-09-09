---
title: sorceress-ai-game-asset-suite
description: AIゲームアセット生成スイート Sorceress の調査メモ。Spritly→Sorceress統合の流れ、料金構造、Tripo/Meshy/ローカルSDとの比較、収益モデル分析。
# permalink:  # don't use
aliases:
  - Sorceress
  - Spritly
  - AutoSprite
tags:
  - ai-tool
  - game-dev
  - sprite
draft: false
date: 2026-09-07
---

## 元ネタ

YouTube: [From AI Character Art to Animated Sprite - Game Ready in 5 Minutes!](https://www.youtube.com/watch?v=sTuzV9RxWro) (DevDude.Unreal, 2025-11-15)

## Spritly ワークフロー(動画時点)

1. OpenArt(Nano Banana / Seedream等)でピクセルアート風キャラ生成、背景を緑/青/黒スクリーン指定
2. Grok Imagineでキャラ画像→歩行アニメ動画化
3. 自作ツール「Spritly」に動画投入
   - ループの開始/終了フレーム選択(ウォークサイクル用)
   - 全フレーム抽出、FPS再生確認、フレーム個別選別可
   - クロマキーで背景除去
   - オートクロップ&サイズ調整(64/128/512px等)、reduce機能でキャラをフレーム内に収める
   - ハロー除去(緑背景の縁残りを透明部分から指定px分削る)
4. 完成スプライトシート or 個別フレームzipダウンロード

動画公開時点で未リリース、買い切り(サブスクなし)予定と発言。

## 現状(2026年時点)

Spritly → **Spritely V2 = AutoSprite** として Sorceress スイートに統合済み。単体版Spritelyも並行存在。

- 旧Spritely単体: 無料5エクスポート、有料$30買い切り無制限
- Sorceress本体: $49生涯アクセス(全ツール込)、無料トライアル100クレジット

### Sorceress スイート構成

- **Auto-Sprite v2**: AI画像/動画→ゲーム用スプライトシート(旧Spritely後継)
- **3D Studio**: プロンプト→リグ済み・アニメーション付き3Dキャラ。Hunyuan3D/Meshy/TRELLIS/Rodin/Tripoなど外部モデルをパネルから選択可能。自動リギング(業界標準ボーン、頂点ウェイト自動計算)+ブラシ微調整、テキスト指示でアニメーション生成(walk cycle等)、GLB統一出力(Unity/Unreal/Godot/Blender/Three.js/Babylon.js対応)
- **Voxel Studio**、音楽/効果音/AI音声生成
- **Sorceress API**: コーディングエージェント向けAPI提供
- **WizardGenie**: AI駆動ゲームエンジン(早期アクセス)

## 料金構造

クレジット単価: $10=1000credits → **1credit=$0.01**

| 生成 | Sorceress経由 | 直接API |
|---|---|---|
| Tripo v3.1(テクスチャ付き) | 40credits=$0.40 | Tripo公式40credits=$0.40(同額、マージンほぼゼロ) |
| Meshy 6(テクスチャ+リメッシュ) | 88credits=$0.88 | Meshy側レート非公開、比較不可 |
| 自動リギング | **0credits** | (Sorceress独自機能、外部API不使用) |
| アニメーション生成 | **2credits=$0.02/クリップ** | (激安、自社製 or 廉価モデル使用の可能性) |

外部3D生成モデル呼び出し自体はほぼ原価転嫁。マージンは別のところにある。

## 収益モデル(推測込み)

razor-and-blades の逆パターン:

1. **$49買い切りが本体利益**。実コストほぼゼロの「入場料」
2. **自社処理(リギング/アニメーション/スプライト加工)が実質原価タダ**。外部API課金なしで動く部分が付加価値の核なのに、価格はほぼ乗せてない→ここが利益源
3. **クレジット前受け金(float)**。買ったが使い切らないクレジットの現金プール
4. **継続収益**: VIPメンバーシップ、API課金(コーディングエージェント向け)

## Tripo/Meshy直接 or ローカルSDとの比較

| 項目 | Tripo/Meshy単体 | ローカルSD/ComfyUI | Sorceress |
|---|---|---|---|
| 3D生成精度 | 各社最高品質 | 非対応(2D専用) | 同モデル呼ぶだけなので同等 |
| リギング | 別途手動(Blender等) | 非対応 | 自動+ブラシ微調整 |
| アニメーション | 別途 | 非対応 | テキスト指示で自動 |
| 2Dスプライト化 | 非対応 | 自前ワークフロー必要 | Auto-Sprite内蔵 |
| コスト | 各社サブスク別々 | 無料(電気代のみ) | $49買い切り+都度クレジット |
| カスタマイズ性 | モデル次第 | 最大(LoRA/ControlNet等自由) | 低い(パイプライン固定) |

**使う価値ある場面**: Tripo/Meshyで生成後の手動リギングが面倒な人、複数3Dモデルをバラバラ契約せず比較したい人、2D+3D両方ツール分散させたくない人。

**使う価値薄い場面**: [[project_comfyui_study|ComfyUI]]などローカルで自前パイプライン組んでる人。カスタマイズ性・コスト面で局所的に負ける。生成品質自体を求めるなら元のTripo/Meshy直接使うのと変わらない(単なるラッパー)。

## リンク

- https://sorceress.games/
- https://spritely.gamemaker.academy/
- https://sorceress.games/3d-studio
- https://sorceress.games/plans
