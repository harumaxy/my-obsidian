---
title: es-toolkit
description: lodash代替目指すJS/TSユーティリティライブラリ調査メモ
# permalink:  # don't use
aliases:
  -
tags:
  - javascript
  - typescript
  - library
draft: false
date: 2026-09-23
---

## 概要

es-toolkit。韓国フィンテック企業Toss製、lodash代替目指すJavaScript/TypeScriptユーティリティライブラリ。MIT license。

リポジトリ: https://github.com/toss/es-toolkit

特徴:
- 高速。lodash比2-3倍速目指す新規実装
- 軽量。tree-shaking前提、バンドルサイズ最大97%削減
- TypeScriptネイティブ。型定義リポジトリ内蔵、strong type annotation
- `es-toolkit/compat` サブパスでlodash完全互換レイヤーも用意。移行しやすい
- テストカバレッジ100%
- Storybook, Recharts, ink, CKEditor等有名OSSで採用実績あり

## 構成(src/)

カテゴリ毎にディレクトリ分割。関数単位1ファイル1実装、JSDoc+`@example`完備。

- array (137) — chunk, groupBy, partition, uniq/uniqBy, union/intersection/difference, sample/shuffle, zip/unzip, sortBy/orderBy等
- object (49) — pick/omit, merge/mergeWith, cloneDeep, mapKeys/mapValues, toCamelCaseKeys等
- string (46) — camelCase/kebabCase/snakeCase等ケース変換一式, trim, pad, escape/unescape, dedent
- math (32) — clamp, lerp/inverseLerp, sum/sumBy, mean/median, range, random/randomInt
- function (42) — debounce, throttle, memoize, curry, retry, once, flow(関数合成)
- promise (14) — delay, timeout/withTimeout, mutex/semaphore(並行制御), limitAsync
- predicate (66) — isNil/isNotNil, isEqual, isPlainObject, isPromise等型ガード群
- iterator (24) — range, chunk, takeWhile, scan(遅延評価版, ジェネレータベース)
- map/set (24/18) — countBy, keyBy, filter/reduce。Map/Set専用、lodashにはない独自拡張
- 他: bigint, error, types, util, fp(関数型API), compat(lodash互換), server

async系(mapAsync, filterAsync, forEachAsync)は別レイヤーで用意。

## function モジュール詳細

呼び出し回数制御:
- debounce — 最後の呼び出しからN ms後実行, cancelメソッド付き
- throttle — N ms毎最大1回実行
- once — 初回のみ実行, 以降キャッシュ値返す
- before(n, func) — n-1回まで実行
- after(n, func) — n回目以降から実行

引数操作:
- curry / curryRight — カリー化(左から/右から)
- partial / partialRight — 部分適用(placeholder対応)
- ary(func, n) / unary(func) — 引数数制限
- rest(func, startIndex) — 指定index以降の引数を配列にまとめる
- spread(func) — 配列引数を個別引数に展開

合成: flow(左→右), flowRight(右→左)

キャッシュ/リトライ: memoize(単一引数のみ), retry(Promise成功までリトライ)

その他: negate, identity, noop / asyncNoop

### curryのTS型対応

対応してる。ただし汎用ジェネリクスでなく**オーバーロード列挙**方式。

- 0〜5引数まで個別シグネチャ用意、各引数毎に型別々に取れる
- 6引数以上は`(...args: any[]) => any`にフォールバック。型情報消える
- 必ず1引数ずつしか渡せない設計。lodashのcurryと違い`fn(1,2)(3)`のような複数引数一括渡し不可

実用上3〜4引数関数までなら型推論完全に効く。

## 実装サンプル(src/array/chunk.ts)

シンプルforループ、Array事前確保、`readonly T[]`受け:

```ts
export function chunk<T>(arr: readonly T[], size: number): T[][] {
  if (!Number.isInteger(size) || size <= 0) throw new Error(...)
  const chunkLength = Math.ceil(arr.length / size)
  const result: T[][] = Array(chunkLength)
  for (let index = 0; index < chunkLength; index++) {
    result[index] = arr.slice(index * size, index * size + size)
  }
  return result
}
```

## 競合比較(2026-09時点)

週間DL数(npm):

| package | DL/週 |
|---|---|
| lodash | 1億2,852万 |
| es-toolkit | 3,648万 |
| lodash-es | 3,394万 |
| underscore | 2,147万 |
| remeda | 764万 |
| radash | 148万 |

GitHub Star: es-toolkit 11,346 vs remeda 5,429。lodash-es系(ESM版lodash代替勢)ではes-toolkitが実質トップ。

背景推測:
- Toss(韓国大手フィンテック)開発リソース潤沢、公式ドキュメントサイト・多言語README完備
- Storybook等有名OSS採用 → 推移的依存でDL数底上げされてる可能性
- compat層でlodashからの移行コスト低い

### lodash-esとの違い

lodash-es = lodash本体をESM形式でビルドし直したパッケージ。lodash公式チーム自身が配布。実装ロジックはlodash本体とほぼ同一、配布形式(tree-shaking対応)だけ変えたもの。

|  | lodash-es | es-toolkit |
|---|---|---|
| 実装 | lodash本体そのまま(枯れてる) | 新規実装、高速化主張 |
| バンドルサイズ | lodashと同等(tree-shakingのみ改善) | 大幅小さい(最大97%減) |
| 型 | 別パッケージ`@types/lodash-es` | TypeScriptネイティブ内蔵 |
| メンテ再開 | 2025年後半〜。OpenJS Foundation+Sovereign Tech Agency資金提供、専属TSC設立 | 継続的活発 |

「枯れた実装のまま軽量化したい」ならlodash-es、「型安全・パフォーマンス込みで刷新したい」ならes-toolkit、の住み分け。
