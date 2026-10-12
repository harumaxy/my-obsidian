---
title: Swift 6.4 と Swift Build
description: Swift 公式 2026年9月ダイジェスト要約。Swift Build が SwiftPM デフォルトに。Xcode 不要にはならない。
# permalink:  # don't use
aliases:
  - Swift Build
tags:
  - swift
  - swiftpm
  - build-system
draft: false
date: 2026-10-09
---

# Swift 6.4 と Swift Build

元ネタ: https://x.com/SwiftLang/status/2108352500147605804
→ https://www.swift.org/blog/whats-new-in-swift-september-2026/

## ダイジェスト要点

- Swift 6.4 9月リリース
- Swift Build、SwiftPM デフォルトになった
- Subprocess 1.0
- Embedded Swift 強化
- Vapor 10周年
- Google Cloud 公式 Swift SDK

## Swift Build

- Apple が 2025/2 OSS 化したビルドエンジン。Xcode 中身と同じ。llbuild ベース、Apache 2.0
- 高レベルクライアント(Xcode, SwiftPM)の依頼受けて、ビルド計画と実行する下層部品
- 狙い: Xcode と SwiftPM のビルド挙動を統一。Linux / Windows / Android も同じエンジン
- 6.2〜6.3 は `--build-system swiftbuild` で opt-in。6.4 でデフォルト化
- コマンド変わらない。`swift build` / `swift test` / `swift run`

### Xcode いらなくなる？

- **ならない**。期待は外れ
- 変わるのは SwiftPM のビルド挙動が Xcode と揃う点だけ
- iOS ビルドは Apple SDK とツールチェーン必要。普通 Xcode 同梱。Swift Build が置き換える情報、見つからず
- iOS アプリ本体は署名、アセットカタログ、Info.plist、シミュレータで `xcodebuild` 絡む。未確認
- VSCode / Zed + SourceKit-LSP + `swift build` は前から可能。SwiftPM パッケージ(ライブラリ、CLI、サーバー)なら成立
- 回避策(未検証、一般知識): xcodebuild CLI をエージェントから叩く、XcodeGen / Tuist で `.xcodeproj` 生成

### 誰が得する

- Xcode ユーザー: 元から使用中。変化なし
- SwiftPM ユーザー: 内部エンジン入れ替わるだけ
- Linux / Windows / Android で Swift 書く人: 恩恵大きい
- クロスプラットフォーム パッケージ作者: Xcode と CLI でズレにくい
- GUI アプリもロジック層(SwiftPM パッケージ部分)は恩恵あり。パッケージング部分は Xcode 依存のまま

## Subprocess 1.0

- 外部プロセス起動の公式パッケージ。Foundation `Process` の代替
- curl, jq, sed, awk みたいな CLI を Swift から叩く。終了コード、stdout/stderr 受け取る
- Python `subprocess`、Node `child_process`、Deno `Deno.Command` 相当
- async/await 前提(一般知識)。記事は「1.0 到達」のみ

## Embedded Swift

- マイコン等 小メモリ環境向け Swift サブセット。ランタイム最小、バイナリ極小
- 6.4 で改善。詳細は別記事 "Embedded Swift Improvements Coming in Swift 6.4"
- 事例: Embedded Swift + `@c` 属性で QEMU 上の最小カーネル
- WasmKit 0.4 が ESP32-C6 / Playdate で動く

## Google Cloud Swift SDK

- 公式 SDK。記事も "new SDK" 表記
- SwiftNIO + Swift concurrency。Linux / macOS
- Cloud Storage, IAM, Secret Manager, Gemini ほか 100+ サービス
- gRPC か REST か、記事に記載なし

## 全体像（解釈）

- Swift を Apple 外へ広げる基盤整備の流れ
- Swift Build 統一、Subprocess、Google Cloud SDK、Android workgroup、Windows 対応
- サーバー / CLI / 組み込み Swift 方向

## 未確認・TODO

- Swift Build の iOS アプリビルド範囲(`swiftlang/swift-build` ドキュメント要読み)
- Embedded Swift 6.4 記事
- Google Cloud ブログ(gRPC/REST)

## Sources

- https://www.swift.org/blog/the-next-chapter-in-swift-build-technologies
- https://alternativeto.net/news/2026/9/swift-6-4-brings-better-interoperability-faster-performance-and-swift-build-by-default/
- https://www.martincid.com/technology-sv/swift-6-4-one-build-system-mac-windows-linux-android/
- https://devclass.com/2025/02/04/apple-open-sources-swift-build/
