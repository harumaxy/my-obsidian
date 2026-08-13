---
title: Fable 5 が Godot MCP + Blender MCP でゲーム1本 丸ごと作った話
description: Blender/Godot 経験ゼロの人間が Fable 5 と MCP で 12時間でドラゴン空戦ゲーム完成させた記録。アセット入手先とビジュアル調整の実装詳細
# permalink:  # don't use
aliases:
  - Claude Fable 5 Makes FULL GAME Using Godot MCP and Blender MCP
tags:
  - youtube
  - claude
  - mcp
  - godot
  - blender
  - gamedev
  - ai
draft: false
date: 2026-08-09
---

# Fable 5 が Godot MCP + Blender MCP でゲーム1本 丸ごと作った話

- 動画: https://www.youtube.com/watch?v=QkckeI0tITg
- チャンネル: JC BuenaVentura
- 長さ: 13:26

## 何が起きたか

Blender も Godot も経験ゼロ人間。**12時間**でドラゴン空戦ゲーム完成。
3Dアート知識なし。エンジンチュートリアルなし。平易な英語のみ。

環境: Claude Code + **Fable 5 (1M context)** + **Ultracode** + Bypass permissions。

## NoirStage = 影の主役

作者自作ツール。macOS 専用 (Apple Silicon, macOS 13+)、無料。
https://noirstage.com/ (動画中の noir-stage.com はハイフン誤り)

存在理由:

> AI は three.js の Web ゲームは得意。**Godot 直接は苦手**。

なので間に噛ませる **AI が読み書きできる 3Dシーン記述層**。

- 3Dキャンバス上のアセット配置を**実座標**で制御、ノードを特定位置に置ける
- → AI と 3D空間について実際に会話可能。作者いわく「Minecraft の 3Dゲーム開発版」
- リギング/アニメ内蔵 (ドラゴン・クモ・犬・鳥・ヘビ・人間)

ワークフロー:

1. NoirStage でステージング (配置・座標決め)
2. **AI が得意な three.js でブラウザ版を先に完成**。ゲームプレイ確定
3. ブラウザで安定してから、NoirStage が全メカニクスを **Godot に1つずつ変換**

**この動画の成功は「Fable 5 が強い」より「自作の足場がある」に依存。**
素の Godot MCP 単体では再現しない可能性 高。

## アセット入手先 一覧

| 用途 | 入手先 | 結末 |
|---|---|---|
| 初代ドラゴン | **Blender MCP** で Fable 5 が直接モデリング | **破棄**。AAA には物足りず |
| コンセプト画像 | **GPT** 画像生成 | Neural 4D への入力 |
| 最終ドラゴン ×2 (自機/敵) | **Neural 4D** (image→3D, スポンサー) | 採用 |
| 敵艦・巨大矢 | **Neural 4D API** (キーを Claude に渡し自動生成) | 採用。複数案から選択 |
| リギング/アニメ | **NoirStage** 内蔵リグ | 自機=ドラゴンリグ40分、敵=鳥リグ流用 |
| 海・空・VFX | **Godot 無料アドオン** (下記) | 採用 |
| BGM・SFX | **ElevenLabs API** (キーを Claude に渡す) | 採用 |

### 重要: Blender MCP のモデリング品質は実用に届いてない

**最終ゲームのアセット、Blender MCP 産ゼロ。** タイトルの "Blender MCP" は実質フック。

- 作者自身がオリジナルドラゴンを破棄 → Neural 4D の image→3D に乗り換え
- 残った Blender MCP の役割: 冒頭デモ + 「片翼を平らにしてエクスポート」程度

Blender MCP が効く領域は別:

- プロシージャル配置・複製・リネーム・座標操作 (スクリプト的作業)
- 既存メッシュの調整
- レンダリング → 自己批評 → 自己修正のループ

有機的形状のスカルプトは弱い。LLM が頂点を言語で組み立てる方式では
image-to-3D の生成モデルに勝てない。

ただし **Neural 4D はスポンサー**。「Blender MCP ダメ → スポンサー製品が救う」
の流れは広告構成として都合良すぎ。割引いて見る。

### Neural 4D の使い方 コツ

1. 画像を投入、設定は全部「高」で生成
2. 生成後、左の **Retopology** で**面数 1万〜2万まで削減** → ゲーム最適化

## 使ってた無料アドオン/アセット (画面から確定)

- **海: FFT オーシャン** — GPU sea spray。"Sea of Thieves 領域" の荒れた青海。GPU 必須
- **空: Sky3D v2.1** (Tokisan, MIT, 11.5MB) — 大気散乱 + 動的雲レイヤー。
  managed sun が **PCSS ソフトシャドウ**を駆動
- **爆発: Unity Labs CC0 flipbook** — Houdini シミュの `Explosion02HD` シート (25フレーム, 2048²)
- **衝撃波: CGHEVEN 4K shockwave flipbook** (49フレーム) を重ねる
- **炎 (燃える船): CGHEVEN の sim-rendered fire loop**
- **パーティクル: Kenney Particle Pack** (CC0) — 煙パフ4種ランダム、
  trace streak (風/雷)、マズルフラッシュ、starburst flash

**手描き形状ゼロ。全部 VFX アーティストのベイク済みシミュ映像。**
これが visual quality の正体。

## ライティング (最大の知見)

- **ACES → AgX にトーンマップ変更**。理由: **ACES は明るい青を紫に寄せる** →
  海洋シーンで破綻。調査した上での consensus
- **sky-graded ambient fill = 1.3** → モデルの陰が**フラット黒でなく青みグラデ**に
- contrast/saturation grade を上乗せ
- **SDFGI は意図的に不採用** — 外洋でちらつく + ambient 調整をロックするため

動画で「未解決」とされた**ドラゴンの平坦・不自然に暗い影**、
ambient fill の項目がまさにその修正。収録後に解決したか別セッションか。

## 転換点になった指示

Godot 移植直後、操作系は完璧に動いたが**見た目が最悪**。
「誰かが画面に嘔吐したような映像」。フラット照明・偽物の水・炎が基本形状ポリゴン。

原因: **Fable 5 がエフェクトを全部ハンドロールしようとした**。

指示を変えた:

> go research the best, most trusted **free add-ons** out there
> to seriously bump up the visual quality

→ AI に自作させず、**既存の信頼できるアドオンを調査・導入させた**。
結果 "night and day" の差。

**教訓: AI に車輪を再発明させるな。既製の信頼できる資産を調査導入させろ。**

## 水: 3回作り直し

1. ゼロから生成 → awful
2. スクショでは良い → 開いたら「波の上に浮かぶテクスチャ付きゴム片」
3. **アドオン導入版 = 勝者**。波がデカすぎたが「調整可能」と言われ採用

その後の微調整:

- 波を落ち着かせる (rough すぎ)
- **航跡 (wake) の発生感度を上げる** — 前は水面すれすれ飛ばないと見えなかった
- 火の玉を hotter & more orange、爆発サイズ拡大

## デバッグの効いたやり方

**太陽まぶしさ問題** (Web版):

- 太陽に向くと全画面 白飛び
- 数回の修正では直らず → **スクショを撮らせて自律デバッグ指示**
- AI の動き: ゲーム起動 → カメラを太陽に向け再現 → **機器を1つずつオフして切り分け**
- 真因: **空自体が明るすぎ**。根本修正

他:

- 遠景の水がちらつく → 真因は**カメラの far クリップが海を早く切ってた**
- 上下操縦桿が反転 → 修正
- ソニックブーム 未実装 → 速度システム再設計
- 旋回時にドラゴンが逆に傾く → 反転
- デフォルト滑空、スロットル時だけ羽ばたき

## 追加した機能リスト

- 敵艦が矢を発射。**赤い点滅警告 + 約2秒の回避猶予**
- 回避成功 → 映画的スローモーション、矢が脇を通過
- 被弾 → 矢がドラゴンに刺さり飛行困難化
- キルカム (撃墜した敵が海に落ちるまで追従)

## サウンド

ElevenLabs API キーを Claude に渡して自動生成。

- チェロ、風、羽ばたき、爆発、水しぶき、木折れ、矢のかすめ音
- **距離で音量減衰**
- **スローモーション中は全音程ダウン** → 映画的効果

## 未解決・断念

- **Xbox コントローラーがブラウザで動かず** → 断念。Godot なら動くと分かってたので時間かけず
- ドラゴンの平坦・暗い影 (動画時点)。**Claude 使用制限に到達**して打ち切り
- 羽ばたきアニメが不自然。リグ40分で妥協「十分であれば十分」
- 敵ドラゴンの角が翼と一緒に羽ばたく (鳥リグ流用の副作用)

## 正直な但し書き (作業ログ画面ママ)

- FFT ocean が GPU 必須 → headless の verify gate はフラットな代替を使用。
  スクショは実機ラン
- ocean/flipbook の zip が `addons/` 構造じゃない → **手置き**、パイプライン追跡外。
  finding #18 の残件として文書化

## 持ち帰り

- **AI にハンドロールさせるな。既製アドオンを調査導入させろ。** 差は歴然
- **AI が得意な土俵で先に完成させ、後から本命エンジンに移植**。
  three.js で確定 → Godot 変換
- **外部サービスの API キーを AI に渡す**とアセット生成が一気に自動化
- **スクショを撮らせて自己デバッグさせる**と真因まで到達する
- 3Dモデリングは MCP でエンジンを殴るより **image→3D 生成モデル**が実用的
- 結局 Web版と Godot版の見た目がほぼ同じになった
