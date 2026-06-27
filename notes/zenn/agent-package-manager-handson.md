---
title: Agent Package Manager (APM) ハンズオン
description: Microsoft製のAIエージェント向け依存関係マネージャー APM の概要と使い方
aliases:
  - APM
tags:
  - AI
  - agent
  - microsoft
  - claude-code
  - devtools
draft: false
date: 2026-06-26
---

出典: https://zenn.dev/microsoft/articles/agent-package-manager-handson

## APM とは

Microsoft が開発したオープンソースの **AI エージェント向け依存関係マネージャー**。`apm.yml` に依存を宣言して `apm install` を実行するだけで、**GitHub Copilot・Claude Code・Cursor・OpenCode** など複数のハーネスに一括展開できる npm ライクなツール。

## 解決する課題

複数の AI エージェントを使うチームでは以下の問題が生じる：

| 課題 | 内容 |
|------|------|
| **集約** | 異なるカタログから skill を集める手間 |
| **配布** | 各ハーネスごとに別の場所に配置する必要 |
| **追跡** | バージョン管理・チーム間の設定同期が難しい |

## 3つの主な価値

1. **オンボーディング** — `apm install` 一発で全ハーネスの設定が揃う
2. **ルール更新の伝搬** — Git 履歴に記録され、`apm.lock.yaml` で 40 桁ハッシュにピン留め（再現性保証）
3. **ハーネス追加への対応** — 新ツールを追加しても過去のルールをそのまま流用可能

## セキュリティ設計

**"File presence IS execution"** の原則（ファイルが置かれた時点で LLM に取り込まれる）に対し：

- **lockfile** に 40 桁コミットハッシュ（タグすり替え攻撃対策）
- **不可視 Unicode 文字**の検出・ブロック（Glassworm 攻撃対策）
- **`apm-policy.yml`** による組織ルール強制（CI でも二重チェック）

## ハンズオン内容

- **① 基本**: `apm install` で再現性のある依存調達
- **② ガバナンス**: GitHub Actions で `apm audit` + SARIF レポートによる違反ブロック

```yaml
# apm.yml の例
dependencies:
    apm:
        - anthropics/skills/skills/frontend-design
        - github/awesome-copilot/plugins/context-engineering
```

ポリシー例（組織レベルで deny リスト）:
```yaml
dependencies:
    deny:
        - "*/evil-*/**"
```

## 所感

Claude Code の superpowers スキルのような仕組みを、**チーム横断・マルチハーネスで標準化**するツール。特に複数の AI ツールを並用している組織では、skill の版管理や配布が大幅に楽になる。セキュリティ面でのアプローチ（ハッシュピン留め・Unicode 検出）も実用的。
