---
title: "Java Cookbook Ch17 - Reflection"
description: "Javaのリフレクション機能の概要・用途・API解説"
# permalink:  # don't use
aliases:
  - Java Reflection
tags:
  - java
  - reflection
  - metaprogramming
draft: false
date: 2026-06-28
---

# Java Reflection（リフレクション）

## Reflection とは

JVMから実行時にクラス情報を動的に取得・操作できる機能。`java.lang.reflect` パッケージと `java.lang.Class` クラスが中心。

**名前の由来**：鏡が光を反射して自分の姿を映すように、プログラムが自分自身の構造を「内省（reflect on itself）」するというメタファーから。

## なぜ使うのか（用途）

| 用途 | 具体例 |
|------|--------|
| DI フレームワーク | Spring が `@Autowired` フィールドを発見してインジェクション |
| シリアライズ/デシリアライズ | Jackson が全フィールドを走査して JSON 変換 |
| ORM | JPA が `@Column` を読んでDBマッピング |
| テストフレームワーク | JUnit が `@Test` メソッドを自動発見・実行 |
| プラグインシステム | 後から追加された JAR を動的ロードして実行 |

**本質**：「フレームワーク側がユーザーのコードを知らなくてもいいようにする」

## メタプログラミングのコスト比較

```
コンパイル時          起動時              実行時（ホットパス）
    │                   │                       │
  マクロ             Reflection（DI）         eval・クォート
  Lombok（APT）      Spring 初期化            動的ディスパッチ
  プリプロセッサ      アノテーション処理
```

Spring AOT / GraalVM Native Image は「起動時 Reflection → コンパイル時コード生成」へ移行することでコールドスタートを解決する方向に進んでいる。

## 主要 API

### クラス記述子の取得

```java
// コンパイル時に型がわかっている場合
Class<String> c1 = String.class;

// インスタンスから取得
Class<?> c2 = obj.getClass();

// 文字列から動的ロード
Class<?> c3 = Class.forName("com.example.MyClass");
```

### フィールド・メソッドの取得と操作

```java
// フィールド取得・値読み出し
Field f = clazz.getDeclaredField("name");
f.setAccessible(true);
Object value = f.get(instance);

// メソッド取得・呼び出し（プリミティブ型は int.class を使う）
Method m = clazz.getMethod("doSomething", int.class);
m.invoke(instance, 42);
```

### MethodHandle API（Reflection より高速・推奨）

```java
MethodHandles.Lookup lookup = MethodHandles.lookup();
MethodType mt = MethodType.methodType(String.class, int.class);
MethodHandle mh = lookup.findVirtual(String.class, "substring", mt);
String result = (String) mh.invoke("hello", 2);
```

## アノテーション

### 定義

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyAnnotation {
    boolean fancy() default false;
}
```

- `@Target`：使用可能な場所を制限（TYPE / METHOD / FIELD 等）
- `@Retention(RUNTIME)`：実行時にフレームワークが検査するために必要

### 実行時検査

```java
for (Method m : clazz.getMethods()) {
    if (m.isAnnotationPresent(MyAnnotation.class)) {
        m.invoke(instance);
    }
}
```

## 高度な API

### ClassLoader（動的クラスロード）

```java
URLClassLoader loader = new URLClassLoader(new URL[]{ jarUrl });
Class<?> clazz = loader.loadClass("com.example.Plugin");
```

名前空間の衝突回避、Webアプリサーバーのクラス分離などに使用。

### JavaCompiler API（実行時コンパイル）

```java
JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
// ソースをメモリ上で生成してコンパイル → Class.forName でロード
```

### Class-File API（Java 最新機能）

Reflection の限界を超え、バイトコードレベルで直接クラスを生成・変換できる。AOP実装やパッケージ名一括変換（`javax.*` → `jakarta.*`）等に使用。

## ネストメイト（Java 11）

内側クラスが外側クラスのプライベートメンバーに直接アクセスできるようになった（従来はコンパイラが隠れた「ブリッジ」メソッドを自動挿入していた）。

```java
clazz.getNestHost();          // 外側クラスを取得
clazz.isNestMateOf(other);    // ネストメイト判定
clazz.getNestMembers();       // ネストメンバー一覧
```

## セキュリティリスク

**「外部入力がクラスロード・コード生成のパスに入り込む」ことが危険。**

```java
// 危険：ユーザー入力をそのまま Class.forName に渡す
Class<?> c = Class.forName(request.getParameter("class")); // RCE
```

**Log4Shell（CVE-2021-44228）** はこのパターンの実例。JNDI ルックアップ経由で外部から任意クラスをロード・実行された。

防御：許可リストで絞り込む、外部入力をクラスロードのパスに入れない。

## 参考ライブラリ

- **Apache Commons BeanUtils**：Reflection を使ったBean操作ユーティリティ
- **BCEL（Byte Code Engineering Library）**：バイトコード操作ライブラリ
