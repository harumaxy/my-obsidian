---
title: naia — Bevy マルチプレイヤー実装メモ
description: naia-lib/naia の概要、Bevy での使い方、オフラインモード設計
aliases:
  - naia
tags:
  - rust
  - bevy
  - multiplayer
  - gamedev
draft: false
date: 2026-08-03
---

# naia — Bevy マルチプレイヤー

GitHub: https://github.com/naia-lib/naia

Rust製 マルチプレイヤー ネットワーキングlib。サーバー権威型エンティティレプリケーション + メッセージパッシング。

- UDP（ネイティブ）/ WebRTC data channel（WASM/ブラウザ）両対応
- ECS非依存コア。Bevy/macroquad アダプター有り
- Tribes 2 設計参考
- MIT/Apache-2.0

---

## 基本設計

```
shared/    ← サーバー・クライアント共通型定義
server/    ← サーバーロジック
client/    ← クライアントロジック
```

### 共有コンポーネント

```rust
#[derive(Component, Replicate)]
pub struct Position {
    pub x: Property<i16>,
    pub y: Property<i16>,
}
```

`Property<T>` = 変更検知 → 差分のみ自動送信。`#[derive(Replicate)]` だけで同期対象。

---

## サーバー側

```rust
// init: WebRTC ソケット起動
let socket = webrtc::Socket::new(&server_addresses, server.socket_config());
server.listen(socket);
let main_room_key = server.create_room().key();

// 接続時: エンティティ生成
let entity = commands
    .spawn_empty()
    .enable_replication(&mut server)   // 必須
    .insert(Position::new(x, y))
    .insert(Color::new(ColorValue::Red))
    .id();
server.room_mut(&global.main_room_key).add_entity(&entity);

// 毎ティック: コマンド処理
let mut messages = server.receive_tick_buffer_messages(&server_tick);
for (_user_key, cmd) in messages.read::<PlayerCommandChannel, KeyCommand>() {
    shared_behavior::process_command(&cmd, &mut position);
}
```

---

## クライアント側

```rust
// 接続時: クライアント権限エンティティ生成
commands
    .spawn_empty()
    .enable_replication(&mut client)
    .configure_replication::<Main>(Publicity::Public)
    .insert(Position::new(x, y));

// コマンド送信 + クライアント予測
client.send_tick_buffer_message::<PlayerCommandChannel, KeyCommand>(&client_tick, &command);
shared_behavior::process_command(&command, &mut position);  // ローカルでも即適用

// サーバー権威位置受信時 → ロールバック + 再実行
client_position.mirror(&*server_position);
for (_, cmd) in global.command_history.replays(&modified_server_tick) {
    shared_behavior::process_command(&cmd, &mut client_position);
}
```

---

## ネットワークフロー

```
[Client] キー入力
  → send_tick_buffer_message
  → ローカル予測適用

[Server] コマンド受信
  → 位置更新
  → Position 差分 → 自動レプリケーション

[Client] update_component_events で権威位置受信
  → サーバー状態にロールバック
  → コマンド履歴再実行 → 補正完了
```

---

## キーポイント

- `enable_replication()` → 呼ばないと同期されない
- `Room` 単位でスコープ管理 → Room 内エンティティのみ同期
- チャネル単位で信頼性・順序設定可能
- クライアント予測 = `local_duplicate()` + コマンド履歴 + ロールバック の3点セット

---

## オフラインモード実装

### ロジックの置き場所

**shared/behavior にゲームロジックを集約** が定石。

```
shared/
├── components/   ← Replicate derive つき
├── channels/     ← チャネル定義
├── messages/     ← コマンド型
└── behavior/     ← ★ゲームロジック全部ここ
    ├── movement.rs
    ├── collision.rs
    └── combat.rs
```

`shared/behavior` = ピュアな状態遷移関数。ネットワーク知識ゼロ。
サーバー / クライアント予測 / オフライン の全員が呼ぶ。

### パターン1: ローカルサーバー（推奨）

```
オンライン: Client → Network → Server (別プロセス)
オフライン: Client → LocalServer (同プロセス内)
```

`webrtc::Socket` → `memory::Socket` に切り替えるだけ。ロジック変更ゼロ。

```rust
if offline_mode {
    let (client_socket, server_socket) = memory::Socket::new_pair();
    app.add_plugins(NaiaServerPlugin);  // 同プロセスにサーバー追加
} else {
    let socket = webrtc::Socket::new(&addr, config);
}
```

### パターン2: trait 抽象化

```rust
trait GameSimulator {
    fn process_command(&mut self, cmd: &KeyCommand);
}
// NetworkedSimulator → サーバーに送信
// LocalSimulator    → shared_behavior 直接呼び出し
```

### アンチパターン

- サーバー側にだけゲームロジック書く → オフライン = サーバー必須 → 詰む
- クライアント予測と別ロジック書く → 予測ズレ → ラグ補正が壊れる
