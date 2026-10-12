---
title: Google AI Pro と Colab GPU
description: Google AI Pro の Colab 特典で A100 使える話。ComfyUI 運用、課金、GPU 買い替えとの比較
# permalink:  # don't use
aliases:
  - Google AI Pro
tags:
  - colab
  - gpu
  - comfyui
  - google
draft: false
date: 2026-10-10
---

## きっかけ

@studio_yebisu のツイート。Google AI Pro 特典で Colab に A100 40GB/80GB 来た、という話。

- 今まで Colab は VRAM 16GB 天井。大きい事できなかった
- A100 40GB/80GB 使える。Blackwell 6000 も使えるらしい (ツイート主「情報あり」)
- 本人の主張: Gemini サブスク本体より価値ある

## Google AI Pro とは

- Google の AI サブスク。Gemini 上位モデル + ストレージ + Google サービス内 AI
- 日本: 月 2,900円。年額 29,000円 (約16%引)
- Colab 特典: AI Plus / Pro / Ultra 加入で高速アクセラレータ + 高性能マシン優先アクセス
- Ultra は Premium GPU + バックグラウンド実行も付く
- Colab 対応国で順次展開。日本も対象
- Colab Pro (月$9.99) / Pro+ (月$49.99) は別契約

## 未確認

- ツイートの「月 200 CU」は裏取れず
- 「Premium GPU は Ultra 向け」という記述もある。Pro で A100 使えるかツイートと食い違う可能性
- 契約前に Google 公式で確認

## 使える用途 (ツイート主の主張)

- 重い動画・画像生成をフル精度で回す
  - Wan2.2, LTX-Video, HunyuanVideo を FP16/BF16 で。FP8, GGUF 量子化なしで OOM 気にしない
- ローカル LLM 検証
  - 24GB: 4bit 量子化 + 文脈短縮必須
  - 40GB: 8bit 量子化、LoRA 検証に余裕
  - 80GB: 30B〜70B 級が普通に動く

## CU 消費 (ツイートの概算、月 200 CU)

- A100 標準 (40GB): 約 5.3〜5.4 CU/時 → 約 37 時間
- A100 ハイメモリ: 約 7.5 CU/時 → 約 26〜27 時間

## ComfyUI は動くか

- 動く見込み。Colab は普通の Linux + GPU 環境
- やり方: ノートブックで git clone → 依存入れる → `python main.py` → cloudflared / ngrok でトンネル → 手元ブラウザで開く
- Colab は過去に Stable Diffusion 系 Web UI (特に A1111) を規約で制限。ComfyUI は比較的通ってた。今の扱いは未確認。規約要確認

## 課金は待機中もかかる

- GPU ランタイム接続してる間ずっと CU 減る。生成してるかどうか関係なし
- アイドル放置でも、自動切断されるまで消費
- 使い終わったら手動で「ランタイムを切断して削除」
- モデル DL 中も消費
- 節約: モデルは Drive に置く、ワークフローは手元で組む、セットアップは CPU ランタイムで先に済ませる、終わったらすぐ切断

## Colab の面倒な点

- セッション毎に環境消える。再セットアップ必要
- カスタムノード依存衝突のデバッグ中も課金
- ファイル操作は Drive 経由。ログ確認も手間

## 手元GPU との比較 (自分の場合)

- 手元: RTX4080 16GB。元はゲーム用
- 常用は手元。環境永続、時間気にしない、SSH/SMB で直接触れる
- Colab は「16GB に載らない大型モデルを一回試す」用途に絞る

## GPU 買い替え vs AI Pro

- AI Pro 年 約3.5万円。高性能 GPU 20万円〜。GPU 1枚で AI Pro 約6年分
- 画像・動画生成だけなら AI Pro 有利
  - 手元 VRAM 超えるモデル試せる、型落ち気にしない、使わない月は解約可
- 不利: CU 上限、毎回セットアップ、規約・特典変更リスク (特典は追加されたばかり、続く保証なし)
- 週数時間の趣味 → AI Pro で足りる。毎日回す / LoRA 学習繰り返す → 手元GPU が結局安くて快適
- ゲームやる限り GPU はどのみち買い替え。その時 VRAM 多めを選ぶ。AI Pro は補助で併用
- 生成専用に最新 GPU を今買うのは避ける

## 参考

- [Impress Watch: 年額キャンペーン](https://www.watch.impress.co.jp/docs/news/2074312.html)
- [helentech: Google AI プラン比較](https://helentech.jp/google-ai-plans-comparison/)
- [Google AI、Colab統合 Ultraにプレミアムgpu解放](https://pasqualepillitteri.it/ja/news/17602/colab-google-ai-puran)
- [@IT: Colab Pro/Pro+/Pay As You Go](https://atmarkit.itmedia.co.jp/ait/articles/2106/07/news025.html)
- 元ツイート: https://x.com/studio_yebisu/status/2108808702577009033
