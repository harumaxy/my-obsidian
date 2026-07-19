---
title: "ComfyUI Tutorial Ep09 - SDXL ControlNet Union の使い方"
description: ControlNet Union ProMax のインストール・ワークフロー構築・複数スタックの方法
aliases:
  -
tags:
  - comfyui
  - controlnet
  - sdxl
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Ep09 - SDXL ControlNet Union の使い方

- 動画: https://www.youtube.com/watch?v=C0zykaDF1ts
- チャンネル: pixaroma

## ControlNet Union とは

従来は Pose/Canny/Depth などの用途ごとに別々のモデルが必要だったが、**1つのモデルで12種類のコントロールを統合**したもの。

- モデル名: `controlnet-union-promax`
- Hugging Face からダウンロード
- 配置先: `models/controlnet/`
- **SDXL 専用**（SD1.5・Flux には使えない）

## 必要なカスタムノード

| ノード名 | 用途 |
|---------|------|
| `comfyui-art-venture` | ControlNet プリプロセッサー |
| `controlnet-aux` | 追加プリプロセッサー |
| `comfyroll-studio` | 複数 ControlNet のスタック |

Manager で検索してインストールする。

## プリプロセッサーの種類と使い分け

| プリプロセッサー | 用途 | 向いているシーン |
|----------------|------|----------------|
| Canny | エッジ・輪郭検出 | ライン画、建築物、詳細な構造 |
| Depth | 奥行き情報 | リアルなシーン、遠近感が重要な画像 |
| OpenPose | 人物ポーズ検出 | アクションショット、キャラクターデザイン |
| MLSD | 直線検出 | 建築、幾何学的構造、都市景観 |
| Scribble | 手書きスケッチ | ラフなコンセプトをAIで仕上げる |
| Normal Map | 表面の法線情報 | テクスチャ、3D的リアリティ |
| Segmentation | 領域分離 | 複雑な環境、レイヤード構成 |

## 基本ワークフロー

```
Positive Prompt ──→ Apply ControlNet ──→ K Sampler
                         ↑
              Load ControlNet Model（Union ProMax）
                         ↑
              ControlNet Preprocessor（art-venture）
                         ↑
                     Load Image
```

`Apply ControlNet` ノードの conditioning を Positive に直結せず、必ず Detour させる。

## Strength の調整

- `1.0`：入力画像に忠実（構図・形状が強く反映される）
- `0.2〜0.3`：プロンプトの自由度が上がる（例：猫の輪郭から全く違うキャラを生成）

## 複数 ControlNet のスタック

### 使用ノード

- `CR Multicontrol Net Stack`
- `CR Apply Multicontrol Net`

### 接続方法

```
Load Image → Preprocessor (Canny)  → image1 ─┐
Load Image → Preprocessor (Depth) → image2  → CR Stack → CR Apply Multicontrol Net → K Sampler
                                    image3  ─┘（OFF のままでも可）
```

- スタックノードのスイッチで各 ControlNet を ON/OFF 切り替え可能
- 3つ以上使う場合はスタックノードを直列に繋ぐ

## アスペクト比の合わせ方

入力画像のアスペクト比と生成サイズが一致しないとクロップされる。
Photoshop で「イメージサイズ」を確認して width/height の値を ComfyUI に入力するのが確実。

## ヒント

- 画像のコントラストが高いほどプリプロセッサーが細部を拾いやすい
- 同じ画像に Canny + Depth を重ねると入力により忠実な生成になる
- ControlNet は SDXL モデルと組み合わせて使う（ep03 のベーシックワークフローベース）


# メモ

- ControlNet は以前は別々のモデルが分かれてたが今は一つに統合されている。 `controlnet-union-promax`


追加の Custom Node
- comfyui-art-venture
  - 画像連結、URLから画像をロード、など
- ComfyUI's ControlNet Auxiliary(オーグジリアリ) Preprocessors
  - ControlNet のヒント画像を作成するためのPnPノードのセット
- Comfyroll Studio
  - ControleNet, LoRA, AspectRatio のセット


## `ControlNet Preprocessor` ノード (`comfyui-art-venture`)

imageを入力して、image を出力する
ControlNet モデルで処理して色々出す
- depth
- canny (輪郭)
- normalmap_bae(法線マップ、面の向き)
- openpose (人体のポーズ抽出 )
- scribble (下書き,塗り絵前の状態)
- seg_ufade20k(セグメントに色塗り。空、地面、建物、人などを異なるカラーで領域を指定。切り抜きとかに使える)
- etc...

パラメータ
preprocessor(種類), sd_version, resolutoion, preprocessor_override

## `Apply ControlNet` ノード (built-in)

CLIP Textencoder の埋め込みベクトルに、コントロールネットを Conditioning に適用して加える
単なる画像変換ではなく、画像生成・デノイズに ControlNet のガイドを影響させることができる


3つの入力ピン
- Conditioning = CLIP埋め込みベクトル (CLIP Text Encorde)
- Image = `ControlNet Preprocessor` で生成されたガイド
- ControlNet = ControlNet のモデル (`Load ControlNet Model` ノードをつなぐ)


## 画像生成での Control Net の違い

例1.剣を持って立ってる人の画像をControlNetのガイド画像として入力する

Preprocessor
- Canny: 輪郭を捉える。剣を持ってる人型のなにか、を出力する(ロボっぽいのとか)
- Detph: 深度を捉える。大体Cannyと似たいような感じだが、輪郭がはっきりしないので剣がバットになったりする。ポジティブプロンプト(CLIP)でしっかり指定
- OpenPose: 人体のポーズしか抽出しない。持ってるものが変わったり、持ち手が右手、左手の反対側に変わったりする


手持ちのなにか、長モノを持ってる人体の画像は、OpenPose より Depth の方が正確になるっぽい

例2. 建築物をガイドにして、似たようなスタイルが違う建築物を出力
- MLSD: 直線を抽出する。建造物、ビルに最適。
- normalmap_bae: 法線マップを抽出。日の光、レイトレーシング的な光沢を表現できる　ようになる。

例3. アニメのちびキャラスタイルの少女
-> 出力は、同じスタイルのウサギにしたい

- Scribble: グレースケールっぽい画像。
- Canny: 輪郭だけ。

ここで重要なのは、`Apply ControlNet` ノードの `strength`(ControlNetガイド画像の影響)
1にすると輪郭を強く受けるので少女の画像から変形しない。
ウサギにしたければ 0.2 ぐらいにすると十分 変形する


## 元画像の品質、ControlNetガイドのディテール不足

画像の品質が悪い、コントラストが低い、と `canny` モデルなどが正しい輪郭を抽出できなかったりする
ControlNet モデルの学習に使われているのはおそらく品質が良い理想状態の画像のため。
(例. 夕焼けなどで逆光がある)

解決方法として、 `depth` + `canny`などで複数のControlNetを適用してガイドを補完・強化する方法がある 

## `CR Multi-ContolNet Stack` ノード -> `CR Apply Multi-ControlNet` ノード

CR = ComfyRole Studio 拡張、カスタムノードのprefix
複数の ControlNetを適用するときのユーティリティ


 `ControlNet Preprocessor`の出力画像を複数用意し、 `Stack` ノードの image1/2/3 につなぐ
 プロパティ
 - Switch1/2/3 = 適用するものを ON にする
 - ControlNet1/2/3 = これは `controlnet-union-promax` でいい
 - strength1/2/3 = 調整する

 image だけ入力するが、ControlNet の種類は自動判定されてる？


 `Apply *` を、ビルトインのやつから CR のやつに置き換える

例1. ブロンド女性の画像 = canny + depth でより詳細
例2. 建物 = canny + depth 最大強度(=1.0)
  - `an apocalyptic building, end of the world.`
  - depth 表現とディテールを兼ね備えた、ダメージが詳細に表現された建物の画像が出力


## `Preview Image` ノード

ControlNet Preprocessor の出力を確認するのに便利
`image` 型を出力するノードにはとりあえず付けといて損はない

## 4 つ以上の ControleNet をスタックする

CR Multi-ControlNet Stack の入力は imageを3つまでしか取れないが、
`controlnet_stack` を入出力に備えるので、新しく繋げれば4つ以上組み合わせられる

## Stack 内の特定の ControlNet が強く影響している場合

strength を調整
