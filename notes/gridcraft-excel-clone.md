---
title: GridCraft - AI向け Rust 製 Excel クローン
description: OSS 表計算 GridCraft の要約と、Excel 互換ソフトの作り方・AI の Excel 操作に関するやり取りまとめ
# permalink:  # don't use
aliases:
  - GridCraft
tags:
  - rust
  - excel
  - oss
  - mcp
  - ai-agent
draft: false
date: 2026-10-11
---

# GridCraft

元ネタ: https://x.com/studio_yebisu/status/2109055929933304076 (StudioYebisu)

## 要約

- Rust ベースで SaaS クローン、最近流行。今度 Excel クローン GridCraft 出た
- OSS 表計算ソフト
- 500 以上の関数、ピボットテーブル、グラフ、XLSX 読み書き対応
- 売り = AI 向け最適化。MCP や CLI 経由で AI がセル読み書き、数式入力、表・グラフ作成
- 例: 「CSV 読んで月別集計、グラフ付きファイルに」をエージェント処理に組み込む
- 予算・進捗管理みたいな定期的に数字更新する仕事と相性良さそう
- alpha 段階。実 Excel ファイル互換性、大きいデータ扱いは改善中
- 筆者「コミュニティ改善速い。日本語対応も 1 日で入ること有る。GitHub 追うと良い」
- 冒頭「マイクロソフト終わり」は釣り。alpha だから誇張
- リポジトリ中身は未確認 (ポスト本文のみ読んだ)

## どうやって作る？ リバースエンジニアリング？

主流ではない。

- xlsx = OOXML (ECMA-376 / ISO 29500)。仕様書公開済み
- 旧 .xls も Microsoft が `[MS-XLS]` 公開 (2008〜)。昔 (〜2000 年代) は実ファイル解析のリバースが中心だった
- 関数の意味は公式ドキュメント。曖昧な所は実 Excel に同じ入力投げて出力比較 (ブラックボックス検証)
- 有名な癖: 1900 年うるう年バグ。Excel は 1900 年を閏年扱い。互換のため再現必要
- 一番しんどい所: 仕様書と実 Excel の挙動がずれる。本物の xlsx 大量に読み書きしてテストするしかない
- GridCraft が「実 Excel 互換性改善中」なのはこれが原因だと思う
- 既存 OSS 流用の線: `calamine` (読み)、`rust_xlsxwriter` (書き)、`IronCalc` (Rust の計算エンジン)
- 今は LLM の寄与大きい。仕様書と既存実装 (LibreOffice 等) 読ませ、テスト大量生成して移植

## MS 互換の無料スイート

- LibreOffice: OpenOffice の fork (2010)。今の本命
- Apache OpenOffice: 元祖。開発ほぼ停滞
- WPS Office: Kingsoft 製。「King Office」はたぶんこれ。無料版は広告あり
- OnlyOffice: OSS。ブラウザ版エディタ。MS 形式との互換性高い
- Collabora Online: LibreOffice のクラウド版
- Gnumeric: 表計算のみ。軽量
- FreeOffice (SoftMaker): 無料版あり

## AI の Excel 操作は今でも Python でできる

そのとおり。「pyxcel」= `openpyxl`。

できること:

- `openpyxl`: xlsx 読み書き、数式文字列書き込み、書式、グラフ
- `pandas`: 集計、`pivot_table`、`to_excel`
- `xlsxwriter`: 書き出し特化。グラフ強い
- 一括変換・レポート生成は AI が Python 書いて実行すれば終わり

限界 (GridCraft 型が狙う所):

- 数式を計算しない。`openpyxl` は数式を文字列で書くだけ。値は Excel / LibreOffice で開いて初めて計算。AI は結果確認できない。LibreOffice headless で再計算する回避策あるが重い
- 小さい操作 (A1 読む、数式入れる) でも毎回 Python 書いて実行
- セル単位の対話的操作は MCP / CLI の方が向く
- Python と各種ライブラリの環境依存。単一バイナリ CLI なら導入楽

## 結論

- 一括変換・レポート生成なら Python で十分
- GridCraft の立ち位置 = 「AI が使う表計算エンジン」。計算エンジン内蔵で、AI が書いた数式の結果をその場で確認できる点が売り (推測、中身未確認)
- 互換性だけ見るなら LibreOffice が一番成熟
