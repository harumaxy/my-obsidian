---
title: Tripo + GPT-6 Astra 3Dキャラワークフロー
description: 1枚の参照画像から Tripo でパーツ別3D生成、Blender MCP + Astra で組立・リグ・アニメ。参照画像のローカル生成手段も調査
# permalink:  # don't use
aliases:
  - tripo-astra-3d-character-workflow
tags:
  - 3d
  - tripo
  - blender
  - blender-mcp
  - image-edit
  - comfyui
draft: false
date: 2026-10-31
---

出典: [GPT-6 Astra 3D Character Workflow (Tripo公式ブログ, 2026/10/27)](https://www.tripo3d.ai/blog/gpt-6-astra-3d-character-workflow)

Tripo 製品宣伝記事。WebFetch は 403、Chrome で取得。所要時間・品質の数値なし。手順は抽象的。

## 概要

- 参照画像 1枚 → Tripo で3D生成 → Blender + Astra (GPT-6, Blender MCP 経由) で組立・リグ・アニメ
- 元ネタ: Nano (@Dstudio_ai) のアニメキャラ制作。body/head/hair を Tripo で別々に生成、Astra で Blender 組立
- Astra 固有の魔法なし。Blender MCP で LLM に bpy 触らせるだけ。ここの環境の `mcp__blender__*` でも同種可能

必要なもの: 参照画像 / Tripo Studio アカウント / Blender / GPT-6 Astra / Blender MCP (アドオンとクライアント側MCP設定は別物)

## 7ステップ

1. **参照画像準備**
   - 正面、全身、Tポーズ、腕を体から離す、手足見える、背景白無地、服・髪・色一貫
   - 首・指・髪シルエットが曖昧なら先に直す
   - 全体画像は後工程のプロポーション基準として残す
2. **Tripo で3パーツ別生成**
   - Body (服付き。首の面積を残す) / Head (髪なし、顔+首) / Hair (帽子等の付属込み、外形シルエット)
   - 単純クロップ不可 (不要部位が残る、組立用の面が欠ける)。パーツ毎に参照を編集して作る
   - Body / Head / Hair の名前で書き出し
3. **Blender MCP 設定**: まず読み取り専用でシーン名・オブジェクト確認
4. **Astra で組立**
   - Body をスケール基準、Head を首で合わせ、Hair を頭皮にフィット
   - 前/側/背面プレビューで首の継ぎ目と髪の裏を確認
   - 指示は1回1編集。承認済み部分を崩さない
5. **リグ**
   - Tripo でリグ済みの Body を GLB で取込、armature と weight を再利用。Head/Hair を同じ骨に付ける
   - 無ければ Blender で biped 作成
   - 腕上げ・肘/膝曲げ・首回しでデフォーム検証、部位限定で weight 修正
   - 表情: 差分切替 (neutral/笑顔/目閉じ、離散) か連続 (まばたき・口、まぶた形状が必要)
6. **マテリアル確認**: 再生成なし。color/roughness/metallic/normal を正しい入力に接続、同一ライティングで参照と比較
7. **アニメ**
   - 既存モーション取込 (権利と互換確認) か、Astra に3秒24fps挨拶キーフレーム生成
   - フレーム単位でフィードバック (例: frame20で左手が上着貫通)
   - 1920x1080 / 24fps で描画。髪はキーフレーム二次動作

他事例: Stefan Vaskevich (Blender MCP + Computer Use、非人型リグ)、Lucca Cerf (Warcraft風ゲーム試作、Tripo + Blender + Unity)

## 参照画像の作り方 (記事は未記載)

記事は条件を書くだけで、生成・編集ツールを指定していない。ここから調査。

- 全体参照 (Tポーズ): Qwen-Image-Edit-2511 の T-pose ノード付き Consistent Character Creator 系ワークフローあり。DWPose で骨格抽出して Qwen-Edit に流す方式もある
- 腕が胴に癒着した画像より、腕を離したポーズの方が3D化でジオメトリ明瞭
- マルチビュー (前/側/背): Qwen-Image-Edit-2511 + Lightning LoRA + multi-angle LoRA + カメラ角度ノード
- パーツ分離 (髪なし頭 / 服付き胴体 / 髪) の実例は検索で見つからず。SaaS (gpt-image, nano banana) では実践報告あり、ローカルは少ない
- 推測: 「髪を消して」「頭と首だけ残して」の編集指示を投げる。失敗時はマスク + inpaint。要検証

## ローカル画像編集モデル比較 (RTX4080 16GB 前提)

ブログ比較は記事ごとに順位が割れる。方向性の参考程度。

- **Qwen-Image-Edit-2511** (Apache 2.0)
  - 複数参照対応、2509 より人物一貫性向上。Kontext を置き換えたという声あり
  - fp8 で本体約20GB + 視覚エンコーダ約8GB。GGUF 量子化なら 16GB に収まる報告
  - 元画像のスタイル維持が強い。アニメ絵のパーツ分離と相性良し
- **FLUX.2 [klein] 4B** (Apache 2.0): 約13GB、高速。一貫性評価が高く一貫性 LoRA あり。縦横を16/32倍数にするとズレ減
- **FLUX.2 [dev]**: BFL 公式の勝率は Qwen より上 (ベンダー数値)。fp8 で本体35GB + エンコーダ18GB と重く、16GB では遅い。絵柄が変わりやすいとの報告
- **LongCat-Image-Edit** (Meituan, 6B): 未編集領域の保持が得意。約18GB (CPUオフロード込み)。「髪だけ消す」と相性良さそう
- **Step1X-Edit v1.2**: 編集前に推論する設計。推奨18GB以上
- **FLUX.1 Kontext dev**: セルフホストサービス用途は非商用ライセンス
- **HunyuanImage 3.0**: 80B MoE、40GB以上。ローカル編集は非現実的

見立て (推測): 1番手 Qwen-Image-Edit-2511 (GGUF/fp8)、2番手 LongCat-Image-Edit と FLUX.2 klein。同じ入力・指示で3つ比べるのが確実。ローカル勢は複雑な分解指示で崩れやすい。

## TODO

- Windows PC 起動後、Qwen-Image-Edit-2511 導入状況確認 (今回は PC 停止中で未確認)
- 髪除去 / 頭首のみ / 服付き胴体のパーツ分離編集を実際に試す

## 参考リンク

- [Qwen-Image-Edit-2511 ComfyUI docs](https://docs.comfy.org/tutorials/image/qwen/qwen-image-edit-2511)
- [Consistent Character Creator 3.8 (RunComfy)](https://www.runcomfy.com/comfyui-workflows/consistent-character-creator-3-8-in-comfyui-hyperrealistic-consistent-ai-characters)
- [Scenario: Use Multi-View for Better 3D Models](https://help.scenario.com/en/articles/use-multi-view-for-better-3d-models)
- [Qwen-Edit → Krea2 Turbo workflow (HF)](https://huggingface.co/JahJedi/Qwen-Edit-Krea2-Turbo-Workflow)
- [Qwen Image Edit 2511 360° turnarounds digest](https://recapio.com/digest/qwen-image-edit-2511-create-360deg-character-turnarounds-in-comfyui-by-smallzero)
- [おーら: 画像編集オープンモデル8種ローカル比較 (note)](https://note.com/ai_0049/n/n8051776106dc?hl=en)
- [Instruction Image Editing 2026: Kontext vs Qwen vs Step1X](https://builderai.tools/blog/ai-image-editing-flux-kontext-qwen-image-edit-step1x)
- [5 Open Source AI Models for Image Editing (juanbretti)](https://blog.juanbretti.com/en/posts/2026-09-04_5_open_source_image_editing_ai_models/)
- [Best Local AI Image Models 2026 (localaimaster)](https://localaimaster.com/blog/best-local-image-models-compared)
- [5 Best Open Source Image Editing AI Models (technomipro)](https://www.technomipro.com/5-best-open-source-image-editing-ai-models-for-2026/)
- [Flux 2 character consistency (r/StableDiffusion 転載)](https://t.me/s/rStableDiffusion/57302)
