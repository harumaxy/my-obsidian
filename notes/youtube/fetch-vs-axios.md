---
title: Fetch vs. Axios in 1 minute
url: https://www.youtube.com/watch?v=OFWATycG_Wc
channel: onjsdev
date: 2024-10-02
---

# Fetch vs. Axios の違い

## 概要

JavaScriptでHTTPリクエスト処理に使う2つのライブラリの比較。

## Fetch API

- **特徴**: JavaScriptの組み込みメソッド（XMLHttpRequestの現代的な代替案）
- **メリット**:
  - ネイティブサポート
  - Promise ベース
- **デメリット**:
  - 自動JSON変換なし
  - エラーハンドリングが弱い（4xx/5xxは resolve される）
  - タイムアウト非対応

## Axios

- **特徴**: サードパーティライブラリ
- **メリット**:
  - 自動JSON解析
  - シンプルな構文
  - 堅牢なエラーハンドリング（4xx/5xxで自動的に reject）
  - インターセプター機能
  - リクエストキャンセル機能
  - タイムアウト設定が簡単
  - ファイルアップロード対応
- **デメリット**:
  - インストール必須
  - バンドルサイズが大きい

## 使い分け

- **Fetch**: 軽量ソリューション、基本的なHTTPリクエスト
- **Axios**: 複雑な機能が必要な場合

## 補足

### Node.js での変化

Node.js 18.0+ ではグローバル `fetch` が利用可能になったため、「Node.js環境だから Axios」という理由は成り立たなくなった。

### Axios のエラーハンドリング

Axios は例外（throw）ベースのエラーハンドリング。ステータスコード 4xx/5xx で自動的に Promise を reject する。

```javascript
try {
  const response = await axios.get('/api/data');
} catch (error) {
  // 4xx, 5xx ステータスやネットワークエラーで catch
}
```

**Fetch との違い**:
- Fetch は 4xx/5xx でも resolve される。手動で `response.ok` チェック必須

### Result型アプローチの方が筋が良い

Rust や OCaml の Result 型のように、戻り値で成功/失敗を表現する方が：
- エラーハンドリングが明示的
- 呼び出し側で必ずエラーケースを処理する必要がある
- スタックアンワインディングなし（予測可能）
- サイレントエラーが起きにくい

JavaScriptでこのアプローチを使う場合は、`{ ok: true; value: T } | { ok: false; error: E }` 形式で返すか、`fp-ts` や `neverthrow` などのライブラリを使う。
