---
title: google/ax 要約
description: エージェントのセッションを Task 単位で宣言し、サンドボックスで大量に動かす Kubernetes 風オーケストレーター。概要、仕組み、ユースケース
aliases:
  - google-ax
  - ax
tags:
  - agent
  - kubernetes
  - orchestration
  - google
draft: false
date: 2026-11-09
---

google/ax (Agent Executor)。エージェント作業を Kubernetes 風の YAML で宣言し、サンドボックスで大量に実行する。
元ネタ: [[agent-skills-tools-clips-2026-11]]

- repo: https://github.com/google/ax (ローカル: `~/ghq/github.com/google/ax`)
- Go、Apache-2.0。星 約 14.6k、2026-03-30 作成、最終コミット 2026-11-05 (活発)。
- README 冒頭に警告: 開発の初期段階で、安定版の前に**大きな破壊的変更**が入る可能性が高い。API は `ax.io/v1alpha1`。
- 実行基盤は **Agent Substrate** (`agent-substrate/substrate`)。AX は、その上で動く制御層。

## 要するに

- エージェント 1 セッション = 1 Task = 隔離された実行環境。それを YAML で宣言し、クラスタ上に大量にデプロイして管理する。
- 実体は Kubernetes の Pod ではなく、Agent Substrate の **actor** (gVisor 製のサンドボックス。WorkerPool のワーカーに割り当てられる)。
- Pod との違い: **状態ごと停止と再開ができる** (`suspend` でメモリとファイルをチェックポイント → `resume` で続きから)。
- 状態の保存先は etcd ではなく **PostgreSQL**。数百万の短命な Task を CRD に置くと etcd の限界を超えるため。
- Kubernetes が「サービスやバッチを動かす基盤」なら、AX は「エージェントのセッションを動かす基盤」。

## 3 つのリソース

- **`Task`**: 隔離実行の最小単位。イメージ、コマンド、CPU とメモリの上限、環境変数、`Workspace` の参照。1 つのエージェントは、1 つの Task か、Task が増やす木構造になる。
- **`Workspace`**: エージェントが仕事を始める前の準備を、宣言して使い回す。Git リポジトリの clone、MCP サーバーとレジストリ、スキルのレジストリ、`AGENTS.md` などのファイル。
- **`Model`**: LLM プロバイダ、モデル名、パラメータ、認証情報 (Kubernetes の Secret への参照)。キーの差し替えやモデルのバージョン固定が `ax apply` 1 回で済む。

## CLI (kubectl 風)

- `ax apply -f task.yaml`、`ax get tasks`、`ax describe task X`、`ax delete`。
- エージェント向けの動詞: `ax suspend` / `ax resume`、`ax ssh` (実行中のサンドボックスに入る。Task に `debug: true` が必要)。
- `kubectx` と連動する。

## 構成 (`DESIGN.md`)

- `ax` (CLI)、`ax-server` (gRPC API、PostgreSQL、分散ロック)、`ax-task-runner` (各コンテナ内でワークスペースを用意してエージェントのコマンドを実行)。
- AX が持つのは仕様とメタデータだけ。実行中の状態は Agent Substrate から読み、コピーを持たない。

## 試すハードル

- Agent Substrate が入った Kubernetes クラスタ、Go、`kubectl`、コンテナのレジストリが必要。
- `make images` でビルド、`make deploy` で制御層をデプロイ。**WorkerPool は自動で作られず**、無いと最初の `resume` が失敗する。
- 例: `examples/` に `simple.yaml`、`claude-code`、`workerpool.yaml`。

## ロードマップ (`docs/roadmap.md`)

- 実行状態を保ったまま Task を**分岐 (フォーク)** して、複数の経路を並列に試す。
- アイドル検出による自動 suspend (密度の向上)。
- Task ごとの SPIFFE ID による相互 TLS、予算の上限、監査、OpenTelemetry による軌跡の収集。
- ワークスペースの準備と、タスク実行を別 actor に分けて、権限を最小にする。

## 嬉しい点

ローカルで数個動かすだけなら何も嬉しくない。大量に、または人のいない場所で動かすときだけ効く。

- **同時実行数**: 手元の PC は数個で頭打ち。クラスタなら数百から数千を並列に動かせる。
- **隔離**: エージェントは任意のコマンドを実行する。サンドボックスに閉じ込めれば、暴走や悪い指示の被害がその中で止まる。
- **無人運用**: PC を開いていなくても動く。夜間や長時間の作業を任せられる。
- **コストの制御**: CPU とメモリの上限、実行時間の予算で、ループによる費用の増加を止める。
- **環境の再現**: `Workspace` を宣言して使い回す。
- **一時停止と再開**: 待機中のエージェントを suspend して資源を返せる。人の承認待ちが長いときに効く。
- **共通の管理**: `ax get tasks` で一覧、`ax ssh` で様子を見られる。

## ユースケース (私の推測。公式の導入事例は未確認)

公式の使用例は、コーディングエージェント (Claude Code の Dockerfile、リポジトリの修正) だけ。以下は構造からの推測。

1. **大規模なコード変更の一括処理** (最も現実的): 数百から数千のリポジトリに、同じ指示を並列に実行する。ライブラリの移行、非推奨 API の置き換え、脆弱性の一括修正。1 リポジトリにつき 1 Task、結果は PR で返す。
2. **バックログの自動処理**: 溜まった Issue や小さなバグを、1 件ごとに 1 Task で並列に処理。人間は PR のレビューだけ。受託や SI の保守案件にも当たる。
3. **顧客や取引先ごとの隔離された作業環境**: 取引先ごとに別の Workspace を用意し、データが混ざらないようにする。隔離と監査の要件を満たしやすい。顧客向けサービスの実行基盤にもなる。
4. **評価と実験**: モデルやプロンプトを変えながら、同じ課題の集合に数千回を並列に走らせて比較。Task のフォークは、探索型の実験に向く。
5. **無人の運用エージェント**: PR が出たらレビュー、障害の一次調査、夜間のテスト失敗の調査。都度 Task を作って、終わったら破棄。
6. **社内のエージェント基盤**: 各チームが個別に動かすと、認証情報やモデルの契約が散らばる。`Model` と `Workspace` で基盤側が統制する。「エージェント版 PaaS」。

向かない: 人が画面を見ながら対話して進める作業、数個しか動かさない用途、サンドボックスに持ち込めない環境。
目安: 「同じ作業を、多数の対象に、人を待たずにやらせたい」なら候補。数十以上の並列から。それ未満なら、CI のジョブ (GitHub Actions など) でエージェントを動かすほうが手軽。

## 所感と判断

- **個人利用には過剰**。Kubernetes クラスタが前提で、破壊的変更も続く段階。判断は見送り。
- 参考になる発想: `Workspace` (エージェントの環境を宣言して使い回す)、suspend / resume、`Model` の一元管理。

## 注意: 名前の混同

- 記事のクリップ「AI 使うなら入れる Agent Skill 4選」にも `ax` が出てくる。そちらは「Web ページ取得」のスキルで、別物と見ている (記事は未再確認)。

## 未確認

- README、`DESIGN.md`、`docs/` の一部 (concepts、roadmap) まで。Go のソースと Agent Substrate 本体は未読。実際には動かしていない。
- Google 社内での使われ方、実際の導入事例は未確認。
