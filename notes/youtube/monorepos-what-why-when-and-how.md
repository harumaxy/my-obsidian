---
title: Monorepos - What, Why, When and How
description: モノレポの定義、メリット・デメリット、実装方法、実践的なTipsを学ぶ
aliases:
  - monorepo
tags:
  - development
  - architecture
  - monorepo
  - pnpm
  - fullstack
draft: false
date: 2026-06-22
---

# Monorepos - What, Why, When and How | Full Stack React + Hono Example

**チャンネル**: Syntax | **日付**: 2024年12月24日  
**動画ID**: KIgPJT806D0

## 📝 概要

モノレポ（monorepo）の基礎から実践まで、フルスタック開発の例を通じて解説。1つのGitリポジトリ内で複数のアプリケーションとパッケージを管理する方法を学ぶ。

---

## 🎯 モノレポとは

**定義**: 1つのGitリポジトリ内に複数のアプリケーションやパッケージを管理する構成

### モノリシックアプリとの違い
- **モノリシック**: 1つの大規模アプリケーション（例: Ruby on Rails）
- **モノレポ**: 複数の独立したアプリ・パッケージが1つのリポジトリに共存

### 典型的な構成
```
root/
├── apps/
│   ├── api/          # Hono バックエンド
│   └── web/          # React フロントエンド
└── packages/
    ├── ui/           # 共有UIコンポーネント
    ├── types/        # 共有型定義
    └── utils/        # 共有ユーティリティ
```

---

## ✅ モノレポのメリット

### 1. **コード共有と重複排除**
- 複数アプリが同じUIコンポーネントを使用可能
- 共有型定義を1箇所で管理
- フォーマッターやユーティリティを共有

### 2. **チーム協働の効率化**
- フロントエンド・バックエンド両方に携わるメンバーが単一コードベースで作業
- PR レビューが一貫性を保ちやすい

### 3. **プロプライエタリコード管理**
- 企業内部のコードを公開せずに共有
- NPM プライベートレジストリが不要

### 4. **依存関係が明確**
- 内部パッケージ参照が NPM パッケージと区別される（namespace化）

---

## ❌ モノレポのデメリット

### 1. **アクセス制御の課題**
- リポジトリへのアクセスが全か無かになる
- 機密コードへのアクセス制限が難しい
- **ただし**: GitHub CODEOWNERS で部分的に権限制限可能

### 2. **ストレージの大規模化**
- すべての履歴を含めてクローンが必要
- Git履歴が肥大化するとディスク容量が膨大に

### 3. **デプロイの複雑性**
- ホスティングサービスがルート以外のディレクトリに非対応
- カスタムビルドプロセスが必要な場合がある

---

## 🌍 実世界の例

| プロジェクト | 構造 |
|-----------|------|
| **React** | `packages/react`, `packages/react-dom` など |
| **Next.js** | `packages/next`, `packages/create-next-app` など |
| **Bun** | 複数のサブパッケージを統合管理 |
| **TLDraw** | `apps/` + `packages/` で複数アプリを運用 |
| **Google** | 超大規模モノレポで全サービスを管理 |

---

## 🛠️ 実装方法

### ツール選択

- **npm Workspaces**: ビルトイン機能
- **Yarn Workspaces**: ビルトイン機能
- **pnpm Workspaces**: ⭐ **推奨** - `pnpm-workspace.yaml` で定義
- **Nx**: ジェネレータと組み込み機能が豊富
- **Turborepo**: タスク実行と依存関係管理に特化
- **Lerna**: 長い歴史を持つツール

### pnpm でのセットアップ例

```yaml
# pnpm-workspace.yaml
packages:
  - 'apps/*'
  - 'packages/*'
```

各パッケージで `package.json` を持ち、namespace を統一
```json
{
  "name": "@tasks-app/api",
  "version": "1.0.0"
}
```

---

## 💡 実践的な Tips

### **Tip 1: 設定ファイル共有**
- ルートの `tsconfig.json` を各プロジェクトが `extends`
- 共有 ESLint 設定パッケージを作成
- 一貫性のある開発環境を実現

### **Tip 2: パスエイリアスの工夫**
- 各アプリに**ユニークなプリフィックス**を付ける
  - API: `@/api`
  - Web: `@/web`
- 複数パッケージ間の競合を回避

### **Tip 3: pnpm Task Runner**
```bash
pnpm run -r dev --parallel --aggregate-output
```
- `-r`: 再帰的に全ワークスペースで実行
- `--parallel`: 並列実行
- `--aggregate-output`: 出力を統合
- ビルドは `--parallel` 除外（順序重要）

### **Tip 4: Vite プロキシ開発**
- フロントエンド (localhost:5173) がバックエンド (localhost:8787) にリクエスト
- Vite がプロキシ化して本番構成をシミュレート
```javascript
// vite.config.js
export default {
  server: {
    proxy: {
      '/api': 'http://localhost:8787'
    }
  }
}
```

### **Tip 5: SPA 静的配信**
- React ビルド出力を API サーバーの `public/` に配置
- 非API パスは `index.html` を配信
- クライアントサイドルーティングに対応

### **Tip 6: バリデーション共有**
- Drizzle ORM の `drizzle-zod` で DB スキーマから自動生成
- 同じスキーマを API とフロントエンド両方で使用
- React Hook Form と組み合わせ

### **Tip 7: Hono RPC 型生成**
- API 型を事前コンパイルして `api-client` パッケージに保存
- `pnpm run dev` 時に自動更新
- TS 言語サーバーの負荷軽減

### **Tip 8: エクスポート制限**
- API から公開範囲を明示的に制限
```json
{
  "exports": {
    "./routes": "./src/routes.ts",
    "./schema": "./src/schema.ts"
  }
}
```
- バックエンド固有の依存関係を隠蔽

---

## 🔐 セキュリティと アクセス制御

### 📌 よくある誤解
```
❌ 「リポジトリ分離 = セキュリティが高い」
✅ 実際: 適切なアクセス制御で十分に保護可能
```

### ✅ 同一組織内のモノレポはセキュリティ上の問題ない

**理由**:
- チームメンバーは既に相互信頼がある
- 環境変数・API キーは GitHub Secrets で管理（コード外）
- CODEOWNERS で review 権限を制限可能

**実装例**:
```yaml
# .github/CODEOWNERS
/apps/api/           @backend-team
/apps/web/           @frontend-team
/packages/shared/    @both-teams
/packages/secrets/   @security-team

# api/ の変更には backend-team の review が必須
```

### ⚠️ セキュリティ分離が**本当に必要**な場面

#### 1. **マルチテナント SaaS**
```
顧客A のコード | 顧客B のコード | 自社コード
↓ 完全に分離が必須
リポジトリレベルでのアクセス制限が必要
```
- 顧客データが混在しないようにする
- 監査ログが顧客ごとに分離されている

#### 2. **外部パートナーとの協業**
```
パートナー企業に公開:
- API クライアント
- 型定義

秘密にする:
- バックエンドの内部実装
- DB スキーマ
- ビジネスロジック
```
- NDA（秘密保持契約）で "このコードは見せるな" という制限

#### 3. **規制産業（金融・医療・保険）**
```
コンプライアンス要件:
- システム監査ログの分離
- アクセス権限の記録（"誰が何を変更したか"）
- リポジトリレベルのアクセス制御が必須
```

### 🎯 チーム別での選択肢

| 状況 | 推奨構成 |
|------|---------|
| 同一組織、関連サービス | **モノレポ** ✅ |
| マルチテナント、顧客分離 | **複数リポ** 分離 |
| 外部パートナーとの協業 | **複数リポ** + 型定義だけ共有 |
| 規制産業 | **複数リポ** + 厳格なアクセス制御 |

### 🔒 モノレポ内でのセキュリティ対策

```yaml
# GitHub Secrets （コード外で管理）
secrets:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  API_KEY: ${{ secrets.API_KEY }}

# .env.example （公開してもいいテンプレート）
DATABASE_URL=postgres://user:pass@localhost/db
API_KEY=your-api-key-here
```

**環境変数 = リポジトリ分離の理由にはならない**
- .env ファイルは .gitignore に追加
- GitHub Secrets で管理
- CI/CD 時のみ環境変数として注入

### 📊 実際の企業事例

| 企業 | チーム構成 | セキュリティ対策 |
|------|----------|-----------------|
| **Google** | 同一組織、超大規模 | CODEOWNERS + 内部レビュー |
| **Meta/Facebook** | 同一組織 | モノレポ + CODEOWNERS |
| **Stripe** | 同一組織、複数チーム | モノレポ + CODEOWNERS |

**結論**: これらの大企業でもモノレポが標準

---

## 🔄 モノレポの代替案

### 1. **Git Submodules**
- 複数リポジトリを親リポジトリ内で参照
- 相対パス参照が困難

### 2. **プライベート NPM パッケージ**
- NPM 有料プラン
- GitHub Packages

### 3. **セルフホスト型**
- **Verdaccio**: 無料、NPM プロキシ機能

### 4. **エンタープライズソリューション**
- **JFrog Artifactory**: Docker も管理
- **AWS CodeArtifact**: AWS エコシステム内

---

## 🎓 学んだこと

✅ **同一組織の関連サービス = モノレポが最適**  
✅ pnpm Workspaces は最も実用的な選択肢  
✅ 設定共有と namespace 統一で開発効率が大幅向上  
✅ フロントエンド・バックエンド間の型安全性強化に有効  
✅ セキュリティ分離（リポジトリ分離）が本当に必要なケースは稀  
✅ GitHub CODEOWNERS + Secrets 管理で十分にセキュア  
✅ マルチテナント・規制産業など特殊ケースのみ複数リポを検討  
✅ **大企業（Google、Meta、Stripe等）もモノレポが標準**

---

**参考**: https://github.com/w3cj/monorepo-example-tasks-app
