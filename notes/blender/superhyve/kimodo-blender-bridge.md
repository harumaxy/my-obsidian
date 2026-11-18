---
title: Kimodo Blender Bridge
description: NVIDIA Kimodo のテキスト→モーションを Blender 内で。無料。Windows/Linux、NVIDIA 8GB+。v1.5.7 以降必須 (旧版に削除バグ)
# permalink:  # don't use
aliases:
  - kimodoblenderbridge
  - Kimodo Bridge
tags:
  - blender
  - superhive
  - motion
  - text-to-motion
draft: false
date: 2026-11-18
---

# Kimodo Blender Bridge

親: [[superhive-blender-gamedev-tools]]

https://superhivemarket.com/products/kimodoblenderbridge

## 価格・状態

- 作者 Lewdineer。**無料**。支援版 $5 / $10 (SOMA リグ済みアーマチュア付き)。
- 評価 4.0 (8件)。GPL。ソース公開: https://github.com/lewdineer/Kimodo_Blender_Bridge
- Blender 4.0+ (4.2+ の Extensions でも導入可、5.1 / 4.4 で検証)。

## 要件

- **NVIDIA 8GB+ (推奨 16GB+)**。RTX 50 (Blackwell) 対応。
- Windows / Linux。**macOS 不可**。
- Python 3.10〜3.13 が必要 (管理 venv の作成用)。約10GB。

## 重要な安全情報

- レビューに「**Retry Install が Linux のホームディレクトリを再帰削除した**」報告 (Anton)。インストール先に自分のホームを選んだ状態で Retry を押し、全データを失った。
- 作者は **v1.5.7 で修正** (削除前に確認、システムフォルダは削除不可)。問題のある旧版は Superhive から削除済みと返答。
- → **v1.5.7 以降を確認**。**インストール先に自分のホームや作業フォルダを指定しない**。
- そのほか: Python 検出失敗、インストール先が C ドライブ固定 (最新版で変更可能に改善中)、「Kimodo failed to start」。

## 機能

- Install Kimodo (Auto): `~/.kimodo-venv/` に venv、PyTorch、重み、テキストエンコーダを自動導入。CUDA 12.1 / 12.4 / 12.8 を自動選択。導入後は完全オフライン。
- プロンプト → `Kimodo_Source` アーマチュアにモーション。モデルは常駐し反復が速い。
- **Motion Segments**: 複数プロンプトを連結 (プレイリスト式)。遷移フレーム数を調整。1回のモデル呼び出しでブレンド。
- 2〜5 種の乱数シード別バリエーションを一括生成。履歴 (直近20件) から再取り込み。
- **空間コンストレイント**: ルート XZ ウェイポイント、手足エフェクタ、全身ポーズ、Bezier / NURBS カーブからの経路サンプリング。
- **リターゲット**: Kimodo の SOMA スケルトンから自分のリグへ Auto-Match Bones (Mixamo 対応)。Child Of / Copy Rotation / Copy Transforms をボーンごとに選択 → ベイク。マッピングはプリセット保存・JSON 共有可。
- 出力は 30 FPS 固定 (シーン側を合わせる)。

## 未確認

- Kimodo モデル自体のライセンス (商用可否)。ページに記載なし。NVIDIA 側の確認が必要。
- ARP リグへの Auto-Match がどこまで効くか (レビューに情報なし)。

## 位置づけ

- 無料なので真っ先に試す価値あり。
- 同じ Kimodo ベースの有料版が [[blaze-puppeteer]] (リグ直書き、Anchors / PostPro などアニメーター向け制御)。
- 動画から取るなら [[motiongen]]。
