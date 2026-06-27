---
title: Coding Agent スキル・依存管理ツール比較
description: gh skill / APM (Agent Package Manager) などのコーディングエージェント向けスキル管理ツールの概要と使い分け
# permalink:  # don't use
aliases:
  - agent skill management
tags:
  - coding-agent
  - claude-code
  - github
  - devtools
draft: false
date: 2026-06-26
---

## 背景

2026年春頃から、Claude Code・GitHub Copilot・Cursor などのコーディングエージェントに対して
「スキル」（命令セット・手順書・スクリプト）を配布・管理するエコシステムが整備されはじめた。

主なツールは以下の2つ:

- **gh skill** — GitHub 公式の CLI ベーススキル管理（2026/4/16 パブリックプレビュー）
- **APM (Agent Package Manager)** — Microsoft 製のエージェントプリミティブ統合管理

---

## gh skill

### 概要

GitHub CLI に統合されたスキル管理ツール。
個人がスキルを検索・インストール・公開するためのシンプルな仕組み。

**前提:** GitHub CLI v2.90.0 以上

### 主要コマンド

```sh
gh skill search   <query>    # スキルを検索
gh skill preview  <skill>    # インストール前に内容確認
gh skill install  <skill>    # ローカルにインストール
gh skill update   <skill>    # 更新
gh skill publish             # 自作スキルを公開
```

### スキルの構造

- Git リポジトリ上に配置する必要がある
- コミット履歴が必要（`gh skill search` で発見可能になる条件）
- リリースタグで公開バージョンを管理

### セキュリティ設計（3層）

| 層 | 仕組み |
|----|--------|
| **Immutable Releases** | 公開済みリリースをロックして改ざん防止 |
| **Tree SHA** | フォルダ単位のハッシュで改ざん検知 |
| **Portable Provenance** | リポジトリ・バージョン・パスをメタデータに記録 |

→ 配布経路の信頼性を保証する設計。中身の悪意検出は対象外。

---

## APM (Agent Package Manager)

### 概要

Microsoft 製のエージェント向けパッケージマネージャー。
スキル単体だけでなく、複数のエージェントプリミティブ（ツール定義・プロンプト・設定等）を
まとめて管理・配布できる。チーム・組織規模のガバナンスに向いている。

### セットアップ

```sh
apm init                                        # リポジトリ初期化
apm install microsoft/apm-sample-package#v1.0.0 # パッケージインストール
apm audit                                        # ポリシー検証
```

生成されるファイル:
- `apm.yml` — 依存定義
- `apm.lock.yaml` — ロックファイル
- `apm_modules/` — インストール済みパッケージ

### ポリシー管理

`apm-policy.yml` でインストールルールを定義できる。

```yaml
# 例: 特定パターンのパッケージをブロック
rules:
  - pattern: "untrusted/*"
    action: block
```

CI で `apm audit` を実行することでポリシー違反を検出。

---

## gh skill vs APM 比較

| 項目 | gh skill | APM |
|------|----------|-----|
| 提供元 | GitHub (Microsoft) | Microsoft |
| 対象 | 単体スキル | 複数プリミティブの統合 |
| 向き | **個人利用・小規模** | **チーム開発・大規模** |
| セキュリティ | 配布経路の保護 | ポリシーによる中身の制御 |
| 設定ファイル | なし（CLI操作のみ） | `apm.yml` / `apm.lock.yaml` |
| CI 連携 | - | `apm audit` でポリシー検証 |

### 使い分けの指針

- **個人・試用段階** → `gh skill install` で手軽にスキルを追加
- **チーム標準化・ガバナンス必要** → APM で依存を明示・ポリシー管理

両者は競合ではなく**役割分担**。gh skill でインストールしたスキルを APM で管理することも可能。

---

## 参考

- [APMとgh skillによるスキル管理ハンズオン - Zenn](https://zenn.dev/hirayuki/articles/66d27a9a1cfb89)
- [GitHub公式gh skillの使い方とMicrosoft製apmとの違い - aimanavo](https://aimanavo.com/c/morphox_ai/a/jqvkg0f9q1_voA)
