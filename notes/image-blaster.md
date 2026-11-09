---
title: neilsonnn/image-blaster 要約
description: 画像 1 枚から 3D 環境 (ガウシアンスプラット)・個別オブジェクトのメッシュ・効果音を作る、Claude Code 用のワークスペース型プロジェクト
aliases:
  - image-blaster
tags:
  - agent
  - skill
  - 3d
  - generative-ai
draft: false
date: 2026-11-08
---

neilsonnn/image-blaster。画像 1 枚から、3D 環境、オブジェクトのメッシュ、効果音を作る。星 約 12.4k、MIT。2026-04-21 作成、最終 push は 2026-05-15 (その後約半年更新なし)。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/neilsonnn/image-blaster
- ローカル: `~/ghq/github.com/neilsonnn/image-blaster`
- 作者: Neilson Koerner-Safrata
- 他のスキル集と違い、**リポジトリ自体をクローンして、その中で `claude` を起動する**作業場。`.claude/` 以下にスキル 8 個、サブエージェント 6 個、フック 2 個、Node スクリプト群 (`.mjs`)、React 製ビューア (`app/`) が入っている。

## 使い方 (README)

1. `git clone https://github.com/neilsonnn/image-blaster` して `cd`。
2. `claude` を起動し、World Labs と FAL の API キーを渡す (`.env.example` に `WORLD_LABS_API_KEY` と `FAL_KEY`)。
3. `input/` に画像を置き、「blast it and confirm each step with me」と頼む。
- 「画像から 5 分未満で、メッシュ化された 3D 環境まで」とうたう。

## 出力

1. 動的オブジェクトの 3D モデル (`.glb`, `.obj`)。
2. 静的な環境のガウシアンスプラット (`.spz`)。
3. 環境音のループと、オブジェクト別の物理効果音 (`.mp3`)。
- Unity / Unreal / Godot、Blender / 3DS Max / Maya、Three.js や Electron アプリのアセットとして埋め込める、と書いてある。
- 用途の例: ゲームのレベル案、昔の自分の部屋、ロボット用の環境、映画のロケハン、建築レンダリング。

## 使うモデル (外部の有料 API)

- `marble-1.1` (World Labs): 探索できる 3D 環境を作る。
- `nano-banana`: 画像編集 (元画像の掃除、クリーンプレート、オブジェクトの参照画像)。代替で `gpt-image-2`。
- `hunyuan-3d` (FAL 経由): オブジェクトの 3D モデル。スクリプトには `meshy` もある。
  - `--face-count <40000-1500000>` (既定 50000。Hunyuan 自体の既定は 500000)。
  - `--enable-pbr true|false` (既定 true)。
  - `--generate-type Normal|LowPoly|Geometry` (Normal はテクスチャ付き、LowPoly はポリゴン削減、Geometry は白い形状のみ)。
  - `--polygon-type triangle|quadrilateral` (LowPoly 用)。
- `elevenlabs-sfx` (FAL 経由): 環境音と効果音。

README に料金の説明は無い。各 API の従量課金がかかるはず。実際の金額は未確認。

## スキル 8 個 (`.claude/skills/`)

- `image-blast-project`: `worlds/<slug>/` にプロジェクトの枠を作る。`input/` の画像を安定したパスへ移す。状態の確認。
- `image-blast-uncover`: 画像を解析し、`image.json` とオブジェクト候補を作る。**ここまでは API 費用がかからない**と明記。オブジェクトは、人が持ち上げられる単体のものだけ (敷物・床・壁・固定の建築物、組み合わせは対象外)。解析後にユーザーの承認を待って止まる。
- `image-blast-plate`: 確定したオブジェクトを消した「クリーンプレート」画像を 1 回の編集で作る。
- `image-blast-world`: 元画像のオブジェクトを引いた「空の環境」の説明文を作り、World Labs で静的環境を生成。ローカルファイルとしてダウンロードする (プロバイダの URL は出所メモ扱い)。
- `image-blast-3d`: 指定した 1 個のオブジェクトの 3D モデルを作る。
- `image-blast-sfx`: 環境音ループ、オブジェクトの衝撃音、任意の効果音。非ループは ffmpeg で無音のトリム + ラウドネス正規化。ループは生のまま (継ぎ目を保つ)。
- `image-blast-image-edit`: 汎用の画像編集 (掃除、オブジェクト除去)。
- `image-blast-wildcard`: FAL の任意のモデルを探して実行する逃げ道。**実行前に、正確なエンドポイントをユーザーが確認する**手順 (有料なので)。

## 設計の特徴

- **ファイルが状態**: `worlds/<slug>/` 以下の JSON (`project.json`、`scene.json`、`image.json`、`source/*.json`、`output/<オブジェクト>/object.json`) が規約で、再開・再生成できる。
- **課金の前に確認**: 解析と承認 (無料) を済ませてから、plate、world、3D、SFX (有料) へ進む順序。リクエストのメタデータは、ポーリングの前に書き出す (中断しても再開できる)。
- 重い生成は `context: fork` のサブエージェントに任せ、メインの文脈を汚さない。
- ビューア (`app/`、React + Vite) で結果を表示する。既定では `.claudeignore` で `/app` を隠している (変更させたいときは外す)。

## 所感

- スキル単体というより、**API を束ねたアプリを Claude Code で操作する形**。画像 → 3D 環境の一気通貫が売り。
- 外部サービス 3 つ (World Labs、FAL、必要なら ElevenLabs 経由) の API キーと従量課金が前提。
- 自分の環境との接点がある。
  - 手元の Godot 関連プラグイン、Blender MCP とつなぐと、生成物 (`.glb`) を取り込める可能性がある。
  - ComfyUI を RTX4080 のマシンで動かしているので、`nano-banana` の画像編集や Hunyuan 3D 相当の処理をローカルで置き換える余地もありそう (未検証)。
- 注意点: 最終 push が 2026-05 で約半年止まっている。モデル名 (`marble-1.1` など) や API の仕様は変わっている可能性がある。
- 導入判断: 見送り。3D アセット作りを実際にやる案件が出たら、その専用ディレクトリにクローンして試す。生成物の質や費用は未検証なので、最初は 1 枚で試す。
