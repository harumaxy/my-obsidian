---
title: テスト戦略まとめ
description: カバレッジ、モック、AI、WebSocket、E2E、並列化
aliases:
  -
tags:
  - testing
  - backend
  - frontend
draft: false
date: 2026-08-02
---

# テスト戦略まとめ

元ネタ: [なぜカバレッジ100%でも本番障害は起きるのか](https://www.youtube.com/watch?v=OwfXb6iFk5o)

---

## カバレッジは指標、目標にするな

- カバレッジ = コード通過確認。振る舞い検証ではない
- グッドハートの法則: 指標が目標化した瞬間→良い指標でなくなる
- 「80%切ったらNG」→数字埋めテスト量産。意味なし

意味のないテスト2種:
- アサーションなし → コード実行のみ、緑になるだけ
- 実装コピーテスト → `Mock に1返せ→1が返ることを確認` = 何も検証していない

## 意味のあるテストの条件

1. 失敗時に「この仕様が壊れた」と特定できる
2. リファクタ後も仕様が同じなら生き残る(内部実装に結合しない)

判断基準1問: **「このテストが明日赤くなっていたら感謝できるか?」**
→ YES = 意味あり。NO = 今日消していい。

2000件の沈黙より100件の証言。

## ミューテーションテスト

- コードにわざとバグ仕込む → テストが検知できるか確認
- カバレッジ100% でもミューテーションスコア40%はある
- ツール: Java→pitest、JS→Stryker、Python→mutmut
- Google: 20億行モノレポで本番フローに組み込み済み

## テストキラミッド

```
E2E (少)          → 遅い・壊れやすい → 数絞る
統合テスト (中)
ユニットテスト (多) → 速い・安定 → 大量に書く
```

逆ピラミッド(画面テストばかり分厚い)はアンチパターン。

---

## モックの使い方

有効:
- 外部依存(DB、API、時刻)の分離 → 速度・安定性確保
- エラー系再現 → 本物では起こしにくい障害パス
- 境界インターフェース定義

腐るパターン:
- 実装コピー(呼び出し回数検証、内部メソッド名検証)
- リファクタ毎に壊れる → 仕様でなく実装を固定している

判断: 「モックを外して実物に差し替えても同じテストが通るか?」→ 通るならモック不要

---

## AI API のテスト

AIレスポンス自体の検証は責任範囲外。

### 3層構成

| 層 | 頻度 | 内容 |
|---|---|---|
| CI (常時) | 毎PR | モック固定。コストゼロ、決定論的 |
| スモークテスト | 週次/デプロイ前 | 実API。繋がるか・形式正しいか |
| Eval | リリース前 | 出力品質スコア。前バージョン比較 |

### ランダム性への対処: プロパティベースassertion

```ts
// NG: exact match
expect(result).toBe("東京は日本の首都です")

// OK: 構造・型・制約を検証
expect(result.language).toBe("ja")
expect(result.summary.length).toBeLessThan(500)
expect(result.sentiment).toBeOneOf(["positive", "negative", "neutral"])
```

プロンプト変更・モデルバージョンアップ時はEval必須。

---

## WebSocket・マルチクライアントテスト

### 分解戦略

**ロジック層** → 純粋関数に切り出す → 普通のユニットテスト
```ts
const state = applyOperation(initialState, insertOp)
expect(state.text).toBe("hello")
```

**プロトコル層** → 実サーバー起動 + テストクライアント接続
```ts
client.send(JSON.stringify({ type: "join", room: "test" }))
const msg = await waitForMessage(client, "user-joined")
```

**マルチクライアント** → 複数インスタンス同一テスト内で並走
```ts
const [clientA, clientB] = await Promise.all([connect(), connect()])
clientA.send(editOp)
await waitForMessage(clientB, "sync")
expect(clientB.state).toEqual(clientA.state)  // 収束確認
```

**E2E** → Playwright マルチタブ

タイミング: `sleep`禁止。`waitForCondition`/`waitForMessage`で待機。

---

## E2E テスト (Playwright)

### 何をE2Eにするか

- ビジネス的に死んだら終わるフロー → ログイン、決済、データ保存
- フロント↔バック統合でしか検証できないもの

### やらなくていいもの

- ユニットで足りるバリデーション・計算ロジック
- エラー系の網羅 → モックで注入した方が速い
- UIの細部(スナップショットテストで十分)

### 本数の目安

ユーザーストーリー単位で1本。機能が増えれば数十本も自然。  
「本数」より **CIで全部通すのに何分かかるか** で判断。10分以内なら問題なし。

### フレイキー対策

壊れる原因の大半:
- `sleep`で待機 → `waitForSelector`/`waitForResponse`に変える
- テスト間で状態漏れ → 各テストでDBリセット、独立ユーザー使う

---

## テスト並列化とDB状態汚染

### 解決策

**トランザクションロールバック** (最速、統合テスト向け)
```ts
beforeEach(() => db.query("BEGIN"))
afterEach(() => db.query("ROLLBACK"))
```
制約: E2Eや別HTTPコネクション経由では使えない。

**ワーカー別DB** (E2E向け)
```ts
// Playwright は TEST_WORKER_INDEX を自動付与
DATABASE_URL: `postgres://localhost/test_db_${process.env.TEST_WORKER_INDEX}`
```

**idに依存しないassertion**
```ts
// NG: serial id はテスト順で変わる
expect(result.id).toBe(1)

// OK
expect(result.email).toBe("test@example.com")
expect(results).toHaveLength(1)
```

### 使い分け

| 状況 | 手法 |
|---|---|
| 統合テスト(DB直接) | トランザクションロールバック |
| E2Eテスト(Playwright) | ワーカー別DB |
| id依存assertion | assertion変更 |
