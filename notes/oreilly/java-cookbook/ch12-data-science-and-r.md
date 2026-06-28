---
title: "Java Cookbook 第5版 第12章 データサイエンスとR"
description: JavaエコシステムとR言語・Sparkの統合
# permalink:  # don't use
aliases:
  -
tags:
  - java
  - r
  - spark
  - data-science
draft: false
date: 2026-06-28
---

## 概要

JavaエンジニアがデータサイエンスをJVMの範囲内で完結させるための章。PythonやRに乗り換えなくても、Renjin・Spark・rJavaを組み合わせることで統計処理・大規模データ処理・Web公開まで対応できる。

## R言語

- 1995年にS言語（AT&Tベル研究所）のOSSクローンとして開発
- C/Fortranで実装されており、JavaとはRenjinを介して連携する
- 統計・ベクトル演算・可視化が強みの実質的なDSL
- Pythonが`pandas`/`numpy`/`scipy`でRの機能をほぼカバーしたため、現在は統計・疫学・バイオ系の既存資産として生き残っている状況

## Renjin

- JavaによるRの再実装（サードパーティ製）
- MavenやGradleで依存追加でき、`ScriptEngine`経由でJavaからRコードを実行できる
- JavaエコシステムとRを統合するための橋渡し

## JavaとRの双方向統合

- **JavaからR**: Renjinの`ScriptEngine`を使い、Java変数をRに渡して統計処理
- **RからJava**: `rJava`パッケージの`J()`・`.jcall()`・`.jnew()`でRセッションからJavaメソッドを呼び出す
- **Web公開**: ShinyフレームワークやJavaサーバー経由でRの分析結果をWebアプリとして公開

## Apache Spark

- Scala製の大規模データ分散処理エンジン（Java/Python/Rからも使える）
- Java Stream APIと似たAPIで、裏で複数マシンに自動分散される
- 単一マシンのメモリに乗り切らないTB〜PBのデータを処理するためのもの
- MapReduceより高速（中間結果をメモリ保持するため）

### Sparkの耐障害性

- ストレージ層（S3など）の耐障害性とは別レイヤーの話
- Workerマシンがクラッシュしても、計算履歴（リネージ）を記録しているため、その部分だけ自動的にやり直せる
- 現代ではAWS EMR・Databricks・Google Dataprocなどマネージドサービスが耐障害性を担ってくれる

### SparkとGPU

- SparkはCPU+メモリのタスク分散が基本
- NVIDIAのRAPIDSプラグインでDataFrame処理をGPUオフロードも可能だが別途設定が必要
- GPUはデータ並列（行列演算・深層学習）、Sparkはタスク並列（ETL・ログ解析）と守備範囲が異なる
