---
title: Eden Ultimate Character Studio + Wrap
description: スタイライズ/リアル両対応の人体ビルダー。Wrap で AI 生成人型に Eden ベースをフィット。Eden $30 / Wrap $7.50、公開1日目
# permalink:  # don't use
aliases:
  - eden-character-studio
tags:
  - blender
  - superhive
  - character
  - character-creator
draft: false
date: 2026-11-18
---

# Eden Ultimate Character Studio + Wrap

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/eden-ultimate-charcters-studio-plus-wrap

## TL;DR

- 男女ベースから顔・体スライダーで作るキャラビルダー。髪30、服28、スキン 512〜8K、アニメ用リグ付き。
- **Wrap 拡張 ($7.50) が肝**。AI 生成の人型を取り込み、ランドマークで Eden ベースをフィット → 髪・服・リグを Eden 側で使える。
- AI 生成メッシュを「リグ・服つき規格ボディ」に載せ替える道。[[rigmend]] とは別方向 (向こうは AI メッシュそのままリグ)。
- 公開1日目、評価2件。Blender 5.0〜5.3、Cycles のみ。実績ほぼなし。

## 価格・状態

- 作者 Xane Studios。Eden $30 (定価 $59.99)、Wrap $7.50 (定価 $15)。販売 90+、評価2件。
- 12か月のサポート + 更新込み。延長は +12か月で製品価格の50%。
- Blender 5.0〜5.3、Cycles。ライセンス GPL 表記 (アセット側の条件は要確認)。UV 展開済み・リグ付き・テクスチャ付き。

## 機能

- 形状: 顔・体スライダー、頭・顔シェイプグラフ。年齢 17〜95。ランダム化 (範囲・強度指定)。
- スキン: 肌色、そばかす、頬紅、唇、爪など。解像度 512〜8K。
- 髪: 30種 (男女各15。スタイライズ10 + リアル5)、眉・まつ毛、髭10。グレー設定。
- 服: 28着 (男女各14)。フィッティングで体型に追従。
- プリセット保存 (サムネ付き)。
- 仕上げ: アニメ用リグ生成、スキンのベイク。

## Wrap

- 男女どちらかの Eden ベースを選び、ガイド付きランドマークで取り込みモデルに合わせる。プレビューして調整後に確定。
- 取り込みモデルのスキンテクスチャを転写、または Eden スキンに切替。
- その後は比率調整、髪・服、仕上げ・リグ。
- 作者の注意: ガイド付きフィット。結果は元モデルの形と状態次第で、ランドマーク追加調整が要る場合あり。

## ゲーム用途の見立て (推測含む)

- 頂点数・トポロジー・LOD・エンジン書き出し (FBX/GLB) の記載は取得ページになし。要確認。
- リグが ARP 互換かは不明。ARP 持ちなら Eden リグ → ARP リターゲット or ARP 側で再リグ。
- Cycles 前提のスキン/髪。ゲームでは焼き込み (Bake) 後の扱いが要点。
- 実績が薄いので、買うなら Wrap の出来を AI 生成 1体で試してから。

## 関連

- 見た目の所感 (ユーザー): サムネ・gif のキャラが西洋寄りで個性的。無個性な土台向きでない。[[autocharacters]] の方が使いやすそう。優先度を下げる。方針は [[character-clothing-workflow]]

- [[autocharacters]] (パラメトリック人体。ゲーム向けに近い) / [[human-generator]] (リアル特化・実績大)
- AI 生成人型の取り込み → [[bizen3d]] / [[image-to-3d-milad]]
