---
title: "ComfyUI Tutorial Ep.15 - スタイル・ファイルからプロンプト・バッチ画像"
description: iTools カスタムノードを使ったスタイル管理、プロンプトファイル読込、バッチ画像処理
aliases:
  -
tags:
  - comfyui
  - itools
draft: false
date: 2026-07-12
---

# ComfyUI Tutorial Ep.15 - スタイル・ファイルからプロンプト・バッチ画像

> [!info] 動画
> https://www.youtube.com/watch?v=KMlUakdbdnc (pixaroma, 2024-10-01)

カスタムノード **iTools** を中心に、スタイル管理・テキストオーバーレイ・バッチ処理の3テーマを扱う回。

---

## iTools のインストール

ComfyUI Manager → Custom Node Manager → "itools" で検索 → インストール → 再起動

---

## 1. プロンプトスタイラー

`iTools Prompt Styler` ノードで YAML ファイルに定義されたスタイルテンプレートをプロンプトに自動付与できる。

- スタイルファイルの場所: `ComfyUI/custom_nodes/itools/styles/`
- pixaroma 提供の **300種類以上のスタイル**（写真・映画・絵画・イラスト等）を同フォルダに移動するだけで有効化
- `Prompt Styler Extra` ノードを使うと **4スタイルを同時に組み合わせ**可能（順番が優先度になる）

### YAML ファイルのフォーマット

```yaml
- name: スタイル名（ドロップダウンに表示される）
  positive: "ポジティブプロンプト。{prompt} と書くとユーザーのプロンプトが挿入される"
  negative: "ネガティブプロンプト"
```

- `{prompt}` を書いた位置にユーザーのプロンプトが入る。書かない場合は先頭に追加される
- 編集には **Notepad++** 推奨（インデントミスを色変化で検知しやすい）
- 読み込みエラーが出たらコマンドウィンドウのエラー行番号を確認して修正

---

## 2. テキストオーバーレイ

`iTools Add Text Overlay` ノードで生成画像にテキストを重ねて保存できる。

- `overlay: true` で画像上に重ねる。`false` にすると画像の下にテキスト行を追加
- 色は HEX コードで指定。末尾に `AA` を付けると透明度（アルファ）が有効になる（例: `#FFFFFF80`）
- ポジティブプロンプトをそのまま `text` 入力に接続すると、プロンプトを画像に焼き込んで保存できる

---

## 3. バッチ画像ロード

`iTools Load Images` ノードでフォルダ内の複数画像を一括読み込みできる。

- `image_directory` にフォルダパスを指定、`limit` で読み込み枚数を制限
- アップスケーラー等と組み合わせてバッチ処理が可能
- **画像のファイル名にプロンプトを書いておく**と `image_name` 出力からプロンプトとして接続できる（画像ごとに異なるプロンプトでアップスケールする技法）

---

## 4. ファイルからプロンプト読込

`iTools Prompt Loader` ノードで `.txt` ファイルから1行1プロンプトで順番に読み込める。

- `seed` 値が行番号に対応（0 = 1行目）
- `control_after_generate: increment` + **Auto Queue** を有効にすると全プロンプトを自動で順次生成
- ChatGPT でプロンプトリストを生成して貼り付けると手軽に多様な画像を生成できる（余分な空行は削除すること）
