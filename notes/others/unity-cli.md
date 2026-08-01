---
title: Unity CLI
description: UnityをCLIから操作するツール。CI/CD・AIエージェント連携向け
aliases:
  -
tags:
  - unity
  - cli
  - ci-cd
draft: false
date: 2026-08-01
---

## 概要

2026/07/20 発表。Unity Editor 管理・操作をターミナルから行うツール。
Unity Hub (GUI) 不要のネイティブバイナリ。

参考: https://note.com/npaka/n/n00f0b44457a2

## インストール

```bash
# macOS/Linux
curl ... | sh

# Windows PowerShell
irm ... | iex
```

確認: `unity --version`

## 基本コマンド

```bash
unity install lts                        # LTS インストール
unity install 6.0.0 -m android ios webgl # モジュール付き
unity open ./MyProject                   # プロジェクト起動
unity auth login                         # アカウント認証
unity doctor                             # 環境診断
```

## CI/CD 活用

- JSON/TSV 出力 → スクリプト解析可能
- GUI スキップ → ヘッドレス実行
- サービスアカウント認証 対応
- GitHub Actions / Jenkins に組み込み可能

```bash
# CI 典型フロー
unity install lts -m webgl
unity open ./Project
# → ビルド実行
```

## Unity Pipeline (実験的, Unity 6.0 LTS以降)

起動中 Editor を外部から操作できる API。

- C# `CliCommand` 属性でカスタムコマンド定義
- `eval` でコード実行
- 開発用 Player の遠隔操作

```csharp
// カスタムコマンド定義例
[CliCommand("open-scene")]
public static void OpenScene(string path) {
    EditorSceneManager.OpenScene(path);
}
```

```bash
unity pipeline open-scene Assets/Scenes/Main.unity
```

## AI エージェント連携

```
AI エージェント
  → unity CLI (Pipeline API)
  → カスタム CliCommand (C# 定義)
  → シーン実行 / スクショ / ログ取得
  → JSON レスポンス → AI 判断 → 次アクション
```

- 構造化出力 (JSON) → LLM パース → 自動修正ループ
- `eval` で `ScreenCapture.CaptureScreenshot()` 呼び出し → スクショ取得
- E2E テスト的な自動化 理論上可能

## E2E テスト (現実的な選択肢)

Unity Test Framework (UTF) + CLI が今は安定。

```bash
unity -runTests -testPlatform PlayMode -testResults results.xml
```

Pipeline API は実験的 → 本番運用はまだ早い。
