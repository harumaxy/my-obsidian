---
title: fluent-react-concurrent-rendering
description: Reactコンカレントレンダリング(Fiber/レーン/useTransition/useDeferredValue)理解メモ
# permalink:  # don't use
aliases:
  -
tags:
  - react
  - concurrent
draft: false
date: 2026-08-09
---

参考: 『流暢なReact』(Tejas Kumar, O'Reilly) 第7章 コンカレントReact

## 前提誤解の訂正

コンカレント(並行)≠マルチスレッド並列処理。JS自体シングルスレッド。
処理速度(スループット)自体は変わらない、むしろ分割・中断のオーバーヘッドで微増もありうる。
実現してるのは「体感速度(レスポンス感)」。優先度高い更新先に処理、低い方後回しにするだけ。

## Fiber = 実行の器

レンダリング処理を小単位(ファイバー)に分割。中断・再開・実行順序並び替え可能にする仕組み。
React 16導入。「何を先にやるか」は決めない、決めるのはレーン。

## レーン = 優先度ラベル

setState等の更新発生時、発生コンテキストから優先度推測→レーンに割当。

- Sync: クリックハンドラ内setState、最優先
- InputContinuous: ホバー/スクロール等連続入力
- Default: ネットワーク応答、setTimeout由来
- Transition: startTransition内setState、低優先度
- Retry: Suspense再試行

内部はビットマスク(2進数フラグ)表現。複数レーンまとめ・比較をビット演算で高速処理。

処理順序: 更新収集→優先度高いレーンから順に処理(同レーンはまとめて1回)→コミット(DOM反映)→次サイクル繰り返し。

Fiber(器)+レーン(優先度)揃って初めて「重要な更新を先に」実現。

## useTransition / startTransition

「この更新は低優先度でいい」と明示的にReactに伝えるAPI。
`const [isPending, startTransition] = useTransition()`
更新をstartTransitionで包む→Transitionレーンに乗る。isPendingで進行中表示可。
フック外でも関数版`startTransition`直接import可(isPendingなし版)。

## useDeferredValue

値の更新を後回しにするフック。初回レンダリングは元値と同じ、以降は新値反映を遅延。
デバウンス/スロットルとの違い: 固定遅延でなくデバイス性能に応じ動的調整、かつ中断可能。

## 使うか迷ったときの判断基準

「これはユーザ操作への直接的フィードバックか？」
- YES(入力欄の文字、ホバー状態) → 何もしない、自動でSync優先扱い
- NO(その操作の結果として起きる重い処理) → Transition/Deferred候補

## 実践ユースケース

- 検索・フィルタリング: 入力欄即時反映、検索結果リスト再計算はuseDeferredValueで遅延
- タブ/ページ切り替え(重いコンテンツ含む): 切替ボタンは即反応、中身レンダリングはstartTransitionで包む
- WebSocket/ポーリング等サーバ由来の一括更新: startTransitionで包みユーザ操作優先
- 巨大リストのソート/フィルタ操作: 再計算重い場合startTransitionで包む

## ティアリング(Tearing)問題

レンダリング中に外部状態(グローバル変数等)変化→コンポーネント間で不整合な値表示されるバグ。
同期レンダリングでは起きない、コンカレントレンダリング特有の落とし穴。

解決策: `useSyncExternalStore(subscribe, getSnapshot)`
外部ストア変更を同期的に反映→レンダリング中の一貫性保証。ウィンドウリサイズ監視等の外部イベント購読に有効。

## 注意点

- 乱用禁止。何でもTransitionで包むと逆に挙動が読みにくくなる
- Deferredは「表示が一瞬古いまま」許容できる場面限定。金額・在庫数など即時性重要な値には不向き
- 根本的に処理が遅いなら気休め。useMemo・仮想化(react-window等)・計算量削減が先
- 設計初期から意識するAPIでない。「重い更新でUIがカクつく」と気づいた時の対症療法的後付け最適化
