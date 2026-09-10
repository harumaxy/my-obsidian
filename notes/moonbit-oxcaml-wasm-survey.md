---
title: moonbit-oxcaml-wasm-survey
description: WASM実用性・MoonBit・OxCaml調査メモ
# permalink:  # don't use
aliases:
  -
tags:
  - wasm
  - moonbit
  - oxcaml
  - ocaml
  - rust
  - cloudflare-workers
draft: false
date: 2026-09-10
---

## きっかけ

mizchi のポスト「今学ぶと差がつくプログラミング言語10選」。MoonBit / OxCaml / Lean / Quint / Verse / Dafny / Rust(no_std)。

全体傾向: 実務言語より形式手法・検証系偏重。Lean/Dafny/Quint = 証明・仕様検証系。OxCaml/Verse = 産業界新興(Jane Street/Epic)。Rust(no_std)だけ毛色違う既存主流技術。

背景(TS Web開発+Cloudflare Workers+Godot趣味)との接点、Rustだけ実質当たり。gdext(Godot拡張)、workers-rs(CF Workers)両方に効く。

## WASM実用性

V8 JIT 速い→重い処理のためだけにWASM化する投資対効果は薄い。

WASM本質価値 = 既存ネイティブ資産(ffmpeg, SQLite等)を**書き直さず持ち込める**点。JS代替ではなく特定要件解決の道具。

刺さる場面:
- 既存C/C++資産の丸ごと移植(ffmpeg.wasm, sql.js)
- 性能予測可能性(JITウォームアップ不要、Workers isolateの短命実行と相性)
- 厳密数値型(u64/i64、JSはBigIntで遅い)
- SIMD/低レベル制御
- サンドボックス隔離(プラグイン実行)

サーバー/DBクライアント: WASM単体でTCPソケット直接持てない(サンドボックス化計算モジュール)。Cloudflare Workersの`cloudflare:sockets`もJS側API、DBクライアント(pg等)はJSのまま。通信=JS/TS、重い計算だけWASM切り出す、が現実パターン。Prisma edge/WASM query engineも同じ型(計算=WASM、通信=HTTPドライバ)。

クロスプラットフォーム: Android/iOSはネイティブコンパイルで十分(WASM不要、遅い)。WebだけOSネイティブバイナリ実行不可のサンドボックス→ここを埋めるのがWASMの役割。コアロジック共有構成 = ネイティブ2ターゲット+WASM1ターゲット。実例: Figma(C++描画エンジンをWASM化)。

結論: 初期の「WASMがJS/Web再発明」的hypeは外れた。Gartner hype cycle的に幻滅期を超え、限定的だが確実な実用領域(既存資産移植・クロスプラットフォームのWeb面埋め・プラグインサンドボックス)に収束した技術。TS Web開発+Godot+CF Workersの領域では出番ほぼなし。

## MoonBit

WASM出力の言語処理系。言語設計自体の差別化点:

- GCベース、再帰的ADTがRustのBox不要でそのまま書ける
- 強力なパターンマッチ(配列/文字列スライスパターン `[first, .. middle, last]`)
- `suberror`構文でエラー型定義、Error型への自動昇格+パターンマッチ復元
- コンパイル速度を明確に売りにしてる設計思想

GC採用理由(推測込み): 複数バックエンド(JS/Wasm/WasmGC/Native)でホスト側GCにそのまま乗れる設計上の単純化。用途もRustのシステムプログラミング領域と違い、クラウド/エッジ向けビジネスロジック記述が主眼。

WASM出力サイズ: 2種のwasmターゲットで挙動違う。
- `wasm`(無印、linear memory): 独自参照カウントを自前バンドル→サイズ増(Go wasmと同系統の問題)
- `wasm-gc`(WasmGC提案準拠): ホストのGCを再利用→自前GC不要、サイズ肥大化しない

ジェネリクス: モノモーフィゼーションしない設計。公式表現「単一コードセットで複数型を扱う、ロジック複製なし」。恐らく辞書渡し方式(Haskell型クラス/Swiftジェネリクスに近い、推測)。ビルド時間・バイナリサイズは有利だが、実行時に間接呼び出しオーバーヘッドが乗る可能性→コンパイル時間コストを実行時オーバーヘッドに付け替えた構図。trait object(型消去)による動的ディスパッチも別途あり。

Go比較(公式ドキュメント "for-go-programmers" より):
- 共通点: 静的型+型推論、高速コンパイル、メモリ安全、クラウド/エッジ向け
- 差分: 関数型+命令型ハイブリッド(Go命令型オンリー)、堅牢なジェネリクス(Goは2022年後付けで薄い)、網羅的パターンマッチ(Goになし)、`raise`/`suberror`のチェック付きエラー機構(Goの`if err != nil`羅列と対照的)

位置づけ: ML系(Rust/OCaml/Haskell系譜)の表現力 + GCによる生産性・省コンパイル戦略 + Web/エッジ向けマルチターゲット出力(WASM/JS/Native)の3点セット。Javaの「独自VM(JVM)でWrite Once Run Anywhere」型解決とは違い、既存ターゲット(JS/Wasm/Native)に相乗りするマルチターゲットコンパイラ型の解決。

弱点: エコシステムが薄い。言語設計は筋良いが実務投入の壁はここに集約。時間でしか解決しない変数、今はウォッチ止まり。

## OxCaml

Jane Street製、OCaml(5.2.0ベース)のフォーク。Flambda 2最適化器+独自CFGバックエンド。

3本柱:
1. **Unboxed types**: `float#`, `int32#`等の`#`付き型でボックス化(ヒープ+ポインタ間接参照)回避、レジスタ/スタックに直接値を持てる
2. **Mode system**: 値がヒープ確保(global)かスタック確保(local)かを注釈で明示制御、GC圧軽減。オプトイン(デフォルトは従来通りヒープ+GC)
3. **データ競合フリー並行性**: atomics/locks/modes/capsulesでマルチコア並行プログラミングをコンパイラが保証

制約: mode/kind system導入でポリモーフィズムに制約(関数がvalueのmode意識する必要)。

位置づけ: 「Rust化したOCaml」というよりGCデフォルトは崩さず、Rustの性能テクニックをオプトインでアラカルト適用できるOCaml。全面borrow checker強制(Rust)とは負担のかけ方が違う。Jane Street社内で金融取引系の低レイテンシ要求箇所にだけ投入、大半は普通のOCamlのまま、という運用が実態。

フォーク分裂リスク: 実際は継続的に本家追従(5.2→5.4のマージ実施を公式Wikiで確認)。Jane Streetは過去Flambda/Multicore OCaml(OCaml5並行機構)を主導しアップストリーム化してきた実績あり、Oracle JDK的な囲い込みとは性質が違う。SwiftやKotlin(企業主導→OSS)に近い構造。残るリスクはOxCaml固有拡張(mode注釈等)を使うほど本家との互換性が落ちるロックイン、素のOCamlとして書けば安全。

開発生産性系メリット(性能・並行性以外):
- **Labeled tuples**: タプル要素に名前付与。構造的型付け(型名宣言不要)。レコード新設が大袈裟な場面向け
  ```ocaml
  val pipe : ?close_on_exec:bool -> unit -> read:File_descr.t * write:File_descr.t
  ```
  制約: ドット記法アクセス不可、構築時の要素並べ替え不可、トップレベルlet束縛では部分マッチの柔軟性低い
- **Comprehensions**: Python/Haskell的内包表記。`for`/`and`/`when`組み合わせ自由、map/filter相当を内包表記で書ける
- **Immutable arrays**: `[: ... :]`専用デリミタ、破壊的更新不可能配列
- **Unboxed records**: `#{ }`構文でヒープ確保なしレコード

ビルド速度自体を売りにする訴求はMoonBitと違い見当たらない。ビルドツールはOCaml標準のDune、OxCaml固有の恩恵ではない。

Labeled tuple vs Record使い分け: 構造的(Labeled tuple、型宣言不要) vs 名目的(Record、明示宣言必須)。一時的・ローカルな軽量用途はLabeled tuple、恒久的ドメインモデル・public API境界はRecord。TSで言えばインラインオブジェクト型リテラル vs `interface`/`type`宣言の感覚。

強み: 既存OCamlエコシステム(opam, Dune, 実務ライブラリ群)をそのまま継承できる点がMoonBitとの決定的差。Jane Street社内実運用実績もあり。昔OCaml書いてた経験があるなら相性良さそう。
