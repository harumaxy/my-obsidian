---
title: GenMesh
description: 画像→3D + リメッシュ + Rigify 自動リグ + Live Link + MCP の統合ツールキット。$34.90、レビュー0件、Blender 5.2 限定
# permalink:  # don't use
aliases:
  - genmesh
tags:
  - blender
  - superhive
  - ai
  - image-to-3d
  - mcp
draft: false
date: 2026-11-18
---

# GenMesh

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/genmesh

## 価格・状態

- Thiago Lage。$34.90 (セール $29.67)。15%オフ全商品クーポンあり (作者 3商品)。
- 公開23日前。**Blender 5.2 のみ**。Windows x64 主対象。GPL-3.0-or-later。
- **レビュー0件**。販売数表示なし。macOS / Linux は未検証。

## 位置づけ

- 作者自身が「出発点を作るツール」と明記。生成物・リグは手動修正が必要。

## 生成

- Hunyuan3D-2mini (別途インストール、重み約4.2GB)。Multi-view は追加約4.9GB。ZIP にエンジンは含まれない。
- 単一画像 or 複数視点。
- CPU 実行可、NVIDIA CUDA で高速化。GPU なしなら Google Colab 接続可 (20分アイドル or 合計120分で解放)。Multi-view は常にローカル。
- 最低 15GB の空き容量。

## 後処理

- リメッシュ: ポリゴン削減、クアッドリメッシュ。Restore texture でテクスチャ維持。アニメ向けエッジループは保証しない。
- Wrap: ベースメッシュ (トポロジー・UV 維持) をターゲットの形状にランドマークでフィット。プレビュー可逆。結果は別コピー。
- テクスチャ: PBR ワークフロー、512px〜4K アトラスベイク。
- 履歴、モデル情報カード、デリバリー予算 (Light / Medium / Heavy で三角形数指定)。

## リグ

- 人型: A/T ポーズに Rigify Basic Human を推定関節 + 編集可能マーカーでフィット。
- 動物: Rigify 四足 or 24種のクリーチャープリセット。元メッシュは複製で保持。
- 顔リグなし。脚・翼・首・尻尾・ウェイトは要確認と作者が明記。

## エクスポート・連携

- GLB / FBX / OBJ / STL。Unreal / Unity / Godot プロジェクトフォルダを認識。
- Live Link: Maya / ZBrush / Unreal / Godot へ送信。Maya / ZBrush / Unreal からの編集は新規オブジェクトとして戻る。
- MetaHuman (UE 5.8): A ポーズ無リグボディを送る。フルリグは Epic サービスと Epic ログインが必要。

## MCP 連携

- Claude Desktop / Codex / Antigravity。Claude Code の記載なし。
- アシスタントがパーツ・寸法・材質・ポリゴン予算を契約形式で渡し、GenMesh がモデルを構築。任意コード実行はしない。完成した組み立てはパーツライブラリに保存。
- **画像生成ではなく構造化モデリング**。
- 画像関連 (A ポーズ参照作成など) はアシスタント側の画像ツールが必要。

## ライセンス注意

- Hunyuan3D は EU・UK・韓国を対象外。商用は要確認。参照画像の権利も自己責任。

## 所感

- 機能の幅は一番広い。実績なし。作者の記載は「できる」の列挙で作例が薄い。
- エンジンが Hunyuan3D-2mini (小型版)。[[image-to-3d-milad]] の Hunyuan と同等とは限らない。
- Auto-Rig Pro 持ちなら重複気味。Godot / Unreal 連携と MCP が目当てなら。
