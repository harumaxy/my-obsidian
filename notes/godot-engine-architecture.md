---
title: Godot Engine アーキテクチャ (C4 + Web 出力)
description: Godot 4.8-dev のソース構造を C4 で整理。エディタ=ゲーム、書き出しの仕組み、モバイル/Web の動かし方、Three.js/Babylon.js 比較
# permalink:  # don't use
aliases:
  - godot-c4
tags:
  - godot
  - game-engine
  - architecture
  - c4-model
  - web
draft: false
date: 2026-10-11
---

godotengine/godot (4.8-dev) を shallow clone して読んだ。C++ 単一バイナリ。
C4 図: https://claude.ai/artifact/CUfdEUwSoHiCaQmQSXAXED

## C4 ざっくり

### L1 Context
- 開発者 → エディタ使う。プレイヤー → 書き出しゲーム遊ぶ
- 外部: OS、GPU API (Vulkan / D3D12 / Metal / GLES3)、GDExtension、Asset Library

### L2 Container (ディレクトリ = レイヤー)
- `main/` 起動・ループ。`Main::setup` → `start` → `iteration` → `cleanup`
- `core/` Object, ClassDB, Variant, Resource, IO, Extension。土台
- `servers/` Rendering / Physics / Audio / Display / Text / Navigation / XR。Node 知らない。RID で操作
- `scene/` Node, SceneTree, Viewport, CanvasItem, 2D/3D/GUI/Resource
- `editor/` エディタ本体。scene の Control で作られてる
- `modules/` ON/OFF 可能機能。gdscript, mono, jolt_physics, gltf, openxr ...
- `drivers/` vulkan, d3d12, metal, gles3, 音声ドライバ
- `platform/` OS 別。windows, macos, linuxbsd, android, ios, web
- エントリは `platform/*/godot_*.cpp` の `main()` → 共通 `Main::`

### L3 Component
- Node → RenderingServer (RID 経由) → Compositor
  - Forward+ / Mobile → `renderer_rd` → RenderingDevice → Vulkan / D3D12 / Metal
  - Compatibility → `drivers/gles3`
  - headless → dummy
- 物理も同構造。PhysicsServer3D 実体は godot_physics_3d か jolt_physics
- `SceneTree` が `MainLoop` 実装。毎フレーム process / physics_process 配る
- 全クラス ClassDB 登録 → インスペクタ / スクリプト / ドキュメント / GDExtension が同じ情報源

### L4 Code
- 登録順: core → server → scene → driver → editor (`main.cpp` L704〜L797)。終了は逆順
- `iteration()`: physics_process (固定ステップ複数回) → Navigation → process → `RenderingServer::draw`

## エディタ = Godot ゲーム
- ほぼ YES。`scene/gui` の Control で組まれた大きい Godot アプリ
- 違いは `editor/` を追加リンク + `register_editor_types()` 呼ぶだけ
- 「実行」ボタン → 別プロセスで同バイナリをゲームとして起動 → デバッガで接続

## 書き出し (Export)
- エディタから不要部分を削るんじゃない
- **Export Templates** = `scons target=template_release|template_debug` で別ビルドした、editor 無しバイナリ
- テンプレは同梱じゃない。`Manage Export Templates` でバージョン一致のものを DL
- 流れ: テンプレ選ぶ → 出力先にコピー → リソースを **PCK** (先頭 `GDPC`) にまとめる → exe 横か埋め込み
- 実行ファイル = 汎用ランタイム。ゲーム固有は PCK。GDScript もデータ側
- PCK 中身は import 済み形式 (`.godot/imported/` の `.ctex` など)

## C++ でゲームを書く
1. **GDExtension (godot-cpp)** 共有ライブラリ。エンジン再ビルド不要。普通はこれ
2. **Custom Module** `modules/` に足してエンジンごとビルド。内部 API 使える。バージョン追従がつらい
3. **fork して独自ビルド** 不要 module を `module_xxx_enabled=no` で外してサイズ削減

## モバイル
- **Android**: `libgodot_android.so` を Kotlin/Java が `System.loadLibrary` → JNI (`GodotLib_*`) → `Main::setup/start/iteration`。ホストは Activity。ホスト薄い
- **iOS**: 静的ライブラリを Xcode プロジェクトにリンク。`main_ios.mm` で `Main::setup`。ホストは Swift/ObjC (`app_ios.swift`)、ループは CADisplayLink
- ゲームロジックはホスト通らない。全部 C++ 側 + PCK

## Web 出力
- Emscripten で wasm32 ビルド (`platform/web/detect.py`)
- 出力: `.html` `.js` `.wasm` `.pck` `audio.worklet.js` (+PWA 時 service worker / manifest / offline)
- 描画は **WebGL2 のみ** (`main.cpp:2647` で `rendering_method.web` が `gl_compatibility` 固定。コメントに "until we have WebGPU support")
- WebGPU は公式未対応。コミュニティ fork はある (信頼度低、要確認)
- ブラウザ機能: fetch (`HTTPRequest`)、WebSocket、WebRTC、WebXR、Gamepad、clipboard、fullscreen、IME、TTS、PWA。任意 API は `JavaScriptBridge`
- 決済 / アクセシビリティ (ARIA) は専用対応見つからず。canvas 1枚なので DOM 統合弱い。C# は Web 書き出し不可 (検索結果。公式未確認)

### スレッドと COOP/COEP
- Godot は元からマルチスレッド設計 (`WorkerThreadPool`)
- Web では Emscripten が pthread → Web Worker に変換。`PTHREAD_POOL_SIZE=8`。wasm メモリを **SharedArrayBuffer** で共有、`Atomics` で同期
- SAB は Spectre 対策で一度無効化 → **クロスオリジン分離** で復活
  - `Cross-Origin-Opener-Policy: same-origin`
  - `Cross-Origin-Embedder-Policy: require-corp`
  - 両方で `crossOriginIsolated === true` → SAB 使える
- 面倒な理由: ヘッダー返せるホスティング必要 / サードパーティ資源が壊れる / ポップアップ (OAuth, 決済) で `window.opener` 制限
- 回避: `threads=no` の単スレッド版 (ヘッダー不要)
- ローカル確認は `serve.py` / `editor_http_server.cpp`

### 音声 (スレッドなし版)
- `audio_driver_web.cpp` に3ドライバ
  1. Worklet (threads): ミキサーが専用スレッド。メインが詰まっても音は安定
  2. Worklet (no threads): ミキサーはメインスレッド。`postMessage` で渡す
  3. ScriptProcessor: 古い API のフォールバック
- スレッドなし制約 = メインが重いと音切れ。バッファ増やすと遅延増える
- 音は出る。「出ない」じゃない

## Three.js / Babylon.js 比較
- サイズ: Godot 数 MB〜 (Brotli 約 3〜9MB 目安、4.3 で wasm 35MB/pck 56MB の報告も)。Three.js コア約 150KB、Babylon 1〜2MB。出典は第三者記事で条件不揃い
- 違い = Godot はエンジン丸ごと配る。Three.js は描画ライブラリ + 自前組み合わせ
- スレッド: Three.js / Babylon は基本メインスレッド。Draco/KTX2 デコードなど一部 Worker。物理 (Rapier/Havok) やナビは外部/プラグイン
- Godot はエンジンが並列前提。Web では Worker に自動変換
- COOP/COEP 問題は共有メモリ使う側だけ。postMessage だけなら不要

| | Three.js | Babylon.js | Godot (Web) |
|---|---|---|---|
| ロジック | メイン | メイン | threads 版は Worker 群 |
| 物理 | 外部 | プラグイン (Havok) | 内蔵 |
| ナビ | 外部 | プラグイン (Recast) | 内蔵 |
| 音声 | Web Audio | Web Audio | 独自ミキサー + AudioWorklet |

### 使い分け
- 軽い Web 3D 表示 / サイト埋め込み / 決済・SEO・a11y が主役 → Three.js / Babylon
- ゲームとして作り込む → Godot。Web は出力先の1つ
- Godot canvas を iframe に入れて `postMessage` で HTML 側と連携も手

## 未確認
- Web の AccessKit 対応状況 (最新ブランチ)
- WebGL コンテキストとスレッドの扱い詳細
- 4.7 の wasm64 など版ごとの機能 (記事間で食い違い)
- 計測ベースの Three.js / Babylon / Godot 性能比較
