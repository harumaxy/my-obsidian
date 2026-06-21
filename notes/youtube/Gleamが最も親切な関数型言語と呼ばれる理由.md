---
title: Gleamが最も親切な関数型言語と呼ばれる理由
description: 2026年Stack Overflow初登場2位。ルイス・ピルフォールドが設計した関数型言語の哲学
permalink:
aliases:
  -
tags:
  - gleam
  - functional-programming
  - language-design
draft: false
date: 2026-06-21
---

## 基本情報

- **作者**: ルイス・ピルフォールド（イギリス・ロンドン）
- **リリース**: 2024年3月に1.0
- **2025年Stack Overflow調査**: 初登場で2位、70%のユーザーが「使い続けたい」
- **異名**: 「最も親切な関数型言語」

## 作者の背景

生物学の大学を中退 → 独学でプログラミング習得 → Haskellで関数型言語を学ぶ

**重要な経験**:
- 11歳で母親に勧められた演劇クラス
- 「人前で話すこと」「人の気持ちを考えること」を学ぶ
- これが後のGleamの「親切さ」哲学に深く影響

## Gleamの3つの設計選択

### 1. エラーメッセージが人間に話しかける

**Haskell（悪い例）**:
```
Expected type: in but Actual type: string
Second argument of ...
```
→ 専門用語だらけで初心者が心が折れる

**Gleam（良い例）**:
```
This expression has type Int but I need String
You can convert it with...
```
→ 何が間違っていて、どう直せばいいかが明確

### 2. 言語の表面積を極限まで小さくした

- **設計目標**: 午後1日で全部学べる
- **キーワード**: 数十個
- **重要な構文**: ほぼ1ページに収まる
- **実用性を確保**: タプル型、パターンマッチング、列挙型すべて搭載

### 3. ツールチェーン一体化

通常のプログラミング言語:
```
npm, prettier, jest, typescript, eslint...
```
→ インストールに30分以上かかる

Gleam:
```
gleam コマンド1つに全部入っている
```

- コンパイル
- フォーマット
- テスト実行
- 依存解決
- LSP起動

**実装言語**: Rustで実装（MLとCを足したような言語）

## 技術的基盤: BEAM仮想マシン

**BEAMの強み**（1986年にアーランと一緒に生まれた）:

1. **軽量プロセス**: 1台のサーバーで数百万のプロセスを同時実行
2. **アクターモデル**: プロセス間でメモリ共有しない、メッセージで通信
3. **Let-it-crash哲学**: エラーが起きたら潔く終わらせる、監督プロセスが新しいプロセスを起動

**代表例**: WhatsApp
- 55人で4.5億ユーザーを支える
- BEAMの信頼性を実証

**Gleamの戦略**:
- Erlangコンパイル時に型安全性をチェック
- コンパイル後はErlangコードに変換 → BEAMで実行
- **JavaScriptへのコンパイルも可能** → フロント・バックで同じコード

## Gleamの言語的特徴

### 関数型プログラミング

- **代数的データ型（ADT）**: タプル、列挙型
- **Immutable デフォルト**: 再代入不可
- **パターンマッチング**: 複雑なロジックをシンプルに
- **パイプ演算子** (`|>`): 関数の連鎖を読みやすく

```gleam
input
|> string.reverse
|> string.trim
|> string.uppercase
```

### TypeScript との比較

```
TypeScript = JavaScript + 型システム
Gleam = Erlang + 型システム
```

- コンパイル時にチェックされ、型情報は削ぎ落とされて実行される
- Erlangのエコシステムを活かしつつ、型安全性を確保

## 業界への影響

### 現状（2026年）

日本での採用:
- 業務で使う人: ほぼいない
- 求人: ない
- 日本語コミュニティ: 小さい

### しかし価値は高い

**3つの理由**:

1. **優しい入り口**: 関数型言語に挫折した人でも午後1日で動かせる
2. **言語設計の教科書**: 設計者の哲学が明確で、選択がなぜなされたかが見える
3. **早期タッチの優位性**: 3～5年後の差別化につながる可能性

### 言語設計の転換点

**1965年**:
- Tony Hoare が「実装が楽だから」としてnullを言語に入れた
- 結果: 10億ドルの損失（nullバグ）

**2016年**:
- ルイス・ピルフォールドが「ストレスを減らしたい」と新言語設計
- 結果: 業界2位の賞賛

**60年で転換**:
- 判断軸が「実装のしやすさ」から「使う人の親切さ」に移行
- Rust, Kotlin, Swift, TypeScript も同じ方向へ進化

## デプロイメント戦略

**推奨**: **Fly.io**
- 理由: Erlang/BEAMアプリに特化
- Elixir コミュニティが大きく、Gleamとの親和性高い
- Wireguard VPN でインスタンス間通信が容易

**その他の選択肢**:
- Docker + VPS（Linode, Hetzner）: シンプル
- AWS ECS: 可能だが過剰
- Lambda: 向かない（実行時間制限）

## 実装命令

```bash
# Erlang release をエクスポート
gleam export erlang-shipment

# OTP設定
[erlang]
application_start_module = "my_project/application"
extra_applications = ["inets", "ssl", "crypto"]

# HTTP server（本番）
pub const prod_http_config = HttpConfig(
    ..base_http_config,
    port: 80,
    use_tls: True,
    log_level: Warn,
)
```

## 学んだこと

1. **言語設計の判断軸の転換**: 実装のしやすさから、使う人の気持ちへ
2. **小さく親切に**: シンプルさと実用性の両立は可能
3. **既存資産の活用**: BEAMの信頼性 + ML言語の型安全性
4. **エンジニア心理を言語に反映**: エラーメッセージ、ツールチェーン一体化
5. **Immutable × ADT × Pipe**: 関数型の柔軟性を実装コストを最小化して実現

## メモ

- 日本ではまだ認知が低いが、早期に触ることの価値は高い
- Erlang/BEAM コミュニティの人なら検討の価値あり
- TypeScript の成功と同じパターン：「親切な型システム」が市場を作る

