---
title: "Java Cookbook 第14章 - ネットワーククライアント"
description: "Java のネットワーク通信（HTTP/REST, ソケット, UDP）の基礎まとめ"
# permalink:  # don't use
aliases:
  - java-network-clients
tags:
  - java
  - network
  - oreilly
draft: false
date: 2026-06-28
---

# 第14章 ネットワーククライアント

## 概要

Java のネットワーク通信を体系的に解説した章。REST/HTTP（`HttpClient`）から生ソケット（TCP/UDP）まで幅広くカバーする。

**設計方針：** 現代的な開発では REST クライアントを最優先とし、低レベルな通信が必要な場合はソケットを使う。

---

## HTTP / REST クライアント

- Java はプラットフォーム間の差異を隠蔽し、ネットワーク通信を1行のコードで実現できる
- ソケットは低レベルレイヤーで、その上に HTTP/RMI/JDBC/CORBA などが構築される
- **新規アプリは生ソケットより HTTP/REST が推奨**

### Java 11+ HttpClient API

```java
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("https://api.example.com/data"))
    .build();

// 同期
HttpResponse<String> response = client.send(request, BodyHandlers.ofString());

// 非同期
client.sendAsync(request, BodyHandlers.ofString())
    .thenApply(HttpResponse::body)
    .thenAccept(System.out::println);
```

- 旧環境では `URLConnection` クラスで代替可能
- SOAP は対象外、REST に焦点

---

## TCP ソケット通信

### 基本接続

```java
try (Socket socket = new Socket("hostname", 8080);
     BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
     PrintWriter out = new PrintWriter(socket.getOutputStream(), true)) {
    // 通信処理
}
```

- try-with-resources でソケットとストリームの自動クローズが保証される

### InetAddress（名前解決）

```java
InetAddress addr = InetAddress.getByName("example.com");
addr.getHostAddress(); // 数値IPアドレス
addr.getHostName();    // ホスト名
InetAddress.getLocalHost(); // ローカルマシン

InetAddress[] all = InetAddress.getAllByName("example.com"); // IPv4/IPv6両方
```

- IPv4 アドレス枯渇対策：NAT と IPv6（128ビット）の両方が使われている

### 例外処理

```java
try {
    // 接続処理
} catch (UnknownHostException e) {
    // ホスト名解決失敗
} catch (NoRouteToHostException e) {
    // 到達不可
} catch (ConnectException e) {
    // 接続拒否
} catch (IOException e) {
    // その他 I/O エラー
}
```

### テキスト通信

```java
// 読み書き
BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
PrintWriter out = new PrintWriter(socket.getOutputStream(), true); // auto-flush

// 行末はプラットフォーム依存のため明示的に \r\n を送る
out.print("HELLO\r\n");
out.flush();
```

### バイナリ通信

```java
// バイナリデータ
DataInputStream din = new DataInputStream(new BufferedInputStream(socket.getInputStream()));
DataOutputStream dout = new DataOutputStream(new BufferedOutputStream(socket.getOutputStream()));

// Java は符号なし int 型がないのでビットシフトで手動再組み立て
long unsignedInt = ((long) din.readUnsignedByte() << 24) | ...;
```

### オブジェクト通信（シリアライゼーション）

```java
ObjectInputStream oin = new ObjectInputStream(socket.getInputStream());
ObjectOutputStream oout = new ObjectOutputStream(socket.getOutputStream());

LocalDateTime dt = (LocalDateTime) oin.readObject();
```

---

## UDP 通信

### TCP vs UDP

| 特性 | TCP | UDP |
|------|-----|-----|
| 接続 | 電話型（コネクション） | ハガキ型（コネクションレス） |
| 信頼性 | 再送・順序保証あり | なし（自前実装が必要） |
| メッセージ境界 | なし（ストリーム） | あり |
| オーバーヘッド | 大 | 小 |
| 用途 | 確実なデータ転送 | リアルタイム性優先 |

### UDP クライアント実装

```java
try (DatagramSocket socket = new DatagramSocket()) {
    // 送信
    byte[] buf = new byte[0];
    DatagramPacket request = new DatagramPacket(buf, buf.length,
        InetAddress.getByName("hostname"), 13);
    socket.send(request);

    // 受信
    byte[] recvBuf = new byte[1024];
    DatagramPacket response = new DatagramPacket(recvBuf, recvBuf.length);
    socket.receive(response);
}
```

### UDP の使いどころ

- FPS・リアルタイムゲームの位置同期（古いデータより最新データが大事）
- 高信頼な LAN 環境での大量データ送信
- パケットロス対応はアプリケーション層で自前実装が必要

---

## URI / URL

```
URI（統一リソース識別子）
├── URL（ロケーター）: https://example.com/path
└── URN（名前）: urn:isbn:0451450523
```

```java
URI uri = new URI("https://example.com/a/../b");
URI normalized = uri.normalize(); // https://example.com/b

URI base = new URI("https://example.com/app/");
URI relative = base.relativize(new URI("https://example.com/app/page")); // page

// URI → URL（文字列経由）
URL url = new URL(uri.toString());
```

---

## ソケットベースのチャット

- 入出力を別スレッドで並行処理（`Thread` または `ExecutorService`）
- 本格的なチャットには **WebSocket / XMPP / RMI / JMS** の利用を推奨
- パブリックネットワーク経由の通信にはソケット接続の暗号化（TLS）が必須

---

## ブラウザ環境でのリアルタイム通信

ブラウザでは生の UDP ソケットは使えないため、代替技術を使う：

| 技術 | ベース | 特徴 |
|------|--------|------|
| WebSocket | TCP | シンプル、ほぼ全ブラウザ対応 |
| WebRTC DataChannel | UDP | P2P、`unreliable` モードで UDP 相当 |
| WebTransport | QUIC | 最新、HOL ブロッキングなし |

**TCP の HOL ブロッキング問題：** パケットロスが起きると後続パケットがすべて詰まる。ゲームの位置同期では致命的になりうる。

**実用的なアドバイス：** まず WebSocket で実装して遅延を計測し、問題があれば WebRTC DataChannel に移行するのが現実的。
