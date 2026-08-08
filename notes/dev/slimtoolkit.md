---
title: slimtoolkit
description: Dockerイメージ軽量化ツール
# permalink:  # don't use
aliases:
  - DockerSlim
tags:
  - docker
  - container
draft: false
date: 2026-08-03
---

# SlimToolkit

https://github.com/slimtoolkit/slim

旧DockerSlim。Dockerイメージを最大30倍圧縮するツール。GitHubスター ~20k。

## 主コマンド

- `slim build <image>` — イメージ圧縮・最適化
- `slim xray <image>` — イメージ内容解析、Dockerfile逆エンジニアリング
- `slim debug <container>` — 実行中コンテナのデバッグ
- `slim lint` — Dockerfile検証

## 動作メカニズム

Dockerfile書き換えなし。OSレベル監視。

1. 元イメージからコンテナ起動
2. `ptrace` / `fanotify` でシステムコール監視 → アクセスファイル記録
3. HTTPプローブ送信 → アプリ実際に動かしてアクセス誘発
4. 触れられたファイルのみ新イメージにコピー
5. 結果 = `FROM scratch` + 必要ファイルのみ

## 問題点

- HTTPプローブが通らないコードパス（エラーハンドリング、バッチ処理等）のファイルは記録されない
- 本番で初めて実行するコードが「ファイルがない」でクラッシュするリスク
- テストカバレッジ低いアプリほど危険
- privilegedモードか特定capability必要

## 向いてる用途

- サードパーティイメージ（変更できない）を圧縮したい
- 既存大量イメージを移行コストなしに縮小したい
- `xray` でイメージ内部調査したい

## 結論

新規開発なら alpine/distroless + マルチステージビルド一択。

- **明示的** — 何が入ってるか自分で把握
- **再現性** — Dockerfile見れば誰でも同じイメージ作れる
- **CIで検証可能** — テストが通れば削除ミスはない
