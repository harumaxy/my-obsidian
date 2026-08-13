---
title: AutoSprite v3 - AIキャラ画像からアニメスプライト自動生成ツール
description: DevDude動画要約。AI画像生成+動画生成で2Dゲームスプライト作成、ComfyUI再現可能性も検討
# permalink:  # don't use
aliases:
  -
tags:
  - youtube
  - gamedev
  - ai
  - comfyui
draft: false
date: 2026-08-09
---

元動画: https://www.youtube.com/watch?v=4sEbE9q09IQ
チャンネル: DevDude
ツール: https://sorceress.games/pages/auto-sprite

## 概要

AutoSprite v3 紹介動画。AI画像生成+AI動画生成でゲーム用2Dスプライトシート自動作成ツール。5分で完成謳う。

## パイプライン

1. **キャラ画像生成** — 好きな画像生成モデル選択可（Nano Banana Pro, GPT Image 2, Grok Imagine, Seedream 5等）。参照画像アップロード対応、複数アングル生成も可
2. **Animate Studio** — AIエージェントがアニメ案自動提案（歩行/攻撃/ジャンプ等）、手動追加も可。動画生成モデルはGrok Imagine 1.5推奨（Wan 2.7も選択肢）。秒数指定可
3. **スプライトシート変換** — 生成動画から不要フレーム除去、Sprite Sheet Analyzerで完璧ループフレーム選定。戦闘用ヒットボックス設定（一括/個別編集）。カスタムタグ（jump start/hover/end等）でAIコーディングエージェントに区切り伝達
4. **書き出し** — JSON+スプライトシート一式zip。フレームサイズ・行列数カスタム可

実践パートではWizard Genie AIゲームエンジンにzip渡し、コーディングエージェントに指示→Sorceress APIでSE/BGM生成、敵キャラ(歩行/攻撃/死亡アニメ付)、パララックス背景も自動生成、Viking風横スクロールゲーム構築デモ。

## 料金構造

- ツール本体: $49買い切り、将来ツール全部込み永久ライセンス
- AI生成部分（画像/動画生成ステップのみ）: 別枠 Generation Credits、月$10〜、失効なし
- スプライトシート抽出はローカル処理→追加費用なし
- 各モデル消費クレジット量・プラン別上限は非公開（サインアップ後管理画面で確認要）

sorceress.games自体は複数サービス展開: Wizard Genie(ゲームエンジン)、Auto-Sprite、Video/Generate(画像動画生成)、3D Studio、VoxelGen、Audio Suite。ゲーム制作AIツール一式まとめ売り。

## コメント欄反応

好意的意見よりビジュアル品質への批判目立つ。

- 「AI丸出し(AI slop)」「醜い」との酷評複数
- 有償ユーザー(プロアーティスト名乗る)から「フレーム過多で動き硬い、コンセプトツールとしては良いが本気の絵描きは納得しない」との辛口フィードバック
- アートスタイル3種混在、BGMにSE混入との指摘
- 機能面の要望は好意的: 8方向スプライト対応、キャラ分離+ボーンリギング+JSON出力、フレーム複製/削除/並べ替え機能
- 開発者本人「写真参照からアニメ生成可能」と返信

「AIゲーム氾濫で業界崩壊」vs「業界元々クソゲー多い、配信者がフィルター」vs「業界はもう崩壊進行中」で論争発生。

## ComfyUIでのローカル再現性

パイプライン3段階のうち大半再現可能。

1. **画像生成** → 標準txt2img。SDXL/Illustrious/Flux+ピクセルアートLoRAで十分
2. **画像→動画** → **Wanはオープンウェイトモデル**、ComfyUI公式ノードあり。Grok Imagineは非公開APIでローカル不可だがWan 2.1/2.2 I2Vが実質代替。VACEノードでモーション制御強化可
3. **動画→スプライトシート** → AIですらない。ffmpegフレーム抽出→rembg/BiRefNetノードで背景除去→PIL自作スクリプトでグリッド配置

再現困難な部分（GUI/UXレイヤー、$49の価値の大半）:
- Sprite Sheet Analyzer（ループフレーム選定UI）
- ヒットボックスエディタ
- カスタムタグ→JSON出力の仕組み
- プロンプト提案エージェント（自前LLM呼び出しで代替可）

結論: 生成本体はWanローカルなら無料（VRAM次第）で再現可能、便利GUI部分は自作Pythonスクリプト必要。

## メモ: Wanとは

Alibaba(Tongyi/通义万相)製オープンウェイト動画生成モデル。

- Wan 2.1/2.2、T2V/I2V両対応
- ComfyUI公式サポート、Hugging Face等でウェイト配布→無料ローカル実行可能
- Sora/Runway等クローズドAPI系と違い重み公開、VRAMあれば動く
- 1.3B軽量版〜14B大型版まで複数サイズ

## 参考

- Wan公式リポジトリ・ComfyUI Wan I2Vワークフローは別途調査要
