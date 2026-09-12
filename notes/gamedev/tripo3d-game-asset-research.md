---
title: Tripo 3D でゲーム用アセット作る調査
description: Tripo 3D(tripo3d.ai)でキャラ・ステージ・小物・建物作る全般調査。体験記/ComfyUI連携/リファレンス画像/コーディングエージェント協業/トポロジー最適化/着せ替えシステム/AAA品質/料金&連携Tips
# permalink:  # don't use
aliases:
  - Tripo3D
  - Tripo AI
tags:
  - tripo
  - ai
  - 3dmodeling
  - gamedev
draft: false
date: 2026-09-11
---

サブエージェント8体並列調査(2026-09-11)。関連: [[blender-tripo-ai-modeling-200h]] [[sorceress-ai-game-asset-suite]]

## 完成まで作った体験記

- 清水勇人氏note: Codex+Tripoで3〜5分探索ゲーム完成。8段階ワークフロー(仮図形プロトタイプ先→重要アセットのみTripo化→最適化)。https://note.com/shimi_hachi/n/nfb00f788cdd9
- Tripo 3D Game Jam「Portal Pass」(2026年1-2月、GDC2026展示、賞金$16000超、31作品完走)。フォーラムで生声: Tripo製壁・床多用したらFPS急落、Unity標準図形に戻しキャラのみTripo化するハイブリッド運用に切替。他ツール併用も公式OK。https://itch.io/jam/tripo-3d-game-jam-for-gdc-2026-portal-pass
- BTA氏note: リトポ用途で好評価だが生成キャラTポーズでなく結合、手に物持たせると精度激減、静物建物苦手。https://note.com/funsetmodev/n/nf0aadcf2cdab
- itch.io完成リリース「Peaceful Grassland」(vasinato)、Tripo製アセット使用。
- 共通の苦労点: リグ非対応、手など複雑形状の精度低下、大量使用時FPS問題、後処理ほぼ必須。

## ComfyUI連携

- 公式ノード [VAST-AI-Research/ComfyUI-Tripo](https://github.com/VAST-AI-Research/ComfyUI-Tripo)。API経由Text/Image/Multiview→Mesh、Texture、Rigまで対応。公式チュートリアル: https://docs.comfy.org/tutorials/partner-nodes/tripo/model-generation
- ローカル完結版 ComfyUI-Flowty-TripoSR(オープンソースTripoSRモデル、APIキー不要無料、低精度)。クラウド版Tripoとは別物、混同注意。
- 公式Python SDK: `pip install tripo3d`。自前スクリプト連携用。
- イラスト系キャラは実写より精度落ちる、マルチビュー画像入力(正面/側面/斜め)で改善。

## リファレンス画像・キャラデザ

- 最低256×256px、高精細狙うなら2048px以上。単色背景・高コントラスト・均一光推奨。被写体と背景同系色は形状誤認識の原因。
- Multiview to Model API: 前後左右4枚(正面必須、最低2枚可)、0/90/180/270°で向き一貫必須。
- T-pose推奨(リギング前提時)。ターンアラウンドシート的プロンプト構造(front/side/back view, orthographic layout, neutral lighting)が有効。
- ネガティブプロンプトも効く。「画像で形状決定、プロンプトでスタイル補足」が公式推奨運用。
- 200h検証ノート([[blender-tripo-ai-modeling-200h]])と一致: テクスチャー用画像とモデル生成用画像は別に作るべき、彩度高め推奨。

## コーディングエージェント協業

- 公式Tripo MCP(VAST-AI-Research/tripo-mcp、alpha、Blender連携)。非公式MCP(Claude Code+Godot特化)も複数存在。
- 公式Tripo CLI: エージェント向け設計(`tripo docs --llm`、ブロッキングコマンド、JSON/exit code対応)。Codexプラグインも公式提供。
- 事例Godogen: Claude Code+Codex+Gemini+Grok+Tripoの役割分担で自律ゲーム開発、Godot/Bevy/Babylon.js対応。https://github.com/htdt/godogen
- Unity/Unreal向け公式「DCC Bridge」プラグインでワンクリック転送。Unreal向け専用MCPは薄い。
- 200h検証ノートの結論と一致: 完全自動化(Claude Code+Tripo API)はコスパ悪い、Web版Tripo手動操作+要所だけ人間修正が最速ルートという実測あり。

## トポロジー最適化

- Smart Mesh(Quad Remesher)でクアッド化リメッシュ。Triangle500〜5万面、Quad500〜2.5万面指定可。API `quad`+`face_limit`パラメータで制御。
- 実測レビュー: 顔まわり(目口)のトポロジー崩れが弱点、Smart MeshV2でも完璧でない、Blender後処理前提。
- Web UI: Game Asset(約5000)/Low(9000)/Med(3.3万)/High(5.5万)の4段階選択。
- ゲーム用目安: PC/コンソールのヒーローキャラ5万〜10万面、モバイルは300〜2000面級。Tripo標準出力では粗すぎ、追加軽量化必須。
- 2026年9月公開P2.0 Previewでネイティブquad出力・生成直後リグ可能に強化。

## 着せ替え・ドレスアップシステム

- Intelligent Segmentation機能でモデル後からパーツ自動分割可能(API一覧になくStudio限定の可能性)。「最初から服とキャラを別々に生成」する専用機能は不明瞭。
- Rigging APIはbiped等7骨格タイプ対応だが、「複数メッシュで骨格共有」の明記は公式ドキュメントになし。
- 実務ワークフロー(一般解): Tripo生成→Blenderで衣装メッシュ分離→メッシュデータ転送でウェイト転送→体と同じArmature共有→ゲームエンジンでSkinned Mesh差し替え。
- Unity: ScriptableObjectで装備スロット管理、SkinnedMeshRendererボーン共有。Unreal: Skeletal Mesh Socket+モジュラーキャラ(Master Pose Component)。
- 200h検証ノート補足: 衣装は先にキャラ完成させてから、そのキャラに合わせた衣装画像を生成した方がフィット良い。

## AAA品質モデル作成法

- Tripo単体ではAAA品質は無理という結論。v2.0→v2.5→v3.0で着実に改善中だがMeshy社内ベンチマークでは表面ディテールで劣る数値(自社比較でバイアス注意)。
- 弱点: floating geometry、UVムラ、オーガニック素材(布・革)テクスチャが弱い。ハードサーフェス(機械・武器)は得意。
- 実践プラクティス: Tripoのワンクリックリトポ→手動UV再展開→Substance Painterで本番テクスチャ描き直し→ノーマルマップ再ベイク、が業界共通ワークフロー。「Tripo=叩き台、仕上げは人力」。
- 競合比較: Meshy(環境物・PBR一括出力に強い)、Rodin/Hyper3D(超写実・高ポリ、生成遅い)、Hunyuan3D(安定性・8K)、Kaedim(人間QA挟む最高品質だが遅い高い)、Luma Genie(最速だが荒い)。

## 料金・ライセンス・エンジン連携Tips

- 無料枠: 月300クレジット、生成物はCC BY 4.0で強制公開(非公開不可)。商用/非公開目的ならPro以上必須($15.9〜19.9/月)。
- Trustpilotに解約困難・無断課金継続の苦情複数、サブスク管理は要注意。
- Unity: GLB非対応(glTFast必須)、FBXなら標準対応で安定。
- Unreal: オートリグと標準ヒューマノイドの骨格互換チェック要、肩・顎ウェイトが不安定との実測報告あり。
- Godot: GLBネイティブ対応で一番手軽。
- Mixamo連携: 非ヒューマノイド非対応、歪み・指破綻報告あり。TripoのAIオートリグがMixamo代替として使われつつある。
