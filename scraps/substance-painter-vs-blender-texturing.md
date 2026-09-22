---
title: Substance Painter vs Blender テクスチャリングフロー検討
date: 2026-09-13
---

# Substance Painter vs Blender テクスチャリングフロー検討

前提: Tripo 3Dでモデル生成→Blender+Quad Remesherでリトポ、のフロー運用中。次工程のテクスチャリング検討。

## Tripo3D自動テクスチャの限界

- UV自動展開、チャート分割乱雑・シーム最適化なし
- リトポ後は頂点/面 別物化 → 元UV・テクスチャ完全に無効、破棄確定

## 標準フロー(ハイポリ→ローポリ)

1. Tripo3D生成(ハイポリ+テクスチャ)
2. Blender Quad Remesherでリトポ(ローポリ)
3. ローポリに新規UV展開
4. **ベイク**: ハイポリ形状情報をローポリテクスチャへ転写。Normal(凹凸疑似表現)・AO(陰影)・Curvature(エッジ/溝検出、汚れマスク元データ)等。色(Base Color)はベイクで作らず、ベイク結果をマスクにして別途ペイント
5. Substance Painter等で仕上げペイント

## Substance 3D Painter 2022(Steam買い切り) vs 2026版

- Steam版パーペチュアルライセンス、2026年も継続予定。買った年のバージョン+その年のアップデートのみ永続利用可、翌年以降の新機能は非対応
- Steam版の制限: `Send to`連携なし(Creative Cloud API依存のため)、Substance 3D Assetsオンラインライブラリ利用不可。ローカル標準搭載素材はSteam版でも同梱
- Blender連携("Send to")はショートカット機能のみ欠落。手動FBX/OBJエクスポートで代替可、実害小さい
- AI生成テクスチャ(Firefly)はPainterではなくSampler/Stager側の機能 → Painterアップグレードの動機にならない。ComfyUI比較は的外れ、そもそも別ツール

### 2022→2026 差分まとめ

- 8.3(2023.1) 新ベイクモード、USD対応
- 9.0(2023.6) 3Dカーブ沿いペイント
- 9.1(2023.11) SVG/透過対応
- 10.0(2024.5) レイヤースタックPython API編集
- 10.1(2024.9) 新フィルタ、USD material/shader対応
- OpenGL→Vulkan移行(2025) パフォーマンス/安定性、機能追加ではない
- 12.0(2026.3) Warp to Geometry、ポストエフェクト強化、**Reload Mesh**(リトポやり直し耐性)
- 12.1(beta) Auto-Rebaking、Hard-Surface Auto Unwrap

結論: killer feature無し、4年分の地味な積み重ね。コアパラダイム(PBRマルチチャンネルレイヤー+Smart Material)自体は2014年発売時〜2015年頃にほぼ確立済み、以降はインフラ更新と周辺機能追加のみ。個人制作用途なら2022版継続で十分、困ったら都度最新Steam版買い足しが合理的。

## Blender単体で完結できるか

技術的には可能、手間が増えるだけ:

- ベイク: Cycles Bakeパネルで Normal/AO/Curvature(Pointiness属性)等 全部焼ける
- ペイント: Texture Paintモード、チャンネルごとにImage Textureノード用意すれば多チャンネル管理可
- Smart Material相当: ノード自作が必要(既製の便利機能なし)、ここがBlender MCP+LLMでノード生成させれば大幅に労力削減できる領域

残るギャップ:

1. アセット/マテリアルライブラリの量と質
2. インタラクティブ視覚フィードバックループ(手動ペイントの反復速度、LLM経由バッチ生成では代替しづらい)
3. エンジン別エクスポートプリセット(これもスクリプト化でLLMに投げれば解決可)

## Blender用アセットライブラリ(Substance資産の代替候補)

- [Poly Haven](https://polyhaven.com/) 完全無料CC0、Asset Browser前提設計
- [BlenderKit](https://www.blenderkit.com/) 無料マテリアル/モデル/HDRI/ブラシ大量、Blender内検索
- [Poliigon](https://www.poliigon.com/blender) 7000+素材、サブスク制
- Extreme PBR Nexus 1800+素材、プレビュー付きブラウザ
- Fluent: Materializer ノードベース自作寄り、Smart Material代替に近い

注意: 上記は「素材そのもの」の配布であって、Substanceの Smart Material(メッシュのAO/曲率読んで自動汚し生成)とは別物。動的マスク生成部分は依然ノード自作(LLM支援前提)が必要。

## Substance PainterのCoding Agentからの操作

- 公式Python API: プラグイン形式でベイク・エクスポート・UI操作を自動化可能。ローカル完結機能なのでSteam版でも使用可能なはず
- Substance Automation Toolkit(SAT): バッチ処理用CLI/Pythonライブラリ、Painter本体というよりsbsarレンダリング寄り
- コミュニティ製MCPサーバー実在: PainterMCP(parodyband)、Substance Painter MCP Server(elliezu)。Python APIをソケット経由でMCPにブリッジ、起動中のPainterをAgentから操作可能。非公式なので安定性は個別プロジェクト次第
