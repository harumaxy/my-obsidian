---
title: celld と Deno チーム Cloudflare 合流
description: Deno 製 celld (セルフホスト Durable Objects) と、Deno チームの Cloudflare 参加、Deno 開発終了、Bun の現状
# permalink:  # don't use
aliases:
  - celld
  - Deno joins Cloudflare
tags:
  - cloudflare
  - durable-objects
  - deno
  - bun
  - runtime
draft: false
date: 2026-10-10
---

## 出典

- https://celld.dev/
- https://github.com/denoland/celld
- https://blog.cloudflare.com/deno-joins-cloudflare/
- https://deno.com/blog/cloudflare (2026-10-09, Ryan Dahl)

## celld とは

- Cloudflare Durable Objects (DO) を自前マシンで動かす、分散実行基盤。Rust 製、単一バイナリ (58MB)、Apache-2.0
- 作者 Deno Land。V8 + セルごと SQLite + LTX (Litestream 系)
- 保存先は S3 互換 / GCS / Azure Blob。バケットが正本
- `wrangler.json` そのままデプロイ。未知キーあると止まる
- 対応: Workers, DO, KV, Queues, D1, R2, Workflows, Cron, Static assets, Dynamic Workers。Containers は実験的
- install: `curl -fsSL celld.dev/install.sh | sh` or `docker run ghcr.io/denoland/celld`

## 設計

- セル = DO。名前 + 専用 SQLite。セル間で DB 共有なし。1セル1スレッド
- 制御プレーン無し、リーダー選出無し、メンバーシップ無し
- 所有権 = バケットへの条件付き書き込みでリース取得。バケットが勝者決める。更新止まれば別ノードが引き継ぎ (failover 約20秒)
- ノード追加 = 同じバケット指すだけ。同バケット共有ノード群 = フリート
- 耐久性: `bucket` モードはバケット書込待ち。`fleet` (既定) は他ノードディスク or バケット、早い方待ち。単一ノードは毎回バケット往復で遅い
- 非アクティブセルはバケット上のオブジェクトのみ。コストほぼゼロ
- サイト記載性能: stateless p50 0.2ms、約94k req/s/スレッド、常駐セル約0.47MB、8GBノードで約2,500セル

## 料金比較 (サイト記載)

- CF DO: Workers Paid $5/月 + 常駐セル1つ $4.15/月
- celld: DigitalOcean 8GB $48/月、2,500セル上限
- 10セル: DO $42 vs celld $49。10,000セル: DO $41,500 vs celld $195
- 少数なら CF 安い。大量常駐セルで celld 圧勝

## ユースケース

- リアルタイム: ゲーム、チャットルーム、共同編集。1セルで完結、外部ロック不要
- AI エージェント: エージェント毎に記憶・スケジュール・受信箱を SQLite に持つ
- シャーディング Web アプリ: ユーザー / テナント / デバイス毎にセル
- 既存 CF アプリの自前ホスト

## 注意点

- 内部リスナー認証なし、ピア通信 TLS なし → private network / WireGuard 必須。公開禁止
- フリート内バージョン混在不可
- CF ネットワーク・GPU・ブラウザ系は対象外
- PR 受け付けず、パッチはメール

## Deno チーム Cloudflare 合流 (2026-10-09)

動機の流れ:

- Dahl が Deno Deploy 運営で、分散処理・状態管理・保存・オートスケールの複雑さを痛感
- DO モデル (1オブジェクト = 単一スレッド + SQLite) が解と判断 → celld 開発
- 8月に celld 公開 → Cloudflare (Kenton Varda) が歓迎 → 協力申し出 → 合流
- 買収条件は記載なし

Cloudflare 側の理由:

- workerd (OSS ランタイム) の DO は単一インスタンスのみ。セルフホストでスケール不可
- 本番実装は大規模向けでセルフホスト不向き
- 「逃げ道があるほうが顧客獲得につながる」というロックイン否定スタンス

今後:

- celld と workerd を統合。Dahl と Bert Belder 主導で workerd セルフホストを第一級サポートに
- 詳細発表は「今後数か月」
- AI 文脈: DO は低コスト serverless + 永続状態 + WebSocket でエージェント基盤向き

## Deno 製品の扱い (重要)

- **Deno ランタイム**: 1年は月次リリースでバグ・セキュリティ修正のみ。"After that year we will end our development of the Deno runtime." OSS のまま残り、引き継ぐ人は歓迎
- **Deno Deploy**: 6か月運営後に終了。有料顧客は Workers 移行支援
- **JSR**: 運営継続、インフラを Cloudflare へ移行
- **rusty_v8**: 継続サポート、workerd 統合を進める
- Fresh、Node 互換の今後: 言及なし

## 後継ランタイム候補

- Node + npm/pnpm/yarn: 無難
- Bun: Deno 的体験 (TS 直実行、単体バイナリ) の最有力後継
- Deno 継続: 1年は安全。以降はフォーク頼み (フォーク誕生は推測)

Bun 現状:

- 2025-12-03 Anthropic が買収発表。MIT 維持、既存チームで継続開発
- stable 確認できたのは v1.3.14 (2026-05)
- Bun 1.4 (2026-08-20 npm 公開) は Rust 書き換え初版との報道あり。第三者ブログのみで公式未確認、breaking change 5件との記事あり
- 1.4 は安定するまで様子見、1.3.14 で十分

## 所感

- celld は単独製品でなく、workerd 統合の先行実装。長期的には workerd に吸収される見込み
- 自分の Deno 使用 (ComfyUI 用 TS スクリプト) は1年は問題なし。移行先は `bun run script.ts` が最も近い
- 続報待ち: celld/workerd 統合の詳細発表、Deno フォークの有無
