---
title: comfyui-desktop-directory
description: ComfyUI Desktop のディレクトリ構造メモ
# permalink:  # don't use
aliases:
  -
tags:
  - comfyui
draft: false
date: 2026-07-28
---

# ComfyUI Desktop ディレクトリ構造

```
Comfy-Desktop\
├── ComfyUI-Installs\   # ComfyUI 本体。複数バージョン共存可
├── ComfyUI-Shared\     # モデル・カスタムノード等 共有アセット置き場
└── ComfyUI-Cache\      # キャッシュ・一時ファイル。削除可
```

## モデル置き場

- `Installs/.../models/` — 本体デフォルト参照パス。実体ここに置かなくていい
- `Shared/models/` — **推奨**。実体ここ

## なぜ Shared 推奨？

- バージョン更新後もモデル引き継ぎ
- 複数バージョン間で共有 → ディスク節約
- `Installs` 内は更新時に消える可能性あり

## 設定確認

Desktop 設定画面 → Model Paths に `Shared` パスが登録済みか確認。
