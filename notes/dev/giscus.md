---
title: giscus
description: GitHub Discussionsを利用したコメントシステム
aliases:
  - GitHub Comments
tags:
  - github
  - comments
  - web
draft: false
date: 2026-06-25
---

## 概要

**giscus** は GitHub Discussions を活用したコメントシステム。ブログやドキュメントサイトに埋め込んで、訪問者が GitHub アカウントでコメント・リアクションできるようにする。

## 特徴

- 🔓 **無料・オープンソース**
- 🛡️ **プライバシー重視** - 追跡や広告なし
- 💾 **シンプル** - 外部DB不要、すべて GitHub Discussions に保存
- 🎨 **カスタマイズ可能** - 複数テーマ、設定可能
- 🌐 **多言語対応** - 40+ 言語

## 従来との違い

| 機能 | Issue | Discussions |
|------|-------|-------------|
| **目的** | バグ報告、機能リクエスト | 質問、アイデア交換、コミュニティ対話 |
| **形式** | 個別チケット | スレッド型掲示板 |
| **解決状態** | Open/Closed | Answered/Duplicate など |

## セットアップ

### 必須条件

- 🔓 **公開リポジトリ**（Private は不可）
- Giscus アプリをリポジトリにインストール
- GitHub Discussions 機能の有効化

### 導入方法

設定ページで以下を指定：
1. リポジトリ選択
2. ページ紐付け方法（pathname / URL / title / og:title など）
3. Discussionカテゴリ設定
4. 機能の有効/無効（リアクション、メタデータ出力など）
5. テーマ選択

生成されたスクリプトタグをWebサイトに埋め込むだけで動作開始。

## Script タグの設定属性

### 必須
- `data-repo` - リポジトリ名
- `data-repo-id` - リポジトリID
- `data-category` - Discussionカテゴリ名
- `data-category-id` - カテゴリID

### 紐付け方式
- `data-mapping` - pathname / URL / title / og:title など
- `data-strict` - タイトル完全一致（1/0）

### 機能制御
- `data-reactions-enabled` - リアクション表示（1/0）
- `data-emit-metadata` - メタデータ送信（1/0）
- `data-input-position` - 入力欄の位置（top/bottom）

### 表示設定
- `data-theme` - GitHub Light/Dark など複数選択可
- `data-lang` - 言語選択（40+ 対応）

### その他
- `data-loading` - 遅延読み込み（lazy）
- `crossorigin` - anonymous
- `async` - 非同期読み込み

## 制限

実質的に制限はなし。GitHub Discussions 自体にコメント数上限がないため。制限があるとすれば GitHub の API レート制限のみで、通常のブログなら問題なし。

## 参考

- 公式サイト: https://giscus.app/ja
- Utterances からの移行も可能
