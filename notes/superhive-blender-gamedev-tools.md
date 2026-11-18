---
title: Superhive Blender ゲーム制作ツール候補
description: ブラックフライデー向け。Superhive で見つけた生成AI・キャラ・リグ・ウェイト系アドオン候補リスト
# permalink:  # don't use
aliases:
  - superhive候補
tags:
  - blender
  - superhive
  - gamedev
  - ai
draft: false
date: 2026-11-18
---

# Superhive Blender ゲーム制作ツール候補

調査日 2026-11-18。ブラックフライデー前。ページ内容は販売者の記載。動作検証なし。

持ってる (除外): Auto-Rig Pro、Voxel Heat Diffuse Skinning

キャラ土台・服の方針: [[character-clothing-workflow]] (所持の [[simply-cloth]] 含む)

個別ツールの詳細: `notes/blender/superhyve/` 以下。横断比較: [[comparison-game-pipeline]]

## 購入提案リスト

反応の強かったもの: 自撮り [[motiongen]] (ARP 対応)、[[autocharacters]] (無個性な土台)、[[quadmend]] (AI メッシュ自動リトポ)。外した: Eden・Human Generator (西洋リアル調)、Marvelous Designer (ソフト往復が面倒)。

### 1. 今すぐ試す (合計 約 $17)

- [[kimodo-blender-bridge]] — 無料。v1.5.7 以降必須
- [[motiongen]] Lite — $1。3 秒の自撮りを ARP に通し、コントローラに乗るか確認
- [[rigmend]] Lite — $1。敵・モブ量産の検証用
- [[quadmend]] — $15。同じ AI メッシュを [[smart-remesh]] と比べる
- 同じ AI 生成メッシュ + 自撮り 1 本で検証 (約 1 日)。Kimodo / MotionGen の未確認事項、リトポ品質を潰す

### 2. 土台として買う

- [[autocharacters]]
  - ゲーム用は Commercial 必須 (Base $134.99 / Complete $157.49)
  - 先に Standard ($26.99) で衣装・顔・ARP 相性を見る手あり。ただし Standard → Commercial の差額切替は記載なし、要確認
  - 買う前に作者へ質問: 表情用シェイプキーの有無、ARP 相性、Standard → Commercial の条件
- [[bizen3d]] — $20。敵・メカ・人形の生成 + クアッドリメッシュ + ベイク。レビュー 0 件、UV 不明。ブラックフライデー割引待ちでよい

### 3. 試して良ければ買い足す

- [[motiongen]] Pro — $29。商用は Pro 以上。Lite で良ければ
- [[blaze-puppeteer]] — $59。自撮りで足りない・演じられない動きの量産が必要になったら。Kimodo Bridge で品質を体感してから
- [[adaptive-auto-skinning]] — $29.75。ARP + VHD で指・顔・複数メッシュに困ったら。30 日返金保証

### 買う順番

1. 「今すぐ試す」を買い、検証
2. 結果を見て、AutoCharacters と Bizen3D を割引時に買う
3. 足りない所だけ「買い足す」から選ぶ

### 未確認のまま買うリスク

- Kimodo の商用ライセンス (Bridge・Blaze のモーションを商用ゲームに使う場合)
- MotionGen の姿勢推定モデルのライセンス
- AutoCharacters の顔・表情の仕組み

## TL;DR

- **画像 → 3D 生成**
  - 手間少なく試す → [[bizen3d]] ($20)。生成 + クアッドリメッシュ + ベイク1本。ただしレビュー0件、UV 不明。
  - 品質・実績・UV まで詰める → 同作者スタック $53 (定価): [[image-to-3d-milad]] + [[smart-remesh]] + [[auto-unwrap]]。25%オフクーポンあり (3日間)。
  - Mac で触るだけ → [[image-to-3d-local-zeg]] ($2.99)。
  - [[genmesh]] は後回し (Blender 5.2 限定、実績なし、ARP 持ちなら重複)。
- **キャラ生成 (カスタマイズ可能キャラ)**
  - **本命は AutoCharacters** (無個性・スタイライズ寄りの土台。Eden・Human Generator は西洋リアル調で外す)。方針は [[character-clothing-workflow]]。
  - ゲーム着せ替え前提 → [[autocharacters]] (Commercial 必須)。服・リグが体型に追従。AI 生成は服・小物・武器に回す。
  - AI 生成人型を規格ボディに載せ替え → [[eden-character-studio]] の Wrap ($7.50)。ただし公開1日目で未検証。
  - リアル・映像寄り → [[human-generator]] (無料トライアルあり)。軽量ゲーム向きではない。
  - 敵・クリーチャー量産 → [[autocreatures]] (5.2 限定、新規で実績なし)。
- **リグ・ウェイト (ARP 持ち前提)**
  - [[rigmend]] Pro は不要。Lite ($1) は敵・モブ量産の検証用に試す。
  - [[adaptive-auto-skinning]] は ARP + VHD で指・顔・複数メッシュに困ったら。30日返金保証。
- **モーション** (ARP 対応必須・手直し前提で手間を減らす)
  - **自分が演じられる動き → [[motiongen]] (自撮り)**。コントロール性が高い。ARP 対応済み。Lite $1 で先に試す。
  - **演じられない動き・量産 → text-to-motion**。
    - 無料で試す → [[kimodo-blender-bridge]] (v1.5.7 以降。旧版にデータ削除バグ)。
    - ARP と相性最良 → [[blaze-puppeteer]] ($59)。リターゲット不要、Unbaking など手直し機能あり。
  - ライブラリ + リグ生成 → [[instant-rigger-and-animator]]。ARP 持ちには競合気味。
  - 手直しフローと方針は [[comparison-game-pipeline]] 参照。
- 全部 Windows (RTX4080) 側で使う前提。
- どの AI 生成も「出発点」。キャラのアニメ用ループは手作業。敵・メカ・人形・静的プロップ向き。
- 実機で同じ画像を Bizen3D / Image to 3D / 今の `generate_3d` で比べるのが確実。

## 注意

- ローカルAI系は NVIDIA GPU 前提多い。Mac 不可。Windows (RTX4080) 側 Blender で使う。
- Mac OK: ZEG 版、RigMend、Adaptive Auto Skinning、Blaze Puppeteer。
- Hunyuan 2.1 / Hunyuan3D 使う製品は EU・UK・韓国 対象外。商用は各エンジンのライセンス要確認。
- 429 エラーで未取得: quadify-bridge-ai-mesh-importer-for-blender、ai-mesh-toolkit-helper、auto-painter-ai
- 価格は調査日時点。セール前。

## 優先度 高 (1) Image to 3D 系 (ローカル生成)

- [x] **Image to 3D** [[image-to-3d-milad]] — $18
  - TRELLIS / Pixal3D / Hunyuan / Hi3D + Canvas (ノード式)。NVIDIA 8GB+、全部入り約132GB
  - 販売 1300+、評価 4.0 (22件)。作者の対応が速い。後処理なし
- [x] **Bizen3D** [[bizen3d]] — $20
  - Pixal3D + TRELLIS.2 + Hi3D + クアッドリメッシュ + ベイク + テクスチャ2倍。約36GB。MIT 中心
  - レビュー0件、公開11日前
- [x] **Image to 3D (AI in Your Local Blender)** [[image-to-3d-local-zeg]] — $2.99 / $3.99
  - Apple Silicon 対応。作者「実験的」と明記
- [x] **GenMesh** [[genmesh]] — $34.90 (セール $29.67)
  - Hunyuan3D-2mini + リメッシュ + Rigify リグ + Live Link + MCP。Blender 5.2 限定、レビュー0件

### 同作者 (Milad / 3DRedbox Studio) の後処理

- [x] **Smart Remesh 3** [[smart-remesh]] — $17
  - 有機は Instant Meshes、ハードサーフェスは頂点を動かさず n-gon 化。ベイク対応。Windows のみ
- [x] **Auto Unwrap 2** [[auto-unwrap]] — $18
  - AI 生成向け UV 自動展開。UDIM、対称性、衣類シーム。Windows / Linux
- [x] **MK Smart Segment** [[mk-smart-segment]]
  - 一体メッシュを自然なパーツに分割。単体で使う場面は限定的 ([[auto-unwrap]] に内蔵)
- ChatGPT to Blender Live Link: ChatGPT 専用。Claude / MCP 記載なし。今回は不要

## 優先度 高 (2) AI メッシュのリグ付け

- [x] **RigMend** [[rigmend]] — Lite $1 / Pro $24
  - AI 生成の人型を1クリックでリグ + スキン。純 Python、GPU 不要、Mac 可。レビュー0件
  - ARP 持ちは Lite のみ検証する価値あり
- [x] **Adaptive Auto Skinning** [[adaptive-auto-skinning]] — $29.75 (バンドル $38.25)
  - 既存リグに GPU ボクセルソルバーで体 + 服を一括スキン。評価 5.0 (20件)。30日返金保証
  - 顔スキニング (実験的) は ARP 限定。着せ替えはバンドルの Voxel Weight Transfer

## 優先度 高 (3) テキスト → モーション / モーキャプ

- [x] **Kimodo Blender Bridge** [[kimodo-blender-bridge]] — 無料 (支援版 $5/$10)
  - NVIDIA Kimodo をローカル実行。Windows / Linux のみ。Mixamo 系 Auto-Match でリターゲット
  - **旧版 Retry Install にデータ削除バグ。v1.5.7 以降**
- [x] **MotionGen** [[motiongen]] — Lite $1 / Pro $29 / Gold $57
  - 動画 → アーマチュア。ARP / Rigify / Mixamo / UE へリターゲット。評価 5.0 (77件)。Windows のみ
- [x] **Blaze Puppeteer** [[blaze-puppeteer]] — $59 (500クレジット込み)
  - Kimodo ベース。リターゲット不要でリグへ直接書き込み。ARP 専用プリセット。Mac 可
  - 10秒/モーション、指なし。クラウド機能のみクレジット制
- [x] **Instant Rigger and Animator** [[instant-rigger-and-animator]] — $39 (セール $28.86)
  - 人型自動リグ + 2300+ クリップ + FBX/GLB 出力。ARP 持ちには競合気味
- 避ける
  - AnimoXtend https://superhivemarket.com/products/animoxtend-ai-animotion-generation-toolbox (クラウド依存、約2年更新なし)
  - MotionAI https://superhivemarket.com/products/motionai (ページほぼ空、Blender 4.3 まで)

## 優先度 中 キャラ生成

- [x] **AutoCharacters** [[autocharacters]] — Base $26.99〜 / Complete $58.49〜 (Commercial $134.99〜)
  - 男女パラメトリック人体 + 衣装168 + ポーズ100 + リグ。体型に衣装・リグが追従。評価 5.0 (16件)、販売 800+
  - **ゲームは Commercial 必須**。再配布不可。SFW 約1.1万頂点。カスタマイズ可能キャラの本命
- [x] **Eden Ultimate Character Studio + Wrap** [[eden-character-studio]] — Eden $30 / Wrap $7.50
  - Wrap = **AI 生成の人型に Eden ベースをフィットして髪・服・リグを使う**。公開1日目、評価2件、Cycles のみ
- [x] **AutoCreatures** [[autocreatures]] — 個人 $14.99 / 商用 $79.99 (ローンチ価格)
  - ベース50 + パーツ399 でクリーチャー組み立て。Prepare for Game で deform コピー + FBX。Blender 5.2 限定、評価2件
- [x] **Human Generator Ultimate** [[human-generator]] — $68 / 商用 $128
  - リアル人体の定番。販売 17300+、評価 4.0 (139件)。顔リグ + ARKit 顔キャプチャ。スタイライズ・軽量ゲーム向きではない。無料トライアルあり
- [x] **Infinity Style Bundle** [[infinity-style-bundle]] — $59
  - アドオンではなくスタイライズ体のブロックアウト/ベースメッシュ集。優先度低

## 優先度 中 ウェイト補助

- [x] **WeightForge** [[weightforge]] — $30 (表示 $22.50)
  - ウェイトの不具合 (腰・肩の潰れ、キャンディラップ) の診断・自動修正 + 階層考慮バインド。評価なし、販売 20+
  - [[adaptive-auto-skinning]] と役割重複。実績で劣る。優先度低
- [x] **Auto Rig & Ragdoll Wizard** [[auto-rig-ragdoll-wizard]] — $19 (表示 $13.30)
  - **ウェイト補助ではなく**自動リグ + ラグドール物理。評価 3.0 (11件)、ドキュメント不足。ゲームのキャラ用には不向き

## 優先度 中 2D・画像生成統合

- [x] **Texturaizer** [[texturaizer]] — Edu $36 / Commercial $78〜
  - ComfyUI の Blender フロントエンド。オブジェクト別プロンプト、PBR、ビルボード。評価 5.0 (8件)
  - **Blender 4.2〜4.5 まで**。約2年更新なし。ComfyUI は運用中だが Blender 5 では使えない
- [x] **Image Generator 2** [[image-generator-2]] — $29
  - レンダー → Gemini / OpenAI でフォトリアル化。**自前 API キー必須のクラウド型**。評価1件。ゲーム制作の本筋ではない
- [x] **Pixel (Local AI)** [[pixel-local-ai]] — $10
  - テキスト・画像 → PBR マップ + レイヤーエディタ。バックエンド・要件の記載なし。評価なし
- [x] **True Pixel Art Generator v2** [[true-pixel-art-generator]] — $1
  - 3D → ピクセルアートのスプライトシート。**生成 AI ではない**。Blender 対応版表記が矛盾。2D ゲーム向けに試す価値あり
- スプライト生成そのものを AI でやる製品は見つからず。2D は ComfyUI (Windows PC) 側が現実的

## その他 気になった

- NexFoliage https://superhivemarket.com/products/nexfoliage — 150種ゲーム向け手続き型植物 ($17〜)
- AI生成メッシュのリトポ系 (調査済み)
  - [x] **QuadMend** [[quadmend]] — $15。AI・スキャンの三角形メッシュを修復してクアッド化 (Instant Meshes + QuadriFlow の良い方を採用)。作者テストで AI 生成 36 回中 22 回が使える結果。完全オフライン。評価 5.0 (2件)。リトポ系の本命
  - [x] **QuadForge Pro** [[quadforge-pro]] — $39。自動 + 手描きリトポ (PolyPen 等)、UV シーム、LOD、3D プリント分割。公開8日、評価なし
  - [x] **Quadify Bridge** [[quadify-bridge]] — $19。Meshy / Rodin / Tripo の取り込み橋渡し + MCP。リトポ本体は別売 Ultra。ローカル生成派には不要
  - [x] **Mesh Prep Studio Toolkit Helper** [[mesh-prep-studio]] — $22。標準機能を 1 パネルに集約。作者が「アニメ用トポロジーではない」と明記。優先度低

## 買い方メモ

1. 無料・$1 で先に試す: Kimodo Bridge (v1.5.7+)、RigMend Lite、MotionGen Lite
2. セール待ち: Bizen3D、GenMesh、Image to 3D 系
3. 通し確認: Image to 3D → RigMend → Auto Skinning で AI生成メッシュがゲーム用に使えるか
4. Milad スタックの 25%オフクーポン (3日間) は期限に注意

## 未解決

- Blender MCP (bpy) から各アドオンを呼べるか → 購入後に実機確認。
- Bizen3D の UV 品質、Version History 未読。
- Adaptive Auto Skinning の 2ページ目レビュー未読。
- Kimodo モデルのライセンス (商用可否) 未確認。
