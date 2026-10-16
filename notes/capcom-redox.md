---
title: Capcom RE:Dox OSS 公開
description: Capcom が RE Engine の一部 RE:Dox (.NET 向け構造化データエンジン) を Apache 2.0 で公開
# permalink:  # don't use
aliases:
  - RE:Dox
  - REDox
tags:
  - gamedev
  - dotnet
  - capcom
  - oss
draft: false
date: 2026-10-12
---

# Capcom RE:Dox OSS 公開

- 元記事: https://gamefromscratch.com/capcom-open-source-re-engine-data-engine-redox/
- 公開日: 2026-10-08
- ライセンス: Apache 2.0
- リポジトリ: github.com/CAPCOM-TD-OSS/REDox

## 結論

- タイトル「RE Engine OSS」は盛り。エンジン本体ちがう
- 公開したのは周辺部品 RE:Dox のみ。レンダラー、物理 なし
- 秘伝のタレ ちがう。地味だけど実用の部品

## RE:Dox 何

- .NET 向け トークンベース 構造化データエンジン
- Capcom 次世代技術「REX」の中核の一つ
- 一言で言うと System.Text.Json / Newtonsoft.Json の高速代替。ただし JSON 専用ちがう
- 仕組み: データ → 固定サイズ トークン DOM/IR に解析 → インデックスで 読取・編集・変換・シリアライズ・並列デシリアライズ

## 特徴

- 性能 (vs System.Text.Json)
  - 逐次デシリアライズ 最大約 1.8 倍
  - 自動並列デシリアライズ 最大約 2.8 倍
  - シリアライズ 最大約 1.6 倍
- メモリ: `canada.json` デシリアライズで 2.56MB vs 8.53MB (約 1/3)
- フォーマット
  - 統合済み: JSON, JSON5, CBOR, MessagePack, INI, DOX
  - プレビュー: TOML, XML, HTML, CSV
- `DataConverter<T>` はフォーマット非依存 (`DataReader` / `DataWriter` 抽象化)
- マネージドオブジェクトツリー無しで トークン DOM 編集
- JSON5 コメント等 (trivia) を再エンコード後も保持
- 互換レイヤー: System.Text.Json, Newtonsoft.Json, DataContractJsonSerializer
- Newtonsoft 並み柔軟: `$type`, `$id`/`$ref`, 順序非依存コンストラクター束縛

## 高速だと何が嬉しい

通信より ロード時間 とツールが主用途。

- ロード時間: 起動、ステージ切替で 設定・マスターデータ (武器、敵ステータス) 大量読込。並列デシリアライズが効く
- エディタ・ビルドツール: 数万ファイルのメタデータ処理。CI、ビルド時間短縮
- セーブデータ: 大きいワールド状態の保存・復元
- GC 削減: 割当 約 1/3。ゲームはフレーム落ち回避が大事。速度より 割当の少なさ が本命
- オンライン通信は主用途ちがう。通信は普通バイナリ (MessagePack、独自プロトコル)。ただし MessagePack / CBOR も同 API で扱えるのは売り

## メモ

- C# 使わない Web 開発者には縁が薄い
- ゲーム以外でも、巨大 JSON を扱う .NET サーバー・データ処理に使える
