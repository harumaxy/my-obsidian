---
title: Anthropic Scion (Git 代替 VCS)
description: Anthropic が社内で作った Git 代替バージョン管理 Scion の要約と、jj / Sapling との比較
# permalink:  # don't use
aliases:
  - scion
tags:
  - git
  - vcs
  - anthropic
  - monorepo
draft: false
date: 2026-10-15
---

# Anthropic Scion

一次情報: [Redesigning source control at Anthropic](https://www.anthropic.com/engineering/redesigning-source-control) (2026-10-13)

## 結論

- Scion = Anthropic 社内製 VCS。モノレポ Git から 5 か月で移行
- **非公開。リポジトリ無し。リリース予定無し**。「社内構造と密結合」
- Git 全置換 違う。巨大モノレポ + エージェント大群 向け
- 触りたい → jj か Sapling で似た体験

## なぜ作った

- コード書くの もうボトルネック違う。Claude が書く。詰まる場所 = VCS / ビルド / CI
- マージ数: 5 月 約 2,500/日 → 9 月 30,000+/日 (10 倍超)
- main 履歴 約 100GB、圧縮 working copy 25GB 超
- CI checkout 約 2,500 万回/日。素朴に Git で取ると 600PB/日 超
- 回避策 (shallow clone, sparse checkout, promisor remote, mirror 数百台, seed snapshot) 全部延命。seed は main 先頭からズレる、partial clone の diff/blame 壊れやすい
- 根本: Git = 分散・オフライン前提。Anthropic のクライアント = ほぼ常時オンライン agent/job + 正本 1 つ。前提ズレてる

## 設計原則

1. クライアント常時オンライン。必要データ オンデマンド取得
2. 非対称。履歴・blame・commit・merge・rebase = サーバー。クライアント = 小さいキャッシュ + ファイル配置 + FS 監視 + UI
3. API 全部ある。ローカル repo 不要 job 多数。自動 bisect / revert もこれ
4. 水平スケール。全量コピー持つサーバー無し。packfile 無し。repo メンテ無し
5. commit 安い・差分比例・ロック無し。サーバー側 commit なので push 無し。ref は main とリリースブランチのみ推奨 (グローバル状態 = スケール敵)
6. working copy は任意・sparse。CI の多くは checkout 自体しない。仮想 FS で読んだファイルだけ実体化

## アーキテクチャ

- **Changeset** = 作業単位。write-ahead log の 1 エントリ。git commit のように tree 指さない。第 1 親からの変更ファイル一覧 + content-addressed blob ポインタ。サーバー側生成、即全域で利用可
- **Ref 移動** = Spanner 1 行の compare-and-swap。changeset 作成と別
- **Derived data**: blame, path history, skip list を changeset から汎用再帰機構で計算。eager / lazy 選択可。クライアントから内部見えない → 後で最適化しても client 変更不要
- **fetch プロトコル** (クライアント `scn`): 欲しい tree/blob のみ交渉。root tree から再帰的に不足 tree → blob。resumable。巨大 packfile 無し。sparse/virtual checkout 特別対応不要
- **3 層、各層同じ RPC**:
  - `scion-daemon`: ノード毎 1 つ。ソケット経由。定期 snapshot から起動
  - `scion-cache`: リージョン毎。メモリから daemon ディスク形式で stream
  - `scion-server`: 正本。miss 時 Spanner / cloud storage 読む
- 層は厳格。リージョン cache 死んでも上流 圧死しない

## 成果

- 全層 cache hit 率 99% 超
- 旧 Git mirror 比 CPU・メモリ 約 200 分の 1
- CI / 研究 checkout 約 2 桁高速 (分 → 秒)
- CI だけで CPU 容量 25% 解放

## 周辺ツール

- **Antique**: コードレビュー。承認に意味的制約。コメントだけ変更と機微ロジック変更を分離 → 人間は重要レビューに集中
- **IAM**: ディレクトリ単位権限。モノレポの利点保ちつつ機微コード保護
- **コード検索**: 同時期に作った。詳細無し
- **Landing / merge queue**: 従来のグローバルロック不可。post-merge / pre-deploy 自動テストで担保。競合は Claude が人間より速く解決

## 移行・教訓

- 7 人チーム、5 か月で Scion + Antique + 関連ツール約 6 個 + 全移行。その間マージ 10 倍
- 少人数で数年級 移行できる時代
- エンジニアの仕事 = 「Claude に No と言う」。例: merge lookup で commit log 総当たり、過剰防御バリデーション
- レビュー = 行単位でなく意図確認
- Claude のおかげで Scion = 最もテスト厚いコードベースの 1 つ (hermetic simulation, fuzzing, rate limiting)
- Git → Scion 取り込み prototype を Claude Mythos Preview 初期版が書き直し: メモリ 20 分の 1、4 倍速、順序不変条件維持
- 運用: Claude Tag の「熱狂ファン」が各コンポーネント監視。閾値アラートで見えない異常を拾う

## Git コミュニティへの提案

- Scion は公開しない。代わりにアイデア共有
- 期待: サーバーアーキテクチャ革新 / forge 横断で標準化された server-side RPC / 現行と違う negotiation プロトコル / sparse・shallow の組み合わせ可能化
- GitHub / GitLab / OSS と協力したい

## 触れる類似ツール比較 (報道・公式 doc ベース、未検証)

| | Git | jj (Jujutsu) | Sapling |
|---|---|---|---|
| 出自 | - | Google 内部ツール発想 | Meta 製。Mercurial 改造 fork |
| Git 互換 | - | Git backend、既存 remote そのまま | Git 対応あり (GitHub のみ stack PR) |
| 特徴 | 分散・オフライン | 自動 snapshot, change ID, operation log, first-class conflict (非ブロック) | `sl pr submit --stack`, ブロッキング conflict |
| 巨大モノレポ | partial clone / sparse / scalar | partial clone, worktree, hook, submodule, LFS 未対応 (公式 doc 時点) | 設計は巨大モノレポ向け。ただしスケール用サーバー (Mononoke) と仮想 FS (EdenFS) は実質非公開寄り |
| 備考 | | blame/bisect 弱い (古い doc) | jj より完成度高い (jj 公式 doc 評) |

- Scion 思想 (サーバー中心 / changeset / 必要分取得) に最も近い = Sapling の設計思想。ただし本体のスケール部分 手元で使えない
- 日常で触る次世代 VCS = jj が現実的
- 2026 時点ガイド曰く、エージェント並列作業の出発点 = Git worktree + partial clone / sparse checkout。jj は monorepo では穴あり

## 感想・TODO

- Scion 自体は触れない。思想だけ吸収
- 触るなら: jj を実プロジェクトで試す。Git worktree 並列エージェントと比較
- 「ref 最小・サーバー側 commit・即全域可視」は agent 時代 VCS の方向性として覚えておく
