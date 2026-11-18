---
title: MotionGen
description: 動画→アーマチュアのマーカーレスモーキャプ。評価5.0 (77件)、ARP リターゲット実績あり。Lite $1 / Pro $29 / Gold $57。Windows のみ
# permalink:  # don't use
aliases:
  - motiongen
tags:
  - blender
  - superhive
  - motion
  - mocap
draft: false
date: 2026-11-18
---

# MotionGen

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/motiongen

## TL;DR

- 人が映った動画 → AI が姿勢推定 → アーマチュアのキーに変換する **video-to-motion**。テキスト入力はない。自撮りをレファレンスにできる。
- **自分が演じられる動きなら、コントロール性が高い**。タイミング・間・重さを自分の動きで指定できる。レビューで「重さの感覚がある」「ジッタ除去が動きの性格を保つ」。
- **ARP 対応済み** (v2.7.5 以降)。レビューで ARP リグへのリターゲット成功あり。ただしコントローラ (IK/FK) に書くのかボーンかは公式未記載。
- 弱点: 指・顔は取れない。1人・全身・固定カメラ前提。撮れない動きは作れない。仕上げ (足接地・ループ・ルート) は手直し前提。
- Lite $1 (3秒) で自撮り → ARP を先に試す。商用は Pro $29 以上。
- 演じられない動き・量産は [[blaze-puppeteer]] / [[kimodo-blender-bridge]] と使い分ける ([[comparison-game-pipeline]])。

## 価格・状態

- 作者 TAngraFX。
  - Lite $1: 動画1本3秒まで、非商用。
  - Pro $29: 30秒まで、商用可 (1席)。
  - Gold $57: 長さ無制限、商用可 (1席)。
  - Ultimate $250: 10席、スタジオ用。
- **評価 5.0 (77件、5星 95%)**。
- アドオンコードは MIT。エンジンは永久ライセンス (初回のみネット接続で認証)。

## 種類

- **動画 → アーマチュア** (マーカーレス)。テキスト → モーションではなく、自分で撮った / 素材の動画から取る。
- MP4 / MOV / AVI。**WebM は不可**。

## 要件

- **Windows のみ**。Linux / Mac は開発中 (時期未定)。
- NVIDIA 2080 以上 (30系以上推奨)、VRAM 8GB+。Blender 3.6〜5.2。15GB。RAM 8GB+。
- 8GB VRAM では最大10倍遅くなる (RAM にフォールバック)。FHD 以下に縮小・クロップで VRAM と速度が大きく改善。

## 使い方 (docs)

1. Preferences でエンジン導入 (約15GB)、ライセンス認証 (初回のみネット接続)。
2. N パネルで Start Engine。エンジンのウィンドウは最小化して閉じない。
3. 動画を選んで Process Video。人物検出は YOLOX / ViTDet を自動選択。FPS は動画から自動取得。
4. MotionGen 専用アーマチュアにモーションが付く。
5. 自分のリグへリターゲット → 足接地・ジッタ補正 → 書き出し。

## 撮影のコツ (docs)

- 全身が常に映る。1人だけ。明るく、モーションブラーを避ける。
- **黒い服は AI が追いにくい**。
- 解像度は 480p〜1080p まで。大きくしても精度は上がらず、VRAM と時間が増えるだけ。
- 短いクリップで先に品質確認。

## 機能 (全ティア共通)

- Video to Armature。
  - Animate Armature: 3D 空間を移動。
  - **Armature InPlace**: 原点固定。ゲームエンジンのルートモーション制御向け。
- A / T ポーズ・各リグのレスト姿勢を frame 0 に適用 (リターゲット前に必要)。
- リターゲット: **Rigify (IK/FK) / UE Mannequin・MetaHuman / Mixamo / iClone・CC4/5 / Auto-Rig Pro** (v2.7.5 で ARP 対応、v2.9.8 で ARP Smart)。手動リターゲットもあり。
- **Motion Layer / Motion Blending / Motion Influence**: ベイクされたキーを触らない非破壊編集レイヤー。
- **IK Controller (Body Schema)**: モーキャプに IK を後付けしてキーを打てる。
- **Auto Foot Lock**: 足滑り修正 (最小足高さ・足速度・曲げ量を調整)。Dynamic foot lock / Anti sliding。
- Fix Ground Offset、Fix Vertical Drift (Z ドリフト補正)。
- Jitter Cleanup (カットオフ既定 3.0)、Reduce Keyframes (既定 50%)。

## 限界

- **顔と手の指は取れない** (Face / Hand Gesture Extraction はロードマップ)。
- カメラ固定が前提のはず。Camera Tracking / Static Camera Mode はロードマップ。動くカメラの動画はルート移動が不正確になる可能性 (推測)。
- 1人・全身が必要。
- 剛体シミュ (落下・衝突) はロードマップ。
- ロードマップの全体: アニメライブラリ、カメラ追跡、パスコントローラ、足接地補正、剛体シミュ。ARP 対応はロードマップ欄に残っているが、リリースノート上は対応済み (ページ側の更新漏れの可能性)。

## 商用で気にすること (推測、要確認)

- docs は人物検出 (YOLOX / ViTDet) までしか書かず、姿勢推定の本体モデル名を出していない。
- この種の 3D 人体復元は SMPL 系の人体モデルを使うことが多く、SMPL は商用に別ライセンスが必要な場合がある。MotionGen に当てはまるかは未確認。
- docs に「使用ライブラリ・SDK のライセンスと規約に同意」とある。Pro / Gold は商用可と明記されているが、作者に確認するのが安全。

## ARP リターゲットの調査 (2026-11-18)

### 時系列 (リリースノート + レビュー)

- 約4か月前: 「ARP へのリターゲットを待っている」というレビューが複数。まだ未対応。
- v2.7.1: Rigged + Controller 対応、Rigify IK/FK 対応、iClone / CC4/5 対応、リグプリセット、Motion Layer / Blending / Influence。
- **v2.7.5**: 「Auto Rig Pro Retargeting」追加。作者が質問に「Rigify と Autorig Pro は v2.7.5 以降で更新した」と返信。Blender 5.2 対応。
- **v2.9.4**: Foot lock、Fix vertical drift、IK Box Controller、Body Schema。
- **v2.9.8**: 「ARP Smart」「Manual retarget」「Id mapping」「Email mapping」「Version manager」、Mixamo 左手修正。
- **v2.9.9**: Dynamic foot lock、Anti sliding、より滑らかなアニメ、VRAM 削減、Clear cache。
- ロードマップ欄には ARP の「Retarget to Rig with Controller」が残っているが、リリースノートでは対応済み。ページの更新漏れとみる。

### 実際に ARP で使えているか (レビュー)

- Erik (1日前): ARP リグのキャラへのリターゲットが良い結果。足滑り修正と整理も「かなり機能する」。ただし最終的な整理には、無料のリターゲット系アドオンに頼る予定と書いている。
- metancholic (3か月前、Gold): 最新版は ARP 自動リターゲット用プリセットと、使いやすい手動リターゲットが付いた。
- Aldar (2か月前): v2.93 には ARP リターゲットがなく、サポートに頼んで v2.99 で追加された。レイヤーでポーズ編集もできる。
- 別の人は MotionGen 付属の Mixamo リグ経由で Second Life へ転写 (追加アドオン併用)。

### 分かっていないこと

- 出力が ARP の **IK / FK コントローラ**に乗るのか、**デフォーム骨**に乗るのか。
- 「ARP Smart」の意味 (ARP の Smart で作ったリグへの対応、の可能性。推測)。
- ARP の Remap を内部で呼ぶのか、独自処理か。
- ソース骨格は付属の Mixamo 系リグと思われる。レスト姿勢 (A / T ポーズ等) を frame 0 に適用する必要がある。

### 品質面 (レビューから)

- 「動きに重さの感覚がある。市販のモーキャプスーツでも欠けがちな点」(michel)。悪い照明、YouTube の小さい動画、速い動きでも良い結果。
- 「ワンクリックのジッタ除去が元の動きの性格を保つ。他のスムージングはそうならない」。
- 「良いベース」(Craig)。仕上げ前提の評価。
- サポートが特に高評価 (Discord で即応答、遠隔操作での解決例)。

### 購入面

- **12か月分のサポートと更新が込み**。延長は +12か月で製品価格の50%。
- 公式サイト tangrafx.com は読み込み時点でメンテナンス表示だった。

### 注意

- 検索で出た「MotionGen は SMPL-X アーマチュアを出力し ARP の Remap で転写」という第三者ガイドは、別プロジェクト (haseebahmed295 の motion_gen) の可能性が高い。根拠には使っていない。

### 確かめる方法

- Lite ($1、3秒) で短い自撮りを ARP リグに通す。コントローラに乗るか、足滑り・ループ・ルートを見る。
- 作者の Discord / Superhive メッセージで「ARP リターゲットは IK/FK コントローラに書くか」を直接聞く。サポートの評判が高い。

## text-to-motion との違い

- text-to-motion ([[kimodo-blender-bridge]] / [[blaze-puppeteer]]): 動きを一から生成。意図は指示できるが、狙い通りにはなりにくい。
- MotionGen: 実際に人が動いた動きを取る。重さ・予備動作などの質感が本物。ただし撮影が要る。空中戦・ファンタジー動作は不向き。
- 手直しの中心: 動画由来はジッタと足滑りの補正。AI 生成は動きの不自然さも含む。
- 組み合わせ案: 自撮りで骨格を取り、足りない箇所を Blaze の Inbetweening でつなぐ。

## ライセンス

- ハードウェア指紋に紐付き、**PC 間移行不可** (Windows 再インストールは可)。Ultimate は10台まで。
- 複数の Blender バージョンで使うのは可 (同一 PC)。

## レビュー要点 (1ページ目 10件)

- **ARP へのリターゲット確認済み**: 「Auto Rig Pro のキャラにも良い結果。足滑り修正も機能」(Erik)。v2.99 で ARP 対応が入った (Aldar)。
- サポートが非常に手厚い。AnyDesk でリモート解決した例が複数。同種アドオン (Blendcap) より対応が良いという比較コメントも。
- 不満: 初回のライセンスと回転行列の扱いで苦労した声。MMD スケルトン対応の要望。

## FAQ の要点

- CUDA kernel build failed → NVIDIA ドライバを更新。
- Out of memory → 他の GPU アプリを閉じる、短い動画、解像度を下げる。
- 複数人・全身が映っていない動画は不向き (全身が明瞭に映ること)。

## 関連

- テキストから作るなら [[kimodo-blender-bridge]] / [[blaze-puppeteer]]。
- Auto-Rig Pro 持ちには動画モーキャプの最有力候補。
