---
title: 3D 生成 AI 創作ワークフロー
description: image-blaster を参考に、ローカルと商用 API を使い分ける 3D 生成の流れを整理したメモ
aliases:
  - 3d-gen-ai-workflow
tags:
  - 3d
  - generative-ai
  - workflow
  - comfyui
draft: false
date: 2026-11-09
---

image-blaster 使わん。流れだけ参考にする。
元ネタ: [[image-blaster]]、[[agent-skills-tools-clips-2026-11]]

## image-blaster の SaaS

契約いるの 2 つだけ。

- **World Labs (Marble)**: 画像 → 歩ける 3D 世界。出力ガウシアンスプラット (`.spz`)。3D 環境はここだけ。代替なし。
- **FAL**: 生成 AI モデルの推論ゲートウェイ。キー 1 つで複数社モデル呼べる。キュー型 API (投げる → ポーリング → ダウンロード)。

FAL 経由で呼んでるモデル:

- 画像編集: `fal-ai/nano-banana-2/edit` (既定)、`openai/gpt-image-2/edit` (代替)
- 3D メッシュ: `fal-ai/hunyuan-3d/v3.1/pro/image-to-3d`、代替 `fal-ai/meshy/v6/image-to-3d`
- 効果音: `fal-ai/elevenlabs/sound-effects/v2`
- 逃げ道: `api.fal.ai/v1/models` で検索

## FAL ってなに

- 「メディア生成版 OpenRouter」。ほぼ合ってる。
- OpenRouter は LLM 中心、トークン課金、OpenAI 互換で形式そろう。
- FAL は画像・動画・3D・音声中心、生成物単位課金 (1 枚、1 秒)、自社 GPU でも推論動かす。
- モデルごと入力パラメータ違う。エンドポイントごとスキーマ確認いる。
- 類似 (知識ベース、未確認): Replicate (一番近い)、Runware、WaveSpeedAI、Segmind、Novita AI、Together AI、Hugging Face Inference Providers。
- 自分でモデル載せる系: Modal、RunPod、Baseten。ComfyUI の API 化向き。

## 商用画像モデルとローカルの差

商用 (nano-banana、gpt-image) 評価高い理由: 言語理解と画像生成が一体。

- 指示編集 (消す、服だけ変える) 強い
- 画像内の文字 (日本語含む) 正確
- 複数参照で同一性保つ
- 図解、構造ある画像

ローカルで近づける候補 (知識ベース、未検証): FLUX.1 Kontext [dev]、Qwen-Image-Edit、Qwen-Image。ComfyUI で動く。

差が出やすい所:

- 曖昧な指示の理解 (世界知識)
- 複数参照の同一性維持
- 日本語長文の文字
- プロンプトの手間 (商用は短文で通る、ローカルは調整いる)

RTX4080 は VRAM 16GB。大きいモデルは量子化前提で、品質・速度落ちる。

## 使い分け方針 (決定)

- **ローカル (ComfyUI)**: ブロックアウト、ランダム生成のアイデア出し。大量に回す。枚数増えても追加費用なし。
- **FAL 経由の商用モデル (gpt-image、nano-banana)**: コンセプトアート、3D 生成の参照画。高品質いる所だけ。採用案を絞ってから使う。
- 理由: 3D 生成は入力画像の破綻 (手足の数、形の曖昧さ) がそのままメッシュに出る。参照画だけ商用で作る効果大きい。

流れ:

1. ローカルで大量生成 → ブロックアウト、アイデア出し
2. 採用案を絞る
3. FAL 経由の gpt-image / nano-banana で、コンセプト画・参照画に仕上げ
4. 参照画 → Hunyuan 3D / Meshy でメッシュ化
5. (必要なら) 環境は Marble、音は ElevenLabs

## image-blaster から盗む設計

- 環境 (点群)、物体 (個別メッシュ)、音 の 3 層に分ける。
- 動かせる物体を画像から消した「空の環境」作ってから、環境生成。物体は別途メッシュ化。
- **ファイルが状態**: JSON で進行管理。再開・再生成できる。
- **課金前に確認**: 解析と承認 (無料) → 有料生成の順。リクエスト情報はポーリング前に書き出す。
- 重い生成はサブエージェントに任せる (`context: fork`)。

## 未確認・やること

- 各社の現行料金、モデルバージョン未確認。image-blaster は 2026-05 から更新止まり。
- ローカルモデルの品質は未検証。同じ画像で商用とローカル比べる実験したい。
- 3D アセット作る案件出たら試す。最初は 1 枚だけ。
