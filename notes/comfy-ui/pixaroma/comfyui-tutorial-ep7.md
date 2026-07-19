---
title: "ComfyUI Tutorial Series: Ep07 - Working With Text - Art Styles Update"
description: テキスト連結ノードと複数アートスタイルセレクターを使ってスタイルを組み合わせる方法
# permalink:  # don't use
aliases:
  - comfyui-ep07
tags:
  - comfyui
  - pixaroma
  - ai-image
draft: false
date: 2026-07-04
---

# ComfyUI Tutorial Series: Ep07 - Working With Text - Art Styles Update

**動画:** https://www.youtube.com/watch?v=Xsx-u0OMezw  
**チャンネル:** pixaroma  
**公開日:** 2024年8月8日

Ep06のアートスタイル回のアップデート版。テキスト連結ノードと複数スタイルセレクターを使って、複数のアートスタイルをプロンプトに組み合わせる方法を解説。

---

## インストールするカスタムノード

- **WASNode Suite** - テキスト連結ノードなどを提供
- **ComfyUI Easy Use** - Easy Positive/Negative ノードなどを提供

インストール後は再起動が必要。マネージャーの「バッジニックネーム」モードを有効にすると、標準ノード（キツネアイコン）とカスタムノードを視覚的に区別しやすくなる。

## テキスト連結ノード（Text Concatenate）

前回の「Conditioning連結」より**テキスト連結ノード**の方がスタイル適用に適している。

- 区切り文字（デリミタ）を設定可能（例: カンマ）
- 余分なスペースを自動削除するオプションあり
- Save Text File ノードと組み合わせてテキストをファイル出力できる

```
[Primitive (text)] → [Text Concatenate] → [Easy Positive] → [CLIP Text Encoder]
[Primitive (style)] ↗
```

## 検索・置換ノード（Search and Replace）

テキスト内の特定の単語を別の単語に置き換えるシンプルなノード。

## スタイルCSVファイルのパス設定

WNode Suiteの設定ファイル（`config.json`）の `web_ui_styles` にCSVファイルのパスを記載する。

```json
"web_ui_styles": "D:\\ComfyUI\\styles.csv"
```

- バックスラッシュは二重にする必要あり
- 設定後はComfyUIを再起動

## 複数スタイルセレクター（Prompt Multiple Styles Selector）

最大4つのスタイルを同時に選択可能。

```
[Prompt Multiple Styles Selector]
  ├─ positive_string → [Text Concatenate B] → [CLIP Text Encoder (pos)]
  └─ negative_string → [Text Concatenate B] → [CLIP Text Encoder (neg)]

[Positive Prompt] → [Text Concatenate A] ↗
[Negative Prompt] → [Text Concatenate A] ↗
```

**スタイルの順序が重要:** 先頭に近いほどプロンプトへの影響が強い。

## SDXLワークフローへの適用例

「洞窟の中のロボット」に以下の3スタイルを組み合わせた結果：
1. **長時間露光** → 照明効果
2. **花の写真** → 花の要素
3. **ファンタジー漫画** → ファンタジーな変形

3つのスタイルがすべてブレンドされた画像が生成される。

## グループノード化

完成したワークフローをコンパクトにまとめる方法：
1. 右クリック → 「グループをノードに変換」
2. 「グループノードの管理」で名前・配置を設定

## 次回

**Ep08:** Fluxについての解説
