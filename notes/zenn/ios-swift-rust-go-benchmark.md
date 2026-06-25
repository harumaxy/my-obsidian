---
title: iOSアプリでSwift・Rust・Goの実行速度を比較してみた
description: iPhone 17上でFFI経由の他言語組み込みとSwiftネイティブの速度を比較。FFIコストの大きさが判明。
# permalink:  # don't use
aliases:
  - ios-ffi-benchmark
tags:
  - ios
  - swift
  - rust
  - go
  - performance
  - ffi
draft: false
date: 2026-06-25
---

## 一言で言うと

**FFIのオーバーヘッドを甘く見るな。メモリ処理はSwiftで書いた方が速い。**

## 元記事

https://zenn.dev/oba_shion/articles/872ce1434f5fc7

著者: Shion / 公開: 2026年6月23日 / 検証機: iPhone 17

## 検証内容

### テスト1: メモリ/FFIベンチマーク

10.5MB のバイト列に `+31` を加える処理。

| 言語 | 相対速度 |
|---|---|
| Swift | 最速（1x） |
| Go (gomobile) | 約2.5倍遅い |
| Rust (UniFFI) | 約12.4倍遅い |

Swift 圧勝。FFI 境界でのデータコピー・型変換コストが大きく効いている。

### テスト2: CPU計算ベンチマーク

20万以下の素数探索。

| 言語 | 相対速度 |
|---|---|
| Go | 最速 |
| Rust | 中間 |
| Swift | 最遅 |

引数が小さく FFI コストが相対的に小さいため、言語本来の計算性能差が出た。

## 結論

| ユースケース | 推奨 |
|---|---|
| iOS内で完結するメモリ・バイト処理 | Swift |
| CPU集約型の純粋計算 | Go/Rust |
| C/C++の既存ライブラリを使いたい | FFI（しかし境界コストに注意） |

## 感想・コメント

- Rust を組み込んだら速くなるという期待は、**FFI 境界を越えるデータ量を無視していると外れる**
- 主なモチベーションは「速さ」より「エコシステムの借用」になる
  - FFmpeg / OpenCV / libvpx など C/C++ 資産の再利用
  - iOS/Android 共通のビジネスロジックをクロスプラットフォームで書く
- WASM/Emscripten と構造的に同じ問題。「境界を越える回数とデータ量を最小化する」が共通の対処法
