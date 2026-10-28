---
title: SOAPを終わらせたのはRESTではなかった
description: SOAP が REST に負けた経緯。仕様の積みすぎで自滅。思想は OpenAPI / gRPC / MCP で復活。
# permalink:  # don't use
aliases:
  - SOAP vs REST
tags:
  - youtube
  - api
  - soap
  - rest
draft: false
date: 2026-10-26
---

# SOAPを終わらせたのはRESTではなかった

- 動画: https://www.youtube.com/watch?v=83jl4f9h5IA
- チャンネル: IT技術屋のボヤキ (2026-09-29)

## 結論

- SOAP 倒したの REST 違う。SOAP 陣営が仕様積みすぎて自滅。
- 負けたの「契約」の考え方 違う。負けたの「人間が読めない契約」と「全部 1 封筒に詰める設計」。
- Postman 2020 調査: SOAP 使う開発者 33.4%、REST 93.4%。3 人に 1 人 まだ SOAP 触る。

## SOAP とは

- Simple Object Access Protocol。XML でメッセージ包んで HTTP 越しにリモート関数呼ぶ。XML による RPC。
- XML「エンベロープ(封筒)」に Header + Body。HTTP POST で 1 URL に投げる。
- WSDL = 契約書。メソッド・型を XML で定義。クライアントコード自動生成。
- WS-* 群 = WS-Security, WS-Addressing, WS-AtomicTransaction, WS-ReliableMessaging など。

```xml
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
  <soap:Header></soap:Header>
  <soap:Body>
    <GetUser><Id>123</Id></GetUser>
  </soap:Body>
</soap:Envelope>
```

## 歴史

### 1章: SOAP 誕生 (1998-2000)

- 背景: DCOM / CORBA は バイナリ独自形式。企業ファイアウォール 全部止める。
- 発想: 80 番ポートなら通る → XML 包んで HTTP POST。
- XML-RPC (Dave Winer, 1998) 先に公開。MS の SOAP は社内で 1 年半 塩漬け。
- SOAP 1.0 = 1999/12。SOAP 1.1 = 2000/5 に IBM 味方につけ W3C 提出。
- 「Simple」= 今までの RPC より簡単。HTTP 活かす意味 違う。HTTP ただの土管。
- SOAP は HTTP を愛して生まれたのでなく、HTTP を利用するために生まれた。

### 2章: REST 論文 (2000)

- Roy Fielding 博士論文 第 5 章。HTTP/1.1 (RFC 2616) 主要著者、Apache 共同創設者。
- 新発明 違う。すでに動く Web が なぜ成功したか の記述。
- リソースに URL。GET 取得 / POST 作成 / PUT 更新 / DELETE 削除。状態はサーバーに持たせない。
- 2001-02 XML 開発者 ML で論争。SOAP 側 IBM / MS / Oracle。REST 側 個人数人。
- Fielding 一番嫌い: 全部 POST。GET なら キャッシュ・URL 共有・ブラウザで開ける。SOAP は全部捨てた。
- 対立の本質: HTTP を主役にするか、土管にするか。

### 3章: SOAP 自滅

- WS-* 仕様 数十本。同じ目的の仕様が 陣営ごとに 2 本。
  - 信頼配送: WS-ReliableMessaging (IBM/MS) vs WS-Reliability (Oracle/Sun)
  - 通知: WS-Eventing vs WS-Notification
- 書き方の流儀 複数 (RPC/encoded, Document/literal)。Java と .NET が 同じ WSDL でも繋がらない。
- 2004 WS-I が Basic Profile 発表。標準の使い方の標準が必要になった。
- 2003 SOAP 1.2 で 正式名称から Simple 消滅。何の略でもなくなった。
- WSDL 手で読めない。生成コード信じるしかない。エラー = Envelope の一言。

### 4章: REST 勝ち始める

- 2003/4 Amazon: 自社 Web サービス利用の 85% が REST。URL 打てば結果見える。
- 2005 頃 Ajax 普及。JS で SOAP の XML 組むの苦行。URL 叩いて JSON 受ける方が楽。
- 2006/12 Google が SOAP 版検索 API の新規受付終了。
- 2007/1 Rails 1.2 が RESTful を標準に。
- 2011 公開 API の 7 割が REST、SOAP は 2 割未満。5 年で逆転。
- 皮肉: 2008 Fielding 本人 「REST API 名乗るものの大半は REST ではない」。
  - 厳密 REST = ハイパーメディアでリンクたどる。
  - 普及したの = URL と HTTP メソッドを素直に使って JSON 返す緩い型。
- 決済・SAP・Salesforce・ONVIF(監視カメラ)など 契約が重い世界では SOAP 今も現役。
- REST は論争で勝ったのでなく、試すのが簡単な方を開発者が黙って選び続けた結果。

### 5章: 思想は生き残った

- OpenAPI (Swagger, 2011 → 2015 OpenAPI Initiative) = WSDL の再来。
- gRPC (2015) = Protocol Buffers で IF 先に定義。契約先行・型付き・ツール前提。SOAP の目指した姿。
- WS-Security の役目 → OAuth / JWT。WS-ReliableMessaging の役目 → メッセージキュー + リトライ設計。
- OpenAPI / proto は人間が読める。WSDL は ツールなしで誰も読めない。読めるかで明暗。
- MCP (Anthropic, 2024/11): 機械が契約読んでクライアント自動生成。SOAP の夢が AI で叶う。
- 25 年前 人間には重すぎた設計 → 読み手が AI なら軽くなる。勝ち負け また変わるかも。

## 質問・やり取りメモ

### REST でも全部 POST のやつ (GraphQL など)

- GraphQL は REST ではない。単一 `/graphql` に POST、操作は本文。構造は SOAP に近い。
- 違い: 本文が XML でなく GraphQL クエリ + JSON。契約が スキーマ (SDL) で人間が読める。
- 得るもの: 必要フィールドだけ取得、複数リソース 1 往復、型付きスキーマ。捨てるもの: HTTP キャッシュ、URL 共有。
- 「REST 名乗って全部 POST」(`POST /api/getUser`) = 実質 JSON-RPC。
- gRPC (HTTP/2 で全部 POST)、tRPC も 土管寄り。ただし「読める契約」満たす → 動画の結論と矛盾なし。

### 全部 POST でも実用変わらない？ REST の利点は？

インターフェース明確なら 全部 POST でも 実用ほぼ困らない。差 出るの = HTTP 層のインフラが意味を理解して働く部分。

- キャッシュ: GET は CDN・ブラウザ・プロキシが自動キャッシュ。POST は不可。最大の差。
- 安全性・冪等性: GET / PUT / DELETE は再実行安全 → 自動リトライ可。POST は二重実行の恐れ。
- URL = 共有・ブックマーク・curl・ログで操作が見える。
- WAF / レート制限 / 認可 / アクセスログを メソッド + パス単位で書ける。`POST /rpc` 1 本だとボディ解析が要る。
- プリフェッチ・クローラ: GET は副作用なしと信頼される。
- 観測性: APM / メトリクスが エンドポイント別に自動集計。
- 目安:
  - 公開 API、読み取り中心、CDN 使う、ブラウザ直叩き → REST 有利。
  - 内部サービス間、操作中心 → RPC で十分 (gRPC / tRPC 普及の理由)。

### なぜ XML が流行った？

- 「それしかなかった」がほぼ正解。
  - XML 1.0 = 1998 W3C 勧告。SOAP 設計 1998-2000。
  - JSON = 2001 頃 Crockford 提唱、RFC 2006、普及は 2005 以降 (Ajax)。SOAP 設計時 JSON 存在せず。
- XML の売り:
  - SGML / HTML の延長で「次世代のデータ交換形式」と業界熱狂。
  - 言語・OS・ベンダー非依存のテキスト (DCOM / CORBA のバイナリ独自形式への対抗)。
  - 周辺仕様が揃う: XML Schema (型)、XSLT、XPath、名前空間 → 企業連携で欲しい「厳密な型と検証」。
- JSON が勝った理由: 軽い・読みやすい・JS が直接パース (Ajax で決定的)。型検証は後付け (JSON Schema, OpenAPI)。
- XML は 文書 (マークアップ) 向き。データ交換には オーバースペック。JSON は オブジェクト・配列に直接対応。
