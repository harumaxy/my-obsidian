---
title: Rust GUI (GPUI) と Electron / Tauri 比較
description: GPUI 批判スレッド要約と、Rust GUI・Tauri・Electron の選び方メモ
# permalink:  # don't use
aliases:
  - GPUI
  - Tauri vs Electron
tags:
  - rust
  - gui
  - tauri
  - electron
draft: false
date: 2026-11-12
---

元ネタ: https://x.com/mylifcc/status/2120003766380642662 (lifcc, 2026-11-10, 中国語ポストの機械翻訳)
元記事: https://blog.zortax.de/posts/a-critique-of-gpui
※ 以下、一部は記憶ベース。最新仕様は未確認

## GPUI とは

- Zed エディタ作った会社 の Rust 製 GUI フレームワーク。Zed 用に内製、のち公開
- GPU 直接描画。DOM なし、Chromium なし
- Rust 関数で UI ツリー組む。React 似。スタイル Tailwind 風メソッドチェーン
- 状態 = Entity。状態変えたら `cx.notify()` 呼ぶ → 再描画

## スレッドの主張

- Discord が GPUI でデスクトップ版書き直すと発表。GPUI 触った人「複雑アプリでは行き止まり」
- Zed 速い = GPUI 速い、ではない。Zed の UI 単純。重いエディタ部分は手書きカスタム Element で GPUI のレイアウト回避
- 根本原因: `&mut` に書き込みバリア無い → フレームワーク「どこ変わったか」知らない → `notify()` は「何か起きた」だけ → ツリー全体再描画。Angular の zone.js と同じ
- 実測: 3000 行リスト、ラベル 1 個変更
  - `.cached()` 付き 8.4ms
  - キャッシュ無し 92ms
  - コスト = 変更量でなく ツリーサイズ に比例
- 回避 = 小さい状態ごと Entity 分割。「未読数 = フィルター件数」が Signals なら 2 行、GPUI は struct + Render + observe + 古い値ガード + Handle。`notify` 書き忘れ = 静かなバグ
- Floem / Vizia / Slint もラベル 1 個で 14〜172ms。ただし原因は Taffy 全量レイアウト走査 = エンジン実装の問題、直せば速くなる
- GPUI / Iced / egui の遅さ = API 契約そのもの。エンジン直しても直らない
- 結論: 全体再描画派 (egui/GPUI) vs Run-Once + 細粒度 Signals 派 (Solid/Leptos)

## Web で言うと

- GPUI の素の状態 = 「React.memo を人間が手で付けて回る」状態
- Rust は定数倍が速いだけ。O(n) → O(変更量) のアルゴリズム差は言語で埋まらない (競プロと同じ)
- Rust GUI は 10 年前のフロントエンドの道を歩き直し中

## Rust GUI 競合

- egui: 即時モード。ツール向き
- Iced: Elm 風
- Floem / Vizia / Slint: Signals 系
- Tauri: Rust バックエンド + OS WebView
- Dioxus: React 風。Web / デスクトップ / モバイル
- Leptos: Solid 風 Signals。主に Web
- Xilem / Masonry: 実験的次世代

## Tauri vs Electron

- Electron: Chromium + Node 同梱。どの OS も同じ描画。重い (インストーラ 80〜120MB 前後)
- Tauri: OS 標準 WebView。軽い (数 MB〜)。バックエンド Rust
- WebView 実体:
  - Windows = WebView2 = Chromium 系 (Edge)
  - macOS = WKWebView = Safari 系
  - Linux = WebKitGTK = Safari 系だが distro 次第で古い
- OS 差が出る: CSS / WebGPU / セキュアコンテキスト (`crypto.subtle`) / Intl (ICU 版)。実機確認必須
- fetch / WebGL / Intl / Web Crypto は基本使える。CORS は通常ブラウザ同様
- Electron = デスクトップのみ。Tauri v2 = iOS / Android 対応 (成熟度は要確認)
- モバイル他選択肢: Capacitor, React Native / Expo, PWA

## 3D ゲームを Web 技術で作る場合

- Electron は十分実績あり。Chromium 固定で WebGL / WebGPU 安定
- Tauri は WebGL 性能 / WebGPU が OS ごとにバラつく。リスクあり
- どちらも JS GC・ブラウザ経由の天井あり。重い 3D は Godot / Unity
- ゲームはアセットが数百 MB〜数 GB。Electron +100MB は相対的に小さい

## 判断メモ

- ほとんどのデスクトップアプリは Electron で十分。VS Code, Slack, Discord が実例
- AI で Rust を書く難易度は下がる。ただし設計判断・検証・静かなバグ発見は人間に残る。エコシステムの薄さも AI で埋まらない
- 状態複雑 UI (メッセージング) ほど Web のリアクティブ成熟度が効く
- エディタ: 性能が価値。Zed 型は描画を手書き。拡張エコシステム重視なら Electron
- ユーティリティ: Electron で十分。常駐で軽さ要るなら Tauri
- 軽さが差別化 (常駐 / 低スペック) なら Rust GUI / Tauri
- Rust 触りたいなら Tauri から: UI は Web のまま、重い処理だけ Rust。摩擦最小。次に Dioxus か Slint
