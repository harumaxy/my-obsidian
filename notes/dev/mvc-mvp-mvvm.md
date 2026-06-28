---
title: "MVC / MVP / MVVM チートシート"
description: "UIアーキテクチャパターンの用語集と比較。React/Vue/SwiftUI/Composeでの実装スタイルを整理"
aliases:
  - ui-architecture-patterns
tags:
  - architecture
  - frontend
  - mobile
draft: false
date: 2026-06-28
---

# MVC / MVP / MVVM チートシート

## パターン比較

| | MVC | MVP | MVVM |
|---|---|---|---|
| 中間層 | Controller | Presenter | ViewModel |
| V→Model の直接参照 | あり | なし | なし |
| 中間層→View の参照 | あり | あり（Interface経由） | **なし** |
| View 更新の仕組み | Observer / 直接呼び出し | Presenter が明示的に呼ぶ | **データバインディング（自動）** |
| テストしやすさ | 普通 | 高い | 高い |

---

## MVC

```
User Input → Controller → Model
                              ↓ notify（Observer）
                           View
```

- **発祥**: 1979年 Smalltalk のデスクトップ GUI
- **Web SSR 版**（Rails/Spring）は簡略化版。Observer パターンがなくリクエスト/レスポンスで完結
- **問題**: Controller が肥大化しやすい（"Massive View Controller"）
- **採用例**: Ruby on Rails, Spring MVC, 初期の iOS UIKit / Android Activity

> iOS/Android が MVC になった経緯: Apple は macOS Cocoa の設計を UIKit にそのまま継承。
> Android は iOS の影響を受けた。どちらも Controller が View 管理を兼任して肥大化問題が発生。

---

## MVP

```
User Input → View ←→ Presenter → Model
```

- Presenter が Model を操作し、View を**明示的に**更新する
- View は Interface（プロトコル）経由なのでモック化しやすく**テストが書きやすい**
- **流行らなかった理由**: Presenter も Controller 同様に肥大化する。ボイラープレートが多い
- **採用例**: Android 旧来の設計, WinForms, ASP.NET WebForms

---

## MVVM

```
User Input → View ←[データバインディング]→ ViewModel → Model
```

- ViewModel は View を**知らない**（参照を持たない）← MVP との最大の違い
- フレームワークが依存を自動追跡し、状態変化で該当 View だけ再描画
- 開発者は subscribe を手書きしなくていい（Backbone 時代は `model.on('change', render)` を手書き）

### ViewModel の実態

- 変更されると UI をリアクティブに更新する **state を持つ object**
- View のことを知らない。View 側がフレームワーク経由で変更を検知して再描画
- 純粋な object/struct で、状態を変更するメソッドがついており**単体テスト可能**

### フレームワーク別リアクティビティ実装

| | 仕組み | 状態の書き方 |
|---|---|---|
| Vue 2 | `Object.defineProperty` で getter/setter をフック | `data() { return { count: 0 } }` |
| Vue 3 | `Proxy` でオブジェクト全体をラップ | `ref(0)` / `reactive({})` |
| SwiftUI | `@Published` + `ObservableObject` | `@Published var count = 0` |
| Jetpack Compose | `StateFlow` / `MutableStateFlow` | `_state.update { ... }` |
| AngularJS | ダイジェスト・サイクル（ポーリング的変更検出） | `$scope.count = 0` |

### Vue 2 の `this` マージの仕組み

```js
new Vue({
  data() { return { count: 0 } },          // → vm.count にマージ＆リアクティブ化
  methods: { increment() { this.count++ } } // → vm.increment にバインド
})
// Vue が内部で全プロパティをフラット化し 1 つの vm インスタンスに載せる
```

### SwiftUI（概要）

```swift
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []  // 変化すると View が再描画
    func addTodo(...) { ... }          // View を触らず state だけ変える
}
struct TodoView: View {
    @StateObject var vm = TodoViewModel()  // ViewModel を所有
    var body: some View { /* vm.todos を参照するだけ */ }
}
```

### Jetpack Compose（概要）

```kotlin
class TodoViewModel : ViewModel() {
    private val _todos = MutableStateFlow<List<Todo>>(emptyList())
    val todos: StateFlow<List<Todo>> = _todos.asStateFlow()  // 外部は読み取り専用
    fun addTodo(...) { _todos.update { it + ... } }
}
@Composable
fun TodoScreen(vm: TodoViewModel = viewModel()) {
    val todos by vm.todos.collectAsState()  // Flow を監視して再コンポーズ
    ...
}
```

---

## Options API vs Composition API（Vue）

### Options API の問題

1つの機能のコードが `data` / `methods` / `computed` / `watch` に**分散**する。

### Composition API

関連ロジックを1か所にまとめた **Composable 関数**として切り出せる。

```js
function useSearch() {       // Composable（React の Custom Hook と同じ発想）
  const query = ref('')
  const results = ref([])
  watch(query, () => search(query.value))
  return { query, results }
}

setup() {
  const { query, results } = useSearch()  // 合成（Composition）
  const { user } = useAuth()
  return { query, results, user }
}
```

**"Composition"** = 小さな Composable 関数を**組み合わせて**コンポーネントを構成する

---

## 用語集

| 用語 | 説明 |
|---|---|
| **MVC** | Model-View-Controller。UIアーキテクチャの元祖（1979年 Smalltalk） |
| **MVP** | Model-View-Presenter。View と Model を完全分離。Presenter が View を明示的に更新 |
| **MVVM** | Model-View-ViewModel。ViewModel が View を知らず、データバインディングで View が追従 |
| **データバインディング** | 状態とUIを紐付ける仕組み。状態が変わると自動でUIが更新される |
| **双方向データバインディング** | Model→View と View→Model の両方向を自動同期（AngularJS, Vue `v-model`） |
| **一方向データフロー** | データが一方向にしか流れない（React, Flux）。追跡しやすく予測可能 |
| **リアクティビティ** | 状態の変化を自動検知して関連する処理（再描画など）を起動する仕組み |
| **Observer パターン** | 状態の変化を購読者（subscriber）に通知するデザインパターン |
| **Proxy** | JS のオブジェクト操作をフックできる組み込みオブジェクト。Vue 3 のリアクティビティの基盤 |
| **Object.defineProperty** | プロパティの getter/setter を定義できる JS API。Vue 2 のリアクティビティの基盤 |
| **ObservableObject** | SwiftUI で ViewModel として機能するプロトコル。`@Published` プロパティの変化を通知する |
| **@Published** | SwiftUI のデコレーター。プロパティ変化時に View に通知する |
| **@StateObject** | SwiftUI で ViewModel を所有・監視するデコレーター |
| **StateFlow** | Kotlin/Android のリアクティブな状態ストリーム。RxJava の現代的代替 |
| **MutableStateFlow** | 書き込み可能な StateFlow。外部には読み取り専用の `StateFlow` を公開するのが慣習 |
| **collectAsState()** | Compose で StateFlow を監視し、変化があると Composable を再実行する API |
| **Composable（Compose）** | Jetpack Compose の UI 関数。`@Composable` アノテーションで宣言 |
| **Composable（Vue）** | Vue 3 でロジックを再利用するための関数。React の Custom Hook と同じ発想 |
| **Options API** | Vue 2 のスタイル。`data` / `methods` / `computed` / `watch` をオプションとして渡す |
| **Composition API** | Vue 3 の新スタイル。関連ロジックを関数にまとめて合成できる |
| **Flux** | Facebook が提案した一方向データフローアーキテクチャ。Action→Dispatcher→Store→View |
| **ダイジェスト・サイクル** | AngularJS の変更検出機構。定期的にスコープ内の値を比較して変化を検知。複雑なアプリで遅延の原因に |
| **Massive View Controller** | iOS 開発での MVC の病理。UIViewController に全ロジックが集中して肥大化する問題 |
| **DI（依存性注入）** | 依存するオブジェクトを外部から注入するパターン。Angular が積極採用 |
| **SSR** | Server-Side Rendering。サーバー側で HTML を生成してクライアントに返す方式 |
| **ref()** | Vue 3 でプリミティブ値をリアクティブにラップする関数。`.value` でアクセス |
| **reactive()** | Vue 3 でオブジェクトをリアクティブにラップする関数 |

---

## 現在の主流

| 領域 | 主流パターン |
|---|---|
| Web フロントエンド | React（Flux / 一方向データフロー）|
| Vue.js | Composition API（MVVM から Reactive Programming へ移行中）|
| Angular | MVVM ベース + DI + RxJS |
| iOS (SwiftUI) | MVVM（`ObservableObject` + `@Published`）|
| Android (Compose) | MVVM（`ViewModel` + `StateFlow`）|
| Web SSR (Rails 等) | 簡略化 MVC |
| レガシー | MVC / MVP（保守目的のみ）|
