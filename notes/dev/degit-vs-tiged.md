---
title: degit vs tiged
description: git repo 部分コピーツール比較。tiged推奨、degit最近再稼働
# permalink:  # don't use
aliases:
  -
tags:
  - git
  - cli
  - scaffolding
draft: false
date: 2026-08-30
---

## 何者

git clone せずtarball DLで高速コピーするツール。用途2つ:

1. repo/サブディレクトリの部分コピー(`tiged user/repo/subdir`)
2. 複数repo合成してプロジェクト雛形構築(Actions機能)

## degit vs tiged

- degit: Rich Harris本家。tiged曰く「長期放置」→ だが2026-08時点で確認すると直近1ヶ月コミット活発(2026-07-17〜08-26)。ただしissueは塩漬け多数(9件中8件が2017〜2020年起票のまま放置、直近1件のみ2024年)
- tiged: degitのfork。degit停滞受けて派生。マルチホスティング対応(GitHub/GitLab/BitBucket/Sourcehut/HuggingFace/Codeberg)、デフォルトブランチ自動検出、Windows互換性改善
- CLI/API ほぼ互換。乗り換えコスト低い: `npm uninstall -g degit && npm install -g tiged`

判断: GitHub中心の単純用途ならdegitでも実用上問題なし(最近息吹き返してる)。マルチホスティングや積極メンテ重視ならtiged。迷ったらtiged(機能上位互換)。

## Actions (`degit.json`)

クローン先repoルートに置く自動処理定義。テンプレ作者が「このテンプレ選んだら共通設定も一緒にDL、不要ファイルは削除」を事前定義 → 利用者は普通にtiged叩くだけ。

対応アクション2種:

**clone** — 別repoを追加クローン(既存ファイル保持)。共通設定・base template合成に使う。

```json
[
  { "action": "clone", "src": "user/shared-configs" },
  { "action": "clone", "src": "user/another-repo#v2.0.0", "cache": true, "verbose": false }
]
```

**remove** — 指定ファイル/ディレクトリ削除。

```json
[
  { "action": "remove", "files": ["LICENSE", "CONTRIBUTING.md", ".github"] }
]
```

複合例(base template + 差分):

```json
[
  { "action": "clone", "src": "organization/base-template" },
  { "action": "clone", "src": "organization/shared-eslint-config" },
  { "action": "remove", "files": ["README.md", "LICENSE", "docs/", ".github/workflows/"] }
]
```

用途1(部分コピー)を複数回チェーンして用途2(雛形構築)を実現する仕組み。独立機能ではない。

JS API側にも `Tiged#doActions()` あり、`degit.json`なしで単体実行可能(最近追加)。
