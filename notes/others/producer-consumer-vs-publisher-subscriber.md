---
title: Producer/Consumer と Publisher/Subscriber の違い
description: 2つのメッセージングパターンの構造・用途・実装の比較
aliases:
  - Pub/Sub
  - プロデューサ・コンシューマ
tags:
  - concurrency
  - messaging
  - design-pattern
draft: false
date: 2026-06-28
---

# Producer/Consumer と Publisher/Subscriber の違い

## 構造

```
Producer/Consumer
[Producer] → [Queue] → [Consumer]
         1つのメッセージを誰か1人が処理（Pull）

Publisher/Subscriber
              ┌→ [Subscriber A]
[Publisher] ──┼→ [Subscriber B]
              └→ [Subscriber C]
         1つのメッセージを全員が受け取る（Push）
```

## 比較表

| | Producer/Consumer | Publisher/Subscriber |
|---|---|---|
| 受け取り側 | 誰か1人が処理 | 全員が受け取る |
| 通信方向 | Pull（Consumer が取りに行く） | Push（Publisher が配信） |
| 仲介役 | Queue | Broker / EventBus |
| 典型的な用途 | タスクキュー・ジョブ分散 | イベント通知・ブロードキャスト |

## 具体例

**Producer/Consumer**（仕事を誰か1人に割り当てる）

```
注文が来た → キューに積む → Consumer A or B or C のどれかが処理
（同じ注文を3人が処理したら困る）
```

**Publisher/Subscriber**（全員に通知する）

```
ユーザー登録イベント発行
  → メール送信サービスが受け取る
  → ポイント付与サービスが受け取る
  → 分析ログサービスが受け取る
（全員が同じイベントを処理する）
```

## Java での実装

### Producer/Consumer → BlockingQueue

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>(100);

// Producer
queue.put(data);        // 満杯なら自動ブロック

// Consumer
String data = queue.take(); // 空なら自動ブロック
```

### Publisher/Subscriber → Java 9 Flow API

```java
SubmissionPublisher<String> publisher = new SubmissionPublisher<>();

publisher.subscribe(new Flow.Subscriber<String>() {
    public void onNext(String item) {
        System.out.println("received: " + item);
        subscription.request(1); // 次のアイテムを要求（バックプレッシャー）
    }
    // onSubscribe, onError, onComplete も実装必要
});

publisher.submit("event"); // 全 Subscriber が受け取る
```

実用上は **RxJava** や **Project Reactor**（Spring WebFlux）がよく使われる。

## バックプレッシャー

Pub/Sub 特有の概念。Publisher が速すぎて Subscriber が溢れるのを防ぐ仕組み。

```
Publisher: 毎秒1000件配信
Subscriber: 毎秒100件しか処理できない → 溢れる

→ Subscriber が「100件ずつくれ」と伝える（request(100)）
→ Publisher は要求された分だけ送る
```

Producer/Consumer の `BlockingQueue` の容量制限に相当するが、Subscriber 側から能動的に制御できる点が異なる。

## まとめ

- **同じメッセージを1人だけが処理** → Producer/Consumer（タスク分散）
- **同じメッセージを全員が処理** → Publisher/Subscriber（イベント通知）

現実のシステムでは両方混在することも多い。例えば Kafka はトピック単位では Pub/Sub、コンシューマグループ単位では Producer/Consumer として動作する。
