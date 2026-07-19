---
title: "ComfyUI Tutorial Ep06 - 300種類のアートスタイルを使う"
description: "A1111/Forge のスタイルCSVをComfyUIに取り込む方法。Conditioning Concat の使い方とスタイルCSVの仕組み"
aliases:
  - comfyui-ep06
tags:
  - comfyui
  - pixaroma
  - stable-diffusion
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Ep06 - 300種類のアートスタイルを使う

元動画: https://www.youtube.com/watch?v=cmikc-Jo1gk  
チャンネル: pixaroma

## 概要

Automatic1111 / Forge UI 向けに作られた **300種類以上のアートスタイルCSVファイル** を ComfyUI で活用する方法。

---

## アートスタイルCSVとは

- A1111 が定義した**固有フォーマット**（業界標準ではない）
- Forge UI は A1111 フォークなので同じ形式を継承
- ComfyUI は標準非対応 → カスタムノードで読み込む

### CSVの構造

```csv
name,prompt,negative_prompt
"Painting Abstract","abstract expressionism, brushstrokes","photorealistic, sharp"
```

3カラム固定。スタイル名・ポジティブプロンプト・ネガティブプロンプトのレシピ集。

---

## CLIP Text Encode と Conditioning Concat

### Conditioning とは

拡散モデル（Diffusion Model）がノイズ除去の各ステップで参照する **「どの方向に除去すべきか」を示す条件付け情報**。

```
ノイズ画像
    ↓  （"cute bunny" の方向に除去せよ）← Conditioning
少しクリアな画像
    ↓  ...
完成画像
```

| 種類 | 役割 |
|------|------|
| Positive Conditioning | この方向に近づけてノイズ除去 |
| Negative Conditioning | この方向から遠ざけてノイズ除去 |

KSampler は両者の差分を使って「Positiveに近くNegativeから遠い画像」を生成する（CFGスケールが強度を調整）。

### CLIP Text Encode

テキストプロンプトを **CLIP モデルで数値ベクトルに変換**するノード。この出力が Conditioning になる。

```
"a cute bunny"  →  [0.23, -0.81, 0.44, ...]  ← Conditioning（条件付け情報）
```

### Conditioning Concat

複数の Conditioning を**エンコード後に連結**して1つにまとめるノード。

```
Conditioning A（メインプロンプト）
Conditioning B（スタイルCSVのプロンプト）
        ↓ Concat
KSampler へ渡す
```

**テキスト文字列を結合しない理由：**  
CLIPのトークン上限（75〜150トークン）があり、先に結合すると後半が切り捨てられる。  
Conditioningレベルで結合することで上限を回避できる。

---

## ワークフロー手順

1. **CSVファイルを準備** — Google Drive からダウンロードして ComfyUI フォルダに配置
2. **カスタムノードをインストール** — ComfyUI Manager で「Styles CSV Loader」を検索してインストール
3. **テキストノードをInput化** — スタイルノードのプロンプトを受け取るテキストノードを右クリック → `Convert Widget to Input` → `Convert Text to Input`
4. **Conditioning Concat で結合** — メインプロンプトとスタイルプロンプトをそれぞれConcatしてKSamplerへ
5. **Group Node にまとめる** — 全ノードを選択して `Convert to Group Node` でシンプルなUIに

### 2スタイル同時使用

- ロードスタイルノードを2つ用意
- Conditioning Concat をもう1段追加して結合
- 同系統カテゴリ同士が相性よし（Photo×Fashion、Vector×Illustration など）

---

## スタイルカテゴリ

painting / illustration / vector / photography / fashion / art / 3D / crafts / design / experimental

---

## 注意点

- 強いスタイルは主題プロンプトを上書きしてしまうことがある → プロンプト側に要素を追加して調整
- CSV手動編集はバックアップ必須。編集には A1111 / Forge のスタイルエディタを使うのが安全


# 注釈

- `CLIP Text encoder (prpmpt)` ノードを右クリックして `Convert Widget to Input > Convert text to input` とすることで、プロンプトを Text ピンで別のノードから文字列型で受け取れる
- 複数のノードをまとめて選んで `Convert to Group Node` -> 入力、出力ピン、及び各ノードの設定値がまとまった一つのノードになり、整理しやすく。プロパティは並べ替えできる
- ノードを右クリック > Color を変えると整理しやすい (Positive = green, Negative = Red, CSV = Yellow)
- Style を複数適用したい場合は、 Load Styles CSV{N} ノードを複数置く、その数だけ `CLIP Text Encoder` と `Conditioning (Concat)` を追加して連結
    - なぜ文字列を連結しないで CLIP が変換した後の Conditioning を連結するか？ => CLIPにはトークン数制限があり長いプロンプトは切られる、変換後の意味の埋め込みベクトルを連結するほうが効果的


# スタイルの例

組み合わせ
- Painting | Chinese Ink Brush
- Painting | Graphity (アメリカの壁とかに書いてるやつ)

- Photography | Long exposure (露光)
- Photography | Flower (花が生える)
- Photography | Portrait > Fantasy


- Vector | Silhouette Cute (ベクターグラフィック)
- Vector | Logo Symbol (Github とかのアイコンキャラ的な)
- Illustration | Anime > Chibi (ちびキャラ)

- Illustration | Illuminated Manuscript (https://ja.wikipedia.org/wiki/装飾写本, 宗教的なテクスト写本)
- Illustration | Cartoon Character on White BG

- Design | Avatar
- Illustration | Cartoon Character on White BG

- Craft | Ceramic > Porcelain (ホーロー)
- Craft | Mosaic > Roman (モザイク)
