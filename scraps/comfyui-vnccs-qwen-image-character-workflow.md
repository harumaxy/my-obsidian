---
title: ComfyUI VNCCS キャラクターワークフロー(Qwen Image + SeedVR2)
date: 2026-09-23
source: https://www.runcomfy.com/ja/comfyui-workflows/comfyui-vnccs-character-workflow-qwen-image-seedvr2
---

# ComfyUI VNCCS キャラクターワークフロー

1枚のリファレンス画像からVN(ビジュアルノベル)用キャラシート一括生成。ゲーム開発・VN制作向け、透明背景スプライト対応。

## 使用モデル・ノード

- Qwen Image(20B MMDiT, Alibaba製, Apache2.0) — エンコーダ+VAE部分のみ使用
- SDXL base — 画像生成本体
- ControlNet OpenPose — ポーズ誘導
- YOLOv8 Face — 顔検出(Ultralytics製)
- VNCCS LoRAバンドル(Pose Studio/Clothes Core/Emotion Core) — タスク別専用学習

カスタムノード: `VNCCS_QWEN_Encoder`, `EmotionGeneratorV2`, `VNCCSSheetManager`, `Face Detailer`, `CharacterAssetSelectorQWEN`

## 処理5ステップ

1. クローン生成(既存キャラ画像+ポーズ指示) or パラメータ駆動生成(年齢/体型/目/髪スライダー)
2. 衣装生成(テキスト指定→マスク抽出+条件付けブレンド)
3. 表情スタジオ(感情リストからバッチ生成、YOLOv8+Face Detailerで顔強化)
4. スプライトクリエーター(均一タイル分割、透明背景PNG出力)
5. データセット生成(LoRA学習用ラベル付きフォルダ)

## VNCCSの一貫性維持の仕組み

VNCCS = Visual Novel Character Creation Suite(AHEKOT/MiuProject製OSS拡張)。IPAdapterやControlNetの「別経路embedding注入」方式でなく、以下3段構え:

1. **参照潜在方式**: リファレンス画像をVAEエンコード→参照潜在をQwen ImageのMMDiT joint attentionに直接混合(Qwen-Image-Edit系の手法)。複数画像(Picture 1-3)を個別リサイズ→重み付け合成(二乗重み)
2. **タスク別LoRA**: Pose Studio/Clothes Core/Emotion Coreを`LoraLoaderModelOnly`でモデルのみに適用。属性ごとに専用学習してるから「ポーズだけ変えて顔は維持」が効く
3. **潜在キャッシュ**: `cache/poses/<id>/`にキャラ潜在・ポーズ・参照画像テンソル保存→再生成時も同じ入力再利用

VN立ち絵の「体・衣装固定、顔だけ差分」という伝統的制作手法を、AI生成パイプラインでそのまま自動化したのがステップ3の本質。

## 関連概念メモ

- **ViT**: 画像をパッチ分割→トークン化→Transformer処理。CNN流の画像認識にTransformer輸入した発想
- **DiT**: ViTの発想を拡散モデル(生成)に応用。UNetと違い局所バイアス弱いが、パラメータ/データ増やすほど素直にスケールする。全体構図の一貫性・テキストレンダリングで優位
- **UNet(SD1.5/SDXL)**: 畳み込み+skip connection。局所ディテール強いが大規模化での伸びは頭打ちしやすい
- **VAE**: 画像↔潜在空間の圧縮/復元。色味・質感などピクセルレベル再現に直結
- **マルチモーダル入力**(ChatGPT/Gemini/Claudeの画像添付): ViT系vision encoderで画像をパッチトークン化→テキストトークンと同じ系列としてTransformerに投入

## ローカル実行(RTX4080/16GB)の現実

- SDXL: 余裕、快適
- Flux(12B, fp8/GGUF量子化): ギリギリ動く
- Qwen-Image(20B): fp8でも20GB超→CPUオフロード必須、速度大幅低下。本気運用はクラウド(RunComfy等)向き

## 出典

- https://www.runcomfy.com/ja/comfyui-workflows/comfyui-vnccs-character-workflow-qwen-image-seedvr2
- https://github.com/AHEKOT/ComfyUI_VNCCS
- https://github.com/AHEKOT/ComfyUI_VNCCS/wiki/Technical-Generator-Internals
