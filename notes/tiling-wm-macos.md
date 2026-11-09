---
title: tiling-wm-macos
description: タイル型ウィンドウマネージャ。Linux デスクトップの動機、macOS の AeroSpace / yabai、入れるべきか判断
# permalink:  # don't use
aliases:
  - タイル型WM
  - AeroSpace
  - yabai
tags:
  - macos
  - window-manager
  - tiling
draft: false
date: 2026-11-06
---

# タイル型ウィンドウマネージャ (macOS)

## Linux デスクトップ使う人の動機

- 自由。中身見える、変えられる。勝手にUI変更・広告・テレメトリ・強制アップデートなし
- 開発環境と相性良い。Docker、シェル、パッケージ管理ネイティブ。本番サーバーもLinux
- カスタマイズ好き放題。タイル型WM (i3, sway, Hyprland) 組める
- 古いPC再生。軽量ディストロで延命
- 脱Big Tech。プライバシー重視
- 構築過程が楽しい人もいる (Arch系)

不人気の理由: Adobe/Office 弱い、ハード対応ムラ、設定コスト高い。
Steam Deck、Proton、Wayland 成熟で改善中。

## 層の整理

- ディスプレイサーバ: X11 / Wayland。画面描画・入力の基盤
- WM: ウィンドウ配置・枠・フォーカス管理
- コンポジタ: 描画合成。Wayland は WM と一体 (sway, Hyprland)
- DE: GNOME, KDE。WM + パネル + 設定UI のセット

## WM の種類

- スタッキング型: Windows/macOS デフォルト。重なる。マウスで動かす
- タイル型: 自動分割。重ならない。tmux のペイン分割と同じ発想。キーボード中心
    - X11: i3, bspwm, dwm, awesome
    - Wayland: sway (i3互換), Hyprland, niri
- tmux との違い: tmux は端末内だけ。タイル型WMは GUI アプリ全部対象

## タイル型のメリット

- 配置作業ゼロ。開いたら自動配置
- 画面無駄なし。全ウィンドウ常に見える
- キーボード完結
- ワークスペース切替速い (1=エディタ, 2=ブラウザ, 3=端末)
- 配置の再現性。設定ファイルで固定
- 軽い

デメリット: 学習コスト、設定自作、ダイアログ系アプリと相性悪い、小画面は恩恵小。

## macOS: AeroSpace vs yabai

### AeroSpace

- i3 風。ツリー型レイアウト
- SIP 無効化不要。公開APIのみ。導入安全
- 仮想ワークスペース自前実装。macOS 標準 Spaces 使わない
    - 非アクティブ WS のウィンドウは画面外 (右下隅) に退避。切替即時、アニメなし
- 設定 `~/.aerospace.toml`
- CLI `aerospace` あり
- 複数モニタなら "Displays have separate Spaces" 無効化推奨 (ログアウト要)
    - 有効だとフォーカス異常・性能問題の報告あり
- Dock を下 + 自動非表示にすると退避ウィンドウの 1px 線が目立たない
- `brew install --cask nikitabobko/tap/aerospace`
- https://github.com/nikitabobko/AeroSpace

### yabai

- BSP (二分空間分割)
- macOS 標準 Spaces 操作する方式
- 一部機能は SIP 部分無効化必要 (Dock.app にコード注入)
    - Space 作成・削除・並替、影消し、透過、アニメ、常に最前面、sticky window
- 基本タイル機能だけなら SIP 不要
- ホットキーは別ツール `skhd` 必要
- 設定 `yabairc` はシェルスクリプト。柔軟だが手間
- macOS アップデートで壊れやすい
- https://github.com/asmvik/yabai

### 選び方

まず AeroSpace。yabai は Space 細かい制御や視覚効果が欲しくなってから。

## 何でもタイルできる？

できない。Accessibility API で動かせるウィンドウだけ。

- 最小サイズ固定のウィンドウ: 縮められずはみ出す
- ダイアログ、ポップアップ、シート、パレット: 自動フロート
- ネイティブフルスクリーン: 独立 Space 作るので管理外
- カスタム描画アプリ (一部 Electron、ゲーム): 不安定になることあり
- メニューバー常駐、Dock、システムUI: 対象外

対処:

- AeroSpace: `[[on-window-detected]]` で `app-id` 指定、`layout floating`。`aerospace list-apps` で確認
- yabai: `yabai -m rule --add app="システム設定" manage=off`

## 自分の場合: 入れなくていい

使うのはほぼ ターミナル + ブラウザ。Orca (ターミナル + 内蔵ブラウザ) で間に合ってる。
プログラミングも AI に投げるのでエディタ開かない。

- Orca が既にタイル型WMの役目。worktree ごと切替
- 入れると Orca 内部レイアウトと二重管理。ショートカット競合
- Godot / OBS はたまに使う程度。パネル・ダイアログ多くタイル型と相性悪い。`cmd+tab` + 別ウィンドウで十分
- t3 code、Android/iOS シミュレーターも同じ判断。別ウィンドウのまま
- 頻度で分ける。毎日使う中核は Orca に集約、たまに使うものは別ウィンドウ
- 統合しすぎない利点: 1アプリの制約に全体が縛られない。不要になったら切り離せる

入れる価値が出るとき:

- Orca と Godot を常に横並びで作業する
- 外部モニタ使いでアプリ配置を固定したい
- ウィンドウ整理が毎日ストレスになった

軽い代替: Rectangle (無料)。ショートカットで半分・1/3 配置。設定不要。

困った時に AeroSpace 試せばいい。SIP 不要、アンインストール簡単。
