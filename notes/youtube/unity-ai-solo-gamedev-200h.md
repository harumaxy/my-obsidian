---
title: プログラミング素人がAI駆使してUnityでアクションRPG200時間開発
description: Claude/ChatGPT/Gemini + Tripoでゲーム開発素人がスマホ用3DアクションRPGを200時間で作った記録
# permalink:  # don't use
aliases:
  -
tags:
  - youtube
  - unity
  - gamedev
  - ai
draft: false
date: 2026-08-09
---

元動画: https://www.youtube.com/watch?v=Hsmo6M0kVss
チャンネル: 素人がCGアニメーション始めてみた

## 概要

ゲーム開発・プログラミング完全素人。Unity×AI(Claude/ChatGPT/Gemini)×Tripoでスマホ用アクションRPG200時間開発記録。C#一切勉強せず完成。

- エンジン: Unity（C#がAIと相性良いため選択。Unreal EngineはC++必須でAI相性△という判断）
- AI: Claude / ChatGPT / Gemini を3AI体制で運用
- 素材生成: Tripo（AIモデリング）

## 序盤(0〜50時間)

- 最初10時間: チュートリアル探しとUnity操作に苦戦、ほぼ無進捗
- Unity系オープンワールドチュートリアル少ない、Unreal Engine系の方が充実
- 電子書籍の入門書＋AI質問の組合せが強い。本のスクショをAIに見せてレベル調整解説させる運用
- Claudeはバージョン差異にも自動対応、コード精度も高い

## 3AI運用の実態

「3AI会議」と称してるが中身は**完全手動オーケストレーション**。API連携やCLIツール(gemini-cli, codex等)経由の自動化は一切なし。開発者本人が3つの別々のチャットUIに同じ質問を手動コピペして回答見比べる、が実態。

役割分担(本人の主観的評価):
- **Claude**: 実装リーダー。端的、脱線否定、完成優先。記憶力弱いのが弱点→引き継ぎ書を都度手動作成してカバー
- **ChatGPT**: チェック/アドバイザー。説明長くテンポ悪いがバグ発見力は高評価
- **Gemini**: 見た目・世界観チェック。3者会議で却下されがちだが稀に良いアドバイス

### この評価への疑問点(自分の考察)

- 同一条件比較になってない。Claudeは本人が一番使い込んでる(メイン利用)ので精度良く見えるのは半分バイアス
- 各AIでチャット履歴/文脈が別々に蓄積、フェアな比較ではない
- 「性格がある」という結論はモデルのRLHF傾向差(実在する)と、運用非対称性からくる後付け物語が混ざってる
- ChatGPTにコードチェックさせてバグ発見、という複数視点レビューの効果自体は妥当（人間のコードレビューと同じ原理）
- 手動コピペ運用はコスト高い。今ならAPIでスクリプト化した方が条件も揃えられて効率的

## 苦労した点

### アニメーション
AssetStoreの人間アニメをデフォルメキャラに適用→崩壊。修正手順:
1. Auto-Rig Proの「リマップ」機能でボーン対応付け
2. 等身差による食い込み/ねじれをボーン個別選択して補正
3. Blenderアドオン「Animation Layers」(約3000円)で元アニメの上にレイヤー重ね付け、これが一番直感的

反省: 最初からUV展開・マテリアルを1つにまとめておくべきだった。頂点カラー設定も先にやっておくべきだった(後から4回もキャラ書き出し直し)。

### 3段コンボ攻撃
AI相談3時間格闘も解決せず→Unity Japan公式チュートリアル「AnimatorControllerを使ってコンボ攻撃する方法」(https://learning.unity3d.jp/6777/) で速攻解決。

記事内容:
- ステートマシンのサブステート「Attacks」に各モーション登録
- パラメータ`AttackType`(int)、`AttackTrigger`(trigger)
- 「AttackTypeが特定値かつAttackTriggerが押された」でトランジション
- StateMachineBehaviourでステート終了時にAttackTriggerを強制リセット(入力残留防止)
- ターゲットマッチング機能で攻撃時の位置補正(空振り防止)

その後の実装は既存の通常攻撃アニメをベースにスクリプトでタイミング調整。ため攻撃は長押し→離す方式がフリーズ多発したため別ボタン発動に変更。攻撃中の前進はUnity標準サードパーソンコントローラーを改造。

### ポリゴン数最適化
- AIモデリング(Tripo)生成物はポリゴン数過多(1オブジェクト90万超えなど)
- 原因: 影・アウトライン設定でポリゴン数が2倍ずつ乗算される
- テレイン解像度(Height Map Resolution)が最重量負荷要因、下げるだけで大幅軽量化。見た目はほぼ変わらない
- 影は動かないオブジェクトはベイクして焼き込み、動的軽量化より軽い
- GPUインスタンス対応シェーダーを自作して同マテリアルのバッチ処理削減

### スマホ移植
タッチカメラ操作の実装に苦戦。既存スクリプトが膨大化した後だったので外部アセット導入が困難→自作するはめに。感度調整・タップ判定のチューニングに時間かかった。

## 実装した独自ツール

- 最適化ツール: 影・アウトライン一括OFF等をチェックボックスで適用
- グラスマネージャー: テレインの草原自動配置、キャラ近接時に回転/縮小して回避
- ランダムプレハブペインター: オブジェクトをブラシでランダム散布(木・岩など)
- エネミースポナールーム: ウェーブ制敵出現＋全滅トリガーでイベント発火(扉解錠等)

## 技術補足: Animator Controller の GUIステートマシン vs C#制御

AnimatorControllerはGUIベースのステートマシンだが、C#から普通に制御可能。

1. **Controller維持 + パラメータ操作**(実務では主流)
   ```csharp
   animator.SetInteger("AttackType", 1);
   animator.SetTrigger("AttackTrigger");
   animator.CrossFade("Attack_Kick", 0.1f);
   animator.Play("Attack_Jab", 0, 0f);
   ```
   遷移条件・グラフ構造はGUIのまま、呼び出しタイミングだけコード管理。

2. **Playables APIで完全スクリプト制御**
   ```csharp
   graph = PlayableGraph.Create();
   var clipPlayable = AnimationClipPlayable.Create(graph, clip);
   var output = AnimationPlayableOutput.Create(graph, "Animation", GetComponent<Animator>());
   output.SetSourcePlayable(clipPlayable);
   graph.Play();
   ```
   AnimatorController自体使わず、`AnimationMixerPlayable`等でブレンドも全部コードで組む。柔軟だがGUIのビジュアルデバッグを失う。動的生成クリップやランタイムでグラフ構造変える特殊ケース向け。

## 総括

- C#完全未学習でも実装で詰まったことはゼロ
- チュートリアル視聴は入門書1冊＋コンボ動画のみ
- AIから答えを引き出す「聞き方の引き出し」の多さが重要
- 課題: マルチプレイ実装実験(3AIとも反対)、AIモデリング(Tripo)研究、キャラクター生成実験
