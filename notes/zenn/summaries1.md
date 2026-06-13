---
title: summaries1
description:
permalink:
aliases:
  -
tags:
  -
draft: false
date: 2026-06-13
---

## Webブラウザのセキュリティについて理解しよう（Origin, SOP, CORS）

**出典:** https://zenn.dev/dem3860/articles/a0478649339e8b

### Origin とは

ブラウザがリソースの出どころを判断するための情報。以下3要素の組み合わせ：

- **スキーム**（http / https）
- **ホスト名**（example.com など）
- **ポート番号**（80, 443 など）

例: `http://example.com:80` → Origin は `(http, example.com, 80)`

スキーム・ホスト・ポートのいずれか1つでも違えば別のOriginとみなされる。

### Same-Origin Policy（SOP）

Cross-Origin間のブラウザ内アクセスを禁止するセキュリティ機構。

制限される操作：
- DOM の読み書き
- Cookie / localStorage へのアクセス
- JavaScript オブジェクトへの参照

悪意あるサイトが他サイトのセッション情報を使って不正操作（例：DELETEリクエスト送信）するのを防ぐ。

### CORS（Cross-Origin Resource Sharing）

SOPが厳しすぎて正当なクロスオリジン連携まで阻んでしまう問題を解決する仕組み。

サーバが `Access-Control-Allow-Origin` ヘッダーで許可するOriginを明示することで、特例としてクロスオリジンアクセスを許可できる。

認証情報（Cookie, Authorizationヘッダーなど）付きリクエストには `Access-Control-Allow-Credentials: true` の追加設定が必要。
