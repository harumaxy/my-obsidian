---
title: 今だから押さえておきたいソフトウェア工学のベストプラクティス
description: AIエージェント時代に必要な12のベストプラクティス
tags:
  - zenn
  - software-engineering
  - ai-agents
  - best-practices
draft: false
date: 2026-06-24
---

## 記事概要

AIエージェント時代のソフトウェア工学における12のベストプラクティスについてまとめた記事。

AIエージェントは「規律の増幅器」であり、ルールが無ければスコープが際限なく広がる。エンジニアが明確なガイドラインを設定することが重要。

## 12のベストプラクティス

### 1. 検証可能な要求
- 完了条件をコマンドや観測可能な状態で定義する
- 曖昧さを排除

### 2. 小さく、理由を1つに
- 1つの変更に1つの理由を持たせる
- スコープを厳密に管理

### 3. テストは契約
- テスト実行をコマンドに含める
- 装飾ではなく検証手段として機能させる

### 4. 境界を明示する
- sandbox、MCP、環境変数で権限や範囲を見える化
- 実行権限の制限を明確に

### 5. 追跡可能性
- 判断を `_docs` などに記録
- なぜその判断をしたのかを後追いできるように

### 6. 関心の分離
- 1ファイル1役割の原則を守る
- 責任を明確に分離

### 7. 型と静的解析
- 実行前の検査を活用
- エラーを早期に発見

### 8. 失敗は早く、はっきり
- エラーを握りつぶさない
- 問題を即座に顕在化させる

### 9. YAGNI (You Aren't Gonna Need It)
- 過剰設計を避ける
- 必要な抽象化のみ実装

### 10. CI は共有の真実
- ローカルと CI コマンドを一致させる
- 環境差異を排除

### 11. レビューはまだ必要
- 自動生成コードも意図とリスクを確認
- 完全自動化を避ける

### 12. 人間のゲート
- 本番デプロイや秘密操作は自動完遂させない
- 重要な操作は人間のゲートを設ける

## 実装のコツ

1. **`AGENTS.md` に規則を集約**
   - エージェントの行動規則をファイル化

2. **`_docs` に設計判断を保存**
   - なぜその判断をしたのか記録

3. **段階的アプローチ**
   - ① まず Done をコマンド化
   - ② 依頼外変更禁止ルール導入
   - ③ 判断・決定を記録

## 感想

AI時代のソフトウェア開発では、AIの能力を最大限活用しつつ、人間による明確な方針設定が不可欠という考え方が一貫している。特に「12. 人間のゲート」の強調は、完全自動化の危険性を認識した現実的なアプローチ。

参考: https://zenn.dev/zapabob/articles/software-engineering-best-practices-agent-era


エージェント向けミニ憲法（コピペ用）
```md
## Engineering practices (always)
- Requirements must be verifiable: Done lists commands and expected outcomes.
- One change, one reason. No drive-by refactors.
- Run documented test/lint/typecheck before claiming Done.
- Do not commit secrets, tokens, or personal paths.
- Put design decisions in `_docs/`, not only in chat.
- Prefer extending existing patterns over new abstractions (YAGNI).
- MCP and destructive ops: opt-in and approval only.
- Local Commands must match CI; report if they differ.
- ```
