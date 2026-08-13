---
title: 【Blender×ComfyUI】3Dモデルベース2Dスプライトアニメーション作成方法調査
description: Blenderの3Dモデル・ポーズをComfyUIに渡して2Dスプライト/スプライトシートを自動生成する各種ワークフロー調査まとめ
# permalink:  # don't use
aliases:
  -
tags:
  - blender
  - comfyui
  - ai
  - 2dsprite
  - gamedev
draft: false
date: 2026-08-11
---

3Dモデルベースで2Dスプライトアニメーション作る方法、Web調査した結果まとめ。5パターン見つかった。

## パターンA: レンダーパス分離方式(mickmumpitz手法)

Blender側で3種のレンダーパス作成:

- Depthパス: View Layer PropertiesでZパス有効化 → CompositingでMap Range → 黒白グラデ生成
- Outlineパス: Freestyleで輪郭線抽出、白色・線幅調整
- Maskパス: オブジェクト毎に別色のEmissionシェーダー割当、Hexコード記録(後でComfyUI側リージョン指定用)

ComfyUI側:

- ImageSequence読込(mask/depth/outlineを別フォルダから)
- Regional Conditioning(mask_colorフィールドにHexコード入力 → オブジェクト毎に別プロンプト)
- ControlNet Depth + ControlNet Canny 併用
- AnimateDiffで滑らか化

マスター/リージョン/ネガティブの3階層プロンプト構成がコツ。3Dの構造情報維持しつつAIで質感生成する路線。

参考: https://www.runcomfy.com/comfyui-workflows/ai-rendering-3d-animations-with-blender-and-comfyui

## パターンB: OpenPose直接生成方式(toyxyz Blenderアドオン)

toyxyz「Character bones Openpose」アドオン。Blender上のボーン構造からOpenPose/Depth/Canny/MediaPipeFace/指位置/カメラポーズを直接レンダー出力可能。ComfyUIのPose ControlNet入力に直結。リグ済み3Dモデルあればポーズ毎にOpenPose画像書き出しでき、多ポーズのスプライト生成が高速に回る。

参考: https://toyxyz.gumroad.com/l/ciojz

## パターンC: 逆方向(プロンプト→3D→リグ)自動化パイプライン

プロンプトからT-poseキャラ画像生成(Flux+ControlNet) → Hunyuan3Dでメッシュ化 → Blenderをheadlessで叩いて自動リギングまで全部スクリプト化。

```
blender.exe --background --python wrapper.py
```

ComfyUI APIは`/prompt`にJSON POSTで叩く方式。バッチ処理・キャラ毎の設定JSON管理がコツ。GPU 5090で1キャラ約2分。

参考: https://shahriyarshahrabi.medium.com/blender-as-a-pipeline-engine-make-rigged-characters-with-comfyui-3a1e81a3e623

## パターンD: 単一画像→フルスプライトシートパイプライン(コード付き実装)

github.com/mor-o/comfyui-2d-character-pipeline が一番実用的。W1〜W5の5ワークフロー構成:

1. W1: OpenPoseスケルトン + Qwen-Image-Edit 2509 + InstantX ControlNet-Union でポーズ配置
2. W2: WAN 2.2/2.1 VACEで画像→動画(ベースモーション生成)
3. W3: スプライトシート化
4. W4: 髪・目・衣装など化粧品レイヤーを2パスinpaint(SAM3, BiRefNet使用)
5. W5: 化粧品レイヤーのスプライトシート化

モデル総容量約80GB(Q5_K_M量子化WAN系込み)。AIエージェント駆動前提設計、Claude CodeやCursorがPythonドライバスクリプト(`run_w2_video_gen.py`等)叩く運用。

参考: https://github.com/mor-o/comfyui-2d-character-pipeline

## パターンE: 総合チュートリアル(一番網羅的)

TawusGamesの8ステップ完結ガイド:

1. Pose ControlNet/Qwen Image EditでT-poseキャラ生成(前後左右の複数ビュー角度も)
2. Tencent Hunyuan3Dでメッシュ化(テクスチャなしでも動くがあった方がAI補助になる)
3. Blender/Mixamoでリグ
4. Qwen Motion 1.0またはMixamoでアニメーション取得
5-7. Depth+Pose ControlNet併用で最大6スプライトのシート生成(16GB VRAM要)
8. 背景除去は解像度512×512に落とすと安定する

参考: https://tawusgames.itch.io/ai-gen-sprite-tutorial

## 共通コツ

- 一貫性の鍵は「T-pose/A-poseで統一姿勢生成」。関節位置推定が楽になる
- 複数ビュー角度(正面/背面/側面)を最初から用意しておくと後工程が安定
- Depth+Canny+Pose の複数ControlNet併用が定番
- VRAM厳しい場合は解像度を落とす(背景除去だけ512×512にする等)
- 3Dの構造保持 + AIで質感・スタイル生成、が全パターン共通の設計思想

## その他参考リンク(未深掘り)

- ComfyUI公式 Sprite Sheet Generatorテンプレート: https://comfy.org/workflows/templates-sprite_sheet-fe5600667e2c/
- ComfyUI公式 Pose ControlNetチュートリアル: https://docs.comfy.org/tutorials/controlnet/pose-controlnet-2-pass
- ArtStation記事「3Dモデルから2Dピクセルアート風アイソメスプライト作成」: https://www.artstation.com/blogs/jsabbott/YQaAw/tutorial-creating-2d-pixel-art-style-isometric-sprites-from-a-3d-model-in-blender
