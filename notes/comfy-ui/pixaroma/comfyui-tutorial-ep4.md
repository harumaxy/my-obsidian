---
title: "ComfyUI Tutorial Series: Ep04 - IMG2IMG and LoRA Basics"
description: ComfyUI の Image-to-Image ワークフローと LoRA モデルの基礎
# permalink:  # don't use
aliases:
  - comfyui-ep4
tags:
  - comfyui
  - stable-diffusion
  - tutorial
  - lora
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Series: Ep04 - IMG2IMG and LoRA Basics

- 動画: https://www.youtube.com/watch?v=xedwjtaPVzw
- チャンネル: pixaroma
- 公開日: 2024-07-24

---

## Image-to-Image ワークフロー

- Empty Latent Image の代わりに「**Load Image**」ノードを使い、自分の画像を入力として使用
- 画像はピクセル形式なので「**VAE Encode**」ノードで Latent 形式に変換してから K Sampler に接続する

## Denoise（デノイズ強度）

- K Sampler の `denoise` パラメータが Image-to-Image の肝
- **低い値（例: 0.1〜0.4）**：入力画像に近い結果。プロンプトの影響が小さい
- **高い値（例: 0.9〜1.0）**：入力画像とほぼ無関係な新しい画像が生成される
- 実用的には **0.5〜0.65 あたり**から調整するのがおすすめ
- 例：`denoise=0.65` + 「robot bunny」プロンプト → バニーの構図を保ちつつロボット化

## Upscale Image ノード（リサイズ）

名前は「Upscale」だが実態は**拡大・縮小両方できるリサイズノード**。

**なぜ大きい画像でメモリ不足になるか：**
VAE Encode はピクセル数に比例して VRAM を消費する。
4096×4096 の画像は 1024×1024 の **16倍のピクセル数**になり、VAE Encode が一度に処理しようとしてVRAMを使い果たす。

**解消方法：**
Load Image と VAE Encode の間に Upscale Image ノードを挟んで、事前に 1024px 前後に縮小する。

```
Load Image（大きい）→ Upscale Image（→ 1024px）→ VAE Encode → K Sampler
```

- サイズは SDXL なら 1024px 前後が推奨
- **64の倍数**にするとGPU処理効率が上がる（GPUはテンソル演算を64や128単位のブロックで処理するため、端数があると無駄が生じる）
- クロップ（`crop`）を有効にすると、異なるアスペクト比の出力も作れる

## クリップボードからの画像ペースト

- 生成した画像を右クリック → コピー → Load Image ノード上で `Ctrl+V` でペーストできる
- Load Image ノードがない状態でも `Ctrl+V` で自動的にノードが作成される

## LoRA とは

**LoRA（Low Rank Adaptation）**：大きなモデルの一部だけを効率的にファインチューンする手法。

- 用途例：特定のオブジェクト・人物・アートスタイルの生成精度を上げる
- 通常のチェックポイントより小さく、学習コストも低い
- civitai でダウンロード → `ComfyUI/models/loras/` フォルダに配置

## LoRA の使い方

**ノード構成：**
```
Load Checkpoint → Load LoRA → Positive/Negative Prompt -> K Sampler                   
```

- **Lora は model/clip を受け取りそのまま出力。ただし、positive, negative の2チャンネルが無いので CLIP Textencode (pos/neg) の前におく**

- Load LoRA はモデル・CLIPの両方をCheckpointから受け取り、両方をその先に渡す
- LoRA をモデルとプロンプトの間に置くことで、LoRAの調整が反映された状態でプロンプトが解釈される

**パラメータ：**
- **Strength Model**：LoRA の影響度。0.3〜1.0 推奨。高すぎると画像が崩れる
- **トリガーワード**：LoRAごとに指定された単語をプロンプトに必ず含める（civitai のモデルページで確認）

## LoRA + IMG2IMG の組み合わせ

LoRA ワークフローに Load Image → Upscale Image → VAE Encode を組み合わせれば、自分の画像をLoRAのスタイルで変換可能。

例：バニーの写真 + Fire LoRA (`denoise=0.5`) → 炎に包まれたバニーの画像

---

## まとめフロー（Ep04 最終形）

```
Load Checkpoint (Juggernaut X)
  → Load LoRA (e.g. EtherFire)
    → Positive/Negative Prompt（トリガーワード必須）
Load Image → Upscale Image（1024px・64の倍数）→ VAE Encode
  → K Sampler (denoise: 0.5前後)
    → VAE Decode → Save Image
```

---

## LoRA 深掘りメモ

### 仕組み：低ランク近似

元モデルのパラメータは変えず、差分だけを小さな行列 A・B として学習する。

```
通常のFT：W (d×d) を直接更新       ← 1,048,576 パラメータ（d=1024）
LoRA    ：A (d×r) と B (r×d) を学習 ← 8,192 パラメータ（r=4）

推論時：y = W·x + α × (B·A·x)
```

`α`（= strength_model）で差分の影響度を調整する。

**小さいパラメータ数で有効な理由：**
- 「スタイルや人物を表現するために必要な変化」は低ランクな部分空間で表現できるという経験則
- ベースモデルはすでに概念を知っているので、ゼロから学ぶのではなく「微調整」するだけで済む

### 更新対象：U-Net の Attention 層

LoRA が主に更新するのは U-Net 内 Transformer ブロックの Attention 層（Q・K・V の投影行列）。

| Attention の種類 | 役割 |
|---|---|
| **Self-Attention** | 画像内の各位置が互いに注目。空間構造・プロポーションに影響 |
| **Cross-Attention** | 画像特徴がテキスト埋め込みに注目。プロンプトが画像に反映される経路 |

LoRA の作用は「注目先が変わる」というより**「テキスト条件を画像特徴に変換するルールを変える」**イメージ。

### CLIP との関係

キャプションは CLIP Text Encoder でベクトル化され、U-Net の Cross-Attention の条件として使われる。
CLIP 自体は学習中も固定で、LoRA は U-Net 側だけを更新する。

```
キャプション → [CLIP Text Encoder（固定）] → テキスト埋め込み
                                                    ↓
                                         [U-Net + LoRA（学習）]
```

キャプションが雑 → CLIP が正確なベクトルを出せない → U-Net が誤った条件で学習される → トリガーワードが効かなくなる。

### 学習データの作り方

**画像ソース（アニメキャラの場合）：**
- 公式設定画・ターンテーブルが最高品質
- BD/DVDキャプチャ、公式ゲームスチルも良い
- モーションブラー・他キャラとの重なりは避ける

**有効な画像の構成（優先度順）：**
- バストアップ〜全身の正面・斜め45度：60%
- 顔アップ：20%
- 全身・引き：20%
- 表情差分・3面図があると精度が上がる

**オリキャラの場合：**
- 少数の高品質な手描き（5〜20枚）を用意
- SD で近いキャラを大量生成 → 良いものだけ選別して混ぜる
- 初期LoRA → 生成 → 選別 → 再学習のブートストラップが現実的

**キャプション：**
各画像に対応する `.txt` ファイルで特徴を詳細に記述する。
`1girl, silver hair, red eyes, white dress, smile, upper body` のように。

### LoRA の入手方法

| 方法 | メリット | デメリット |
|---|---|---|
| civitai からDL | すぐ使える・無料・種類豊富 | 求めるものがないことも。ライセンス注意 |
| 自作 | 自分のスタイル・キャラに完全対応 | データ収集・学習パラメータ調整が手間 |

商用利用するなら自作が確実。学習ツールは **kohya_ss** が定番。

### トリガーワードの役割

「この LoRA を発動させるスイッチ」として機能する。

学習時にキャプションへ特定の単語を必ず含めることで、U-Net が「この単語が来たときにこのスタイルで生成する」というマッピングを学習する。

```
学習時：「ethereal clouds, blue sky, ...」→ 雲がオブジェクトに見えるスタイル
推論時：プロンプトに「ethereal clouds」を含める → そのスタイルが発動
```

**トリガーワードがない（汎用単語だけで学習した）場合：**
- `1girl` や `cloud` など日常的な単語に効果が紐づいてしまう
- LoRA を有効にしただけで常にスタイルが出る（意図しない場面でも発動）
- 他の LoRA と組み合わせたとき干渉しやすくなる

珍しい単語・造語を使うほど誤発動しにくい（既存の概念と混ざらないため）。

### 複数 LoRA の同時使用

ComfyUI では Load LoRA ノードをチェーン状に繋ぐだけで複数適用できる。

```
Load Checkpoint
  → Load LoRA (スタイル系, strength=0.6)
    → Load LoRA (キャラ系, strength=0.7)
      → K Sampler
```

**注意点：**
- strength の合計が大きすぎると画像が崩れる（各0.6〜0.7程度に抑える）
- ベースモデルの互換性を揃える（SDXL用同士など）
- 同じ領域を学習した LoRA 同士は干渉しやすい。「スタイル系 + キャラ系」の組み合わせは相性が良い

---

次回（Ep05）: 未視聴
