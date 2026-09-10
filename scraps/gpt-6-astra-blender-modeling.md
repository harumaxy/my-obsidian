---
title: GPT-6 Astra + Blender モデリング 実態調査
date: 2026-09-10
---

# GPT-6 Astra + Blender モデリング 実態調査

対象: X等で話題「OpenAI GPT Astra + BlenderでのAIモデリング凄い」の実態確認。

## 正体

- 「GPT Astra」= **GPT-6 Astra**。OpenAI公式、2026-09-03発表フラッグシップモデル。命名は天体系(Sol/Terra/Luna/Astra)最上位ティア
- Google「Project Astra」とは別物。名称類似で混同注意
- Blender連携自体は**OpenAI非公式**。第三者がAstraのagent能力(コーディング+Computer Use)で既存手段(bpyスクリプト or blender-mcp)叩いてるだけ。公式「Blenderワンクリック機能」は存在しない
- 話題化トリガー: Duncan Trussell氏Xデモ(2026-09-05、210万再生)

## 仕組み

汎用LLMのagentループ。3D専用モデルではない。

1. bpy/bmeshスクリプト自律生成
2. Blender実行(headless/GUI)
3. レンダリング→スクリーンショット取得
4. マルチモーダルで画像確認、歪み・寸法違い判定
5. コード修正して2に戻る、収束まで反復

連携方式2種併存: (a) bpy直接スクリプト実行 (b) blender-mcp等MCPサーバー経由。Blender 5.1以降は公式MCPサーバー登場との情報あり。

## 実績デモ

- 東京タワー(鉄骨・手すりまで精緻)
- 住宅一棟→UE5歩行可能空間化
- 蒸気機関車スケッチ→3,295個編集可能オブジェクト
- 人型キャラ8分でモデリング+リギング+走りモーション
- 失敗例: 暗い画像からのヘッドホンモデリングは形状把握失敗

## Hypeか実用か

結論: バイラルデモはやや誇張、叩き台生成+反復修正ツールとしては実用段階入りつつある。完全自律ワンショットでの実務品質保証は未達。

- 否定: 「a sick joke」(Blenderプロ)、キャラモデリング(三面図起こし)明確に弱い、同一プロンプトでも再現性なし、旧世代実験(Zenn)19回反復・4時間26分でも形状ミス解消せず
- 肯定: 「熟練モデラー1人が以前10人分」(HN)、東京タワー等精緻さ高評価

## コスト

API: 入力$10/出力$50(百万トークン)。GPT-5.6 Solの約2.5倍。Fastモード更に倍。

実消費例: 東京タワー+住宅モデリングでChatGPT 5時間枠の約80%消費。ヘッドホン試行後残枠12%。「気軽に何度も試すには重い」が共通認識。具体的な「モデル1体$いくら」の数字は不明。

## 制限

- UVテクスチャ、リギング精度、コリジョンメッシュ非対応/弱い
- 製造公差・3Dプリント適性検証不可
- 参照画像にない背面等は推測で精度低下
- 指示外の検査項目見落とし→形状ミス残存のまま完了扱いの例あり

## Tripo/Meshyとの違い

別カテゴリ。

- **Tripo/Meshy**: 画像/テキスト→3Dメッシュ直接生成の専用モデル。数秒〜数十秒。速いが編集しづらいトポロジ
- **Astra+Blender**: 汎用agentが既存3Dソフトを間借り操作。遅い・高コストだが編集可能な構造化データ(オブジェクト単位)で出る、複雑指示に対応可

用途住み分け: 高速量産→Tripo/Meshy、対話的に編集可能モデル作り込み→Astra方式。

## Tripo「Astraプロンプト集」ページの実態

https://www.tripo3d.ai/ja/3d-prompts/models/gpt-6-astra

技術連携ではなくTripoのマーケティングページ。AstraでバズったBlender/Three.js/ゲーム作品(211件)をキュレーションしプロンプトコピー可能に。「3Dアセットを無料で生成」ボタンで自社Tripo Studio誘導、GitHub「Awesome Astra Prompts」リポジトリへのリンクあり。

AstraがTripo APIを内部で叩いてる訳ではない。同じプロンプトを両ツールで試せる、という比較・誘導コンテンツ。

## 出典

- https://openai.com/index/gpt-6-astra/
- https://gigazine.net/gsc_news/en/20260907-gpt-6-astra-3d-modeling/
- https://kingy.ai/blog/drawing-to-editable-3d-model-astra-blender/
- https://kingy.ai/blog/openai-astra-rumor-tracker-demo-evidence-launch-window/
- https://codersera.com/blog/gpt-astra-vs-google-project-astra-2026/
- https://bettertoken.ai/en/blog/gpt-6-astra-blender-codex-computer-use/
- https://www.mindstudio.ai/blog/gpt-6-astra-video-game-development
- https://www.mindstudio.ai/blog/gpt6-astra-pricing-api-access
- https://news.ycombinator.com/item?id=49571621
- https://github.com/ahujasid/blender-mcp
- https://developers.openai.com/blog/architectural-visualization-with-astra
- https://modelinghappy.com/archives/70333
- https://note.com/npaka/n/n9635d06c377f
- https://himanekoblog.hatenablog.com/entry/2026/09/08/135419
- https://zenn.dev/test_myname/articles/gpt-5-6-blender-mcp-modeling
- https://www.ipentec.com/document/software/3d-model-generation-using-gpt-6-astra
- https://qiita.com/zukka/items/6492cf4db31e374850e2
- https://www.itmedia.co.jp/enterprise/articles/2609/05/news006.html
