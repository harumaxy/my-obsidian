---
title: Blaze Puppeteer
description: Kimodo ベースの人型モーション生成。リターゲット不要でリグに直接書く。ARP 専用プリセットあり。$59、評価4.0 (11件)
# permalink:  # don't use
aliases:
  - blaze-puppeteer
tags:
  - blender
  - superhive
  - motion
  - text-to-motion
draft: false
date: 2026-11-18
---

# Blaze Puppeteer

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/blaze-puppeteer
公式: https://blazeanimation.com/superhive/blaze-puppeteer / ドキュメント https://docs.blazeanimation.com/

商品ページ本体は iframe。公式サイトとドキュメントをブラウザで直接読んで確認した。

## 価格・状態

- Standard $59 (500クレジット込み)。Studio 5席 $199 (2500クレジット)。10席 $349 (5000クレジット)。
- **評価 4.0 (11件)**。5星 73%。
- 現行 v1.3.0 (2026-07-16)。Blender 5.2 対応済み。約半年で3回の大きな更新。

## 要件

- Blender 4.2+。**Windows x64 / Linux x64 / macOS Apple Silicon**。
- NVIDIA RTX 推奨、VRAM 4GB 以上。CPU 生成も可だが1回数分。10GB。
- RTX 3060 で待ち時間が気にならないとの声。

## 設計の核

- **リターゲットなし**。Rig Setup (5つのボディチェーンをマッピング、T ポーズでキャリブレーション) を1回行えば、以降は自分のリグのコントローラに直接書き込む。
- 対応プリセット: **Auto-Rig Pro、Rigify、Mixamo、CloudRig、Puppet Studio**、カスタム保存。
- ヘルパーリグ `_Blazed` / `_TPOSE` を生成。直接触らない。
- ベースは **NVIDIA Kimodo**。ローカルランタイムの導入フロー付き (Keep Kimodo Warm で常駐)。

## 機能

- **Text to Motion**: プリセットプロンプトで生成。
- **Inbetweening**: 全身・手・足・個別エンドエフェクタのアンカーポーズ間を補間。
- **Waypoints**: フレーム指定のルート位置。**Dense Path**: 連続カーブでルート軌道を誘導 (注釈ツールで描画可)。
- **Prompt Sequencer**: Blender のビデオシーケンサーのタイムラインでプロンプトのタイミングを指定。
- 組み合わせ可。互いに矛盾する指示は破綻 / 無視される。
- 視覚フィードバック: アンカーのバッジ、ゴースト、カラーバンド。
- **History**: アーマチュアごとの生成物管理。派生物 (バリエーション・ループ) もまとめる。
- **PostPro**: Root Extraction、**Unbaking** (ベイク済みキーを少数の制御可能なキーに戻す)。評価でも「品質が驚異的」。

## ローカルとクラウド

- ログイン・クレジット不要 (完全ローカル): Rig Setup、プリセットプロンプト、Inbetweening、Waypoints、Dense Path、History、PostPro。
- クレジット制クラウド:
  - Custom Prompts: 入力テキストのみリモートで埋め込み。以降は保存して無料再利用。
  - Motion Refinement (Variation / Extend・Shorten / Loop): 骨格モーションデータのみ送信。
- 購入後に作者へメッセージして500クレジットのコードをもらう。
- クラウドを避けるなら「ログインしない + プリセットのみ + Refinement 不使用」。
- プリセットライブラリは毎月拡充予定。

## 制限 (作者の記載)

- 1モーション最大 **10秒**。長いものはシーケンス分割。
- **指のアニメーションは生成しない**。
- **人型のみ**。四足・羽根など不可。
- 複雑な IK ソルバーは手直し (FK で生成 → IK にスナップ)。
- 足滑り・体の貫通・拘束の命中誤差あり。PostPro で後処理。
- 拘束フレームは種類ごとに 20 未満が良好。長いプロンプトは意図がぼやける。

## レビュー要点 (11件読了)

- Rigify 運用で実績。「時間・予算が足りないプロジェクトの救世主」(Faust)。Unbaking が有益。
- 足滑り問題の約90%を解決 (Asela)。カーブ誘導より自然な歩き。
- 「ワンクリックで理想の結果にはならない。アニメ経験があれば、数時間かかっていたキーポーズが30分で土台になる」(abraham)。
- ドキュメント不足の指摘 (Gerard、4星)。初心者は試行錯誤に時間がかかる。作者は動画チュートリアルを準備すると返答。
- 作者の対応が良いという声が多い。

## 同作者

- Blaze AutoPose: 手・足・胸・頭を数回ドラッグすると残りの体が追従するポーズ作成ツール。別アドオン、価格未取得。

## 位置づけ

- Auto-Rig Pro 持ちには最も設計が噛み合う (専用プリセット、リターゲット不要)。
- 無料の [[kimodo-blender-bridge]] で Kimodo の品質を先に体感し、制御が足りなければ Blaze。
- 動画から取るなら [[motiongen]]。

## 関連

- [[adaptive-auto-skinning]] (ウェイト)
