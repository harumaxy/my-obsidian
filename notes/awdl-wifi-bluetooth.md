---
title: AWDL / Wi-Fi P2P / Bluetooth
description: Apple の P2P 通信 AWDL、Wi-Fi と Bluetooth の使い分け、歴史、名前の由来メモ
# permalink:  # don't use
aliases:
  - AWDL
  - Apple Wireless Direct Link
tags:
  - network
  - apple
  - wifi
  - bluetooth
draft: false
date: 2026-10-21
---

## AWDL とは

- Apple Wireless Direct Link。Apple 独自の Wi-Fi ベース P2P プロトコル
- Wi-Fi チップ使う。AP 接続維持しつつ、時分割で AWDL 用チャンネル (social channel 6 / 44 / 149) に切替
- 速度 Bluetooth より速い。遅延低い
- 使うもの: AirDrop, AirPlay (P2P), GameKit / Multipeer Connectivity, Sidecar, Universal Control, Handoff 一部
- 流れ: BLE でアドバタイズ → AWDL 起動 → Bonjour (mDNS) でサービス発見 → 転送
- 仕様非公開。OpenDrop など研究者のリバースエンジニアリングで解析された
- 過去に脆弱性あり。2020年 Google Project Zero の Ian Beer が iOS ゼロクリック RCE 発表
- 欠点: チャンネル切替でインフラ Wi-Fi の ping スパイク。ゲーム中 AirDrop 有効でラグ、など
- 今後: EU DMA 対応で Apple が Wi-Fi Aware (業界標準) 対応。Android Quick Share と AirDrop 相互運用の流れ

## Vision Pro の Mac Virtual Display は AWDL か

- 結論: 確定情報なし。Apple 公式に転送経路の記載なし
- 公式要件: 同一 Apple ID、Wi-Fi と Bluetooth オン、約10m以内。「同じ Wi-Fi 接続」は一部ガイドが推奨するだけ
- 要件が Wi-Fi + Bluetooth + 近接 → P2P (AWDL) 前提の設計っぽい。弱い根拠のみ
- AWDL は高帯域も出せる。AirDrop 大容量転送や Sidecar で使われてる。「AWDL は低速用途」は誤解
- Xcode 同梱は SDK ヘッダと .tbd のみ。実装は見えない。Mac 側バイナリ (dyld shared cache) 解析なら手掛かりあるが手間
- 裏取り案: ルーター無しで動くか試す。Mac で `sudo tcpdump -i awdl0` で流量を見る

## 自分で Wi-Fi P2P を使う (iPhone アドホック通信)

- AWDL を直接叩く API は無い。上位 API 経由で使える。DS / PSP のアドホック通信に近いことが可能
- Multipeer Connectivity (MPC)
  - 近くの端末発見 → `MCSession` で接続 → データ / ストリーム / ファイル送信
  - 下層は AWDL / Bluetooth / 同一 Wi-Fi を自動選択
  - 簡単。ただし新機能は止まってる。後継を問う声が Developer Forums にある
- Network framework + `includePeerToPeer`
  - `NWParameters.includePeerToPeer = true` で `NWListener` / `NWBrowser` (Bonjour) / `NWConnection`
  - TCP / UDP 素で扱える。ゲーム自前プロトコル向き。iOS 12+ / visionOS 1.0+
  - iOS 26 以降は `peerToPeerIncluded(_:)` 新 API (`NetworkListener` / `NetworkBrowser`)
- Wi-Fi Aware (iOS 26+)
  - 業界標準 P2P。Network framework から `.wifiAware(...)`。Android と相互運用
  - 接続前にデバイスペアリング必要
- GameKit: 対戦マッチング高水準 API
- 制約: 相手も Apple 端末 (Wi-Fi Aware なら Android も) で同じアプリ。シミュレーターで P2P Wi-Fi 再現不可、実機 2 台要る

## Wi-Fi と Bluetooth の性能差 (P2P 用途、概算)

- スループット
  - Wi-Fi P2P: 数十〜数百 Mbps
  - Bluetooth Classic: 実効 2〜3 Mbps
  - BLE: 実効 0.1〜1.4 Mbps (BLE 5 の 2M PHY で理論 2 Mbps)
- 遅延
  - Wi-Fi: 数〜十数 ms。AWDL チャンネル切替で数十 ms スパイクあり
  - BLE: 接続間隔の制約で 7.5 ms〜数十 ms。安定
- 距離: Wi-Fi P2P 屋内数十 m。Bluetooth Class 2 約 10 m。BLE 5 条件次第で数十 m〜
- 消費電力: BLE 最小。Bluetooth Classic 中間。Wi-Fi 大
- 接続確立: BLE 速くて軽い。Wi-Fi P2P 数百 ms〜数秒
- 同時接続: Wi-Fi 多人数向き。BLE 接続数制約あり
- 使い分け
  - 発見、ペアリング、小メッセージ (スコア、入力) → BLE
  - 動画、大容量、画面共有 → Wi-Fi
  - Apple は自動化済み。AirDrop は BLE で発見 → AWDL で転送。MPC も同様

## Wi-Fi の歴史

- 1985: 米 FCC が ISM バンド (2.4GHz 帯など) を免許不要で開放
- 1990年代前半: 豪 CSIRO が OFDM 系技術開発
- 1997: IEEE 802.11 初版。2Mbps
- 1999: 802.11b (11Mbps, 2.4GHz) と 802.11a (54Mbps, 5GHz)。Apple が iBook + AirPort で一般普及
- 1999: Wi-Fi Alliance 設立。Wi-Fi はブランド名。規格名は 802.11
- 2003: 802.11g (54Mbps, 2.4GHz)
- 2004: WPA2。WEP は脆弱で廃止の流れ
- 2009: 802.11n (Wi-Fi 4)。MIMO、最大 600Mbps
- 2013: 802.11ac (Wi-Fi 5)。5GHz、MU-MIMO、数 Gbps
- 2019: 802.11ax (Wi-Fi 6)。OFDMA、多台数効率向上
- 2020: Wi-Fi 6E。6GHz 帯
- 2024: 802.11be (Wi-Fi 7)。MLO、320MHz 幅、理論 46Gbps
- P2P: Wi-Fi Direct (2010年頃)。Apple 独自 AWDL は AirDrop 用 (2014年頃)。Wi-Fi Aware (NAN) は業界標準 P2P

## Bluetooth の歴史

- 1989〜1994: Ericsson が RS-232 ケーブル置換の無線技術を研究 (Jaap Haartsen, Sven Mattisson ら)
- 1998: Bluetooth SIG 設立 (Ericsson, IBM, Intel, Nokia, 東芝)
- 1999: Bluetooth 1.0
- 2004: 2.0 + EDR。最大 3Mbps
- 2009: 3.0 + HS。Wi-Fi 切替で高速転送 (AMP)。普及せず
- 2010: 4.0。BLE (Bluetooth Low Energy) 登場。ボタン電池で数年。Classic と別系統、互換なし
- 2013: iBeacon (Apple)。BLE 近接通知
- 2016: 5.0。BLE 距離 4 倍、速度 2 倍
- 2019: 5.1。方向検知 (AoA / AoD)
- 2020: LE Audio (5.2)。LC3 コーデック、Auracast
- 2023〜: 5.4 / 6.0。Channel Sounding で高精度測距
- 流れ: Wi-Fi は高速化と多台数化。Bluetooth はケーブル置換 → 省電力 (BLE) → 位置・音声。両者とも 2.4GHz 帯で干渉が長年の課題。最近は融合 (BLE 発見 + Wi-Fi 転送)

## Bluetooth の名前の由来

- 命名者: Intel の Jim Kardach (1997年頃)。歴史好き。当時読んでた小説『The Long Ships』(ヴァイキング物語) に Harald が出てきた
- Harald Bluetooth = 10世紀デンマーク王。デンマークとノルウェーを統一
- 当時、Nokia / Ericsson / Intel などで規格バラバラ。「共通規格に統一」が「分裂国を統一した王」に重なった
- 仮の開発コード名のつもり。正式名候補は PAN, RadioWire。商標調査や発表時期の都合で Bluetooth が残った
- 「青い歯」: 古ノルド語 *Blåtand*。blå = 青 / 黒っぽい、tand = 歯
- 渾名の理由は確定せず。説: 虫歯で歯が変色 / ブルーベリーで歯が染まった / blå は「暗い色」の意味
- ロゴ: ルーン文字の合字。Harald の頭文字 ᚼ (Hagall) と Bluetooth の頭文字 ᛒ (Bjarkan) を重ねたもの

## Ericsson と Erlang

- Bluetooth を作った Ericsson (スウェーデン通信機器メーカー) = Erlang を作った会社と同じ
- Erlang: 1986年頃 Ericsson のコンピュータ科学研究所で Joe Armstrong ら開発。電話交換機ソフト用言語
  - 要件: 高並行、障害耐性、無停止コード更新
  - 1998年オープンソース化
- Bluetooth: 1989年頃 Ericsson モバイル部門で研究開始
- Erlang の末裔: Elixir、WhatsApp 基盤 (Erlang/OTP)
- Erlang の名前の由来: デンマーク数学者 Agner Krarup Erlang (通信トラフィック理論)。社名 Ericsson (創業者 Lars Magnus Ericsson) とは別

## 参考

- [includePeerToPeer](https://developer.apple.com/documentation/network/nwparameters/includepeertopeer)
- [peerToPeerIncluded(_:)](https://developer.apple.com/documentation/network/nwparametersprovider)
- [NWParameters.wifiAware(_:)](https://developer.apple.com/documentation/network/nwparameters/wifiaware%28_%3A%29)
- [MCSession.send(_:toPeers:with:)](https://developer.apple.com/documentation/multipeerconnectivity/mcsession/send%28_%3Atopeers%3Awith%3A%29)
- [What is the Multipeer Connectivity replacement? (Developer Forums)](https://developer.apple.com/forums/thread/829633)
- [How to Use Apple Vision Pro with Your Mac: 2026 Setup Guide](https://www.switchingtomac.com/how-to-use-apple-vision-pro-with-mac/)
- [iGeeksBlog: How to connect Mac to Apple Vision Pro](https://www.igeeksblog.com/how-to-connect-mac-to-apple-vision-pro/)
- [9to5Mac: vision pro intel macs](https://9to5mac.com/2024/02/05/vision-pro-intel-macs/)

※ 年・数値は概数。歴史部分は一般知識ベースで一次資料未確認
