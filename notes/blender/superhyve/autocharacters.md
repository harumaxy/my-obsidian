---
title: AutoCharacters
description: 男女パラメトリック人体 + 衣装168着 + ポーズ + リグ。ゲームは Commercial 必須。評価5.0 (16件)、販売800+
# permalink:  # don't use
aliases:
  - autocharacters
tags:
  - blender
  - superhive
  - character
  - character-creator
draft: false
date: 2026-11-18
---

# AutoCharacters

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/autocharacters-male--female-body-presets-base

## TL;DR

- 男女ベース + 100+ 体コントロール + モジュラー (髪・耳・鼻・角・尻尾) + 衣装 + ポーズ + リグ。**カスタマイズ可能キャラ向けの本命**。
- 衣装は体型に morph + リグウェイトで追従する。着せ替え前提のゲームに噛み合う。
- **ゲームは Commercial 必須** (Standard は個人・教育・非商用)。素材の再配布不可。ゲーム内からの抽出対策も求められる。
- 頂点数 約1.1〜1.2万 (SFW) と軽くない。ゲーム用は LOD / ポリ予算の検討が要る。

## 価格 (調査時点)

- Base: Standard $26.99 (定価 $59.98、最初の2000人50%オフ) / Commercial $134.99。
- Complete (Base + Expansion): Standard $58.49 / Commercial $157.49。
- Studio: 10人まで (価格未取得)。Complete へのアップグレードに $15 クーポンあり (13日、残り2000回)。
- 販売 800+、評価 **5.0 (16件)**。公開約2か月前。12か月のサポート + 更新込み (延長は製品価格の100%)。
- ライセンス表記は Creative Commons (購入条件は商品ページの規約に従う。要確認)。

## 内容

- Base: 男女ベース、SFW/NSFW 各マスターシーン、コアのモジュラーライブラリ、スターター衣装9、アニメ髪 男女各5、ポーズ5。
- Complete: Base + 衣装168 (男75 / 女93。UV 付き・morph 付き)、ポーズ100、髭・眼鏡。
- 体: 101 コアコントロール (Body / Proportions / Upper Body / Abdomen / Torso / Hips / Arms / Legs / Hands / Feet ほか)。プリセット: 体5 + スタイライズ6 + キャラ3。
- モジュラー: 耳20、鼻20、角20、尻尾20、髪 男女各10 ほか。体型を変えても付いてくる (v2.3 で修正)。
- リグ: 体型変更に自動フィット、手・指サイズ (左右別)。**アニメ後の体型変更は不可** (先に比率を決める)。
- ランダム化 (ロック・お気に入り・JSON プリセット保存)。
- 出力: 別コピーを確定して使う。GLB 書き出し任意 (出力先で材質・リグの追加設定が要る場合あり)。
- アセットブラウザ用 268 点のライブラリ。
- Blender: Standard 5.2、Legacy 3.6〜4.5 の2系統。Cycles。

## 数値

- SFW: 女 12,116 頂点 / 男 11,242 頂点 (各 101 コントロール)。
- NSFW: 女 16,285 / 男 12,269 (成人向けコントロール追加)。
- 衣装のトライアングル数は商品ページ内カタログに記載 (細部未取得)。

## 注意

- 衣装は布シミュなし。極端な組み合わせ・重ね着・座った長衣・手と体の接触は局所調整が要る。
- 衣装の貫通は Basis シェイプキーを Edit Mode で手直し。
- ゲーム配布: 素材抽出対策が必要。.blend・メッシュ・リグ・テクスチャ・モジュラー部品・プリセットの単体/編集可能配布は不可。
- 予定 v3.1: 自作アセットの取り込み、体の部位を衣装下で非表示にして貫通を減らす。
- NSFW マスターが同梱される (SFW だけ使う運用は可)。

## ゲーム用途の見立て (推測含む)

- カスタマイズ可能プレイヤーキャラ・NPC 量産に向く。AI 生成 ([[bizen3d]] 等) は服・小物・武器に回し、体は本製品、が分担案。
- リグが ARP 互換かは不明 (同梱リグ前提)。ARP 持ちは、同梱リグのままか ARP で再リグかを検証。
- ウェイトの再計算が要るなら [[adaptive-auto-skinning]] / VHD。
- 費用: ゲームなら Commercial。Complete Commercial $157.49。まず Base で試して $15 クーポンでアップグレードする手も。

## 関連

- 方針・用途別の流れ・服の扱い: [[character-clothing-workflow]] / 自作服: [[simply-cloth]]

- [[eden-character-studio]] / [[human-generator]]
- 同作者: [[autocreatures]]
