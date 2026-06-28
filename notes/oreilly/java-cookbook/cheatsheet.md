---
title: Java Cookbook チートシート
description: Java Cookbook (O'Reilly) の学習メモ・超要約
aliases:
  -
tags:
  - java
draft: false
date: 2026-06-27
---

## 実行環境

| 概念 | 説明 |
|---|---|
| **JDK** | Java 開発キット。コンパイラ(javac)・JVM・標準ライブラリを含む |
| **JRE** | Java 実行環境。Java 9以降廃止。今は JDK のみ |
| **JVM** | Java 仮想マシン。`.class` ファイルを実行する |
| **JAR** | クラスファイルをまとめた ZIP。ライブラリ or 実行可能アプリとして使う |
| **CLASSPATH** | JVM がクラスを探すパスの設定 |

## バージョン

| バージョン | 備考 |
|---|---|
| Java 8 | 非推奨。新規開発で使うべきでない |
| Java 17 | LTS。まだ現役だが古め |
| **Java 21** | 現行 LTS。これから始めるならここ |
| Java 24 | 最新リリース（2024年時点） |

## コンパイル・実行

```bash
javac HelloWorld.java   # コンパイル
java HelloWorld          # 実行
java HelloWorld.java     # Java 11+ : コンパイル不要で直接実行
java --release 17 ...   # 特定バージョン向けにコンパイル
```

## クラスレスメイン（Java 21+ プレビュー）

```java
// 従来
public class Main {
    public static void main(String[] args) { ... }
}

// Java 21+ プレビュー
void main() {
    System.out.println("Hello");
}
```

## 配布方法

| 方法 | 説明 |
|---|---|
| JDK インストール | ユーザーに JDK を入れてもらう（手間あり） |
| **jlink** | 必要モジュールだけ含んだ JVM 同梱バイナリを生成 |
| **GraalVM native-image** | JVM 不要のネイティブ実行ファイルを生成。起動爆速 |

## GraalVM

- 多言語対応の JVM 実装
- **Truffle**: JS/Python/Ruby/R を JIT 実行するフレームワーク
- **JVM 言語**（Java/Kotlin/Scala/Clojure）: JVM バイトコードとして動く
- **C/C++**: LLVM ビットコード経由（Sulong）で動く
- 言語間の相互呼び出しがゼロコストで可能
- 本命は Java アプリの **native-image** によるネイティブバイナリ化

## コード構造

| 単位 | 説明 |
|---|---|
| **クラス** | メソッド・フィールドのまとまり |
| **パッケージ** | クラスの名前空間。`com.example.foo` 形式 |
| **モジュール（JPMS）** | Java 9+。パッケージ間のアクセス制御・依存管理。`module-info.java` で定義 |

## ビルドツール

| ツール | 設定ファイル | 備考 |
|---|---|---|
| **Maven** | `pom.xml`（XML） | 老舗。シェアが多い |
| **Gradle** | `build.gradle`（Groovy/Kotlin） | 速い・簡潔。Android 必須 |

```bash
mvn compile      # コンパイル
mvn test         # テスト
mvn package      # JAR 生成
mvn clean        # 成果物削除
```

依存ライブラリは **Maven Central** から自動 DL → `~/.m2/repository/` にキャッシュ。

## テスト（JUnit / Hamcrest / Mockito）

### JUnit（テスト実行基盤）

- テストクラスを `src/test/java/` に置き、`@Test` を付けるだけ
- `mvn test` で全テストを自動実行。失敗するとビルドが止まる
- **JUnit 5（Jupiter）** が現在の標準

```java
class PersonTest {
    @BeforeEach void setup() { p = new Person("Ian", "Darwin"); }

    @Test
    void testName() {
        assertEquals("Ian Darwin", p.getFullName());
    }
}
```

### Hamcrest（読みやすいアサーション）

- `assertEquals` より英語として読めるアサーションを書けるマッチャーライブラリ
- 失敗時のメッセージが `Expected: > 100 but: <42>` のように親切

```java
assertThat(name, equalTo("Ian Darwin"));
assertThat(score, greaterThan(0));
assertThat(text, containsString("hello"));
assertThat(list, hasItem("foo"));
```

### Mockito（モックオブジェクト）

- 依存クラスを偽物に差し替えてテストを独立させる
- スタブしていないメソッドはデフォルトで `null` / `0` を静かに返す（バグ見逃しリスクあり）

```java
Database db = mock(Database.class);
when(db.findUser(1)).thenReturn(new User("Ian"));  // スタブ
verify(db).findUser(1);                             // 呼ばれたか検証
```

| | `mock()` | `spy()` |
|---|---|---|
| 未スタブのメソッド | null/0 を返す | 本物の実装を呼ぶ |

**STRICT_STUBS** → 未スタブのメソッドが呼ばれたら例外を投げる（推奨）:

```java
@MockitoSettings(strictness = Strictness.STRICT_STUBS)
```

### 関数DIでモックを不要にする

クラス全体ではなく**関数を依存として受け取る**と、ラムダで差し替えられてモック不要になる。

```java
// クラスDI（モック必要）
class OrderService {
    private final Database db;
}

// 関数DI（ラムダで済む）
class OrderService {
    private final Function<Integer, User> findUser;
}

// テストはラムダを渡すだけ
var service = new OrderService(id -> new User("Ian"));
```

| 型 | シグネチャ | 用途 |
|---|---|---|
| `Supplier<T>` | `() -> T` | 値を生成 |
| `Consumer<T>` | `T -> void` | 値を消費 |
| `Function<A, B>` | `A -> B` | 変換 |
| `Predicate<T>` | `T -> boolean` | 条件判定 |

## CI（継続的インテグレーション）

- コミットのたびに自動でビルド＆テストを実行し、コードが壊れていないことを保証する
- **Jenkins**: `java -jar jenkins.war` で起動。ブラウザで操作するセルフホスト型CI
- **GitHub Actions / CircleCI**: リポジトリに設定ファイルを置くだけのホスト型CI

| ツール | 種別 |
|---|---|
| Jenkins | セルフホスト（自分でサーバ管理） |
| GitHub Actions | ホスト型（設定は `.github/workflows/*.yml`） |
| CircleCI / TeamCity | ホスト型商用 |
