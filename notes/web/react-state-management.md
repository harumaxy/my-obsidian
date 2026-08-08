---
title: React 状態管理ライブラリ比較
description: valtio / zustand / jotai / redux / mobx の概念と使い分け
aliases:
  - valtio
  - 状態管理
tags:
  - react
  - state-management
draft: false
date: 2026-08-02
---

# React 状態管理ライブラリ

## 前提知識

### JS Proxy

ES6 標準機能。オブジェクト操作を横取りするトラップ定義できる。

```js
const handler = {
  get(target, key) { return target[key] },
  set(target, key, value) {
    target[key] = value
    return true
  }
}
const obj = new Proxy({ count: 0 }, handler)
```

- `Object.defineProperty` getter/setter → 特定プロパティに個別定義
- Proxy → オブジェクト全体を一括横取り

### Immer

イミュータブル更新ライブラリ。ネストオブジェクトのスプレッド地獄を回避。

```js
// before
setState(prev => ({ ...prev, user: { ...prev.user, city: 'Tokyo' } }))

// after (Immer)
setState(produce(draft => { draft.user.city = 'Tokyo' }))
```

Proxy の `set` トラップで操作記録 → 元オブジェクト不変のまま新オブジェクト生成。

---

## valtio

- Proxy ベース ミュータブル状態管理
- 直接代入で更新 → Immer 不要
- コンポーネント外（WebSocket等）からも更新可能

```js
import { proxy, useSnapshot } from 'valtio'

export const state = proxy({ count: 0, name: 'John' })

function Counter() {
  const snap = useSnapshot(state)  // 読み取り
  return (
    <button onClick={() => state.count++}>  // 書き込み: 直接ミュータブル
      {snap.count}
    </button>
  )
}
```

**仕組み:**
1. `proxy()` → Proxy でラップ
2. `set` トラップ → 変更検知 → サブスクライバー通知
3. `useSnapshot()` → `get` トラップでアクセス済プロパティ追跡
4. 読んだプロパティのみ変更時に再レンダリング（最適化済）

`state.name = 'Bob'` → count だけ読む Counter は**再レンダしない**。

**WebSocket との相性:**

```js
const ws = new WebSocket('wss://...')
ws.onmessage = (e) => {
  state.messages.push(JSON.parse(e.data))  // コンポーネント外から直接更新
}
```

---

## ライブラリ選定

| ライブラリ | 向いてる場面 |
|-----------|------------|
| **Zustand** | 迷ったらこれ。シンプル・軽量・実質標準 |
| **Jotai** | 細粒度アトム設計。派生状態が多い |
| **valtio** | 外部イベント駆動・ミュータブル操作好き |
| **Redux Toolkit** | 大規模チーム・厳格な変更追跡必要 |
| **MobX** | 既存コードで見るだけ。新規不要 |

**導入タイミング:**
- 小規模・状態が2〜3階層 → `useState` + Context で十分
- 画面5枚超 or リアルタイム通信 → ライブラリ入れる
- サーバー状態は TanStack Query に逃がすとクライアント状態が激減

---

## MobX（歴史）

valtio の先祖。クラス + デコレータ文化、OOP寄り。

```js
class CounterStore {
  count = 0
  constructor() { makeAutoObservable(this) }
  increment() { this.count++ }
}
const Counter = observer(() => <button onClick={() => store.increment()}>{store.count}</button>)
```

MobX（2015〜）がミュータブル状態管理を証明 → valtio がプレーンオブジェクトでシンプルに再実装。
