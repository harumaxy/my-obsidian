---
title: Godot 4 マルチプレイヤー専用サーバーの構築とデプロイ
description: Godot 4で専用サーバーを構築し、DigitalOceanでホストする方法
aliases:
  - Godot マルチプレイヤーサーバー
  - 専用サーバー構築
tags:
  - godot
  - multiplayer
  - gamedev
  - server
  - deployment
draft: false
date: 2026-06-24
---

# Godot 4 マルチプレイヤー専用サーバーの構築とデプロイ

Godot 4でマルチプレイヤーゲームの専用サーバーを構築し、クラウドホスティング環境にデプロイする手順をまとめました。

参考: [Basics Of Multiplayer In Godot 4 - YouTube](https://www.youtube.com/watch?v=e0JLO_5UgQo)

## 基本概念

### ネットワークアーキテクチャ

- **ピア・ツー・ピア接続**: LAN環境向け、ホスト兼プレイヤー
- **専用サーバー**: クラウドホスティング、複数のゲームインスタンス対応

### サーバーの種類

| 方式 | 用途 | 構成 |
|------|------|------|
| LAN サーバー | ローカルテスト | ホストマシンがサーバー兼クライアント |
| 専用サーバー | 本番環境 | 別マシンでサーバー稼働 |
| WebRTC | P2P | シグナリングサーバー経由 |

## 1. ローカル開発環境での実装

### サーバー起動の条件分岐

```gdscript
# multiplayer_controller.gd
if "--server" in OS.get_command_line_arguments():
    host_game()  # サーバーモードで起動
```

### ネットワークアドレス設定

**変数定義:**
```gdscript
@export var address: String = "127.0.0.1"  # テスト用（後で変更）
@export var port: int = 8910  # ゲームポート
```

### ENetマルチプレイヤーピアの設定

```gdscript
# ホスト（サーバー）の作成
func host_game():
    var peer = ENetMultiplayer Peer.new()
    var error = peer.create_server(port, 32)  # 最大32プレイヤー
    
    if error != OK:
        print("Cannot host: ", error)
        return
    
    # ネットワーク圧縮の設定
    peer.get_host().compress = ENetConnection.COMPRESS_RANGE_ENCODING
    
    # マルチプレイヤーピアとして設定
    multiplayer.set_multiplayer_peer(peer)
    print("Waiting for players")

# クライアント（プレイヤー）の接続
func join_game():
    var peer = ENetMultiplayer Peer.new()
    peer.create_client(address, port)
    peer.get_host().compress = ENetConnection.COMPRESS_RANGE_ENCODING
    
    multiplayer.set_multiplayer_peer(peer)
```

### ネットワーク圧縮の選択

| アルゴリズム | 特性 | 推奨用途 |
|-----------|------|--------|
| `compress_none` | 無圧縮 | LAN接続 |
| `compress_range_encoding` | **低CPU、低帯域幅** | **デフォルト推奨** |
| `compress_fastlz` | 低CPU、高帯域幅 | リアルタイムゲーム |
| `compress_zlib` | 高圧縮、高CPU | 大容量データ |
| `compress_zstd` | バランス型 | 汎用 |

**重要**: サーバー・クライアント間で**同じ圧縮方式を使用**すること

## 2. プロジェクトのエクスポート

### Windows でのビルド

```
1. Project → Export
2. Windows Desktop を選択 → Add
3. Export Project をクリック
4. ファイル名: multiplayerlandtutorial.exe
```

**実行方法:**
```bash
# ホストモードで起動
multiplayerlandtutorial.exe

# サーバーモードで起動（UIなし）
multiplayerlandtutorial.exe --server
```

### Linux でのビルド（推奨）

```
1. Project → Export
2. Linux を選択 → Add
3. Export Project をクリック
4. ファイル名: multiplayerlandtutorial.sh
```

**実行方法:**
```bash
# サーバーモード（ヘッドレス）
./multiplayerlandtutorial.sh --headless --server
```

**注意**: `--no-window` オプションは動作しない（ドキュメントの誤記）。正しくは `--headless`

## 3. クラウドホスティング（DigitalOcean）

### ドロップレット（VPS）の作成

**推奨設定:**
- **OS**: Ubuntu（22.04 LTS 推奨）
- **プラン**: $7/月（初期テスト用）
  - vCPU: 1
  - メモリ: 512 MB
  - ストレージ: 20 GB
- **リージョン**: 任意（遅延を考慮してユーザーに近い場所を選択）

**設定ステップ:**
```
1. Create → Droplets
2. OS: Ubuntu を選択
3. Size: $7/月 を選択
4. Region: ゲーム配信地域を選択
5. Authentication: SSH Key or Password
6. Create Droplet
```

### SSH キーペアの生成と設定

**PuTTYgen でキー生成:**
```
1. PuTTYgen を起動
2. Generate ボタンをクリック
3. マウスを動かして乱数生成
4. Save public key → 公開鍵を保存
5. Save private key → 秘密鍵を保存（パスフレーズなし推奨）
```

**サーバーへの公開鍵追加:**
```bash
# SSH接続
ssh root@<DROPLET_IP>

# authorized_keys に公開鍵を追加
nano ~/.ssh/authorized_keys
# PuTTYgen の公開鍵をペースト
# Ctrl+X → Y → Enter で保存
```

### ファイアウォール設定

**ゲームポートのオープン:**
```bash
# iptables でポート 8910 を開く
iptables -I INPUT -i eth0 -p TCP --dport 8910 -J ACCEPT

# UFW の場合
sudo ufw allow 8910/tcp
```

### SFTP でビルドファイル転送

**FileZilla での転送設定:**
```
1. Site Manager → New Site
2. Protocol: SFTP
3. Host: <DROPLET_IP>
4. User: root
5. SSH Key: 秘密鍵ファイルを指定
6. Connect

# ローカルのビルドファイルをドラッグ&ドロップで転送
```

## 4. サーバー起動

### サーバーの起動

```bash
# ドロップレットにSSH接続
ssh -i private_key.pem root@<DROPLET_IP>

# サーバー実行（ヘッドレス）
./multiplayerlandtutorial.sh --headless --server

# 出力: "Waiting for players"
```

### クライアント接続テスト

**Godot エディタでテスト:**
```
1. multiplayer_controller.gd の address を DROPLET_IP に変更
2. Project → Debug → Run Multiple Instances
3. Run 2 Instances
4. ホストウィンドウで Host ボタン
5. クライアントウィンドウで Join ボタン
6. Start Game ボタンで接続確認
```

**接続確認:**
```
サーバーログに以下が表示されれば成功:
- "player_connected: 1" （ホスト）
- "player_connected: <random_id>" （クライアント）
```

## 5. アドレス設定の重要なポイント

### ローカルテスト時

```gdscript
@export var address: String = "127.0.0.1"  # localhost
```

### グローバル接続時（クラウドサーバー）

```gdscript
@export var address: String = "0.0.0.0"  # すべてのインターフェースでリッスン
```

**アドレス入力:**
- ローカル: `127.0.0.1`
- クラウド: `<DROPLET_IPv4_ADDRESS>`（例: `204.48.28.159`）

## 6. マルチプレイヤーシグナル

### 重要なシグナルと呼び出し箇所

| シグナル | 呼び出し元 | 用途 |
|---------|----------|------|
| `peer_connected(id)` | サーバー・クライアント | プレイヤー接続通知 |
| `peer_disconnected(id)` | サーバー・クライアント | プレイヤー切断通知 |
| `connected_to_server()` | **クライアントのみ** | サーバー接続完了 |
| `connection_failed()` | **クライアントのみ** | 接続失敗 |

**シグナル接続:**
```gdscript
func _ready():
    multiplayer.peer_connected.connect(player_connected)
    multiplayer.peer_disconnected.connect(player_disconnected)
    multiplayer.connected_to_server.connect(connected_to_server)
    multiplayer.connection_failed.connect(connection_failed)

func player_connected(id: int):
    print("Player connected: ", id)

func connected_to_server():
    print("Successfully connected to server")
    send_player_information.rpc_id(1, player_name, multiplayer.get_unique_id())
```

## 7. ネットワーク最適化

### マルチプレイヤー同期化

**レプリケーション間隔の調整:**
```gdscript
# Multiplayer Synchronizer の replication_interval
# デフォルト: 0.1秒（10Hz）
# 調整例: 0.05秒（20Hz）高速同期
# 調整例: 0.2秒（5Hz）低帯域幅
```

### Lerp による滑らかな補間

```gdscript
# サーバーから受け取った位置を補間
var sync_position: Vector2 = Vector2.ZERO

func _process(delta):
    if multiplayer.is_multiplayer_authority(self):
        sync_position = global_position
    else:
        # 受け取った位置に向かって補間
        global_position = global_position.lerp(sync_position, 0.5)
```

**メリット:**
- パケット送信量削減
- 滑らかなアニメーション効果
- ネットワーク効率向上

## 8. 本番環境への考慮事項

### スケーリング戦略

1. **マッチメイキングサーバー**
   - プレイヤーマッチング処理
   - ゲームサーバーの割り当て

2. **マルチサーバー管理**
   - 複数のゲームインスタンス稼働
   - ロードバランシング

3. **シグナリングサーバー（WebRTC）**
   - P2P接続のセットアップ
   - NAT トラバーサル

### 推奨アーキテクチャ

```
クライアント
    ↓
マッチメイキングサーバー
    ↓
ゲームサーバー（複数インスタンス）
    ↓
セッション管理DB
```

### リソース要件

| 項目 | 小規模 | 中規模 | 大規模 |
|------|-------|-------|-------|
| vCPU | 1 | 4-8 | 16+ |
| メモリ | 512MB | 2-4GB | 16GB+ |
| ストレージ | 20GB | 100GB | 500GB+ |
| 同時プレイヤー | 32 | 128-256 | 1000+ |

## 参考資料

- [Godot 公式: マルチプレイヤー](https://docs.godotengine.org/ja/stable/tutorials/networking/index.html)
- [DigitalOcean](https://www.digitalocean.com/)
- [FileZilla](https://filezilla-project.org/)
- [PuTTY](https://www.putty.org/)

## よくある質問

### Q: LAN接続で専用サーバーは必要ですか？
**A:** 必須ではありません。ホストマシンがサーバーとして機能します。ただし、複数のゲームインスタンスを同時実行する場合は専用サーバーが必要です。

### Q: サーバーコストを削減するには？
**A:** $7/月のドロップレットで初期テストは十分です。本番環境では、初期負荷テストを実施してからスケール判断してください。

### Q: オートスケーリングは可能ですか？
**A:** 可能ですが、Kubernetes や Nomad などのコンテナオーケストレーション、または DigitalOcean App Platform の利用を検討してください。

---

最終更新: 2026-06-24
