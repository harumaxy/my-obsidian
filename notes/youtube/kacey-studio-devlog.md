---
title: Kacey Studio devlog - AI + Claude Code でゲーム開発
description: Claude Code と Godot で SUMMONS TALE を作る個人開発チャンネルの要約。使用ツール、モーション生成の比較、自作ツール agent-dailies / linear-tui
aliases:
  - Kacey Studio
  - SUMMONS TALE
tags:
  - youtube
  - gamedev
  - claude-code
  - godot
  - ai-tools
draft: false
date: 2026-10-10
---

# Kacey Studio * devlog

- チャンネル: https://www.youtube.com/channel/UCzX68XRXdf36GgpAbCS9SrQ
- 作者: ソフトウェアエンジニア。ゲーム制作ゼロ経験。X: @k1_c_studio / GitHub: k1-c
- ゲーム: ターン制ローグライク「SUMMONS TALE」(旧 Summoner Life)。デーモン召喚・契約・連れ歩き。ゴール = Steam 有料公開
- 2026-10-10 時点で動画 5本 (長尺3 + Shorts2)

## 動画一覧

- ゲーム開発ログ #1 (10/1, 4分): https://www.youtube.com/watch?v=ckrajvbmAeM
- ゲーム開発ログ #2 (10/4, 11分): https://www.youtube.com/watch?v=bvtzX3Cq0gI
- 開発の小話 #1 (10/6, 12分): https://www.youtube.com/watch?v=CefKvf7tXaM (説明欄のみ確認、字幕未取得)
- Shorts: デーモン1体ができるまで / 試遊コンテンツ 闘技場

## 使用ツール

- 開発: Claude Code / Godot 4.5
- 課題管理: Linear / linear-tui (自作)
- 確認・選択: agent-dailies (自作) / 設定レビューページ (自作) / 台本レビューツール (自作)
- 3D: Meshy (1体約3分) / Blender
- 画像: gpt-image-2 (設定画・絵コンテ) / Seedream, nano-banana-pro (動く立ち絵、fal.ai)
- 動画: Kling 3.0 / Seedance 2.0 (fal.ai)
- 音: ElevenLabs (声・効果音) / Suno (BGM) / Kenney (CC0 効果音)
- 試して不採用: NVIDIA Kimodo / Meshy Text to Motion

## #1 最初の36時間 (165コミット)

- 最初にゴールと優先順位を決める。コード前に Linear へ Issue 起票。作業ルールは CLAUDE.md に書き、作りながら追記。
- Issue に目的と完了条件を書いてから着手。実装中の判断は Issue コメントに残す。
- PoC (グリッド・ターン制・連れ歩き) とデバッグメニュー (どの場面もすぐ再現) を先に作る。
- 1時間でダンジョン歩行、1.5時間で戦闘成立。面白さ足りず、その夜に駆け引き要素を追加。
- 3D は Meshy で3分。時間がかかるのは形・骨・動きの調整。
- 斬撃SE 37案生成、採用2。音だけで選ぶのをやめ、動きに合わせた動画で確認する手順に変更。
- 字幕は BGM のみ (ナレーションなし)。内容は説明欄とチャプターから。

## #2 6日間 (606コミット)

- デーモン150種、テスト2,000件超。
- 作者が遊んで気になった所を Issue に書く → Claude が直す、の繰り返し。
- 人間は「見て決める」係。決定コストを下げる自作ツールが肝 (後述)。
- 設定レビューページ: デーモン・魔法・アイテム・台詞 1,800枚超のカード。その場で編集 → データ1行だけ書き換え。メモ → AI にまとめ依頼。

### 攻撃モーション: 生成AIより手付け(IK)

縦斬り1本を3方式で比較、同じ自動採点。

- Kimodo: 64本中15本合格。だが体ほぼ立ったまま、腕だけの小さな動き。
- Meshy Text to Motion: 17本全滅。
- 採用: 型を言葉化 → 絵コンテ → キー姿勢に分解 (袈裟斬りは10個)。
  - キーごとに握り位置・刃の角度・腰胴のひねりを数値化。
  - 腕は IK で解く (Blender)。
  - 間は緩急ルールで補間。振りかぶりはため、振り下ろし 0.035秒。
- 両手持ちは3頭身の腕で頭上まで届かない。盾弾きは3回作り直し。
- 結論: ゲーム用の短い攻撃は「キー姿勢 + IK + 緩急ルール」が強い。生成はスクリプト(AI)が書く。

### オープニング映像

- 1カットずつ1枚絵 (設定画添えて顔崩れ防止) → Kling と Seedance で動画化し比較。
- Kling = 当たる瞬間が読みやすい / Seedance = カメラ大移動。使い分け。
- 曲は通しで流し、映像側を打音に合わせてカット。
- 絵案58枚、動画55本、約120ドル。立ったまま髪なびくカットは AI っぽいと不評で戦闘場面に変更。

### デーモン制作パイプライン

設定文 → 立ち絵 → 三面図 → 3D → 骨と動き。段ごとに作者OKで次へ。3D化後は影が絵と合うか数値検証。
169体を1部屋に並べて確認、23体の不具合修正。武器59本・盾9枚を新規生成。

### テスト運用

- マージ前に全テスト(3〜7分)だと、並列レーンでメモリ枯渇し開発機が2回落ちた。待ち時間の4割超がテスト。
- 解決: マージ前は高速テストのみ(約20秒)。全テストはマージ後に専用機で裏実行。失敗時のみ通知、気づいたレーンが直す。CI待ちゼロ。

## 小話 #1 (説明欄のみ)

- ダンジョンは BSP で自動生成。シード固定で再現可能。
- ボットに何十回も遊ばせ、到達階・ボス勝利数で HP や敵数を調整。
- 落とし穴: 広間を北向きにしただけでボット勝率が 19勝/40戦 → 36勝。AI が迷ったとき北から方角を調べる癖。
- テスト約2,400件。

## 自作ツール

どちらも公開OSS。共通思想 = 人間の確認・判断をエージェントのループに戻す入出力口。

### agent-dailies

https://github.com/k1-c/agent-dailies

- エージェントが生成した画像・動画・音・GLB・PDF 等を、開きっぱなしの1ブラウザタブにライブ表示。
- `agent-dailies show a.png b.png --title ...` で投稿。`ask` で A/B/C の選択式質問。
- 人間は OK かメモ。返信は `watch` コマンドや hook 経由でエージェントに戻る (待機中でも起きる)。
- 履歴: リポジトリ → Issue(ブランチ名から) → セッション。ファイルはハッシュ保存で repo 外。
- Devlog 機能: main マージ時に変更点・工夫・苦労・決定を before/after つきで記録。
- 導入: Node.js 22.6+。Claude Code プラグイン。
  ```
  /plugin marketplace add k1-c/agent-dailies
  /plugin install agent-dailies@agent-dailies
  ```
- ローカルサーバ 127.0.0.1:4777。ComfyUI 生成物の確認にも使えそう。

### linear-tui

https://github.com/k1-c/linear-tui

- Linear をターミナルで操作する Rust 単一バイナリ (crates.io, MIT)。
- Linear と同じショートカット、コマンドパレット、保存ビュー。通信は非同期で UI が固まらない。
- worktree ごとに開いていたページを復元。
- `linear-tui context` で開いている Issue とカーソル行をエージェントに伝達。メモを1プロンプトにして渡せる。
- 認証は `linear-tui auth login` のみ。

## 学び (自分向け)

- 先に Issue と CLAUDE.md で枠を作る → PoC + デバッグメニュー → 遊べる縦切りを早く。
- AI生成物は自動採点 + 人間レビュー + 段階承認の品質ゲートを通す。確認は動画・実物で。
- 人間の判断待ちがボトルネック → 確認専用ツールを作る価値が高い。
- 並列エージェント運用ではテストをマージ後非同期にする。
- Meshy は「絵 → 3D」「再テクスチャで色違い量産」が量産向き。モーションは別問題。
