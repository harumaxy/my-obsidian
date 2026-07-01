---
title: E2B - エンタープライズAIエージェント向けクラウド
description: AIエージェント向けのサンドボックス実行環境プラットフォーム
aliases:
  - E2B Sandbox
tags:
  - AI
  - Sandbox
  - Infrastructure
  - Cloud
draft: false
date: 2026-06-24
---

## 概要

E2B は、**AIエージェントが安全にコードを実行できる隔離されたクラウド環境（サンドボックス）を提供するプラットフォーム**。Fortune 100企業を含む多くのエンタープライズが採用。

- **セキュリティ**: Firecracker マイクロVM技術で完全隔離
- **起動時間**: 同じリージョン内で 200ms以下
- **月間700万以上のダウンロード数**

## 料金プラン

| プラン | 価格 | 特徴 |
|------|------|------|
| **Hobby** | 無料 | $100クレジット、最大1時間セッション、20並行実行 |
| **Pro** | $150/月 | 最大24時間セッション、100並行実行、カスタマイズ可能 |
| **Enterprise** | カスタム | カスタムソリューション、営業相談 |

**従量課金**: CPU \$0.000014/秒（1vCPU）、メモリ $0.0000045/秒（1GiB）

## 主な機能

### 1. コーディングエージェント向け 👨‍💻

AIエージェント（Claude Code、Codex、Amp等）が自律的にコード実行
- **環境**: ターミナル、ファイルシステム、git、パッケージマネージャーに完全アクセス
- **利点**: AI生成コード＝本番環境完全隔離、並列実行可能
- **セッション管理**: pause/resumeで状態保持可能

### 2. Computer Use（GUI自動化）🖥️

仮想Linuxデスクトップ上でマウス・キーボード操作を自動化
- VNCストリーミングでリアルタイム監視
- スクリーンショット → LLM分析 → アクション実行のループ
- **用途**: Web自動化、UI自動テスト、ビジュアルデータ入力

### 3. GitHub Actions CI/CD 🚀

プルリクエストの自動レビュー・テスト実行
- 悪意あるコードがCIランナーに触れない
- LLMが差分分析して自動レビューコメント投稿

## ネットワーク機能と制限

### インターネットアクセス制御

```javascript
// アクセス有効（デフォルト）
const sandbox = await Sandbox.create({ allowInternetAccess: true })

// アクセス無効
const isolated = await Sandbox.create({ allowInternetAccess: false })
```

### ファイアウォール（Allow/Deny リスト）

- IP アドレス、CIDR ブロック、ドメイン名指定可能
- **ルール優先**: allow > deny
- ワイルドカード対応: `*.domain.com`
- **制限**: HTTP（ポート80）、TLS（ポート443）のみ対応

### HTTP ヘッダーインジェクション（ベータ機能）

```javascript
rules: {
  'api.example.com': [
    { transform: { headers: { 'X-Header': 'Content' } } }
  ]
}
```

### Sandbox Public URL

すべてのサンドボックスに自動割り当てされる公開URL
```javascript
const host = sandbox.getHost(3000)
// https://3000-[ID].e2b.app
```

### 実行中のネットワーク設定変更

```javascript
await sandbox.updateNetwork({ /* 新設定 */ })
```

## カスタマイズと拡張

### パッケージインストール

**事前構築（推奨）**
```javascript
Template()
  .fromTemplate("code-interpreter-v1")
  .pipInstall(['tensorflow', 'numpy'])
  .npmInstall(['express'])
```

**ランタイムインストール**
```bash
apt-get update && apt-get install -y ffmpeg
pip install tensorflow
npm install pytorch
```

## 他プラットフォームとの比較

### vs AWS Lambda / Cloudflare Workers

| 観点 | Lambda | Workers | E2B |
|------|--------|---------|-----|
| 実行時間 | 最大15分 | 最大30秒 | **最大24時間** |
| 環境 | 限定的 | JS のみ | **フルLinux** |
| GUI | ❌ | ❌ | **✅** |
| セッション復帰 | ❌ | ❌ | **✅** |

**メリット**: AIエージェント向けの対話的実行、複雑な環境が必要な場面に最適

### vs ECS / EKS / AppRunner / Fly.io

| 観点 | ECS/EKS | AppRunner | Fly.io | E2B |
|------|---------|-----------|--------|-----|
| 起動時間 | 数秒～数十秒 | 数秒 | 1～5秒 | **200ms以下** ⚡ |
| セッション復帰 | 別途実装 | 別途実装 | 別途実装 | **ネイティブ** ✅ |
| インフラ管理 | 複雑 | 簡単 | 簡単 | **フルマネージド** |
| GUI サポート | ❌ | ❌ | ❌ | **✅** |
| 料金体系 | 常時起動前提 | 常時起動前提 | 常時起動前提 | **実行時間ベース** 💰 |

**結論**: 常時起動サービスなら Fly.io、AIエージェントの試行錯誤なら E2B

## Get Started (クイックスタート)

### 1. 初心者ガイド: Running your first Sandbox

5ステップで開始：
1. E2B アカウント作成（$100クレジット獲得）
2. ダッシュボードから API キーを設定
3. JavaScript/Python SDK をインストール
4. サンドボックス起動＆Pythonコード実行
5. `npx tsx` または `python` コマンドで実行

### 2. Connecting LLMs to E2B

複数の LLM プロバイダーと統合可能：
- OpenAI、Anthropic、Mistral、Groq、LangChain、CrewAI、LlamaIndex、Ollama 他
- **基本方針**: ツール使用機能（関数呼び出し）が最も簡単
- Python/JavaScript の完全なコード例提供

### 3. Uploading & downloading files

ファイル転送方法：
- **アップロード**: `files.write()` メソッド
- **ダウンロード**: `files.read()` で内容取得 → ローカル保存

### 4. Install custom packages

Debian ベースマシンなので `apt-get` で Linux コマンドも インストール可能

## 実用的な活用観点

### AI エージェント向けメリット

1. **極めて低い起動時間**: 200ms 以下で、高頻度な試行錯誤に最適
2. **セッション復帰**: ファイルシステム、プロセス状態がそのまま保持
3. **完全隔離**: 悪意あるコード実行時も安全
4. **ネットワーク制御**: API キー注入、ドメイン制限など細かい制御
5. **GUI 対応**: Desktop 自動化で、ブラウザ操作も可能

### 向いているユースケース

- ✅ AI コード生成・テスト・修正サイクル
- ✅ データ分析・可視化（複雑な環境）
- ✅ Web 自動化・RPA
- ✅ GitHub Actions での AI 駆動コードレビュー
- ✅ 強化学習実験

### 向いていないユースケース

- ❌ 常時起動 Web サービス（Fly.io の方が適切）
- ❌ リアルタイム API サーバー（Lambda/Cloudflare Workers の方が効率的）
- ❌ 複数コンテナ連携（ECS/EKS の方が得意）

## 技術スタック

- **隔離技術**: Firecracker マイクロVM
- **ベースイメージ**: Debian ベース
- **言語対応**: Python、JavaScript、Ruby、C++、その他 Linux で動作する言語
- **SDK**: JavaScript、Python
