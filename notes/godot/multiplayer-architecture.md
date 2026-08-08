---
title: Godot マルチプレイヤー設計
description: 権威サーバー型 + シングルプレイ両立パターン
aliases:
  -
tags:
  - godot
  - multiplayer
  - networking
draft: false
date: 2026-08-02
---

# Godot マルチプレイヤー設計

## 基本構成

権威サーバー型 = サーバーがゲームロジック全担当。クライアントは表示と入力送信のみ。

## トランスポート

- `ENetMultiplayerPeer` — UDP ベース、デフォルト。信頼性制御あり
- `WebSocketMultiplayerPeer` — ブラウザ向け
- 差し替え可能 (同一 High-level API)

## サーバー/クライアント起動

```gdscript
# サーバー
var peer = ENetMultiplayerPeer.new()
peer.create_server(PORT, MAX_CLIENTS)
multiplayer.multiplayer_peer = peer

# クライアント
var peer = ENetMultiplayerPeer.new()
peer.create_client(IP, PORT)
multiplayer.multiplayer_peer = peer
```

## オフライン (シングルプレイ) モード

Godot デフォルト = `OfflineMultiplayerPeer`。
何もしなくても自分が authority = サーバー扱いで動作。

```gdscript
# マルチ→オフライン切り替え
multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
```

## シングル + マルチ両立パターン

最初から権威サーバーロジックで実装 → 起動時に peer 差し替えだけでマルチ化。

```gdscript
func start_game(mode):
    if mode == "online_server":
        var peer = ENetMultiplayerPeer.new()
        peer.create_server(PORT, MAX_CLIENTS)
        multiplayer.multiplayer_peer = peer
    elif mode == "online_client":
        var peer = ENetMultiplayerPeer.new()
        peer.create_client(IP, PORT)
        multiplayer.multiplayer_peer = peer
    # offline は何もしない (OfflineMultiplayerPeer がデフォルト)
```

## 状態同期

- `MultiplayerSynchronizer` — ノードのプロパティ自動同期
- `MultiplayerSpawner` — サーバースポーンノードをクライアントに複製
- `@rpc` — 関数呼び出しをネット越しに飛ばす

```gdscript
@rpc("authority", "call_local", "reliable")
func take_damage(amount: int):
    hp -= amount
```

## Authority (権威) 管理

```gdscript
node.set_multiplayer_authority(peer_id)  # 権威者を指定
multiplayer.is_server()                  # サーバー判定
```

## 専用サーバー export

```gdscript
if OS.has_feature("dedicated_server"):
    start_server()  # headless 起動、レンダリングなし
```

エクスポート時に "dedicated server" モード → GPU 不要バイナリ生成。

## 注意点

- `@rpc` / `MultiplayerSynchronizer` は最初から設計に組み込む
- 後付けすると authority 管理が崩れる
- `multiplayer.is_server()` 分岐箇所は最初から意識

## 参考

- Veloren (Rust製ボクセル RPG) が同様の設計。サーバー内部でゲームロジック完結、クライアントは描画のみ。オフライン時はローカルサーバーを同プロセス内起動。

---

## クライアント予測とロールバック

### 権威サーバーのみ（予測なし）の問題

```
入力 → サーバー送信 → 処理 → 結果返信 → 画面反映
←──────── RTT分の操作遅延 ────────→
```

操作してから画面が動くまで RTT 分遅れる。80ms超えると体感できる。

### クライアント予測

入力を即座にローカルで適用。サーバー確認を待たない。

```
入力 → ローカル即反映（予測）
     → サーバーへ送信
     → サーバー確定値が返ったらズレを補正
```

操作レスポンスが知覚上ゼロになる。自分の入力もSSoTはサーバー（チート対策）。

### ロールバック

サーバー確定値と予測がズレたときの補正方法。

```
tick:  1    2    3    4    5(現在)
相手   [推測][推測][推測][!実際B届く][再計算]
                              ↑
                    tick2の実際入力がtick5で届いた
```

1. tick2の状態までロールバック
2. tick2→5を実際の入力で再シミュ
3. tick5の状態を上書き

過去の全tick分の状態をメモリに保持する必要あり。

### ロールバック上限

深すぎるとCPU爆発。多くの実装で8〜16tick程度に制限。  
上限超え → テレポートまたは切断。

### ラグ別挙動

- ~80ms: ほぼ気づかない
- ~150ms: たまに微妙な引き戻し（ラバーバンディング）
- ~300ms: 演出と結果のズレが顕著
- 500ms+: テレポートまたは切断

### 同期するデータの分類

| データ | SSoT | 理由 |
|---|---|---|
| 位置・速度 | サーバー | 当たり判定に影響 |
| HP・ステータス | サーバー | チート対策 |
| アニメ状態 | クライアント | 見た目のみ |
| エフェクト・サウンド | クライアント | 見た目のみ |
| スキル発動フラグ | サーバー | ゲームプレイ影響あり |

アニメの「何フレーム目」はクライアントが状態を受け取って自己計算。サーバーは「攻撃中かどうか」だけ持てばいい。

### ラグ補償ヒット判定

「クライアント画面では当たったのにサーバーで外れ」を軽減する技術。  
サーバーが「クライアントが撃った瞬間の過去状態」で判定する。

トレードオフ: 高ラグプレイヤーが有利になる（補償上限msを設計で決める）。

---

## ジャンル別許容ラグ

- 格ゲー: ~50ms（1フレーム=16ms、フレーム読みが狂う）
- FPS: ~80ms
- MOBA: ~150ms
- 協力アクション: ~200ms

---

## netfox（Godot 4 アドオン）

ロールバック + クライアント予測を実装済みのアドオン集。  
Godot標準マルチプレイヤーに乗っかっており、`multiplayer` API / `@rpc` はそのまま使える。

`MultiplayerSynchronizer` の代わりに `RollbackSynchronizer` を使い、ゲームロジックを `_rollback_tick()` に書く。

- https://github.com/foxssake/netfox

---

## インフラ

### CDNはゲーム通信に使わない

CDN = HTTP静的コンテンツ向け。ゲームのリアルタイム通信はUDP/TCP双方向なので相性が悪い。  
CDNを使うのはアセット配信（テクスチャ、音声DL）のみ。

### 主な戦略

**リージョン分散サーバー** — プレイヤーをping最小のリージョンにマッチング。

**Anycast / ゲーム専用ネットワーク** — インターネットBGP経路を専用バックボーンで短絡。大陸をまたぐ接続で20〜40ms改善することがある。国内同リージョンでは誤差。
- Cloudflare Spectrum（UDP対応）
- AWS Global Accelerator

### 規模別戦略

- インディー: 単一リージョン + マッチメイキングで近い人同士を組ませる
- 中規模: 3〜5リージョン分散
- 大規模: Anycast + 10+リージョン + 専用バックボーン
