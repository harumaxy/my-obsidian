---
title: VNCCS - Visual Novel Character Creation Suite
description: ComfyUI カスタムノード。ビジュアルノベル向けキャラクター一貫性生成ツール。
aliases:
  - VNCCS
tags:
  - comfyui
  - character-consistency
  - image-generation
draft: false
date: 2026-08-06
---

# VNCCS - Visual Novel Character Creation Suite

ComfyUI カスタムノード。ビジュアルノベル向けキャラスプライト制作特化。
複数画像でキャラ外見一致 自動化。

GitHub: https://github.com/AHEKOT/ComfyUI_VNCCS

## 主要ノード

- **VNCCS Pose Studio** — ComfyUIノード内 3Dポーズ編集。照明・カメラ・ポーズライブラリ対応
- **VNCCS 3D Factory** — 参照画像→TripoSplat→3D Gaussian変換。任意角度レンダリング
- **VNCCS UniCanvas** — キャンバス統合
- **Visual Camera Control** — マウス操作でカメラ位置調整
- **VNCCS_QWEN_Encoder** — 参照画像+プロンプト融合。identity-aware条件付け生成

ユーティリティ単体版: https://github.com/AHEKOT/ComfyUI_VNCCS_Utils

## キャラ一貫性の技術スタック

### 1. TripoSplat (3D Gaussian Splatting)

参照画像→TripoSplatで3Dモデル化→任意角度レンダリング。

- 出力形式: `.ply` / `.splat`（ポリゴンメッシュではない）
- 各Gaussianが持つ属性: 位置(XYZ) / **色(RGB)** / 不透明度 / 形状(楕円体)
- 色情報 Gaussian自体に埋め込み → カラー任意角度レンダリング可能
- 「シルエットだけ」ではない。色・テクスチャ・陰影を3D空間に復元

従来メッシュ(OBJ/GLB+PBRテクスチャ)が必要な場合は TripoSR が適切。

### 2. IP-Adapter FaceID

顔認識モデル(InsightFace)の顔embeddingで同一性維持。

通常IP-AdapterはCLIP(画像全体)使用。FaceIDは顔IDだけ抽出→顔以外(ポーズ/服/背景)はプロンプト制御。

処理フロー:
```
参照画像 → InsightFace → 顔ID embedding (512次元)
  → Transformer decoder → 拡散モデルのtext semantic spaceにマッピング
  → attention注入 → 顔同一性維持
```

**FaceID PlusV2:** 顔ID embedding + CLIP顔構造 両方使用。顔構造重み数値調整可能。
対応LoRAとセット使用必須。

### 3. VNCCS_QWEN_Encoder (Qwen Image)

Qwen Image = Alibaba製 20B MMDiT 画像**生成**モデル（画像理解VLMではない）。

**MMDiT = Multi-Modal Diffusion Transformer**

通常DiT: テキストをcross-attentionで注入。
MMDiT: テキストと画像を**対称dual-stream**で処理（Flux.1と同設計）。

```
テキスト条件 ─→ Text Encoder ─→ [Transformer Blocks] → デノイズ出力
画像latent ────────────────→ [Transformer Blocks]   ↑ 同一attention空間
```

強み: 複雑テキストレンダリング（中国語特に強い）/ 精密画像編集 / フォトリアル〜アニメ対応

VNCCSでの役割: 参照画像のキャラ特徴読取→プロンプト融合→identity-aware条件付け生成

### 4. ControlNet (ポーズ制御)

Pose Studioで生成した3DポーズをControlNet条件として使用。

## Qwen Image LoRA / ControlNet 対応状況

- **LoRA:** 対応済み（MajicBeauty LoRA等 ModelScope経由）。DiffSynth-StudioでLoRAトレーニングも可
- **ControlNet:** Qwen-Image-Edit-2509でネイティブ対応。depth map / edge map / keypoint map
- **低VRAM:** DiffSynth-Studioで4GB VRAM以内レイヤーオフロード + FP8量子化

## インストール

```bash
cd ComfyUI/custom_nodes/
git clone https://github.com/AHEKOT/ComfyUI_VNCCS.git
```

または ComfyUI Manager から `VNCCS` 検索→インストール。
