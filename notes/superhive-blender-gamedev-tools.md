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

## 注意

- ローカルAI系は NVIDIA GPU 前提多い。Mac 不可。Windows (RTX4080) 側 Blender で使う。
- Mac OK 明記は image-to-3d-local (ZEG) のみ。Apple Silicon 24GB+。
- Hunyuan 2.1 使う製品は EU・UK・韓国 対象外。商用は各エンジンのライセンス要確認。
- 429 エラーで未取得: humgen3d、quadify-bridge-ai-mesh-importer-for-blender、ai-mesh-toolkit-helper、auto-painter-ai
- 価格は調査日時点。セール前。

## 優先度 高 (1) Image to 3D 系 (ローカル生成)

- [ ] **Image to 3D** https://superhivemarket.com/products/imageto3d — $18
  - ローカル。TRELLIS / Pixal3D / Hunyuan / Hi3D / Enhance Texture / Canvas (ノード式)
  - NVIDIA のみ。VRAM 8GB 推奨。全部入れて約 132GB
  - Blender 4.2〜5.2。販売 1300+、評価 4.0 (22件)
  - 後処理 (UV/PBR/リトポ/リグ) の記載なし
- [ ] **Bizen3D** https://superhivemarket.com/products/bizen3d — $20 (サポート版 $26、5席 $60)
  - ローカル。Pixal3D + TRELLIS.2 + Hi3D 詳細強化 + Real-ESRGAN + クアッドリメッシュ (既定1万quad)
  - 色・粗さ・金属・法線ベイク。ゲーム向き後処理が一番揃う
  - NVIDIA VRAM 6GB+。Blender 4.5〜5.2。Windows 前提
  - 公開 11日前。実績不明
- [ ] **Image to 3D (AI in Your Local Blender)** https://superhivemarket.com/products/image-to-3d-local — $2.99 個人 / $3.99 商用
  - TRELLIS.2 / Hunyuan 2.1 / UltraShape / TripoSR
  - **Apple Silicon 対応** (24GB+ 推奨)。TripoSR は CPU 可
  - 作者「実験的」と明記。安いので試す価値あり
- [ ] **GenMesh** https://superhivemarket.com/products/genmesh — $34.90 (表示 $29.67)
  - Hunyuan3D 生成 + リメッシュ + テクスチャ + Rigify 自動リグ + GLB/FBX 出力
  - Godot / Unreal Live Link。Claude Desktop / Codex 向け MCP 連携
  - リメッシュはアニメ向けエッジループ保証せず。顔リグなし
  - Blender 5.2、Windows 主対象

## 優先度 高 (2) AI メッシュのリグ付け

- [ ] **RigMend** https://superhivemarket.com/products/rigmend — Lite $1 / Pro $24
  - 人型専用。関節検出 → スケルトン → スキニング自動
  - Pro: 指、Mixamo リターゲット、Unity/Unreal/Godot 出力プリセット
  - GPU不要、オフライン。顔リグなし。太い胴体でウェイト漏れ報告あり
  - Blender 4.2〜5.2
- [ ] **Adaptive Auto Skinning** https://superhivemarket.com/products/adaptive-auto-skinning — $29.75 (バンドル $38.25)
  - 別メモ参照 (ボクセル + GPUソルバー、頂点グループ出力)

## 優先度 高 (3) テキスト → モーション / モーキャプ

- [ ] **Kimodo Blender Bridge** https://superhivemarket.com/products/kimodoblenderbridge — 無料 (支援版 $5/$10)
  - NVIDIA Kimodo をローカル実行。Mixamo 自動マッチでリターゲット
  - NVIDIA VRAM 8GB+ (推奨16GB)。Windows / Linux のみ
  - Blender 4.2〜5.1。販売 70+、評価 4.0 (8件)。単独作者、GPL
  - 無料なので真っ先に試す
- [ ] **MotionGen** https://superhivemarket.com/products/motiongen — Lite $1 (非商用) / Pro $29 / Gold $57
  - 動画 → アーマチュア (マーカーレス)。Rigify / UE Mannequin / Mixamo リターゲット
  - NVIDIA 8GB+、Windows のみ。販売 1400+、評価 5.0 (77件)
  - エンジン非公開 (アドオンコードのみ MIT)。初回ライセンス認証でネット要
- [ ] **Blaze Puppeteer** https://superhivemarket.com/products/blaze-puppeteer — $59 (500クレジット込み)
  - 人型リグの FK/IK ポーズ + 中割り生成。タグに kimodo
  - クラウド機能はクレジット制。出力形式不明。販売 100+、評価 4.0 (11件)
- [ ] **Instant Rigger and Animator** https://superhivemarket.com/products/instant-rigger-and-animator-auto-rig-animate-and-export-humanoid-characters- — $39 / $28.86
  - 人型自動リグ + アニメライブラリ + FBX/GLB 出力。完全ローカル
  - 販売 20+。評価なし
- 避ける
  - AnimoXtend https://superhivemarket.com/products/animoxtend-ai-animotion-generation-toolbox (クラウド依存、約2年更新なし)
  - MotionAI https://superhivemarket.com/products/motionai (ページほぼ空、Blender 4.3 まで)

## 優先度 中 キャラ生成

- [ ] **Eden Ultimate Character Studio + Wrap** https://superhivemarket.com/products/eden-ultimate-charcters-studio-plus-wrap — Eden $30 / Wrap $7.50
  - スタイライズ人体ビルダー。Wrap = **AI生成の人型モデルに Eden ベースをフィット**
  - Blender 5.0〜5.3、Cycles のみ。公開1日目、評価2件
- [ ] **AutoCharacters** https://superhivemarket.com/products/autocharacters-male--female-body-presets-base — $26.99〜 (Commercial $134.99〜)
  - パラメトリック人体。100+コントロール、リグ付き。販売 800+、評価 5.0 (16件)
  - **Standard は非商用。ゲームは Commercial 必須**。再配布不可。NSFW マスター同梱
- [ ] **AutoCreatures** https://superhivemarket.com/products/autocreatures — 個人 $14.99 / 商用 $79.99
  - モジュラーでクリーチャー組み立て。399パーツ。FBX 出力のみ
  - Blender 5.2+。評価2件 (平均3)。パーツ単体取り出し・アセットライセンス要確認
- [ ] **Human Generator Ultimate** https://superhivemarket.com/products/humgen3d — $68〜$128 (未取得、429)
- [ ] **Infinity Style Bundle** https://superhivemarket.com/products/infinity-style-bundle — $59 (スカルプト用ベースメッシュ10点、商用可、再配布不可)

## 優先度 中 ウェイト補助

- [ ] **WeightForge** https://superhivemarket.com/products/weight-painting-addon-fix-weight-painting — $30 (表示 $22.50)
  - ウェイトの問題診断と修正。販売 20+、実績薄い
- [ ] **Auto Rig & Ragdoll Wizard** https://superhivemarket.com/products/auto-rig-ragdoll-wizard — $19 (表示 $13.30)
  - 評価 3.0 (11件)、機能説明薄い。優先度低

## 優先度 中 2D・画像生成統合

- [ ] **Texturaizer** https://superhivemarket.com/products/texturaizer — Edu $36 / Commercial $78〜
  - ComfyUI (ローカル/リモート) の Blender フロントエンド。PBR素材・ビルボード
  - Blender 4.5 まで。約2年更新なし
- [ ] **Image Generator 2** https://superhivemarket.com/products/image-generator2 — $29
  - Gemini (Nano Banana) / OpenAI 画像生成。自前 API キー。クラウド型
  - 旧モデル終了日 (2026年10月) 記載あり、モデル一覧が古い可能性
- [ ] **Pixel (Local AI)** https://superhivemarket.com/products/pixelai — $10
  - テキスト・画像 → PBR マップ。バックエンド記載曖昧
- [ ] **True Pixel Art Generator v2** https://superhivemarket.com/products/true-pixel-art-generator-v2 — $1
  - 3D → ピクセルアート スプライトシート。生成AIではない。Blender 対応版表記が矛盾
- スプライト生成そのものを AI でやる製品は見つからず。2D は ComfyUI (Windows PC) 側が現実的

## その他 気になった

- NexFoliage https://superhivemarket.com/products/nexfoliage — 150種ゲーム向け手続き型植物 ($17〜)
- AI生成メッシュのリトポ系
  - Quadify Bridge https://superhivemarket.com/products/quadify-bridge-ai-mesh-importer-for-blender (未取得)
  - QuadMend https://superhivemarket.com/products/quadmend
  - QuadForge Pro https://superhivemarket.com/products/quadforge-pro
- Mesh Prep Studio Toolkit Helper https://superhivemarket.com/products/ai-mesh-toolkit-helper (未取得)

## 買い方メモ

1. 無料・$1 で先に試す: Kimodo Bridge、RigMend Lite、MotionGen Lite
2. セール待ち: Bizen3D、GenMesh、Image to 3D 系
3. 通し確認: Image to 3D → RigMend → Auto Skinning で AI生成メッシュがゲーム用に使えるか
