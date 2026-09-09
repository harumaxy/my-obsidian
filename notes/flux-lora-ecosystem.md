---
title: flux-lora-ecosystem
description: FLUX系モデル(1/2)のライセンス・ラインナップ・LoRA学習ツールまとめ
# permalink:  # don't use
aliases:
  -
tags:
  - ai画像生成
  - flux
  - lora
draft: false
date: 2026-09-02
---

## ライセンス周り

FLUX系モデル、モデルによってライセンス違う。

- **FLUX.2 [dev]** - 非商用ライセンス。商用は別途契約必要
- **FLUX.2 [pro]/[flex]** - API経由(BFL, Replicate等)。従量課金で商用利用可
- **FLUX.2 [klein]** - Apache 2.0見込み、商用利用可（オープンウェイト）

非商用ライセンスの中身、勘違いしがちな点:

- **出力画像(Outputs)自体は商用利用OK**。BFLは出力の著作権主張しない。「出力を使ってFLUXと競合するモデル学習」だけ禁止
- 制限受けるのは**モデルの使い方**。以下該当すると非商用逸脱:
  - 収益活動でモデル動かす
  - エンドユーザーに直接影響与える形で使う（本番組込）
  - 商用目的で他モデル学習に使う
- 「ローカルで動かすだけ、本番アプリに組み込まない」は言い訳にならない。**モデル使用が収益活動に紐づくか**で判定される。商用ゲームのアセット生成に dev 使うのは、収益活動に紐づく扱いされる可能性高い→非推奨
- 生成画像に「dev使った証拠」は基本残らない。推論コードに透かし埋め込みオプションあるが、有効化しなければ何も残らない。pro(API)はC2PA署名メタデータ自動付与

安全に商用利用したいなら: pro/flex を API経由 で使うか、klein(Apache2.0)使う。dev をどうしても使うなら BFL に商用ライセンス問合せ(bfl.ai)。

## モデルラインナップ

Civitaiとかで出てくる略称:

| 略称 | 正体 |
|---|---|
| Flux.1 D | dev版。標準品質、非商用ライセンス |
| Flux.1 S | schnell版。蒸留・高速、Apache2.0で商用利用可、品質はDより落ちる |
| Flux.1 Kontext | 画像編集特化（元画像+指示で部分編集・スタイル変換） |
| Flux.1 Krea | BFL×Krea AI共同、devベース。「AIっぽさ・プラスチック肌」排除方向にチューニングされたフォトリアル特化版 |
| Flux.2 D | flux2のdev版 |
| Flux.2 klein | flux2世代で新規追加。軽量高速枠、schnellの後継的ポジション |

flux1にklein系統は存在しない。軽量枠はschnellが担当してた。

## flux2 klein vs flux2 dev

- dev: 32Bパラメータ、50step推論。品質最優先
- klein: 4B/9Bの2種。sub-second生成(4step)。9Bの方がディテール・一貫性で4Bより明確に上
- klein、フォトリアル系(肌質感・毛皮等の複雑テクスチャ)でAIアーティファクト出やすい。複雑な指示追従もdevに劣る
- スタイライズ系(アニメ調・ドット絵・シンプルイラスト)ならklein で十分戦える

## flux2 vs flux1 品質差

flux2の方が明確に上:

- テキストレンダリング: flux1は長文で文字崩壊しがち、flux2は正確
- フォトリアル: flux2は肌質感・生地等マテリアル表現が別次元。flux1特有の「合成っぽさ」解消
- 色精度: HEXコード指定で正確な色再現(flux1にはない機能)

引き換えにVRAM要求増(flux1 dev ~34GB vs flux2 dev ~74GB @FP16)、生成も遅い。

## LoRA/ControlNetエコシステムの枯れ具合

- **flux1**: 12Bパラメータ、エコシステム最深。Civitaiに大量の学習済みLoRA蓄積済み、ComfyUI周辺ツールも成熟
- **flux2**: 2026年リリースでまだ若い。ComfyUIネイティブ対応済みだが、LoRA/ControlNet資産はこれから発展途上

判断基準: 生アセット品質最優先→flux2。既存LoRA資産(Civitaiの膨大なコミュニティLoRA)に頼るなら flux1 の方が現状実用的。

## LoRA学習ツール

ComfyUI自体には学習機能なし。学習は専用ノード/外部ツール併用が実態。

- **ComfyUI-FluxTrainer** - Kohya sd-scriptsをComfyUIノード化したラッパー。ComfyUI Managerからインストール可。ワークフロー内で完結できる
- **Kohya SS (sd-scripts)** - 単体GUI/CLIツール。flux1 LoRA学習の事実上デファクト、情報量最多。ComfyUIとは別プロセスで学習→出力LoRAをComfyUIのLoraLoaderで読む
- **FluxGym** - Kohyaをラップした簡易GUI。初心者向け設定楽
- **ai-toolkit (Ostris製)** - MIT licenseの学習ツール。現状一番人気どころ。Flux/Qwen-Image/Z-Image/Wan/LTX/HiDream等幅広く対応。独自Web GUI付き、インストーラー一発でPython/PyTorch/Node.js諸々自動セットアップ。ComfyUIとは別系統(学習専用、生成は別途ComfyUI側でLoRA読込)

VRAM目安:

- flux1系LoRA学習: 12〜24GBで足りる
- flux2 klein学習: 32GB以上、48GB推奨
- flux2 dev学習: 80GB以上必要

### 学習の流れ(共通)

1. 学習用画像収集: キャラLoRAなら10〜50枚、1024x1024推奨、質>量
2. キャプション付け(各画像に対応する.txt、トリガーワード仕込む)
3. 上記ツールいずれかで学習実行
4. 20〜50枚で3〜5時間(GPU次第)
5. 出力された.safetensorsをComfyUIの`models/loras`に置いて`LoraLoader`ノードで読込

flux1系LoRA自作したいなら FluxGym が一番手軽、ComfyUIワークフロー内で完結させたいなら FluxTrainer。ai-toolkitはCLI/独自GUI操作に抵抗なければ最有力候補。
