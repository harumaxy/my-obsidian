---
title: Souls-like 3日制作 全アセットAI生成 (Stefan 3D AI)
description: 熟練3Dアーティスト 72時間 Souls-like 作る。Tripo + Blender + UE5.8 + Claude Code。
aliases:
  -
tags:
  - youtube
  - ai
  - 3d
  - gamedev
  - unreal-engine
  - blender
  - tripo
draft: false
date: 2026-10-31
---

# I Built a Souls-Like Game in 3 Days - Every Asset Made by AI

- URL: https://www.youtube.com/watch?v=9kejfKCb0S8
- チャンネル: Stefan 3D AI (2026-08-16)

## 前提

- 3D アーティスト (テクニカルアーティスト10年) 72時間で作る。アイデア出し期間 含まない
- 「プロンプト一発でゲーム完成」 信じない。センス + アイデア 必要。AI は使う人次第
- コンセプト: 円形遺跡アリーナ、騎士、鹿モチーフのボス。Dark Souls / Bloodborne / Elden Ring の雰囲気

## アセットパイプライン (約1.5日)

1. **Tripo でハイポリ生成**
   - Smart Mesh は 20k tri 上限。小物ディテール 落ちる → ハイポリのまま生成
2. **Blender で整備**
   - ローポリ: Tripo リトポ or Decimate
   - UV: Smart Project + UV パッキングアドオン。手動展開 省略
   - ハイ→ロー Cycles でベイク。Normal / AO / **色もベイク** → テクスチャ再生成 不要
   - 静的アセットに完璧なワイヤーフレーム・UV 要らない、という考え
3. **タイルテクスチャ**: Patina (fold.ai) でシームレス生成。AO / Normal も同 AI で出る
   - 地面・壁・チェーンメイル 用
   - アリーナ全体を 3D 一発生成 = 無意味。8K でもぼやける → タイルで十分
   - 円形エリア: 画像生成 + 円柱投影。3D 生成 不要で安い
4. **アリーナ構築**: Blender で プリミティブ + Curve + Array モディファイア。壁を円周上に配置。小物は UE 側ブラシ

## キャラクター (ボス / プレイヤー)

- 環境アセット同様、**ほぼハイポリで Tripo 生成**
- Blender **Sculpt モード** でパーツ組み合わせ。ストレッチ系ブラシ使う
- 男性リファレンスの体の一部 流用 (プロポーション崩れ対策)
- 露出部分に チェーンメイルのタイルテクスチャ 適用
- パーツごとに Tripo でリトポ → ハイ/ロー 元に戻して アセットと同じベイク
  - 別ルート: ローポリに Tripo でテクスチャ → ベイクは Normal + AO のみ。どちらも ほぼ同じ地点に着く
- エプロン・マント: 平面 + Gemini (Nano Banana Pro) でアルファテクスチャ
- リグ: AccuRig (マーカー設定)。ヒューマノイドなので簡単。Weight は多少調整
- 詳細は 同チャンネルの 1時間「AIで3Dキャラ 完全初心者ガイド」にある

### 未確認点

- Tripo の入力 (テキスト/画像、パーツ単位/全身) 動画内で説明なし
- 「パーツ組み合わせ」が 人体パーツ (頭・胴・四肢) か 鎧・装飾か 字幕だけでは不明。推測: 個別生成 → Blender 位置合わせ → Sculpt で継ぎ目なじませ + プロポーション調整 + 形崩れ修正

## Unreal Engine 側

- UE 5.8 + **Vibe UE** (UE ネイティブ MCP) + Claude Code
- **Souls-like テンプレート**から開始。メカニクス把握しやすい。初心者にも勧める
- Claude Code の用途:
  - テンプレート構造の調査
  - ボス / キャラの Blueprint 接続、武器設定
  - ボス登場シネマティクス (カメラワーク)
- 全部任せてない。Opus 5 はよく動くが API 課金だと非常に高い (Kimi K3 / GPT とも比較)
- マテリアルは Blender から持ち込めず UE で手動再構築 (一番手間)
- 無料 VFX (火)、水シェーダー、Ultra Dynamic Sky/Weather、霧で演出
- 衣服物理 (Cloth) は UE 5.8 で簡単化。Weight ペイント + ボーンコライダー設定

## 結論

- AI は初心者より **プロにとって大きなレバレッジ**。3D / ゲーム開発の基礎 + AI エージェント指揮が要る
- 成果: ロケーション完成、キャラ2体、ボス戦のみ遊べる。うるさいゲーム
- アイデア出しは AI に代行できない
- 予告: Tripo P2 (Smart Mesh 強化) 近日
