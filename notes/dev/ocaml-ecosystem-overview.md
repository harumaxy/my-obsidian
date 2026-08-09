---
title: ocaml-ecosystem-overview
description: OCaml言語の特徴、OCaml5 Multicore/Effect、Eio、他言語比較、Unikernel(MirageOS)まで、実用面重視でまとめたメモ
# permalink:  # don't use
aliases:
  -
tags:
  - ocaml
  - functional-programming
  - unikernel
draft: false
date: 2026-08-08
---

## OCaml基本

関数型+命令型+OOP併せ持つ静的型付け言語。1996年INRIA発。

- 型推論強力、型注釈ほぼ不要
- 代数的データ型+パターンマッチング標準装備
- モジュールシステム強力（functor=モジュール引数化）
- コンパイル爆速、ネイティブバイナリ生成
- null無し→`option`型で表現

用途: コンパイラ実装、静的解析ツール、金融（Jane Street主力言語）、形式検証系。

## OCaml5 Multicore/Effect handlers

2022年リリース最大変更。

- **Domain** = 並列実行単位。OSスレッドマップ、複数コア同時実行可能
- **Effect handlers** = 計算中断→再開を言語機能でサポート。async/await的パターンを言語コアに実装
- Domain=並列(Parallelism)、Effect上のライブラリ=並行(Concurrency)、と役割分離

Effectはコルーチンより汎用的な下位プリミティブ。中断理由(Effect型)自作可能、継続を自由に操作できる。ただしアプリ開発者が直接使う場面稀、`Eio`等フレームワーク経由で使うのが普通（JSでいうPromiseの裏のマイクロタスクキュー的立ち位置）。

## Lwt/Async vs Eio

**Lwt(旧世代)**: モナドベース非同期。`'a Lwt.t`型で値ラップ、`Lwt.bind`/`let%lwt`/`let*`でチェーン。型が「色付け」される(`int` vs `int Lwt.t`)。

- `let%lwt` = PPX拡張構文（プリプロセッサ）
- `let*` = OCaml4.08で言語標準になった「バインディング演算子」。PPX不要、`let*`/`let+`等モジュール開いて使う
- `Lwt.bind : 'a Lwt.t -> ('a -> 'b Lwt.t) -> 'b Lwt.t` = 非同期計算A→Bを繋ぐ接着剤（JSの`.then()`相当）。`bind`の語源は「結びつける」
- `Lwt.map`はflatten無し（配列の`map`相当）、`Lwt.bind`はflatten有り（`flatMap`相当）

**Eio(新世代、Effect handlers基盤)**: 非同期呼び出しが普通の同期コードと同じ見た目で書ける。型汚染なし（"function coloring problem"解消）。

- **Fiber**: 軽量実行単位。`Fiber.fork`/`Fiber.both`で生成、アプリ開発者が日常的に直接使う
- **Switch**: fiberライフタイム管理。構造化並行性(structured concurrency)の要、スコープ内fiber全部完了/キャンセル保証。エントリポイントで必ず書く
- **Domain**: CPU重い処理を別コアに逃がす時だけ直接使う
- **Suspend/Scheduler**: `Eio.Private`、ライブラリ内部実装者向け、アプリ開発では触らない
- I/O(ファイル/ネット/stdin等) = `env`経由のcapability-basedアクセス（`env#fs`, `env#net`）。`#`はOCamlオブジェクトのメソッド呼び出し演算子、構造的型付けで最小権限の型指定がしやすい

エラー処理: Eioは基本**例外throw**がデフォルト(`_exn`サフィックス関数群)。`result`返す版も一部併存。理由: OCaml標準ライブラリが伝統的に例外ベース、Switch自動キャンセルが例外伝播前提で作られてる、Effect自体が例外機構の拡張として実装されてる。

アプリ層でResult使いたい場合は境界で`try~with`ラップして変換するのが定石パターン。

## Web開発エコシステム

- **cohttp-eio/cohttp-lwt**: HTTP client/server基礎ライブラリ、`_eio`/`_lwt`/`_async`サフィックスでbackend別opamパッケージに分割されてる命名規則
- **Dream**: 人気の高レベルWebフレームワーク。ただし現状まだLwtベースのまま、Eio移行は進行中止まり
- **Piaf**: 最初からEio前提設計の高性能HTTPライブラリ

全体的にNode.js/TSと比べエコシステム狭い、更新遅い、バグに当たると自己解決力必要。理由: OCaml5移行(Lwt/Eio/Async分断)の過渡期、コミュニティ規模の差。

## DB/インフラツール

- **Caqti**: DB抽象化層の事実上標準。PostgreSQL/MySQL/SQLite対応、Lwt/Async/Eio全部functorで切替可能。ただしORMではなく「型安全にクエリ実行するだけの層」
- マイグレーション/スキーマ管理ツールが無い。Drizzle Kit的な「スキーマ↔コード自動同期」文化がOCamlに薄い。実務では生SQL連番管理+自作ランナーが定番
- Caqtiの型安全性はDrizzleと逆方向: クエリ毎に`Caqti_type`で型を**手動宣言**（DB→コード自動生成ではない）
- **ocaml-aws**: AWS SDKバインディングあるが網羅性・保守にムラ、本番フル依存は厳しめ

→ DB絡むアプリはOCamlのDXが弱くなりがちな領域。「型安全ドメインロジック層はOCaml、周辺インフラは別ツール」という部分採用が現実的な落とし所。

## ビルド速度・opam

**コンパイル爆速な理由**:
- 型推論がローカル完結（Hindley-Milner系）、Rustの大域借用チェックのような重い解析が無い
- モジュール依存が明示的→増分ビルドの追跡がシンプル
- GC付き→メモリ安全性の静的検証コストが無い
- 多相型はboxed valueで扱う→Rustのmonomorphization(型ごとコード複製)のような肥大化が起きにくい

**全体ビルドが走る原因**: `.mli`（インターフェースファイル）書いてないと、実装(`.ml`)全体がインターフェース扱いになり、中身の変更だけで下流全部再コンパイル対象に。`.mli`分離すればシグネチャ不変なら下流再コンパイル回避できる。flambda(クロスモジュールインライン最適化)有効時は`.mli`書いてても波及するケースあり。

**opam switch**: OCamlコンパイラをソースからビルドする（プリビルドバイナリDLではない）。opam自体が「ソースベース配布」哲学、switch作成毎に数分待たされるのはこれが原因。

## 他言語比較

**対Haskell**: 純粋関数型じゃない分実務で書きやすい、正格評価でメモリ挙動予測しやすい（遅延評価の空間リーク問題なし）、コンパイル速い。

**対Scala**: JVM無し→起動速い・ネイティブバイナリ、言語機能絞ってる分implicit地獄なし、コンパイル速い（Scalaは遅いので有名）。

**対Lisp**: 静的型+型推論で実行前バグ検出。

**対Rust**: Rustは所有権をコンパイル時解決→実行時性能の理論上限はRust。ただしAST/コンパイラ領域はグラフ構造(複数箇所から同一ノード参照)が多く、借用チェッカーと相性悪い(`Rc<RefCell<_>>`等で疑似GC再発明になりがち)。OCamlはGC付きだからグラフ構造を素直に書ける。コンパイル速度もOCamlが優位（借用チェック分のオーバーヘッドがRustに乗る）。「性能が直接価値になる場面はRust、開発イテレーション速度が欲しい場面はOCaml」という住み分け。

**対Go**: 軸が違う（性能vs速度ではなく、シンプルさ・エコシステムvs型の表現力）。
- Go優位: Kubernetes/Docker/Terraform等インフラツール群のエコシステム、goroutine/channelの並行処理成熟度(10年以上の実戦投入)、コンパイル速度、学習コストの低さ
- OCaml優位: ジェネリクス・代数的データ型の表現力、`nil`皆無、`Result`+パターンマッチの網羅性チェック
- 結論: インフラ/クラウドツールはGo圧勝、複雑ドメインロジックの型安全性はOCaml優位

**コンパイラ/静的解析ツール領域の実例**: Rust初期コンパイラ、ReScript、Flow、Hack typechecker、Infer、Semgrep、Frama-C、Coq、Why3、Merlin。Meta(旧Facebook)がFlow/Hack/Infer/Semgrepと繰り返しOCaml選んでる組織的慣性も大きい。ただし2020年代はRust(rust-analyzer, swc, biome, ruff等)が新規プロジェクトの主流になりつつあり、この領域の勢力図も変化中。

## Unikernel/MirageOS

Unikernel = アプリに必要な最小限コードだけをハイパーバイザ上に直接動かす。汎用OSカーネル経由しない、攻撃対象面が劇的に小さい。

MirageOSはOCaml実装。TCP/IPスタック(`mirage-tcpip`)含め、通常OSが提供する機能を全部OCamlライブラリとして実装、functorで開発時(Unix socket)/本番(Xen/KVM直接)を同一インターフェースで切替可能。

**メリット**: 抽象化層なしで性能良い、余計な機能ゼロで起動速い、最小構成で攻撃対象面小さい。

**Dockerとの違い**: 上位互換ではなく別軸のトレードオフ。Dockerはカーネル共有+高い汎用性/互換性、Unikernelはカーネル共有すらせず攻撃対象面最小だが既存アプリそのまま動かせない(全部書き直し必要)。

**サーバーレス(Lambda/Workers)的な高速起動での優位性**: 理論上はある(unikernel起動=ミリ秒オーダー)が、実際の業界はFirecracker(AWS、最小Linux+KVM)やV8 isolate(Cloudflare Workers)という別解決策を選んだ。Unix互換性を捨てる代償が実装判断で割に合わないと判断された。

**アプリ開発の実際**: Webサーバーは`S.TCP.listen`等で普通に書ける。DB接続は壁がある—既存DBクライアント(postgresql-ocaml, Caqtiドライバ)はUnixソケット/libpq Cバインディング前提で、Unikernel環境にはUnix自体が存在しないため動かない。Mirageの抽象Flow上でワイヤプロトコル自前実装するアダプタが必要。

**ホスティング**: AWS/GCPにUnikernel専用マネージドサービスは無い。選択肢は(1)既存VMインフラへの手動カスタムイメージデプロイ、(2)NanoVMs/Unikraft等専門スタートアップ、(3)自前ハイパーバイザ運用。デプロイ・運用の手間が実用性最大のボトルネック。

**実用面の結論**: 汎用アプリ開発では非実用（ライブラリ資産Unix依存、ホスティング無し、デバッグツール無し）。DNSサーバー/VPN終端/ファイアウォール等「DB・ファイルシステム不要、ネットワークパケット処理だけ」の単機能アプライアンス、かつセキュリティが最優先で機能追加より攻撃対象最小化に投資価値がある組織限定で実用。

## 総合評価

OCamlは汎用言語というより**専門特化の道具**。

- 型安全なドメインロジック層としては強い（特に金融、コンパイラ/静的解析）
- Web/DB/インフラ周辺エコシステムは薄く、TS/Go/Rustに分がある
- 「型安全ロジック層だけOCaml、周辺は別ツール」という部分採用が現実的な選択パターン
- Unikernel(MirageOS)はOCamlの特性(GC付きだが軽量、モジュールシステム、型安全性)を活かしたニッチだが実在する応用領域、ただし実用範囲はさらに狭い
