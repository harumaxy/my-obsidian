---
title: NGINXがApacheの牙城を崩した話
description: ロシア人エンジニア1人が作ったnginxがApacheを逆転した歴史と、Webサーバーという概念そのものの整理
aliases:
  - nginx history
  - Apache vs nginx
tags:
  - nginx
  - Apache
  - Web Server
  - OpenResty
  - Envoy
  - Kubernetes
  - Infrastructure
draft: false
date: 2026-08-09
video_url: https://www.youtube.com/watch?v=J90nV6s8q1M
channel: IT技術屋のボヤキ
---

## 動画の内容: nginx誕生秘話

- 1995年生まれのApache、ピーク2009年頃シェア7割超。ランプスタックの王者だった
- 弱点: 接続1本ごとプロセス/スレッド1個割当方式。1万接続で1万プロセス、メモリ・CPU食い潰す（C10K問題、1999年命名）
- ロシア人エンジニア、イーゴリ・シソエフ。ロシア最大ポータル「Rambler」のインフラ担当者としてC10K問題を毎日浴びる
- 2001年Apache改良モジュール(mod_accel)試すも限界感じ、2002年ゼロから新設計着手
- 発想転換: 少数ワーカープロセスがイベント駆動で数千接続巡回対応（銀行窓口の例え: 専属担当制→巡回制）
- 2004年10月4日nginx 0.1.0公開（スプートニク打ち上げ47周年に合わせた日）
- 静的ファイル配信でApache数倍性能。Apache手前にnginx置くリバースプロキシ構成で無理なく浸透
- 2011年nginx社設立、2019年F5が約700億円で買収
- 買収9ヶ月後、Rambler側が「在職中の著作物、著作権はうちにある」と警察沙汰起こすも批判浴びて立ち消え
- 2021年春、シェア逆転（現在nginx約33% vs Apache約23%）
- 2022年シソエフF5退社、2024年主要開発者マキシム・ドゥニンもF5離れ「freenginx」フォーク立ち上げ
- 作者も企業も去ったが道具は今も世界の1/3のWeb支え続けてる

## Webサーバーという言葉の整理

「Webサーバー」= HTTPプロトコル喋るサーバー全般の総称。

- APIサーバー/JSONサーバー/RESTfulサーバー/SSRサーバー → 全部HTTPで通信→Webサーバーの一種（レスポンス形式や設計思想の呼び分けだけ）
- プロキシサーバー → HTTPも扱う→Webサーバーの一種。自分でコンテンツ生成せず転送/中継が役割
- DBサーバー → **含まれない**。MySQL/PostgreSQL等は独自ワイヤプロトコル使う、HTTPじゃない、別レイヤー

Apache/nginx = 汎用HTTPサーバー（TCP接続受付、HTTP解析、静的配信、リバースプロキシ、LB、TLS終端）。Node.js/Go/Rails/Spring/.NET等 = アプリケーションフレームワーク（ビジネスロジック処理）。役割レイヤーが違う→基本は競合せず共存。nginxを前段に置き後ろでアプリプロセス動かす構成が定番（静的配信の高速化、複数インスタンスへの負荷分散、TLS終端集約、クラッシュ時の緩衝材）。

nginx自体はアプリロジック持たない。標準機能は静的配信・リバースプロキシ・LB・TLS終端・軽いconfig制御(rewrite等)のみ。OpenResty(後述)使わない限り汎用プログラミングロジックは書けない。

## nginxの真の競合

現代のnginxの実用途はほぼ「静的配信」「リバースプロキシ」「LB」「TLS終端」の4つに収束。だから今のnginxの競合は同レイヤーのこいつら:

- LB機能 → AWS ALB/NLB、GCP Load Balancer
- 静的配信機能 → S3 + CloudFront、GCS
- CDN/エッジキャッシュ → CloudFront、Cloudflare、Fastly
- リバースプロキシ機能 → HAProxy、Envoy、Traefik、Caddy
- k8s Ingress Controller → Traefik、Envoy(Istio)、ALB Ingress Controller

AWS完結構成(ALB+CloudFront+S3)ならnginxの役割ほぼ代替可能。自前でサーバー管理(EC2/コンテナ/k8s)する時にnginxが選択肢に上がる力学。

## 長時間コネクション・カスタムプロトコル対応

**WebSocket**: v1.3.13以降対応。バックエンドが101 Switching Protocolsで返す時、Upgrade/Connectionヘッダーをデフォルトでは転送されないので明示的にproxy_set_headerで転送する設定必要。k8s ingress-nginxでもWebSocket対応標準搭載。チャット/リアルタイム通知系の定番構成。

**stream module (TCP/UDP)**: nginx標準ビルドに含まれない別モジュール(`--with-stream`でビルド時有効化)。HTTP層を介さず生TCP/UDPレベルでプロキシ/LBできる。用途: DBサーバーへの接続プロキシ、DNS(UDP)のLB、メールサーバーのプロキシ、ゲームサーバー等カスタムバイナリプロトコルのLB。ALB(L4/L7両対応)やHAProxyと直接競合する領域。

**動的upstream追加について**: 素のnginx(OSS)には「HTTP APIで動的にupstream追加」機能は無い(NGINX Plus商用版の`ngx_http_api_module`のみ)。OSSでの代替策:
1. Consul-template等で「バックエンド一覧変化→nginx.conf再生成→reload(グレースフル)」自動化するのが最も一般的
2. `proxy_pass`に変数使いresolver経由で毎リクエストDNS解決(TTL管理必要)
3. OpenResty(後述)の`balancer_by_lua`でリクエスト毎にRedis/etcd参照して転送先動的決定、これが実質の本命

ゲームサーバーのセッション専用IP割当パターンについては、実はnginx経由でプロキシしない設計が現場の主流。マッチメイキングAPI(HTTP、ここはnginx/ALB経由でOK)がセッション専用インスタンスのIP:PORTをクライアントに返し、クライアントは直接そのIP:PORTに接続(プロキシ層バイパス、レイテンシ最優先のため)。

## nginxはレガシー寄りか

レガシー化しつつあるが、Apacheの時とは意味合い違う。

**レガシー寄りな面**:
- 設計自体2004年生まれで動的リコンフィグ前提にしてない(動的upstream追加は本来Plus機能かOpenResty頼み)
- k8s Ingressという現代インフラの重要な戦場で、**2026年3月24日にingress-nginxがEOL**(CVEパッチも無し)、Kubernetes運営委員会がセキュリティ上の理由で正式引退表明。後継はGateway API(CNCF標準)＋Envoy Gateway/kgateway等の実装。移行ツール`ingress2gateway 1.0`も登場
- CloudflareがRustで自社インフラ用にPingora開発、自社nginxを置き換え済み。大規模事業者視点だともう最適解じゃないという判断が実際に下された

**まだ現役な面**:
- Web全体シェア約33%で世界最大手(Apache超え)
- VPS1台構成・個人開発・中小規模の「とりあえずリバースプロキシ立てる」用途では今も第一候補
- 軽量・省リソース・安定性は健在。C10K問題自体は解決済みのまま古びてない
- F5配下で今も現役開発継続中

結論: Apacheの時の「構造的欠陥抱えた王者が新方式に食われる」構図とは違う。nginxは**枯れた実用インフラとして生き残るタイプのレガシー化**。新規のクラウドネイティブ/動的インフラ設計ではEnvoy/Gateway API系が新標準になりつつあるが、シンプル用途では当分デファクトのまま。

## OpenRestyとは何か

正体: **nginx本体 + LuaJIT + 大量のサードパーティnginxモジュールを1つにバンドルしたディストリビューション**。別物じゃなくnginxそのものの拡張。

核心はngx_lua(lua-nginx-module)。nginxのリクエスト処理の各フェーズ(rewrite, access, content, balancer, log等)にLuaコードをフックできる仕組み。LuaJITで動くから軽量・高速。

Rails/Expressのような汎用アプリFWとは違う。位置づけは**nginxのリクエスト処理パイプラインにプログラマブルなロジックを差し込むための基盤**。主用途: API Gateway(認証/認可、レートリミット)、動的LB(`balancer_by_lua`)、動的ルーティング、キャッシュ制御、WAF的フィルタリング。実例: API Gateway製品KongはOpenResty土台に作られてる。

**開発体験は良くない部類**:
- Lua自体は言語仕様シンプルで習得は速いが、Web開発文脈での知見・エコシステムは薄い(ゲーム開発/組み込み系の実績はある)
- nginxのフェーズモデル理解必須(参入障壁の最大要因)
- 非同期プログラミングモデルが独特。素のLua標準ライブラリ(blocking I/O)は使えず、OpenResty独自の非同期ライブラリ(`ngx.socket`等)を学び直す必要
- デバッガ・IDE支援が弱い
- 採用市場が狭い

救い: 現場では「OpenResty=薄いインフラ/ゲートウェイ層のロジックだけ書く」用途に限定するのが普通、業務ロジック本体は別言語に置く設計にする、書く量が少ないから知見不足はあまり問題にならない。

代替の潮流: 同じニーズに対して今はEnvoyのWASMフィルタ(Rust/Go/C++で書いてWASMコンパイル、Lua不要)という選択肢も普及。「Lua新規習得コスト払うくらいならEnvoy+WASM/得意言語」という判断するチームも増えてる。

## 関連キーワード
- #nginx #Apache #Webサーバー #C10K問題
- #リバースプロキシ #ロードバランサ #CDN
- #Kubernetes #ingress-nginx #GatewayAPI #Envoy
- #OpenResty #Lua #APIGateway #Kong
