---
title: Java Cookbook 第11章 - スレッド処理
description: Java のマルチスレッド処理（Thread、ExecutorService、CompletableFuture、Lock、Fork/Join）のまとめ
aliases:
  - Java スレッド
  - Java 並行処理
tags:
  - java
  - concurrency
  - thread
draft: false
date: 2026-06-28
---

# 第11章 スレッド処理

## スレッドの基礎

- **プラットフォームスレッド**：OS スレッドと 1対1 で対応
- **仮想スレッド**（Java 21+）：複数が OS スレッドプール上で多重化される。I/O バウンド処理のオーバーヘッドを大幅削減
- `Thread.stop()` は禁止。`volatile boolean` フラグでスレッド自身に終了させる

```java
// 推奨：Runnable + ExecutorService
ExecutorService pool = Executors.newCachedThreadPool();
pool.submit(() -> doWork());

// 仮想スレッド（Java 21+）
ExecutorService vPool = Executors.newVirtualThreadPerTaskExecutor();
Thread.startVirtualThread(() -> doWork());
```

## Runnable / Callable

クロージャーと同概念。「後で実行される処理のかたまり」。

| | 戻り値 | チェック例外 |
|---|---|---|
| `Runnable` | なし（void） | 投げられない |
| `Callable<T>` | あり（T） | 投げられる |

## Future / CompletableFuture

`Future` は非同期処理の結果を表すハンドル（クリーニング店の領収書のようなもの）。

```java
// 非同期処理の起点
CompletableFuture.supplyAsync(() -> fetchData())  // 値を返す
CompletableFuture.runAsync(() -> sendEmail())      // void

// チェーン
.thenApply(s -> s.toUpperCase())      // 前の結果を変換して次へ渡す
.thenAccept(s -> System.out.println(s)) // 前の結果を使う（終端）
.thenRun(() -> System.out.println("done")) // 結果に関係なく後処理

// 複数の非同期処理を合わせる
CompletableFuture.allOf(f1, f2, f3).join() // 全部終わるまで待つ
CompletableFuture.anyOf(f1, f2, f3).join() // どれか1つ終わったら

// エラーハンドリング
.exceptionally(e -> defaultValue)
.handle((result, e) -> e != null ? fallback : result)
```

### 通常 / Async / Async+Executor の違い

どのスレッドで後続処理を実行するかの違い。

```java
.thenApply(fn)                    // 前のタスクと同じスレッドで実行
.thenApplyAsync(fn)               // ForkJoinPool.commonPool() で実行
.thenApplyAsync(fn, myExecutor)   // 指定した Executor で実行
```

## synchronized と Lock

すべての Java オブジェクトは内部にモニターロック（intrinsic lock）を持つ。`synchronized` はその糖衣構文。

```java
// synchronized（暗黙的ロック）
synchronized (this) {
    counter++;
} // ブロック終了で自動解放

// Lock（明示的ロック）
lock.lock();
try {
    counter++;
} finally {
    lock.unlock(); // finally で確実に解放
}
```

| | `synchronized` | `Lock` | `Semaphore` |
|---|---|---|---|
| 同時入場数 | 1 | 1 | N（指定可能） |
| タイムアウト | ✗ | ✓ `tryLock(timeout)` | ✓ |
| 割り込み | ✗ | ✓ `lockInterruptibly()` | ✓ |
| 手動解放 | 不要（自動） | 必要 | 必要 |

### ReadWriteLock

読み取り多・書き込み少のキャッシュに最適。読み取りスレッドは同時実行可能。

```java
ReadWriteLock lock = new ReentrantReadWriteLock();

// 読み取り（複数スレッド同時OK）
lock.readLock().lock();
try { return map.get(key); }
finally { lock.readLock().unlock(); }

// 書き込み（1スレッドのみ）
lock.writeLock().lock();
try { map.put(key, value); }
finally { lock.writeLock().unlock(); }
```

### Semaphore

「同時に N 個まで」に制限するカウンティングセマフォ。

```java
Semaphore sem = new Semaphore(5); // 同時5スレッドまで
sem.acquire();
try { useResource(); }
finally { sem.release(); }
```

**ユースケース**：DB コネクションプール、外部 API レート制限

### tryLock（デッドロック回避）

```java
// タイムアウト付き。失敗なら即リターンしてリトライできる
if (lock.tryLock(500, MILLISECONDS)) {
    try { /* 処理 */ }
    finally { lock.unlock(); }
}
```

## ThreadLocal / ScopedValue

```java
// ThreadLocal：各スレッドごとに独立したデータを保持
ThreadLocal<User> currentUser = new ThreadLocal<>();
currentUser.set(user);
currentUser.get(); // このスレッドのみの値

// ScopedValue（Java 21+ プレビュー）：ThreadLocal の後継
// メモリリーク・継承コスト問題を解決。スコープ終了で自動解放
ScopedValue.where(CURRENT_USER, user).run(() -> process());
```

## プロデューサ・コンシューマパターン

生産速度と消費速度が異なる2工程を `BlockingQueue` でつなぐ。

```
[Producer] → [BlockingQueue] → [Consumer]
（速い）        （バッファ）       （重い・遅い）
```

```java
BlockingQueue<String> queue = new LinkedBlockingQueue<>(100);

// Producer
queue.put(data);   // 満杯なら自動ブロック

// Consumer
String data = queue.take(); // 空なら自動ブロック
```

`wait()`/`notifyAll()` を自分で書く必要がなく、Producer・Consumer の数を独立してスケールできる。

**ユースケース**：非同期ログ書き込み、画像リサイズキュー、スクレイピングパイプライン

## Fork/Join フレームワーク

大きなデータを再帰的に分割して並列処理する（分割統治）。

```
[大きいタスク]
  ├── [中タスク] → fork（別スレッドで非同期実行）
  └── [中タスク] → compute（現スレッドで実行）
        → join で結果を統合
```

**ワークスティーリング**：暇なスレッドが忙しいスレッドのキューからタスクを盗む → CPU を遊ばせない

```java
// RecursiveTask<T>：値を返す
class SumTask extends RecursiveTask<Long> {
    static final int THRESHOLD = 1000;

    protected Long compute() {
        if (to - from <= THRESHOLD) {
            // 十分小さい → 直接計算
            long sum = 0;
            for (int i = from; i < to; i++) sum += array[i];
            return sum;
        }
        int mid = (from + to) / 2;
        SumTask left  = new SumTask(array, from, mid);
        SumTask right = new SumTask(array, mid, to);
        left.fork();
        return right.compute() + left.join();
    }
}

ForkJoinPool pool = new ForkJoinPool();
long result = pool.invoke(new SumTask(array, 0, array.length));

// RecursiveAction：戻り値なし（大規模データ変換）
invokeAll(new DoubleAction(array, from, mid),
          new DoubleAction(array, mid, to));
```

`parallelStream()` は内部で `ForkJoinPool.commonPool()` を使っており、多くのケースで自前実装は不要。

```java
long sum = LongStream.rangeClosed(1, 10_000_000).parallel().sum();
```

## タスクスケジューリング

```java
// Timer / TimerTask：指定時刻・間隔でタスク実行
Timer timer = new Timer();
timer.schedule(new TimerTask() {
    public void run() { saveData(); }
}, 0, 5 * 60 * 1000); // 即時開始、5分間隔
```

## DB・Redis との使い分け

`synchronized` は同一 JVM 内でしか効かない。複数サーバーにスケールアウトした場合は無効。

| 状況 | 使うロック |
|---|---|
| 同一 JVM 内 | `synchronized` / `Lock` |
| DB トランザクション内で完結 | `SELECT FOR UPDATE` / `pg_advisory_xact_lock` |
| 複数サーバー・Redis あり | Redis 分散ロック（Redisson など） |
| 複数サーバー・PostgreSQL あり | `pg_advisory_lock` がシンプル |

## パターン別ユースケースまとめ

| パターン | 向いてる処理 | 例 |
|---|---|---|
| `synchronized` | カウンター・フラグ更新 | リクエスト数カウンター |
| `ReadWriteLock` | 読み多・書き少のキャッシュ | 設定値・マスタデータ |
| `Semaphore` | 同時接続数制限 | DB プール・API レート制限 |
| `tryLock` | デッドロック回避 | 複数リソース横断トランザクション |
| `BlockingQueue` | 速度差のある2工程をつなぐ | ログ書き込み・画像処理 |
| `Fork/Join` | 大きなデータを並列分割 | 集計・ソート・数値計算 |
| `CompletableFuture` | 独立した非同期処理の組み合わせ | 複数 API 並列呼び出し |
