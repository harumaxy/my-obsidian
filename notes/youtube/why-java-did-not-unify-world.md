---
title: なぜ世界はJavaに統一されなかったのか
description: Java 勝った。でも統一できなかった。理由5章 + 追加Q&A
# permalink:  # don't use
aliases:
  - Java 統一されなかった
tags:
  - youtube
  - java
  - jvm
  - history
draft: false
date: 2026-10-10
---

# なぜ世界はJavaに統一されなかったのか

- 動画: https://www.youtube.com/watch?v=9KfUY3RnJL8
- チャンネル: IT技術屋のボヤキ
- 結論: Java 勝った。でも統一せず。「どこでも動く」思想だけ業界全体に残った。

## 1. 誕生

- 1991年 Sun Microsystems の Green Project。中心 James Gosling。
- 最初の狙い = TV セットトップボックス(STB)。メーカーごと CPU 違う。C++ だと機種ごと作り直し。
- 解決 = 仮想マシン(JVM) + バイトコード。架空 CPU 向けコンパイル。JVM 乗ってれば同じ動く。
- 名前 最初 Oak。商標問題で Java に改名。
- TV 市場は売れず。ケーブル TV 会社が採用せず。
- 1995年 SunWorld 発表。Netscape がブラウザ搭載宣言。「Write Once, Run Anywhere」誕生。
- Green Project 最初の試作機 = `*7`(Star Seven) 手持ち双方向端末。STB は次の目標。
- TV 用 VM が たまたま Web 時代に刺さった。

### STB とは

- TV に繋ぐ小型受信・制御機器 (set-top box)。
- ケーブル/衛星放送受信、録画、番組表、VOD。
- 日本の例: ケーブル TV チューナー、スカパー!、地デジ/BS チューナー、Apple TV、Fire TV Stick。

## 2. 勝った面

- 「30億デバイスで Java」。主力ガラケー。日本 iアプリ(2001年〜) ほぼ Java。
- サーバー側: 銀行、証券、EC、エンタープライズ。「迷ったら Java」。
- Hadoop, Kafka, Elasticsearch も JVM 上。Minecraft も Java。
- 2000年代半ば、携帯 + サーバー + 業務を押さえ、統一まであと一歩。

## 3. 技術的に取りこぼした領域

- ブラウザ: アプレット。JVM 起動遅い、セキュリティホール多い。Flash → JavaScript に負け。2015年 Chrome プラグイン廃止で消滅。
- CLI / スクリプト: JVM 起動 + メモリ重い。Perl / Python が取った。
- OS / 組み込み / 高頻度取引: GC 停止が許されない。C / C++ 残った。
- 「どこでも動く」≠「どこでも最適」。JVM 実装差で環境ごと検証必要。Write Once, Debug Everywhere。

## 4. 政治・法務

- 1997年 Microsoft が J++ (Windows 専用拡張入り独自 Java)。Sun 提訴、勝訴。報復で Microsoft は 2000年 C# 作る(Anders Hejlsberg)。
- 2010年 Oracle が Sun を約74億ドルで買収。同年 Google 提訴(Android が Java API 無断使用、最大約90億ドル請求)。
- 2021年 連邦最高裁 6対2 で Google フェアユース。決着まで11年。
- Google は保険: 2017年 Kotlin 公式サポート、2019年 推奨言語。
- 2019年 Oracle JDK ライセンス変更で混乱。
- 統一を最後に阻んだのは性能でなく、所有者への不信。

### J++ とは

- Microsoft 製 Java 実装(Visual J++ + Microsoft JVM)。C → C++ 的な別言語ではない。
- 文法 Java そのもの。独自拡張: COM 連携、J/Direct(Win32 直呼び)、delegate / event 構文。
- 使うと Windows でしか動かない → WORA 崩壊 → Sun 提訴。
- J++ 捨てて .NET / C# へ。C# の delegate / event は J++ の流れ。

## 5. 逆転の視点

- 2013年 Docker 登場。依存ごとコンテナ化、どのサーバーでも同じ動く。WORA をインフラ側が実現。
- 移植性は言語の売りからインフラの標準機能に格下げ。統一の必要そのもの消えた。
- JVM は勝った。Kotlin, Scala, Clojure 全部 JVM 上。
- 言語は統一されず。思想「動く場所から自由になる」は全員に統一された。

## 追加メモ (Q&A)

### C# と Java

- C# 設計上 Java 系。クラス中心、単一継承 + interface、GC、中間言語(CIL) + VM(CLR)。
- C# 独自: プロパティ、delegate / event、LINQ、async/await、struct(値型)、実行時に型情報残るジェネリクス。
- 「トップレベルに関数書けない」は古い。C# 9 (2020) トップレベルステートメント。Java 21〜25 も unnamed class + instance main で追従。入門の敷居を後から削る流れ。

### Java が今も向く領域

- 長時間常駐のサーバー側業務システム。
- JIT で動かすほど速くなる。JVM 起動の遅さは1回払えば済む。
- スループット重視なら GC の一瞬停止は許容。
- 大規模・長期保守: 静的型、IDE、後方互換、Spring エコシステム、人材豊富。
- 弱点も緩和中: GraalVM Native Image / CRaC で起動改善。ZGC / Shenandoah で GC 停止ミリ秒未満へ。

### スケールアウト時代の弱点

- コンテナ頻繁に立てて落とす運用では、Java 起動数秒〜数十秒 + メモリ数百MB はコスト高。
- JIT 暖機が必要。起動直後遅い。
- FaaS(Lambda 等) でコールドスタート致命傷。
- 新規の軽量サービスは Go / Node.js / Rust / Python が選ばれやすい。
- 対策: GraalVM Native Image(ビルド重い、リフレクション制約)、CRaC / SnapStart、Quarkus / Micronaut。
- 常時稼働の中〜大規模なら、ローリングデプロイで吸収できる。

### 新規採用メリット

- 選ぶ理由: 採用市場広い、Spring Boot + 業務ライブラリ厚い、常駐スループット高い、Virtual Threads(Java 21)、長期保守性、既存 Java 資産連携。
- 他を選ぶ理由: 小規模・スタートアップは TypeScript / Go / Python / Ruby が軽い。サーバーレスは Go / Node.js / Rust。フロントと言語統一なら TypeScript。
- Java 以外の JVM 新規採用は Kotlin が一番多い(簡潔、null 安全、Java 資産使える)。
- 大規模・長期運用・採用重視なら合理的。軽量サービス・個人開発は積極的に選ぶ理由薄い。
