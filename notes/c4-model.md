---
title: c4-model
description: C4モデル。ソフトウェア構成を4階層で描く図法。AIに「C4モデルでHTML出力して」と頼むだけで全体像つかめる
aliases:
  - C4モデル
tags:
  - architecture
  - diagram
  - ai
draft: false
date: 2026-10-10
---

## きっかけ

X ポスト (@voidwarriorchan)。
「技術をしっかり理解したい人はこれ使ってみて。Skill も MCP もいらない」
プロンプト: 「ソフトウェアアーキテクチャをC4モデルでHTMLに出力して」
→ AI に頼むだけ。追加ツール不要。

## C4モデルとは

- ソフトウェア構成を、抽象度の違う4階層の図で描く手法
- 提唱者: Simon Brown (英国)。2006〜2011年頃に考案
- 動機: UML 重い。アジャイルに合わない。もっと軽い図法ほしい
- 地図のズームイン。1枚に全部詰めると読めない。全体像失う。だから倍率違う図を重ねる
- 公式: c4model.com (CC ライセンス)
- ツール: Structurizr、Mermaid / PlantUML の C4 拡張

## 4階層

- **Context**: 対象システム1個の箱。周りに使う人と連携する外部システム。内部構造書かない。技術名も書かない。非エンジニアに通じる
- **Container**: 動く単位、データ持つ単位。Web アプリ、SPA、モバイル、DB、バッチ、キュー。プロセス間通信 (HTTP, SQL) で繋がる
- **Component**: コンテナの中の部品。モジュール、サービス、クラス群
- **Code**: クラス・関数レベル。普通は省略

## 注意点

- Container は Docker コンテナと無関係。C4 独自用語
- Container は実行単位。ディレクトリ、ライブラリ置き場は Container じゃない (Component 側)
- Context 図はステークホルダー図と別物。目的違う。Context は「誰が何使う / 何と連携」。ステークホルダー図は「利害関係者の関心・影響力」
- Context 図は DFD 最上位 / システムコンテキスト図に近い

## 緩く使う

- 厳密定義に縛られなくていい。「抽象度を段階的に分けてズームする考え方」と受け取る
- 記法 (形、色) 自由。凡例つければ OK
- Level 1〜2 だけで十分役立つ
- 守る点: 階層を1枚に混ぜない、Container は実行単位、各要素に役割一言

## 試した結果 (このリポジトリ)

- AI にそのまま頼むと、Container 定義が緩くなる。`notes/` や `Makefile` を Container 扱いした
- 本来の Container は quartz サーブのプロセスと、fetch.py の cron ジョブくらい
- 構造単純なリポジトリだと Level 3 以降の旨味薄い
- コード量多いプロジェクトで試すと差が出そう
- AI 出力は鵜呑みにしない。Container がプロセス単位か確認

## 日本での知名度

- 海外ほど浸透してない印象。ただし統計なし。確度低い
- Qiita タグ「C4モデル」: 投稿5件 (2026-10-10 時点)
- Zenn トピック `c4` / `c4モデル`: 記事0件 (スラッグ違いの可能性あり)
- trend-archive (10/1〜10/10): C4 関連トレンドなし
- 日本語解説: InfoQ Japan「ソフトウェアアーキテクチャのための C4 モデル」
- 理由候補: 邦訳なし、日本は独自構成図・設計書文化、定型図法の定着動機が弱い

## 使い道

- 未知のリポジトリ・技術の全体像把握
- 仕事のオンボーディング、設計共有
- 大規模チームなら定義を厳密に揃える価値あり

## 参考

- [c4model.com](https://c4model.com/)
- [c4model.com FAQ](https://c4model.com/faq)
- [InfoQ Japan: C4 architecture model](https://www.infoq.com/jp/articles/C4-architecture-model/)
- [Wikipedia: C4 model](https://en.wikipedia.org/wiki/C4_model)
- [X ポスト](https://x.com/voidwarriorchan/status/2108731917151731944)
