---
title: Claude Code でチーム開発ルールを自動化する (team-dev-kit)
description: Skill/Hook でドキュメント運用から自動化運用へ
permalink:
aliases:
  - claude-code-team-dev-kit
tags:
  - Claude Code
  - チーム開発
  - 開発プロセス
draft: false
date: 2026-06-21
---

## 概要

チーム開発のルール（コミット形式、ブランチ運用、Issue/PR の紐付けなど）を、従来のドキュメント（人が読んで覚える）から **Skill と Hook**（AI と機械が自動で適用）に移行する team-dev-kit というツール。

## 問題

- チームのルールは README/Wiki に書かれるが、メンバーが全部覚えられない
- レビューで毎回同じ規約違反を指摘することになる
- 新しいメンバー参加時に同じオンボーディング説明を繰り返す

## 解決策

### Skill（自然言語指示）
- Claude Code がルールを読んで正しいやり方に導く
- 確率的（見落とし可能性あり）
- 文脈で正解が変わるもの（コミット形式・PR 運用・文書の文体）に向く

### Hook（自動検査プログラム）
- commit/push 時に機械で確定的に止める
- 秘密情報・個人情報の混入防止など「絶対に超えさせない一線」に向く
- 人手修正でも機械が検査する（pre-commit hook）

## 実例

```
Claude Code に頼む：
「Rust で Hello, World! を作成。Issue から PR マージまで、
このリポジトリのルールに従って」
```

自動で実行される：
- ✅ 適切なブランチ名（`feature/5-rust-hello-world`）の自動作成
- ✅ 規約に従ったコミットメッセージの生成
- ✅ Issue と PR の双方向リンク（`Closes #N`）
- ✅ squash マージ時に Issue の自動クローズ
- ✅ 秘密情報の pre-commit hook 検査

## Key Points

1. **Skill は確率的** → 見落とし可能性がある
2. **Hook は確定的** → 絶対に止める
3. **二重防御** → Skill で導く + Hook で最終防線
4. **人が払うコストを削減** → 暗記・注意力が不要

## 導入対象

✅ 複数人・複数リポジトリでチーム開発
✅ 新しいメンバーの出入りが多い
✅ レビューで規約違反を毎回指摘している
✅ 秘密情報コミットを仕組みで防ぎたい

❌ 単一開発者の趣味プロジェクト

## 注釈

Skill は確率的なため、lint/format など重要なルールは **git hook（husky など）も併用**した方が良い。
Claude Code 経由以外での手修正でも Hook が全員の commit を確定的に止められるから。

## 参考

- リポジトリ: https://github.com/aRaikoFunakami/team-dev-kit
- 検証用サンドボックス: https://github.com/aRaikoFunakami/sandbox-team-dev-kit
