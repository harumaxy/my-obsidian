---
title: kindle-shot-capture-ocr
description: 電子書籍ビューアを自動スクショ+OCRして Markdown 化する kindle_shot。mac セットアップと使い方
# permalink:  # don't use
aliases:
  - kindle_shot
tags:
  - tool
  - ocr
  - kindle
draft: false
date: 2026-10-12
---

# kindle_shot

元ネタ: X (@pareorogas) 「kindle_shot 方が断然マシ。数分でスクショ、OCR、Markdown まで出す」。紹介 note は 404。
引用元 (@ugaya): Kindle 本 PDF 化ソフト。PDF なら AI 読める、要約で読書不要、という話。

## 実体

- `shizimin/kindle_shot` (MIT, Windows + macOS)
- 派生元っぽい: `ahalcyon/kindle_shot` (Windows 専用、機能多い、CI あり)
- 同名リポジトリ多数。ツイート主がどれ指すか不明
- 置き場: `~/ghq/github.com/shizimin/kindle_shot`

## 何するか

```
キャプチャ or 既存PDF → トリミング → PDF / Markdown (OCR)
```

- ビューア画面をキー送りでめくりながら連続スクショ
- 対応: Kindle Cloud Reader, 楽天Kobo, Google Play ブックス, DMM, シーモア, Kindle PC アプリ
- GUI (customtkinter) と CLI 両方
- Markdown は NotebookLM 向け最適化 (段落結合、H1=書名 H2=章 H3=節、50万語超で章境界分割)

## 使ってるライブラリ

- 画面取得: pyobjc (Quartz) + mss。ウィンドウ探しに Quartz
- キー送り: pyautogui
- 画像処理: opencv + numpy (ヘッダー/フッター検出、白紙/重複検証)、Pillow
- PDF 展開: pypdfium2、PDF 生成: reportlab
- OCR: NDLOCR-Lite (国会図書館、ONNX、CPU のみ、縦書き/見開き強い)。subprocess で別プロセス呼び出し
- 整形: text_reflow (句点で段落区切り)、replacements.json (誤認識置換)
- LLM は使わない。ルールベース

## mac セットアップ

- Python 3.11〜3.13 必須。システムは 3.14 で不可
- uv で入れた: `uv python install 3.12` (tkinter 同梱)
- setup.sh 実行時 PATH に 3.12 の bin を足す

```sh
cd ~/ghq/github.com/shizimin/kindle_shot
PATH="$HOME/.local/share/uv/python/cpython-3.12.11-macos-aarch64-none/bin:$PATH" bash setup.sh
```

- 権限: システム設定 → プライバシーとセキュリティ → **画面収録** と **アクセシビリティ**
  - 権限は起動元アプリ単位。Ghostty に付与 (Zed 内蔵ターミナルなら Zed にも)
  - 付与後、アプリ再起動
- Chrome で `https://read.amazon.co.jp/?asin=<ASIN>` 開いて F11 全画面
- 確認: `./kindle_shot.sh check --profile kindle_cloud` が全部 OK

## 使い方

```sh
./kindle_shot.sh run --asin B0XXXXXXXX --title 書名 --out ./books --format markdown --max-pages 20
```

- 最初は `--max-pages 20` で試す
- キャプチャ中は PC 占有。マウスキーボード触らない
- ASIN は商品ページ URL `.../dp/B0XXXXXXXX/`

### ページ送り方向 (ハマった)

- `kindle_cloud` 既定は次ページ = `left` (右開き縦書き前提)
- 巻き戻しは逆キー連打 → 左から右の横書き本だと巻末へ進む
- 対処: **`--page-turn right`**。巻き戻しは `left` になる
- 恒久化: `core/config.json` の `capture.profiles.kindle_cloud.page_turn_key: right`
- ページ数多い本は `--max-rewind` (既定 1000) も増やす

## 注意

- 先頭巻き戻しで Whispersync 読書位置が動く。他端末にも同期。読みかけ本は避ける
- Kindle 規約違反の可能性高い (DRM 本複製)。README も私的利用のみとしてる。BAN リスク
- 配布/公開は完全アウト
- OCR 誤認識は機械処理で直らない。要約用途なら実害小
- 図解/漫画/レイアウト重視の本は情報落ちる
- 1 冊数十分〜数時間。リスクと手間、量産には見合わない

## 代替

- 先に要約/書評/著者インタビュー探す (Zenn, note, YouTube)
- 公式機能 (Audible, Kindle Ask this Book 等)
