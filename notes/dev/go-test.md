---
title: Go テスト - t.Context() と並列実行
description: Go 1.24 で追加された t.Context() の使い方・移行方法・テスト並列実行の仕組み
# permalink:  # don't use
aliases:
  - go testing
tags:
  - go
  - testing
draft: false
date: 2026-06-25
---

# Go テスト - t.Context() と並列実行

## t.Context() とは（Go 1.24〜）

`testing.T` に追加されたメソッド。**そのテストが終了した瞬間に自動でキャンセルされるコンテキスト**を返す。

```go
func TestFoo(t *testing.T) {
    ctx := t.Context()
    db.QueryContext(ctx, "SELECT ...")
    http.NewRequestWithContext(ctx, "GET", url, nil)
}
```

### キャンセルされるタイミング

- テスト関数が `return` した（正常終了）
- `t.Fatal()` / `t.FailNow()` で即時終了
- プロセスに SIGTERM / SIGINT が来た場合

> 他のテストがエラーになっても自分のテストのコンテキストはキャンセルされない。あくまで「自分のテストのライフサイクル」に紐付く。

### なぜ便利か

従来は `cancel` の書き忘れでリークが起きていた：

```go
// 従来
ctx, cancel := context.WithCancel(context.Background())
defer cancel()  // 書き忘れるとリーク
```

`t.Context()` を使うと自動キャンセルされるため、テスト失敗後に HTTP コネクションや DB クエリが裏で生き残るリソースリークを防げる。

### 注意: t.Cleanup 内では使えない

クリーンアップ関数内ではコンテキストがすでにキャンセル済みのため `context.Background()` のままにする：

```go
t.Cleanup(func() {
    DoSomething(context.Background())  // t.Context() は使ってはいけない
})
```

---

## 既存コードの一括移行

テストファイル内の `context.Background()` を `t.Context()` に一括置換：

```bash
find . -type d -name "generated" -prune \
    -o -type f -name "*_test.go" ! -name "main_test.go" \
    -exec sed -i '' 's/context.Background()/t.Context()/g' {} +
```

不要になった `context` インポートを削除：

```bash
goimports -w .
```

---

## 再発防止: golangci-lint の usetesting ルール

`.golangci.yml` に追加して新規コードでの `context.Background()` 使用を lint エラーにする。

---

## テストの並列実行

Go のテストはデフォルトで**パッケージ内は直列実行**。

| 設定 | 挙動 |
|------|------|
| デフォルト | パッケージ内直列 |
| `t.Parallel()` を呼んだテスト | 並列実行される |
| `-parallel N` フラグ | 並列数を制御（デフォルトは CPU コア数） |
| `-p N` フラグ | パッケージ間の並列数を制御 |

---

## 参考

- [Zenn: Go 1.24の`t.Context`メソッド対応について](https://zenn.dev/budougumi617/articles/quick-migrate-go-test-context)
