---
title: "Fluent React - Chapter 1 補足: フロントエンド史とアーキテクチャパターン考察"
description: "Chapter 1 を読んで議論した内容。Backbone/Knockout の歴史的位置づけ、MVC/MVVM/Flux の違い、コードファースト思想の普及"
aliases:
  - fluent-react-ch1-appendix
tags:
  - react
  - frontend
  - architecture
  - oreilly
draft: false
date: 2026-06-28
---

# Chapter 1 補足: フロントエンド史とアーキテクチャパターン考察

## Backbone.js / KnockoutJS は流行ったのか

知らなくて当然で、どちらも **2010 年前後に流行ったが React（2013年〜）の登場で一気に陳腐化した**。

- **Backbone.js**: jQuery 全盛期に「構造化」の概念をフロントエンドに持ち込んだ。Twitter・Airbnb・LinkedIn が採用
- **KnockoutJS**: Microsoft の Steve Sanderson 作。ASP.NET コミュニティを中心に広まった

2018年以降に Web 開発者になった世代は実務で触れることがなく、名前だけ知っている存在。

---

## フロントエンド MVC とは何か

サーバーサイド MVC（Rails / Spring Boot）との違い：

| | サーバーサイド MVC | フロントエンド MVC（Backbone） |
|---|---|---|
| 実行場所 | サーバー | ブラウザ内 |
| View の役割 | テンプレートで HTML を生成して返す | DOM を監視・更新し続ける |
| 状態の場所 | サーバー | ブラウザ内の JS オブジェクト |
| ページ遷移 | リクエストのたびに全体再レンダリング | URL が変わっても JS が状態を保持 |

Backbone の問題は**イベントの連鎖**。`Model が変わる → イベント発火 → View A 更新 → 別イベント発火 → View B 更新 → ...` という連鎖が追いにくかった。

---

## Knockout が流行らなかった理由

MVVM パターン自体は正しかった。**実装アプローチが Web の進化と合わなかった**のが原因。

```html
<!-- Knockout: HTML が主役、JS を後付けで繋ぐ -->
<button data-bind="click: likePost, enable: !isPending()">いいね</button>
```

```jsx
// React: JS が主役、HTML は出力結果
<button onClick={likePost} disabled={isPending}>いいね</button>
```

Web は「**JS がファーストクラス**」という方向に進化した。Knockout は HTML 中心のまま JS を埋め込む発想だったため乗り遅れた。また Microsoft / ASP.NET のイメージが強く、Web 全体には広がりにくかった。

---

## 現代の MVVM（SwiftUI / Jetpack Compose）は React の子孫

SwiftUI / Compose は名前こそ MVVM だが、実態は **React の思想をネイティブに移植したもの**に近い。

| | Knockout MVVM | SwiftUI / Compose |
|---|---|---|
| バインディング | HTML の `data-bind` 属性 | `@State` / `remember` などの言語機能 |
| 発想 | View と ViewModel を繋ぐ | 状態が変わったら View を再構築 |
| コンポジション | 弱い | コンポーネント関数として自然に合成できる |

「UI をコードで記述する（コードファースト）」という思想は React が証明し、各プラットフォームが独自のパターンで実装した。

- React はパターンとしては **Flux（一方向データフロー）**
- SwiftUI / Compose はパターンとしては **MVVM**
- **思想だけ輸出してパターンは各プラットフォームが選んだ**、という整理が正確

---

## Flux パターンとは何か

```
Action → Dispatcher → Store → View → (ユーザー操作) → Action → ...
```

完全に一方向で逆流しない。

| | MVVM | Flux |
|---|---|---|
| データフロー | View ↔ ViewModel（双方向） | 一方向のみ |
| 状態の更新 | View から直接 ViewModel を変更できる | 必ず Action 経由 |
| デバッグ | 変更元が複数になりうる | Action の履歴を追えば必ず分かる |

Redux の「タイムトラベルデバッグ」が実現できるのも、この一方向性があるから。

---

## 双方向バインディングの本質

> 「state の変数を読み取る以外に、代入で更新できるかどうか？の違いで、変更されたら再レンダリングは変わらない」

その通りで、本質は**変更の入口を関数に絞るか、代入を直接許すか**の違いに過ぎない。

Flux が価値を持った時代的背景：
- 状態が巨大でどこからでも変更されていた（グローバル変数地獄）
- チーム開発で「誰が何を変えたか」が追えなかった

現代は `useState` でローカルに閉じ込めたり TypeScript で型制約できるようになったため、Redux のような厳格な Flux はオーバーキルになりつつある。

---

## Flux と Redux の違い

- **Flux**: Facebook が提唱した**アーキテクチャパターン**（概念）
- **Redux**: Flux パターンの**実装ライブラリ**の一つ（最も広まった）

`useState` は Flux そのものではないが、「状態を直接変えず setter 経由で更新する」という点では Flux の思想を継承している。現代では **Flux という言葉自体がほぼ Redux の文脈でしか使われない**。
