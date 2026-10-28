---
title: dev-null.sh (開発者向けSNS)
description: GitHubログイン限定の開発者SNS /dev/null。仕組み、認証、審査、XP、技術構成を調べたメモ
# permalink:  # don't use
aliases:
  - /dev/null
  - dev-null
tags:
  - sns
  - laravel
  - moderation
  - ssh
draft: false
date: 2026-10-20
---

## 要約

- dev-null.sh = 開発者向けSNS。2026年10月中旬に公開。GitHubでログイン。
- 投稿 = 「commit」。プレーンテキスト 最大4,000字。タイムライン = 「log」。DM = 「Remotes」。
- 数人が配信で48時間で作った。ソースはOSS (MIT)。PRで誰でも改善できる。
  - リポジトリ: https://github.com/nunomaduro/dev-null.sh
- 作者 Nuno Maduro (Laravel界隈)。貢献数1位は xHeaven (Márk Magyar)。
- 名前の由来 = `/dev/null`。投稿が虚空に消える冗談。公式説明は見つからず推測。

## 図 (C4)

- Claude Artifact: https://claude.ai/artifact/RcUTajvDvxUKczLdCsbShG
  - C4 Context / Container / Component、サインアップ流れ、審査流れ、技術要件
  - 非公開。自分のアカウントでのみ開ける
  - 閲覧期限: 不明。ツールの説明に期限の記載なし。消える前提でこのメモに要点を残す

## 技術構成

- バックエンド: PHP 8.5 / Laravel 13
- フロント: React 19 + TypeScript、Inertia 3、Tailwind 4、Vite+、Bun
- DB: PostgreSQL 17+ (pgvector, pg_trgm)。セッション・キャッシュ・キューも既定でDB
- Redis なし、WebSocket なし。DMは数秒ごとのポーリング
- ホスティング: Laravel Cloud
- 品質: Pest カバレッジ100%、型カバレッジ100%、PHPStan 最大レベル
- コードの癖:
  - Actions (書き込み、約90) / Queries (読み取り、約60) に分離
  - `final readonly class` + `handle()` 1つ。関数に近いOOP
  - Eloquent は Active Record で、副作用は混ざる
  - フロントは関数コンポーネント中心。`any` なし

## 登録直後の Following

- 登録時 (`SessionController::store`) に2つ実行:
  - Tom と相互フォロー (全員の最初の友達、通知なし)
  - GitHub のフォロー取り込み (非同期、初回のみ、双方向、各最大1,000件)
- だから登録前にフォローしてない人が Following に出る
- 外したフォローは戻らない

## 認証 (GitHub公開鍵)

- ターミナル投稿: `curl -fsSL https://dev-null.sh/commit | bash -s -- 'text'`
  - GitHub登録済み SSH公開鍵で署名 (`ssh-keygen -Y sign -n devnull-commit`)
  - 秘密鍵は送らない。エージェント、ハードウェアキーも使える
  - サーバーは署名検証 + タイムスタンプ±300秒 + nonce使い捨て
  - GitHub API から公開鍵を同期。ユーザーごと5分キャッシュ。GitHubで鍵を消せば数分で失効
- モバイルアプリ: 別方式。端末の ed25519 鍵をWebで「デバイス承認」(OAuth+PKCE)。GitHub登録は不要
- すごい点: 鍵登録簿を自作せず、GitHubの公開情報を認証基盤にした。トークン発行も不要
- 弱点:
  - GitHub APIのレート制限は OAuth アプリ全体で 5,000回/時 (全ユーザー共有)
  - 同期から5分超でGitHubが落ちていると、署名検証が失敗する作り。逃げ道なし
  - GitHub限定ログインなので、GitHub依存はサービス全体の前提

## 投稿の審査

- 管理者以外の投稿は最初 pending
- 「評判良好」の著者は AI審査を飛ばして即承認 (通報がなければ):
  - 作成1時間超 + 承認済み投稿あり + フォロワー10人以上
  - 直近7日に未却下の通報があると、自動承認されない
- それ以外は OpenAI で審査:
  - `omni-moderation-latest`: 審査専用の分類器。13カテゴリの点数。無料。閾値 0.2、`sexual/minors` は 0.01。0.95以上で自動却下
  - `gpt-6.1-sol` (推論モデル): 有害テキスト判定、画像の未成年判定。迷ったら true
  - 理由: moderation は暗黙の脅迫、画像の未成年を拾えない (`sexual/minors` はテキストのみ)
- 判定不能や失敗は pending のまま。人間が `/moderation` で承認か却下
- モデル名はコード直書き。`gpt-6.1-sol` `gpt-6-luna` は自分の知識にない名前。実在や性能は未確認
- 検索結果の関連度判定は別: OpenAI Decisions API (`gpt-6-luna`、predicate で確率を返す)。審査には使わない

## Jev と Decisions API

- Jev = TypeSafe AI の判定専用モデル。文章を生成せず、choice / score / boolean を確率つきで返す。単一パスで推論なしという記事あり。一次資料は未確認
- OpenAI Decisions API = 近い発想。`POST /v1/decisions`、公開ベータ、`gpt-6-luna` のみ、入力 $0.10/100万トークン
- moderation との違い: moderation は固定カテゴリ、Decisions は質問を自由に書ける

## Lv / XP / バッジ

- Lv = XP で決まる Unix ランク。権限や特典は何もない。表示と演出のみ
  - user 0 / daemon 50 / operator 150 / maintainer 400 / wheel 1000 / root 2500
- XP: 投稿 10、最長連続日数 15/日、もらった★ 5、他人への返信 5、あげた★ 2、luddite -100
- バッジ13個。解放してもボーナスXPなし
  - init(初投稿) stdout(50件) kernel space(100件) syntax(コードブロック) pipe(返信5件)
  - uptime(連続7日) daemon(30日) sysadmin(100日) stargazer(★10個あげる) superstar(★25個もらう)
  - sweet tooth(パステル100個) authorized_keys(GitHub公開鍵あり) luddite(Tomのフォローを外す)
- 計算は表示のたびに現在データから。投稿削除や却下で連続日数が割れると、解放済みでも外れうる
- 連続系は最長記録で数えるので、日を空けるだけなら外れない
- Tomを付け直すと luddite も -100 XP も消える
- XP内訳はUIに出ない。ただしバッジの進捗分数から逆算できる
- ターミナル投稿、GitHub Actions、予約投稿で自動化可能。連続系バッジは機械で埋められる。実害は小さい

## 所感

- 流行るか: 主流にはならない。数万人規模の技術者の居場所としては残る可能性。運営が数か月続けられるかが鍵
- GitHub限定: 間口は狭いが、コールドスタート解消 (フォロー取り込み)、ボット対策、話題の揃い方がメリット。読み専用は誰でも可
- 自分の好み (動的型・OOP苦手):
  - PHP だが strict types + 型100% なので許容できる範囲
  - 継承なし、不変寄り、1クラス1関数。OOPの嫌な部分は薄い

## 調べた方法

- リポジトリを浅くclone (履歴1件) して README、KNOWLEDGE_BASE.md、app/ を読んだ
- 動かしてはいない。コードの読みと公式ドキュメントのみ
- KNOWLEDGE_BASE.md に配信初日の議事録的な記述あり (YouTube タイムスタンプ付き)。経緯はそこを掘れる

## 出典

- https://dev-null.sh/
- https://github.com/nunomaduro/dev-null.sh
- https://github.com/nativephp/dev-null-app
- https://developers.openai.com/api/docs/guides/moderation
- https://developers.openai.com/api/docs/guides/decisions
- https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api
- https://en.wikipedia.org/wiki/Jev_(AI_model)
