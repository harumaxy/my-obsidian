---
title: ch18-java-with-other-languages
description: Java から外部プログラム・スクリプト言語・ネイティブコードを呼び出す方法
aliases:
  -
tags:
  - java
  - jni
  - ffm
  - interop
draft: false
date: 2026-06-28
---

# Chapter 18 - Java を他の言語で使う

## 外部プロセスの実行

### Runtime.exec() / ProcessBuilder

```java
// 基本的な外部コマンド実行
Process p = new ProcessBuilder("ls", "-l").start();

// 出力をキャプチャ
BufferedReader reader = new BufferedReader(
    new InputStreamReader(p.getInputStream())
);
reader.lines().forEach(System.out::println);

// 終了コード取得
int exit = p.waitFor();
```

- `Runtime.exec()` は旧来の方法、`ProcessBuilder` が後継で推奨
- `ProcessBuilder` は環境変数の変更・初期ディレクトリ設定が容易
- 標準出力は自動表示されないので `getInputStream()` で明示的にキャプチャが必要
- `waitFor()` / `exitValue()` / `destroy()` でライフサイクル管理

### Desktop API

OS レベルの操作（ブラウザ起動・メール送信・ファイルオープン）を行える。

```java
Desktop.getDesktop().browse(new URI("https://example.com"));
```

---

## javax.script - スクリプト言語の組み込み

```java
ScriptEngineManager manager = new ScriptEngineManager();
ScriptEngine engine = manager.getEngineByName("groovy");

// Java 変数をスクリプトに渡す
Bindings bindings = engine.createBindings();
bindings.put("x", 42);
engine.eval("println(x * 2)", bindings);  // → 84

// スクリプトから値を受け取る
Object result = bindings.get("result");
```

### 何のためにあるか

**組み込みスクリプティング（Embedded Scripting）** パターンのための API。

- アプリ本体はコンパイル言語で安全に実装
- ユーザー拡張ロジックだけをスクリプトに委ねる
- `Bindings` に渡すオブジェクトを限定することでサンドボックス化

C 言語でいう Lua 組み込みと同じ思想。

```
C アプリ + Lua  →  Neovim, Redis, World of Warcraft
Java アプリ + Groovy  →  javax.script
```

### 現状の注意点

- Nashorn（JavaScript エンジン）は Java 15 で削除済み
- Jython は Python 2 系止まりで実質メンテ停止
- **現代では GraalVM Polyglot API が実質的な後継**

---

## GraalVM Polyglot API

```java
try (Context ctx = Context.create()) {
    Value result = ctx.eval("python", "2 + 2");
    System.out.println(result.asInt());  // → 4
}
```

- Java + Python/Ruby/JS/R などを同一 JVM 上で実行可能
- Maven/Gradle で言語パックを追加するだけで使える
- `javax.script` より性能・互換性ともに優れている

---

## FFM API（Foreign Function and Memory API）

Java 22 で正式採用（JEP 454 / Project Panama）。**C コードなしで既存の .so / .dll / .dylib を Java から直接呼び出せる。**

JNI の後継として推奨。

### 主要な構成要素

| 要素 | 役割 |
|---|---|
| `Linker` | ネイティブライブラリへのアクセス |
| `SymbolLookup` | ライブラリから関数を検索 |
| `FunctionDescriptor` | C 関数のシグネチャを記述 |
| `MethodHandle` | 実行可能な関数参照 |
| `Arena` | メモリ管理スコープ |

### 基本的な使い方

```java
Linker linker = Linker.nativeLinker();
SymbolLookup libc = linker.defaultLookup();

MethodHandle strlen = linker.downcallHandle(
    libc.find("strlen").orElseThrow(),
    FunctionDescriptor.of(ValueLayout.JAVA_LONG, ValueLayout.ADDRESS)
);

try (Arena arena = Arena.ofConfined()) {
    MemorySegment s = arena.allocateFrom("Hello");
    long len = (long) strlen.invoke(s);  // → 5
}
```

ソースコード不要。**関数名とシグネチャ（.h ヘッダや API ドキュメント）さえあれば呼べる。**

### Arena の種類

| 種類 | 特徴 |
|---|---|
| `Arena.ofConfined()` | 単一スレッド専用、明示的クローズ必要（最も一般的） |
| `Arena.ofShared()` | 複数スレッドで共有可能 |
| `Arena.ofAuto()` | GC 時に自動解放 |
| `Arena.global()` | 永続的、解放されない |

### jextract

.h ヘッダから Java バインディングを自動生成するツール。手書き不要になる。

```bash
jextract --output src cairo.h
```

---

## JNI（Java Native Interface）

FFM API 以前のネイティブ連携手段。**現在は FFM API が推奨されており、新規用途では避けるべき。**

### 仕組み

```
Java（native 宣言） → javah で .h 生成 → C で実装 → .dll/.so をビルド → System.loadLibrary()
```

### デメリット

- プラットフォームごとにビルドが必要（ポータビリティを失う）
- 粗悪な C コードで JVM ごとクラッシュするリスク
- GC が効かないためネイティブ側のメモリ管理はプログラマの責任
- C グルーコードを自分で書く必要がある

---

## まとめ：用途別の選択肢

| やりたいこと | 手段 |
|---|---|
| 外部コマンドを実行したい | `ProcessBuilder` |
| ユーザーにスクリプトを書かせたい | `javax.script` + Groovy / GraalVM Polyglot |
| 既存の .so/.dll を呼び出したい | **FFM API**（Java 22+） |
| レガシーな JNI コードを維持する | JNI（新規では使わない） |
| 多言語を JVM 上で統合したい | GraalVM Polyglot API |
