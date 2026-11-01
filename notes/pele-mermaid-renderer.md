---
title: Pele - Mermaid 互換 SVG レンダラー
description: kepano 製。Mermaid 記法を軽量・高速・安全に SVG 化。CSS 変数でテーマ変更
# permalink:  # don't use
aliases:
  - pele
tags:
  - mermaid
  - svg
  - obsidian
  - library
draft: false
date: 2026-10-28
---

# Pele

元記事: https://gigazine.net/news/20261020-pele/
公式: https://pele.run / https://github.com/obsidianmd/pele

## どういう奴

- Mermaid 記法 → SVG 変換する軽い道具。Mermaid.js の代わり
- 作者 kepano (Obsidian の人)。2026-10-17 公開。MIT。依存ゼロ
- 次の Obsidian で採用予定
- 速い。Mermaid.js の 100〜500 倍 (記事の例: 59ms → 0.3ms)。バンドルは約 1/6 (自己申告、未検証)
- 作った理由は速さより安全。Mermaid 12.1 は CVE 出た。Obsidian 1.13 で危険図の警告入れた

## 安全

- 出力するのは SVG 形状・テキスト・リンク・画像だけ
- スクリプト、イベントハンドラ、HTML ラベル、JS コールバック、click 内コード → 実行しない
- リンクは http / https / mailto / tel だけ。画像は http / https だけ。ネットワークパス遮断

## 使い方

CLI ない。npm の bin なし。ライブラリだけ。スクリプトから呼ぶ。

```js
import { render } from "pele";
import { writeFileSync } from "node:fs";

const { svg, width, height } = render(`flowchart LR
  A[メモ] --> B{Quartz?}
  B -->|yes| C[グラフビュー]
  B -->|no| D[Markdown のみ]`);
writeFileSync("out.svg", svg);
```

- `render(src, options)` 同期。戻り値は **オブジェクト** `{ svg, width, height, links, type, mermaidType }`。文字列じゃない。`.svg` が文字列
- `renderAsync()` もある
- ブラウザ向けは `mount()`。要素描画 + フォント読込 + 幅調整

### options (第2引数)

- 見た目: `fontFamily` `fontFamilyMono` `fontSize` `padding` `responsive` `maxWidth` `autoDirection` `directionBreakpoint` `idPrefix`
- 安全・制限: `links` `images` `linkSchemes` `imageSchemes` `linkRel` `limit` `outputLimit` `maxEdges`
- 拡張: `icons` `math` `measurer` `config`
- 色は options にない。色は CSS 変数

## テーマ = CSS 変数

SVG に色を焼き込まない。`var(--pele-bg, デフォルト)` の形で出る。だから再描画なしで色変更できる。ダークモードも変数上書きだけ。

```css
.pele {
  --pele-bg: #1c1c1c;  --pele-fg: #ededed;
  --pele-surface: #262626;
  --pele-line: #3ecf8e; --pele-border: #3ecf8e; --pele-accent: #3ecf8e;
  --pele-radius: 6px;
}
/* 個別ノードだけ変える。data-id = Mermaid のノード ID */
.pele [data-id="C"] :is(rect,path,polygon) { fill:#3ecf8e; stroke:#3ecf8e }
.pele [data-id="C"] text { fill:#1c1c1c; font-weight:700 }
```

- 変数: `--pele-bg` `--pele-fg` `--pele-muted` `--pele-line` `--pele-surface` `--pele-surface-alt` `--pele-border` `--pele-accent` `--pele-font` `--pele-radius`
- グラフ系: `--pele-series-1` 〜 `--pele-series-8`
- エッジの `data-id` は `L_A_B_0` の形
- 変数が少なく名前固定。DESIGN.md に書いて AI に CSS 書かせるのに向く

### 単体 SVG にスタイルを入れる

Pele は `<style>` を出さない。自分で差し込む。

```js
svg.replace("</svg>", `<style>${css}.pele{background:#1c1c1c}</style></svg>`)
```

- 背景の矩形は Pele が描かない。`.pele{background:...}` を自分で足す
- 試した結果: ブラウザ直接 / `<img>` / macOS qlmanage、全部 OK。rsvg や Inkscape は未検証
- 変数定義が SVG の外 (HTML 側) だと qlmanage は色が効かなかった。SVG 内に入れれば効く

## 本家 Mermaid.js のカスタマイズ

できる。やり方が違うだけ。

- `theme: 'base'` + `themeVariables` (`primaryColor` `lineColor` など)。カスタム可能なのは base テーマだけ
- 個別ノードは図のソース内。`classDef myStyle fill:#f00` + `A:::myStyle`、または `style A fill:#f00`
- `themeCSS` で SVG 内 CSS 追記
- 色は描画時に SVG へ焼き込み → テーマ変更に再描画いる
- 外部 CSS は Mermaid 内部スタイルに負けやすい

## 比較

- **Mermaid.js 12.2**: 機能最大。全図種。非同期。npm 展開 約 122MB
- **Beautiful Mermaid 1.1.3** (lukilabs): 6 種だけ (フロー / ステート / シーケンス / クラス / ER / XYチャート)。依存 `elkjs` `entities`。15 テーマ内蔵。CSS 変数で切替可。ASCII / Unicode 出力できる (ターミナル向け)。最終更新 2026-02
- **Pele 1.12.0**: 全図種 (公式の主張)。依存ゼロ。CSS 変数。安全重視

使い分け:
- 全図種を確実に → Mermaid.js
- 6 種で足りる、ASCII 欲しい → Beautiful Mermaid
- 軽く、CSS で外から管理、安全 → Pele

速度の数字は全部自己申告。ベンチ未検証。Pele の「全図種対応」もフローチャートしか動かしてない。使う図で試すのが確実。

## 結論

自作スクリプトで Mermaid → SVG するなら Pele 良さげ。CLI なくても数行で足りる。
