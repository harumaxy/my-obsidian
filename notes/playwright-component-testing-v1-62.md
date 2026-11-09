---
title: Playwright component testing 刷新 (v1.62)
description: experimental-ct 削除と stories/gallery モデル
aliases:
  -
tags:
  - playwright
draft: false
date: 2026-11-06
---

元:
- https://playwright.dev/docs/test-components
- https://github.com/microsoft/playwright/releases/tag/v1.62.0
- https://github.com/microsoft/playwright/pull/42168 (chore: remove experimental component testing)

## 変更

- `@playwright/experimental-ct-{core,react,react17,vue}` 削除。もう公開されない。
- 旧パッケージ利用中は 1.62 に固定したまま、移行ガイドで移行。
- PR は `babelPlugins` フックと tsxTransform 注入の仕組みも削除。jsx-runtime は残す (消すと .tsx テストの JSX が壊れるため別 breaking change)。

## 新モデル: stories + gallery

- story = コンポーネントを 1 シナリオ (固定 props、モックデータ、provider) で包んだもの。
- gallery = 自前 dev server で配信するページ。story を id で描画。
- `mount` fixture が gallery に遷移し、story をマウントして、ルート要素の Locator を返す。
- 専用ランタイム・bundler 連携・追加 npm パッケージなし。普通の e2e テストとして動く。

```ts
test('click should expand', async ({ mount }) => {
  const component = await mount('components/Expandable/Stateful');
  await component.getByRole('button').click();
  await expect(component.getByTestId('expanded')).toHaveValue('true');
});
```

テストは Node、コンポーネントは実ブラウザ。実クリック、実レイアウト、visual regression、並列・retry・trace がそのまま使える。

## 補足: 公式 docs 通読 + 会話メモ

### docs の要点

- gallery = 自前 dev server が配る 1 ページ。`window.mount({story, props})` / `window.unmount()` を生やし、`#root` に描画。フレームワーク依存部分はこれだけ。
- story id = `src/` 以下のパス (拡張子なし) + export 名。例 `components/Button/Primary`。末尾一致でも可 (`Button/Primary`)。
- セットアップは `npx playwright init-skills` で agent skill を入れ、agent に gallery と最初の story / spec を作らせる想定。仕様は skill 内 `references/gallery-spec.md`。
- config: project に `baseURL` = gallery、`serviceWorkers: 'block'` (SW が `page.route()` のモックを隠すのを防ぐ)、`reuseContext: true` (コンテキスト使い回しで大幅高速化)。
- 状態の検証: story が state と callback を持ち、結果を hidden な `<input data-testid>` に書く。テスト側は `toHaveValue()` で web-first assertion。callback を Node/ブラウザ間で渡さない。
- `mount<typeof Story>(id, props)` で props を型付け。props は serializable のみ。`component.update(props)` は remount せず state 保持。
- ネットワーク: `page.route()` は `mount()` の前に登録 (mount が navigate するため)。MSW は story / decorator 内で起動。
- 内部メソッド・インスタンスには触れない (非推奨・非対応)。ユーザー視点で操作して観察。
- 旧 experimental-ct からの移行: 1.62 に固定したまま gallery と新 project を並走させ、spec 単位で移植。最後に旧依存と `playwright/index.*` / `.cache` を削除。

### 旧版を捨てた理由

旧版は JSX をテストに書けた (`mount(<Button onClick={spy} />)`)。そのため Playwright がバンドル全体 (独自 Vite、独自 config、独自 server) を握る必要があり、
- ユーザーの alias / plugin / CSS を `ctViteConfig` に手で写す必要
- webpack / Next.js 等では使えない
- JSX を Node でコンパイルしブラウザで再構築 → 生オブジェクト・callback・モジュールモックが漏れる
- フレームワークごとにパッケージが必要
という理由で experimental のまま止まった。新版は制御を手放し、「自前 dev server が配るページを開くだけ」にした。

### Testing Library + jsdom との比較

- 速さは jsdom の方が上。jsdom + Vitest はプロセス内で完結、watch で即返る。こちらは実ブラウザ + dev server が要り、`mount()` ごとに gallery へ navigate。
- 速さの数字は docs に無い。以下は推測 (未計測): jsdom < Playwright CT < 普通の E2E。
- E2E より軽い理由: 小さな gallery 1 枚、バックエンド・DB・ログイン不要 (API は `page.route()`)、dev server 使い回し、`reuseContext`、並列。
- 起動オーバーヘッドは避けられない。選ぶ理由は速さでなく「分離された状態での実ブラウザ挙動」。

### Storybook との関係

- 構造は似てる: `*.story.tsx` に名前付き export で 1 シナリオ、gallery を手で開けば目視確認にもなる。
- 統合ではない。Storybook の story を流用する記載は docs に無い。gallery は自前。Storybook の UI / addon / docs / controls は無い。

### 使い分け

- jsdom (Testing Library): ロジック・分岐・フォーム検証・props 網羅など、件数多く見た目に依存しないもの。
- Playwright CT: レイアウト / CSS 崩れ、visual regression、フォーカス・ドラッグ・スクロールなど実ブラウザでしか見れないもの。
- E2E: 認証、複数ページ導線、本物のバックエンド結合。

### 向いてるコンポーネント (動画プレイヤー、エディタ)

- jsdom で動かない API に依存: `<video>` の再生・シーク・フルスクリーン、contenteditable・Selection/Range・クリップボード・IME・キャレット・スクロール。
- 状態が主役でアプリ全体のノイズが邪魔: story で「再生中 / 一時停止 / エラー」を名前付きで固定し、1 点だけ検証。`update(props)` で state 保持のまま props 変更 (再生中に src が変わったら、等)。

### 注意点 (一部推測・要確認)

- 動画: Playwright 同梱 Chromium は H.264 等の商用コーデック非対応のはず。mp4 テストで詰まる可能性。`channel: 'chrome'` が要るか確認。
- 再生位置・選択範囲などを hidden input に書き出す形になり、状態が多いと story が肥大化。
- headless は本番と挙動が違う場合あり (自動再生ポリシー等)。
- story id は文字列。リネームすると実行時に初めて壊れる。テスト毎の JSX は書けず、組み合わせ毎に export を増やす。
