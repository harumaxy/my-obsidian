---
title: Terraformが変えた世界
description: 1人のエンジニアが起こした革命：2014年から2026年、Terraformが業界に植えた根
aliases:
  - Terraform revolution
  - Infrastructure as Code history
tags:
  - Terraform
  - Infrastructure as Code
  - HashiCorp
  - OpenTofu
  - Platform Engineering
  - Cloud Engineering
draft: false
date: 2026-06-23
video_url: https://www.youtube.com/watch?v=fXpH2SvbLng
channel: IT技術屋のボヤキ
---

## 概要

Terraform が業界を変えた革命の物語。2014年の誕生から2026年の現在までの12年間の劇的な変化を追う。ツールそのものは揺れたが、業界の働き方を根本的に変えた発想は今も生き続けている。

## 誕生の背景：3年待った後発組

- **2011年**：AWS CloudFormation 発表に感動したミッチェル橋本（日系アメリカ人エンジニア）
- ブログで「クラウド非依存のオープンソース IaC ツール」を呼びかけるも、3年誰も作らず
- **2014年7月**：自分で作ることを決断 → Terraform 0.1 リリース
- 最初は AWS と DigitalOcean のみ対応

## 逆転の成功戦略：後発組がなぜ主役になったか

**意外な事実：業界に7番目に登場**
- 既に6つの競合ツール存在：AWS CloudFormation, ARM Template, Google Deployment Manager, Chef, Puppet, Ansible
- 最初の18ヶ月ほぼダウンロードされず、プロジェクト閉鎖議論もあった
- VMware からの2000万ドル買収オファーを断る

**勝利の転機：周年戦略とエコシステム**
- **2016年**：プロバイダー機能で拡張性を確保（AWS, Azure, GCP などを同じ言語で操作可能に）
- **2017年**：Microsoft Azure との公式パートナー認定で爆発的成長
- ミッチェル本人の振り返り：「最初だったから勝ったのではない。最後まで諦めず、カンファレンスに行き続け、コミュニティを育て、開発者体験を改善し続けたから勝った」

## 業界を根本的に変えた3つのもの

### 1. マルチクラウド時代の到来
- **Before（2014年以前）**：企業は1つのクラウドプロバイダーに全面依存
  - ベンダーロックインのコスト極大
- **After**：AWS、Azure、GCP、Oracle Cloud を同じ言語で操作
  - 2026年：Fortune 500 の70%以上がマルチクラウド採用

### 2. Platform Engineer という新職種の誕生
- **Before**：インフラエンジニア＝手作業中心
  - サーバー1台の構築に半日かかる時代
- **After**：インフラがコード化 → ソフトウェアエンジニアと同じワークフロー
  - Git でコードレビュー、CI でテスト、CD で自動デプロイ
- **結果**：2026年、世界のIT求人で Platform Engineer は最も給料が高い職種の1つ

### 3. 宣言的 IaC の業界標準化
- **命令的アプローチ（旧：Chef, Puppet, Ansible）**：「どうやってするか」を書く手順書
- **宣言的アプローチ（Terraform）**：「最終的にこうあるべき」を書く → 差分計算は Terraform がやる
- **影響**：2026年、業界のほぼすべてのインフラツールが宣言的アプローチを採用
- Kubernetes と同じ思想が業界標準に

## 急展開：栄光の頂点から急転直下（2023-2025）

### 2023年8月10日：ライセンス変更
- MP 2.0（完全オープンソース）→ BSL（ビジネスソースライセンス、反オープンソース）
- **理由**：AWS, Azure, GCP などがマネージドサービス化して再販、HashiCorp に還元なし

### 2023年9月：コミュニティの激怒と分裂
- 30日後、AWS / Google Cloud / Cloudflare など **140社が OpenTofu フォークを発表**
- Linux Foundation 傘下で、Terraform 1.5 から分岐した新プロジェクト

### 2023年12月：創業者の退任
- ミッチェル橋本が HashiCorp を離職
- 表向き「次の挑戦」だが、業界の見方は BSL 改変への抗議

### 2024年4月～2025年2月：IBM 買収
- IBM が 64億ドル（約9600億円）で買収
- HashiCorp は独立企業から IBM の一部門に

## 2026年の現状：ツールは分裂したが思想は生き続ける

| 指標 | 数字 |
|------|------|
| Terraform 市場シェア | 32% |
| OpenTofu 市場シェア | 12%（年300%成長） |
| ダウンロード数（合計） | 9800万 |
| OpenTofu 移行企業 | Boeing, Capital One, AMD, Fidelity など大企業 |

**業界の見方**：ライセンス改変の代償は極めて高い。コミュニティの信頼は一度失うと戻らない。

## 結論：会社は揺れた、思想は残った

### ツールは揺れても業界の変化は戻らない
- マルチクラウド時代はもう戻らない
- Platform Engineer という職種は業界に定着した
- 宣言的 IaC は業界の標準的な考え方になった

### 最大の遺産：「インフラはコード」という発想
- **ミッチェル本人（2026年2月インタビュー）**：「私が誇りに思うのは Terraform そのものじゃない。Terraform が生み出した業界の働き方の変化」
- 会社が IBM に買収されても、OpenTofu に分裂しても、この思想は消えない

### 業界の格言
> 最高の技術は自分が消えた後も業界に残り続ける

あなたが今 Terraform や OpenTofu を書いているなら、それは2014年に1人のエンジニアが起こした革命の直接の延長戦上にある。

---

## 関連キーワード
- #Terraform #OpenTofu #HashiCorp #IBM買収 #ライセンス論争
- #InfrastructureAsCode #IaC
- #MultiCloud #マルチクラウド時代
- #PlatformEngineering #SRE #DevOps
- #オープンソース論争 #BSLライセンス
