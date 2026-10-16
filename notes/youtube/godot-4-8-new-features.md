---
title: Godot 4.8 新機能まとめ
description: ByteSeb の動画「Godot 4.8 is a HUGE update!」要約。Texture Streaming, Trail3D, Decal, AnimationNode Observer など
# permalink:  # don't use
aliases:
  - Godot 4.8
tags:
  - godot
  - gamedev
  - youtube
draft: false
date: 2026-10-13
---

動画: https://www.youtube.com/watch?v=obAcK2Xv980 (ByteSeb / 14:09)

Godot 4.8 feature freeze 入り。新機能 いっぱい。おれ 興味ある所 だけ メモ。
(エディタ改善 は コード zed + LLM でシーン作るから 興味なし。Visual Shader Group も テキストシェーダー 派だから 興味なし)

## レンダリング

### Texture Streaming (実験的)
- カメラ 距離 で 低解像度 mip だけ VRAM に 載せる。VRAM 節約 + ロード 短縮。オープンワールド 向き
- メッシュ LOD の テクスチャ版 に 近い。でも 目的 ちがう
  - メッシュ LOD = 頂点 処理 軽く する
  - Texture Streaming = VRAM 常駐 量 を 動的 に 管理 する
  - 普通 の mipmap は 画質 用。VRAM は 減らない
- Project Settings で 有効化。メモリ 予算 指定 可。予算 超えたら 解像度 下げる
- ツールバー に Textures ボタン (品質 プリセット)
- テクスチャ は **Texture2D Streamed** で インポート しないと 効かない
- 実行時 設定 変更 は Texture Streaming シングルトン の 値 を いじる。ゲーム内 テクスチャ品質 設定 に 使える

### Directional Light 3D の Contact Shadows
- スクリーン スペース の 細かい 影。葉っぱ、柵 など
- ライト ノード と Project Settings 両方 で 有効化
- 画面外 の 物 は 影 出ない (スクリーン スペース 技術 の 限界)

### Trail3D ノード
- 動くもの の 後ろ に 軌跡 を 伸ばす。弾道、斬撃、速度線、風、ドリフト跡、船 の 軌跡
- 幅、色 グラデ、カーブ、マテリアル 指定 可
- **レーザー は 向かない**。Trail3D は 動いた 履歴。レーザー は 始点〜終点 固定 の 線 → 将来 の Line3D か 引き伸ばし メッシュ
- Line3D は 4.8 でも 未実装。Trail3D は その 下地 コード 共有

### Decal
- Compatibility レンダラー でも 使える に なった
- Decal atlas を 部分 更新 可。DrawableTexture で アニメ decal / アニメ light projector (水 の caustics、水たまり、映写機)
- 血糊、弾痕、水たまり、汚れ 向き
- **Splatoon 風 インク 塗り は 不向き**
  - 個数 多いと 重い。上限 あり
  - 塗った 面積 の 判定・集計 できない
  - 向く 方式 = ステージ 専用 ペイント マスク (SubViewport / 画像) に ヒット UV で 描く + シェーダー で 合成。面積 は マスク ピクセル から 数える

### Multibounce Ambient Occlusion
- albedo から 色 の 跳ね返り 計算。SSAO の 暗すぎ を 防ぐ
- Project Settings で 有効化

## UI / Theme

### Theme に UI イベント 用 AudioStream
- ホバー音、クリック音 など を Theme に 設定 するだけ で 全 Control 自動 で 鳴る
- 今まで は ボタン ごと に AudioStreamPlayer + signal 接続 手動
- AudioStreamRandomizer 使える → ピッチ・音量 ばらつき で 単調 回避
- Theme ≒ CSS
  - Theme リソース = スタイルシート
  - 型名 (Button, Label) = 要素 セレクタ
  - Theme type variation = クラス セレクタ
  - 状態別 StyleBox (hover, pressed) = 疑似クラス
  - 親 に 設定 → 子孫 に 継承 = カスケード
  - 違い: specificity なし。ノード 単位 の theme override が 最優先。レイアウト は 含まない (Container 担当)
- 動画 では 細部 (どの Control の どの項目) 未確認

### Label 自動リサイズ
- min / max フォント サイズ 指定 → 枠 に 収まる よう 自動 調整
- 多言語化、ユーザー入力 の 溢れ 対策

## Animation

### AnimationNode Observer
- 背景: AnimationTree で Transition / OneShot / BlendSpace の イベント を 受ける 手段 が なかった。StateMachine playback だけ signal あった。タイマー や Animation Track で ハック してた
- 4.8: Observer リソース を 定義 → コード から 取得 → signal 接続
- 期待 ユースケース (想像。API 詳細 は 動画 で 語られず 未確認)
  - OneShot: 攻撃 / 被弾 / リロード 終了 で 入力 ロック 解除。死亡 アニメ 終了 で queue_free / ゲームオーバー
  - コンボ: 各段 終了 で 次入力 あれば 次段 へ。入力 受付 窓
  - Transition: クロスフェード 完了 検知、二重入力 防止
  - BlendSpace: 区切り で 足音 / エフェクト
  - 演出: アニメ 区切り に SE / VFX / カメラ / ダイアログ 連動
- 効果: タイマー 不要。アニメ 長 変えても コード 直さなくていい

## API / 性能
- Fuzzy search API 公開。誤字・語順違い に 強い。インベントリ 検索 に 便利
- Physics query 新 Result クラス。Dictionary 返却 やめて 型付き オブジェクト → 速い
- 高 ポーリング レート マウス の Windows 性能 問題 修正
- 大量 ノード 削除、Polygon2D 更新 が 高速化

## 所感 (動画)
- 1ヶ月 使用、おおむね 安定。小さい バグ は 修正 済み
- 安定版 か beta まで 待つ。バックアップ 必須
- Line3D まだ

## メモ
- 字幕 DL は YouTube 429 で 失敗 → 英語 自動字幕 のみ 取得
