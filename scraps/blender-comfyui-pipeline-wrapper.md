---
title: Blenderパイプラインエンジン化 + ComfyUI自動リグキャラ生成
date: 2026-09-12
source: https://shahriyarshahrabi.medium.com/blender-as-a-pipeline-engine-make-rigged-characters-with-comfyui-3a1e81a3e623
---

# Blenderパイプラインエンジン化 + ComfyUI自動リグキャラ生成

著者Shahriar Shahrabi、16分記事、2025/11/25。
GitHub: [comfyUI-blender-wrapper](https://github.com/IRCSS/comfyUI-blender-wrapper) / [comfy-UI-character-generation-batcher](https://github.com/IRCSS/comfy-UI-character-generation-batcher)

## 背景

本番制作、同処理を百体千体規模で繰返す前提。Blender無料・内蔵機能豊富(3D/2D/動画/音声)→自前C++/engine内実装より自動化に強い。
例: スタイライズ木の法線調整、200本自動化なら10分設計で済む話。

## headless起動

```
blender.exe --background --python file.py
```

file.py内、Blender Python API全機能アクセス可能。

## 汎用ラッパー設計

decimate/retopo/unwrap等、毎回import/export書くの面倒→共通部分ラッパー抽出、ステージ固有処理だけ別途記述する構造。

情報伝達は環境変数経由:

```python
env = os.environ.copy()
env["INPUT_MODEL"] = input_model
env["OUTPUT_JSON"] = tmp_output_path
cmd = [blender_exe, "--background", "--python", WRAPPER_PATH]
subprocess.run(cmd, env=env, capture_output=True, text=True)
```

wrapper側 `os.getenv()` で受取、`bpy.ops.import_scene.fbx()` 等でインポート。

ステージコードは別.blendファイル内Textスクリプトとして保存。ラッパーが`Main`スクリプト探索→あれば実行、無ければ全部実行。`exec()`でグローバル変数注入(`blend_file`, `input_model`, `config`, `input_objects`等)。

Collection規約: ラッパーが`INPUT`にメッシュ投入→ステージ側はそこから取得。`OUTPUT`に置けばラッパー側export(オプション)。

config(JSON)でパラメータ柔軟化:

```json
{
  "decimate_ratio": 0.06,
  "image_size": 512,
  "bake_margin": 8,
  "final_height": 0.4896774,
  "center_x": false,
  "export_intermediate": true
}
```

headless/UI両対応Tips: UI内でINPUT Collection手動用意→スクリプト先行開発→動作確認後コマンドライン移行。`isHeadless`フラグで分岐。

ComfyUI連携: カスタムノード(`run_blender_task`)→wrapper.py→指定.blend(例`MeshCleanup.blend`)のステージ実行。config in/outでノード間通信。seed入力追加理由: Comfyの「入力不変なら再実行しない」最適化を強制回避(config変更検知不能なため)。

## Flux + Hunyuan3D自動リグキャラ生成

用途: 遠景・低品質群衆キャラ。

フロー:
1. 画像生成+ControlNetでT-poseキャラ画像生成
2. Hunyuan3Dで同T-poseから3Dメッシュ生成
3. Blenderでメッシュクリーンアップ(リトポ/アンラップ/テクスチャベイク/ピボット/スケール調整)
4. シンプルリグでリギング・スキニング

ステップ4成立理由: T-pose ControlNetが常にピクセル完全一致姿勢生成→関節位置予測可能。ヒーローキャラ向けはOpenPose等CV併用でより精密化も可能(著者本人は未実施)。

速度: RTX 5090で1体約2分。100体規模には遅い→バッチツール着想に繋がる。

## Comfyバッチ呼出ツール

基本API通信:

```python
COMFY_API = "http://127.0.0.1:8188"
requests.get(f"{COMFY_API}/api/system_stats", timeout=3)
requests.post(f"{COMFY_API}/prompt", json={"prompt": prompt})
```

config例:

```json
{
  "base_additional_prompt": ", T-pose, studio lighting, clean background, full body",
  "characters": [
    {"name": "Elf Warrior", "prompt": "A tall elf warrior in silver armor, fantasy style", "runs": 2},
    {"name": "Cyberpunk Hacker", "prompt": "A young cyberpunk hacker with neon lights", "runs": 1}
  ]
}
```

プロンプト+base_additional_prompt、runs回実行。

注意点3つ:
- ワークフローJSON内ノードはtitleで検索・書換(`Prompt`, `OutputPath`, `CharacterName`)
- 表示用workflow ≠ API実行用workflow。reroute/switch等含む表示用そのまま使用不可→developer options有効化→「Export for API」済sanitize版使う。自前sanitizer実装は非推奨(Comfy更新追従できない)
- 配布ワークフローは自分のPC構成(モデルパス/VAE/CLIP/input画像)に合わせ再調整必須。API版は人間編集不可なのでオリジナル版で調整→再度API export

## 結論

汎用ラッパーパターンで「import/export/通信」と「ステージ固有処理」分離→同ステージコードをUnity/Unreal等他エンジンでも再利用可能な設計。
