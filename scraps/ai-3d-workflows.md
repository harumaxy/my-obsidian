# AI活用3Dモデル制作ワークフロー調査

Godot(glb/gltf)向け。工程別ベストプラクティス+ソースURL。


## コンセプトアート・三面図（元絵）

- ターンアラウンドシート: 1枚横長画像にfront/3-4/side/back並べ生成。プロンプト"character sheet, turnaround, multiple views"。
  https://stable-diffusion-art.com/consistent-character-view-angle/
- ControlNet(OpenPose+Lineart): 各アングル骨格・シルエット固定→ビュー間ブレ防止。SDXL世代標準。
  https://blib.la/blog/mastering-character-consistency-in-stable-diffusion-sdxl-a-detailed-guide
- FLUX.1-dev + キャラLoRA: 2026年主流。LoRA訓練済み一貫性85-92%、参照画像のみ65-75%止まり。
  https://apatero.com/blog/ai-character-turnaround-sheet-generation-guide-2026
- Midjourney V7 Omni Reference(--oref/--ow): 正面クリア画像→側面・背面プロンプト追加投入。
  https://www.imaginepro.ai/blog/2025/7/midjourney-character-reference-guide
- Tripo/Meshy Multiview入力: 前後左右2-4枚オーバーラップ30-60%、背景無地・透過推奨。単一画像は背面欠損しやすい。
  https://www.tripo3d.ai/tutorials/tripo-ai-image-to-3d-tips
  https://help.meshy.ai/en/articles/12634481-how-to-use-multi-view
- ツール向き: Tripo=速度、Meshy=クリーンメッシュ・エンジン互換、Rodin=ハードサーフェス高品質。
  https://medium.com/ideas-with-wings/best-ai-3d-model-generators-in-2026-tripo-ai-vs-meshy-rodin-kaedim-and-more-7eea7b05eb11


## モデリング

- image-to-3D比較: Tripo(最速・自動リグ向き)、Meshy(オールインワン・プロップ向き)、Rodin(高忠実度ヒーローアセット)、Trellis2/Hunyuan3D(PBR標準付属・高ポリ対応)。
  https://www.neural4d.com/features/neural4d-vs-tripo-vs-meshy-vs-rodin
  https://trellis2.com/blog/trellis-2-vs-hunyuan3d-image-to-3d
- 生成メッシュ問題: 三角形スープ・非多様体・孤立頂点頻発。標準プロップで50-100万ポリ過剰出力あり。
  https://www.tripo3d.ai/media-production/retopologize-ai-3d-model-in-blender
- Blenderリトポ手順: Merge by Distance→Voxel Remesh→Decimate(Collapse)→Shrinkwrapでディテール投影。複雑キャラは手動リトポ標準。
  （同上URL）
- 実務パイプライン例: Meshy生成→検証→RetopoFlow4手動リトポ→Auto-Rig Pro。
  https://github.com/73K-Y/3D-Workflow-Pipeline
- ポリ数目安(PC/コンソール): 小物2-10K、環境5-50K、NPC20-50K、ヒーロー50-100K+。Godotはドローコール・シェーダーの方が重い、MultiMeshInstance3Dで削減。
  https://www.tripo3d.ai/blog/poly-count-for-game-assets-how-to-prepare-ai-3d-models


## テクスチャリング

- Meshy AI Texture Generator: Albedo(8K)/Metallic-Roughness(4K)/Normal/Emission自動生成、UV展開も自動。
  https://www.meshy.ai/features/ai-texture-generator
- ComfyUI+ControlNet(Depth/Normal)投影: メッシュから複数視点Depth画像生成→投影ノードでテクスチャ化(StableGen等)。
  https://docs.comfy.org/tutorials/controlnet/depth-controlnet
  https://github.com/Zaws77/StableGen
- Substance 3D Painter 12.0(2026 GDC): Warp to Geometry、ZBrush連携、OpenPBR初期対応。
  https://blog.adobe.com/en/publish/2026/03/09/more-control-less-friction-texturing-workflows-latest-substance-3d-innovations
- ORMパッキング: Occlusion/Roughness/Metallicを1枚RGBに統合、フェッチ回数・VRAM約66%削減。UE5前提ORM、Unity HDRPはRoughness反転要。
  https://www.strayspark.studio/blog/orm-texture-packing-game-performance-guide
- Godotインポート: Normal専用処理、Albedo=色データ・Roughness/Metallic/AO=データマップとしてVRAM圧縮設定。ETC2実用的選択肢化。
  https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html


## リギング・スキニング（共通スケルトン・リターゲット）

- AccuRIG2 / Mixamo: 無料自動リグ。AccuRIG2はスタイライズド・非人型対応進み2026年Mixamo代替評価。
  https://www.tripo3d.ai/content/en/guide/the-best-mixamo-auto-rigger-not-working-tools
- UniRig(VAST-AI-Research, SIGGRAPH2025): 人・動物・オブジェクト横断の自己回帰リギングモデル。Tripo/Meshyの自動リグに統合済み。
  https://arxiv.org/abs/2504.12451
  https://github.com/VAST-AI-Research/UniRig
- 共通スケルトン標準: Unity Humanoid Avatar(標準ボーンマッピング層でモデル間アニメ共有)、UE5 IK Rig/IK Retargeter(ボーンチェーン定義→比率差吸収)。
  https://docs.unity3d.com/Manual/Retargeting.html
  https://dev.epicgames.com/documentation/en-us/metahuman/retargeting-animations-between-metahumans-in-unreal-engine-5
- Godot4リターゲット: SkeletonProfileHumanoid+BoneMap。骨名だけでなくBone Rest(基準姿勢)も一致要。4.3/4.4でインポーターの骨名リネームバグ報告あり。
  https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html
  https://github.com/godotengine/godot/issues/106073
- Mixamo→Godot自動化: MixaBridge、godot_mixamo_converter(Blenderアドオン、ルートモーション対応)。
  https://mixabridge.uzair.gt.tc/
  https://github.com/CodeDoes/godot_mixamo_converter
- モーキャプ流用: Auto-Rig Pro組込Remapプリセット(Mixamo/Rokoko対応)、Rokoko Blenderプラグインでストリーミング+組込リターゲット。
  https://www.rokoko.com/insights/ace-retargeting-in-blender-with-this-simple-workflow-i-the-ultimate-retargeting-guide
  https://www.lucky3d.fr/auto-rig-pro/doc/remap_doc.html


## アニメーション

- Cascadeur(Nekki): AutoPhysicsでキーフレーム物理補正。2026.2で加算アニメレイヤー追加、実務投入最進のAIアニメツール評価。
  https://cascadeur.com/
  https://digitalproduction.com/2026/08/03/cascadeur-2026-2-adds-animation-layers/
- Rokoko Video: 単眼カメラAIモーキャプ→Studio→標準リグ適用→足滑り自動修正→リタゲット→FBX。
  https://www.rokoko.com/insights/will-generative-ai-replace-motion-capture-in-2026
- DeepMotion: 単眼動画からフルボディ+顔+手抽出。テキストからモーション生成"SayMotion"も提供。
  https://mocaponline.com/blogs/mocap-news/ai-game-animation-tools-2026
- Move.ai: マーカーレス複数カメラモーキャプ、Blender/Unreal MCP Server連携の自動化パイプライン実務進行中。
  https://www.strayspark.studio/blog/moveai-mocap-without-suits-indie-animation-pipeline
- 2026標準構成(インディー): Mixamo(基本モーション)+Cascadeur(補正)+DeepMotion/Rokoko Video(モーキャプ)+Blender(調整)。共通ボーン命名前提。
  https://www.strayspark.studio/blog/ai-mocap-indie-developers-2026-comparison
- Godot自動化: Godot-Mixamo-Animation-Retargeter(FBX右クリック一発)、MixaBridge(3クリック)。
  https://github.com/RaidTheory/Godot-Mixamo-Animation-Retargeter


## シェーディング

- AI生成テクスチャ→Blender PBR 5段階: 複数バリエーション生成→物理妥当性チェック(非金属Metallic=0確認)→Principled BSDF自動構築→Curves/ColorRamp補正→ORMパック。
  https://www.strayspark.studio/blog/ai-pbr-material-generation-pipeline-blender-unreal
- AI生成マテリアルの落とし穴: Metallic/Roughness値が物理的に非妥当な場合あり、生成後手動検証必須。
  https://www.strayspark.studio/blog/ai-material-generation-blender-2026-complete-guide
- Godot向けPBRチェック: Base Color=sRGB、Metallic/Roughness=リニアグレースケール、Normal=Raw Color。GodotはORM仕様でもStandardMaterial3D自動割当されるバグ的挙動あり、手動確認要。
  https://supermatrix.studio/blog/how-to-create-realistic-pbr-materials-in-blender-for-godot-4
  https://github.com/godotengine/godot/issues/70979
- NPR/トゥーン: BlenderはEEVEE中心にNPR機能強化中(2025年〜、Smooth Toon/ピクセレート/ハーフトーン+アウトライン開発)。AI生成メッシュはトポロジー不均一→輪郭線シェーダー破綻しやすい、リトポ後適用推奨。
  https://code.blender.org/2025/05/npr-project/
  https://github.com/meshy-dev/game-asset-pipeline
- Godotトゥーン実装: `light()`関数オーバーライドで陰影バンド作成が定番。GodotToonShader等コミュニティ実装あり。
  https://forum.godotengine.org/t/tutorial-about-toon-shading-and-the-light-function-in-shaders/135038
  https://github.com/nakedsnake888/GodotToonShader


## ゲームエンジン連携・エクスポート（Godot / glb,gltf）

- 形式はGLB一択: +Y Up必須有効化。
  https://bitsoulhosting.com/marketplace/blog/blender-to-godot-4-glb-export-workflow-guide
- アニメ/スキニング: "NLA Strips"にチェックし名前付きストリップ整理が正。"Export all animation actions"オフ推奨、"Export Deformation Bones Only"でヘルパーボーン除去。
  https://supermatrix.studio/blog/best-workflow-for-exporting-animated-characters-from-blender-to-godot
- Transform未適用が変形バグ元凶: エクスポート前Ctrl+AでApply Transforms(特にScale)必須。
  https://gamineai.com/help/blender-4-2-glb-export-loses-materials-godot-4-metallic-roughness-import-fix
- マテリアルはPrincipled BSDF縛り: 複雑ノードはドロップ・フラット化。Metallic/Roughnessはリニア直結。
  （同上URL）
- Draco圧縮は非推奨: Godot側で明示有効化しないとエラー、実行時性能寄与なし(ロード時間短縮のみ)。BlenderはDracoオフ推奨。
  https://forum.godotengine.org/t/compression-version-of-glb-gltf-is-not-working/94486
- テクスチャ圧縮: BlenderはImage Format"Automatic"、圧縮判断はGodotインポートに委任。KTX2/Basis Universalは2026年時点でも未成熟。
  https://github.com/godotengine/godot-proposals/issues/13660
- ドローコール最適化: gltfpack(meshoptimizer)/glTF-Transformでジオメトリ簡略化、GodotのLODシステムにLOD1/2登録。
  https://meshoptimizer.org/gltf/
- AI生成モデル特有の法線問題: MeshyなどがGLB出力時カスタム分割法線埋込→Blenderクリーンアップ操作と衝突しまだら状崩れ。"Clear Custom Split Normals Data"実行後Auto Smooth再設定要。
  https://www.tripo3d.ai/blog/how-to-clean-up-ai-generated-3d-models-in-blender
