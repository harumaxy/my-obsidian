---
title: blender-mcp-claude-fable5-research
description: Blender MCP × Claude Fable 5 のバズ調査。得意分野・限界・GPT/Gemini比較・アドオン連携
# permalink:  # don't use
aliases:
  -
tags:
  - blender
  - mcp
  - ai
  - claude
draft: false
date: 2026-08-11
---

Blender MCP × Claude Fable 5、流行り調査結果。原始人記録。

## なぜ今 Fable 5 で話題？

Blender MCP（ahujasid/blender-mcp）自体2025年3月公開。既に2万star級人気プロジェクト。旧世代Claude（Sonnet 3.5/3.7、Opus 4系）でも動作実績あり → **旧モデルでも技術的可能だった。新規性の話ではない。**

「Claude Fable 5」実在確認。2026/6/9公開、Anthropic新設"Mythos-class"一般公開第1弾。

バズの実態: 発売直後(6月中旬)、複数YouTuber同時多発でBlender MCP比較・実演動画投稿。単一発端動画特定不可。相乗効果でバイラル化。

Fable5固有強み:
- 長時間自律エージェント実行（数日間動作継続）
- ビジョン性能SOTA化
- 永続メモリ改善（約3倍、公式テスト報告）

上記がBlender MCPの「作る→レンダ確認→修正」反復ループの質底上げした可能性高い。ただし公式ベンチマークなし。「5倍速い」等はYouTuber個人の非公式主観。

2026年4月、Anthropic公式Blenderコネクタもリリース済み（Blender Development Fund へ年間24万ユーロ以上寄付）。これはコミュニティ製MCPとは別ルート。

## 得意分野・限界

仕組み: `execute_blender_code`という任意Pythonコード実行ツールが中核。Blender Python API(bpy)ほぼ全域に技術的アクセス可能。

- **有機モデリング/スカルプト**: ほぼ不可。Sculpt ModeはAPI上存在するが、スカルプト特有のリアルタイム視覚フィードバックループをテキストコード実行で再現できない。人の顔・リアル木・精密頂点配置は期待不可
- **ハードサーフェス**: 単発モディファイア(Boolean/Bevel/Array/SubSurf)得意。複雑スタック重ねは不安定(当たり外れ)
- **主戦場はシーン構築・アセット配置**: プリミティブ組み合わせ、Poly Haven/Sketchfab既製アセット検索・DL、ライティング/カメラ設定。「凄いモデル」の実体は大抵Hyper3D Rodin（別のAI3D生成サービス）に生成させてBlenderへ取込んでるだけ、というケース目立つ
- **テクスチャ/マテリアル**: 基本適用(色/メタリック/ラフネス)得意。専用ツール`set_texture`あり
- **シェーダーノード**: 簡単なものは可。数ノード超える複雑ノードグラフは破綻しやすい
- **UV展開**: 専用ツールなし。Smart UV Project等をAIがコード生成する形。単純形状のみ実用的
- **リギング**: ボーン作成・IKコンストレイント設置は可。ウェイトペイントは「視覚判断」要るため事実上不可
- **アニメーション**: 単純トランスフォーム(移動/回転)のみ実用的。歩行サイクル等複雑なもの不可

外部連携充実: Poly Haven(HDRI/テクスチャ/モデル検索DL)、Sketchfab(既製モデル検索DL)、Hyper3D Rodin(テキスト/画像→3D生成)、Hunyuan3D。

リスク: `execute_blender_code`は任意コード実行でガードなし。GitHub Issueでセキュリティ研究者指摘あり。作業前保存必須。

## GPT/Gemini比較

3社ともMCPプロトコル共通対応（blendermcp.orgが汎用サーバー、Claude/ChatGPT/Gemini/Cursor/VSCode/ローカルLLM全対応）。公式・第三者機関の直接比較ベンチマークなし。個人YouTuber非厳密検証3件のみ確認:

1. **幾何精度厳密タスク（Archimedes多角形CAD生成）**: GPT系優勢。Claudeはメッシュ肥大化・shade smooth誤爆で失敗例あり。Geminiはテキストセンタリング失敗+ハルシネーション（指示にないカメラ・ライト生成）。Grok最も混乱
2. **長時間マルチツール連携タスク（映画生成: Blender MCP+ElevenLabs+VideoEdit MCP）**: Claude Opus 4.7が38分で完了、最速高品質。Codex(GPT-5.5)は1時間3分（1.7倍時間）だが同等品質。Gemini 3.5 Flashは17分最速だが完全失敗（ほぼ空フレーム・無音）
3. 一般コーディング/エージェンティックベンチマーク(SWE-bench等)集計ではFable5/Opus系優位という記事複数あるが、Anthropic公式発表の後追い記事中心で独立監査ではない

総括: **Gemini最弱。Claude/GPTはタスク性質で優劣入れ替わる**、が現状実態。厳密な性能序列は断定不可。

## アドオン連携（BoxCutter, Auto-Rig Pro等）

公式ドキュメント上のサポート明記なし。

技術的には: `execute_blender_code`（実装名`execute_code`）が`exec(code, namespace)`で任意Python実行。事前にBlender側でアドオン有効化済みなら、理論上そのアドオンのbpy.ops呼び出しも可能な構造（namespaceに`bpy`のみ渡すが、コード内で追加import可能）。

ただし制約:
- アドオンインストール・有効化はユーザー側事前作業必須（MCPにインストール機能なし）
- MCPサーバーはアドオン固有API知らない → AIが正しいbpy.ops呼び出し名を推測生成できるかに完全依存
- 実際にBoxCutter/Auto-Rig Pro/Hard Ops/Machin3tools等を操作した実践報告、検索範囲では未発見

非公式フォーク（RFingAdam/mcp-blender「218ツール」、6xvl/blender-mcp「約270ツール」等）が標準bpy API拡張（UV展開・リギング・アニメーション専用ツール追加）してるが、これらもBlender標準API再実装であり、サードパーティ商用アドオンAPI直接ラップではない。

## 参考リンク

- https://github.com/ahujasid/blender-mcp
- https://www.anthropic.com/news/claude-fable-5-mythos-5
- https://www.mindstudio.ai/blog/claude-blender-mcp-real-world-performance
- https://www.strayspark.studio/blog/ai-powered-3d-modeling-blender-mcp-server-guide
- https://blendermcp.org/compare/best-blender-ai-assistant
