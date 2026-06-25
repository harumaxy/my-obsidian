---
title: ComfyUI + Claude Code / MCP 統合ガイド
description: RTX 4080 で ComfyUI を Claude Code から制御するセットアップ方法
aliases:
  - ComfyUI セットアップ
tags:
  - AI画像生成
  - ComfyUI
  - Claude Code
  - MCP
  - LocalAI
draft: false
date: 2026-06-25
---

## なぜ ComfyUI か

AI 画像生成ツールには Automatic1111、Forge、Fooocus などもあるが、ComfyUI が優れている理由：

- **ワークフローがノードグラフ＝JSON** で表現される
- **HTTP/WebSocket API が標準装備** で、CLI・コード・MCP から完全制御可能
- FLUX・SDXL・Qwen-Image・Z-Image など主要モデルがすべて動作
- クラウド不要・課金なし・ログ収集なし

これらの「スクリプタビリティ」が、Claude Code / MCP との連携に最適。

## Claude Code / MCP との連携

### 使用する MCP サーバー

**artokun/comfyui-mcp**（最も機能豊富）
- Claude Code プラグイン兼 MCP サーバー
- 画像・動画生成、ワークフロー実行・編集、モデル管理、リアルタイム進捗監視に対応
- Windows対応で ComfyUI インストール先とポートを自動検出

### セットアップ

```bash
/plugin marketplace add artokun/comfyui-mcp
/plugin install comfy
```

または `.claude/settings.json` に：

```json
{
  "mcpServers": {
    "comfyui": {
      "command": "npx",
      "args": ["-y", "comfyui-mcp"],
      "env": { "CIVITAI_API_TOKEN": "" }
    }
  }
}
```

### 使用方法

ComfyUI を起動した状態で Claude Code から「夕焼けの山の画像を生成して」と自然言語で指示すると、チェックポイント検出・ワークフロー構築・実行・画像返却が自動化される。

**前提：ComfyUI は http://localhost:8188 で動作**

## RTX 4080（16GB VRAM）での推奨モデル

16GB は「ほぼ全モデルが動く快適ゾーン」

| モデル | 特徴 | VRAM | 用途 |
|--------|------|------|------|
| **FLUX.1 dev (FP8)** | プロンプト追従と写実性で本命 | 12~16GB | 高品質出力 |
| **Z-Image Turbo (6B)** | Alibaba Tongyi Lab、Apache-2.0 ライセンス | ~8GB | 高速生成（1024px / 2~3秒） |
| **SDXL** | アニメ調・LoRA・ControlNet エコシステム | 6~8GB | スタイル特化 |
| **Qwen-Image** | テキスト描画（日本語・中国語）が優秀 | 20B（実験用） | テキスト含む生成 |

### 実装コース

1. **Z-Image Turbo** で速さに慣れる
2. **FLUX.1 dev** で品質が欲しい場面に対応
3. **SDXL + LoRA** でスタイル特化

## 導入フロー

1. ComfyUI をインストール（ComfyUI Desktop が最簡、またはソースから）
2. ComfyUI Manager 経由で ComfyUI-GGUF ノードを追加（量子化版モデル用）
3. 上記 MCP を Claude Code に登録
4. ComfyUI を起動した状態で Claude Code から自然言語指示

**重要：ワークフロー変更前に「今のワークフローを要約して」と Claude に言わせる**

古いグラフ状態のまま操作すると接続位置がずれる可能性がある。

## WSL2 での localhost 接続トラブル

### 問題の原因

WSL2 では 3 層の接続隔離がある：

1. WSL2 から見た `localhost` は WSL 自身を指す（Windows の localhost には届かない）
2. ComfyUI はデフォルトで `127.0.0.1` にのみバインド
3. WSL → Windows の NAT 接続は自動だが、逆方向は自動ではない

### 解決策 1：ミラーモード（推奨、Windows 11 22H2 以降）

`C:\Users\<ユーザー名>\.wslconfig` を作成/編集：

```ini
[wsl2]
networkingMode=mirrored
```

PowerShell で再起動：

```powershell
wsl --shutdown
```

これで `localhost` が WSL ↔ Windows 双方向で通り、MCP 設定をデフォルトのまま使用可能。

### 解決策 2：NATモード（Windows 10 でも可）

**ComfyUI を外部接続可能にする**

ソース版：

```bash
python main.py --listen
```

Desktop 版：設定の「server」セクションで listen を有効化。

**Windows ホスト IP を取得して MCP 設定に指定**

WSL から：

```bash
ip route show default | awk '{print $3}'
```

出力例：`172.x.x.1`

`.claude/settings.json` に：

```json
"env": { "COMFYUI_URL": "http://172.x.x.1:8188" }
```

（このIP は再起動ごとに変わるのが欠点）

### 動作確認

```bash
# ミラーモード
curl http://localhost:8188

# NAT モード（ホスト IP 経由）
curl http://$(ip route show default | awk '{print $3}'):8188
```

どちらも繋がらない場合、Windows ファイアウォールが 8188 番をブロック。管理者 PowerShell で追加：

```powershell
New-NetFirewallRule -DisplayName "ComfyUI WSL" -Direction Inbound -LocalPort 8188 -Protocol TCP -Action Allow
```
