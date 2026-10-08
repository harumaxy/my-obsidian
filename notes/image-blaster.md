---
title: image-blaster
description: 1枚の画像から 3D環境・メッシュ・SFX を作る Claude Code 用リポジトリ。構成と、モデル差し替え・サブスク枠の調査メモ
# permalink:  # don't use
aliases:
  - neilsonnn/image-blaster
tags:
  - claude-code
  - 3d
  - gaussian-splatting
  - image-generation
draft: false
date: 2026-10-06
---

https://github.com/neilsonnn/image-blaster

## これ何

画像1枚 → 3D世界 作る。Claude Code の skills / agents / scripts の集まり。TS アプリ本体ではない。
約5分で出来る。ゲーム・DCC・Three.js 向け素材作り。

作るもの:
- 動く物体 → 3Dモデル (`.glb` `.obj`)
- 動かない環境 → Gaussian splat (`.spz`)
- 環境音ループ + 物体別 SFX (`.mp3`)

## 使い方

1. clone して `claude` 起動
2. `.env` に `WORLD_LABS_API_KEY` と `FAL_KEY` 入れる
3. `input/` に画像置く
4. 「blast it and confirm each step with me」と頼む

## 使うモデル

- `marble-1.1` (World Labs) — 環境 (splat)
- `nano-banana` — 画像編集 デフォルト。clean plate、物体参照画像
- `gpt-image-2` — 画像編集 代替
- `hunyuan-3d` (FAL) — 物体 3D化
- `elevenlabs-sfx` (FAL) — 音

3D 生成の Hunyuan パラメータ: `--face-count` (既定 50000)、`--enable-pbr`、`--generate-type Normal|LowPoly|Geometry`、`--polygon-type`

## 流れ

1. `input/` → `worlds/<slug>/source/` へ置く
2. ビューア起動 (`bun run dev`、port 5173)
3. `image-blast-uncover` — 画像解析。持ち上げて動かせる物だけ候補にする。承認後 `object.json` 作成
4. `image-blast-plate` — 物体を消した clean plate 作る
5. `image-blast-world` — plate から World Labs で世界生成
6. 物体ごと `image-blast-3d`
7. 環境音 + 物体ごと `image-blast-sfx`

生成は全部 Agent の `run_in_background: true` で投げる。スクリプト自体は同期。

## 構成

- `.claude/skills/` 工程ごとの skill
- `.claude/agents/` skill 対応の agent
- `.claude/scripts/*.mjs` FAL / World Labs の API ラッパー
- `app/` 結果を見る React ビューア (R3F, rapier, `@sparkjsdev/spark` で splat 描画, zustand)
- `worlds/<slug>/` 成果物

ファイル名規約: `N-slug.ext` + 隠し `.N-slug-request.json`。0 = 元画像、増えるほど後の世代。再生成しても履歴残る。中断した生成も再開できる。

設計メモ:
- ディスクファースト。プロバイダ URL は来歴だけ。フロントはローカルファイルだけ読む
- 生成画像は Read でコンテキストに入れない。JSON サイドカーで状態を見る

## 別モデルに差し替えできる？

標準で切替できるもの:
- 3D: `--provider meshy|hunyuan` (Meshy は FAL 経由。README に書いてないが実装済み)
- 画像編集: `nano-banana` / `gpt-image-2`。環境変数 `ASSET_IMAGE_EDIT_PROVIDER` でも切替
- 世界 (Marble) と SFX は固定。切替口なし

Tripo / ComfyUI を足すなら:
- 3D: `generate-single-asset.mjs` の `MODEL_PROVIDER_ALIASES` と `run3DProvider()` に登録。`meshy-3d.mjs` と同じ形で `tripo-3d.mjs` 書く。FAL にエンドポイントあれば `runFalImageTo3DProvider()` 呼ぶだけ
- 画像編集: `image-edit.mjs` の `PROVIDERS` に `comfyui` 足す。`/prompt` → `/history` → `/view` を叩く
- 足したら SKILL.md の `--provider` 説明も直す (Claude が skill を見て引数決めるため)
- Gaussian splat の代替はほぼ無い。ビューアも splat 前提。ここは差し替え困難

## サブスク枠で gpt-image / nano-banana 使える？

- このリポジトリは両方 FAL 経由。必要なのは `FAL_KEY` だけ。OpenAI / Gemini のキーは使わない。FAL の従量課金
- ChatGPT Plus / Gemini のサブスクは UI 利用権。スクリプトからは呼べない。API 課金とは別会計

ChatGPT:
- Plus で gpt-image-2 使える。UI で 3時間に約40〜50枚、1日約200枚 (公式固定値ではない)
- Codex も ChatGPT ログインならサブスク枠で画像生成できる。ただし枠の消費はテキストの 3〜5倍速い
- Pro ($100/$200) は 5時間で何枚か、信頼できる数字なし。UI では実質無制限と言われる
- Codex 経由の自動化がサブスク規約上 OK かは未確認

Gemini (アプリ、日次、太平洋時間 0時リセット):
- Free 約20枚 (Nano Banana Pro は 1日2〜3枚)
- AI Plus 50枚 / AI Pro 100枚 / AI Ultra 1000枚
- 上限はよく変わる。公式ページで確認

blast 1回の画像生成は少ない (clean plate 1枚 + 物体参照が数枚〜十数枚)。枚数は足りる。問題は枠の数字でなく FAL 固定なこと。

## ローカル (ComfyUI, RTX4080) と gpt-image どっち

私の知識ベースの見解。ベンチ検索はしてない。

gpt-image 強い:
- 指示理解と編集。「家具消して背景埋めて」を一発でやる
- 元画像の構図・光・質感を保つ部分編集。clean plate と物体参照に効く
- ノード調整もマスクも要らない

ローカル強い:
- Illustrious / SD: アニメ・イラスト画風、LoRA、ControlNet
- 規制なし、無制限、再現性 (seed 固定)
- Z-Image / Qwen-Image: 素の生成品質は高い。Qwen-Image は文字に強い
- Qwen-Image-Edit が編集のローカル代替。16GB なら量子化で動く見込み。ただし失敗率は gpt-image / nano-banana より高いという評判

使い分け案:
1. 元画像はいつものローカル生成で作る
2. clean plate と物体参照だけ gpt-image か nano-banana (FAL 経由) に任せる
3. 品質で困ったら Qwen-Image-Edit の provider を足す

## 留意

- 有料 API 2つ (World Labs, FAL) 必須
- `app/` は `.claudeignore` で除外済み。改造するなら外す
