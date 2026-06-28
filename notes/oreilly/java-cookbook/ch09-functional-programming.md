---
title: Java Cookbook 第9章 - 関数型プログラミングテクニック
description: Java の関数型プログラミング（Lambda、Stream、Collectors、Flow）のまとめ
aliases:
  - Java 関数型プログラミング
tags:
  - java
  - functional-programming
  - stream
draft: false
date: 2026-06-28
---

# 第9章 関数型プログラミングテクニック

## 関数型プログラミングの基本概念

- 計算を数学関数の評価として扱い、状態・可変性を避ける
- **純粋関数**：入力だけで出力が決まる。副作用なし → テスト・並列処理が容易
- ファーストクラス関数、不変性データ、遅延評価が特徴
- Java 8 で Lambda 式と関数型インターフェースが導入された

## Lambda 式

```java
// 旧: 匿名内部クラス
list.stream().filter(new Predicate<Camera>() {
    public boolean test(Camera c) { return c.getPrice() < 500; }
});

// 新: Lambda
list.stream().filter(c -> c.getPrice() < 500);
```

- 型はコンパイラが推論するので省略可能
- 複数引数は括弧で囲む: `(a, b) -> a + b`

## 関数型インターフェース

`java.util.function` パッケージに約50個の標準実装がある。
**実際のコードでは型名を書かず、Lambda を直接渡すだけでよい。**

| インターフェース | メソッド | 主な用途 |
|---|---|---|
| `Predicate<T>` | `boolean test(T t)` | filter |
| `Function<T, R>` | `R apply(T t)` | map |
| `Consumer<T>` | `void accept(T t)` | forEach |
| `Supplier<T>` | `T get()` | 遅延生成 |
| `BiFunction<T,U,R>` | `R apply(T t, U u)` | 2引数の変換 |

型名を明示するのは、条件を変数に入れて再利用・合成したい場合のみ:

```java
Predicate<String> long  = s -> s.length() > 3;
Predicate<String> upper = s -> Character.isUpperCase(s.charAt(0));
list.stream().filter(long.and(upper));
```

## メソッド参照

既存メソッドを Lambda の代わりに渡せる。`クラス名::メソッド名` の構文。

```java
list.stream().map(String::toUpperCase);      // インスタンスメソッド
list.stream().forEach(System.out::println);  // 特定インスタンスのメソッド
list.sort(String::compareToIgnoreCase);      // 任意インスタンスのメソッド
```

## Stream API

コレクションを `stream()` で変換し、パイプラインで処理する。Rust の `iter()` と同じ発想。

```java
list.stream()        // Stream に変換（遅延評価開始）
    .filter(...)     // 中間操作（何個でも繋げられる）
    .map(...)
    .collect(...)    // 終端操作（ここで初めて実行される）
```

### 主な中間操作

| メソッド | 説明 |
|---|---|
| `filter(Predicate)` | 条件で絞り込み |
| `map(Function)` | 変換 |
| `flatMap(Function)` | ネストを平坦化 |
| `sorted()` | ソート |
| `distinct()` | 重複除去 |
| `limit(n)` | 先頭 n 件 |
| `peek(Consumer)` | デバッグ用（中身を見つつ流す） |

### 主な終端操作

| メソッド | 説明 |
|---|---|
| `collect(Collector)` | コレクションに集める |
| `toList()` | List に集める（Java 16〜） |
| `forEach(Consumer)` | 各要素に処理 |
| `count()` | 件数 |
| `reduce(...)` | 畳み込み |
| `findFirst()` | 最初の要素（Optional） |
| `anyMatch / allMatch / noneMatch` | 条件チェック |

### JS との比較

JS の `Array` は `map/filter/reduce` を直接持つが、Java の `List` は持たない。
`stream()` への変換が必要な分冗長だが、遅延評価・並列化・無限列などの恩恵がある。

```java
// parallelStream() に変えるだけで並列処理になる
list.parallelStream().filter(...).map(...).toList();

// 無限列
Stream.iterate(0, n -> n + 1).limit(10).toList();
```

## Collectors クラス

`collect()` に渡す「集め方」を定義したファクトリクラス。自分で実装することはほぼない。

```java
// 基本
stream.collect(Collectors.toList());
stream.collect(Collectors.toSet());
stream.toList();  // Java 16〜（不変リスト）

// 文字列結合
stream.collect(Collectors.joining(", ", "[", "]")); // → "[a, b, c]"

// Map に変換
stream.collect(Collectors.toMap(Person::getId, Person::getName));

// グループ化（最もよく使う）
Map<String, List<Person>> byCity =
    stream.collect(Collectors.groupingBy(Person::getCity));

// グループ化 + 集計
Map<String, Long> countByCity =
    stream.collect(Collectors.groupingBy(Person::getCity, Collectors.counting()));

// 2分割
Map<Boolean, List<Person>> partition =
    stream.collect(Collectors.partitioningBy(p -> p.getAge() >= 20));
```

## Stream Gatherer（Java 22〜）

中間操作を自由に拡張できる仕組み。従来の中間操作セットを超えた変換が可能。

```java
// 定義済み Gatherer の例
stream.gather(Gatherers.windowFixed(3));   // 3件ずつグループ化
stream.gather(Gatherers.windowSliding(3)); // スライディングウィンドウ
stream.gather(Gatherers.scan(...));        // 各ステップの集計結果を出力
```

カスタム Gatherer は `Gatherer.ofSequential(initializer, integrator)` で実装できる。

## Reactive Streams / Flow API（Java 9〜）

非同期でデータが流れてくるケース（I/O、WebSocket など）向け。通常の Stream とは別物。

```java
// Publisher（送信側）
var publisher = new SubmissionPublisher<String>();

// Subscriber（受信側）を実装
class MySubscriber implements Flow.Subscriber<String> {
    private Flow.Subscription subscription;

    public void onSubscribe(Flow.Subscription s) {
        this.subscription = s;
        s.request(1); // 最初の1件を要求
    }
    public void onNext(String item) {
        System.out.println(item);
        subscription.request(1); // 次の1件を要求
    }
    public void onError(Throwable t) { t.printStackTrace(); }
    public void onComplete() { System.out.println("完了"); }
}

publisher.subscribe(new MySubscriber());
publisher.submit("hello");
publisher.close();
```

### バックプレッシャー

Subscriber が `request(n)` で「今 n 件だけ送ってください」と伝える仕組み。
Publisher が速すぎてバッファが溢れる（OOM）を防ぐ。

### Stream vs Flow

| | Stream | Flow |
|---|---|---|
| 実行 | 同期 | 非同期 |
| 用途 | コレクション操作 | 非同期I/O・イベント |
| バックプレッシャー | なし | あり |

### 実用フレームワーク

Flow API は仕様のみ。実務では以下を使う:

| フレームワーク | 特徴 |
|---|---|
| **Project Reactor** | Spring WebFlux の基盤。`Mono<T>` / `Flux<T>` |
| **RxJava** | 歴史が長い。Android でも使われる |
| **Akka Streams** | 分散処理向け |
