---
title: 絵心無しVTuber制作 手札調査(ComfyUI+Blender)
date: 2026-09-10
---

# 絵心無しVTuber制作 手札調査(ComfyUI+Blender)

前提: 絵下手、ComfyUI/Blender触れる。プロの手法調べ→現実解探し。

## プロの実態

大半 分業。絵師とモデラー(Live2Dリガー/3Dモデラー)別人。個人勢は外注主流。

## ルート2択

### 3D派(推奨、手札にフィット)

1. VRoid Studio でベースモデル作成(パーツ組合せ、絵心不要、無料)
2. Booth で追加衣装・髪・小物調達(標準パーツ有限問題の解決策)
3. テクスチャ直塗りでカスタム(UV展開PNGエクスポート→編集→再インポート)
4. Blender で改造(VRM Add-on for Blender使用、服メッシュ追加/変形、アクセサリ追加)
5. VRM出力

弱点: 体型基本アニメ体型固定、顔骨格はスライダー範囲内で似る→衣装/髪/色で差別化。

### 2D派(Live2D)

絵必須級。外注が現実的(絵師依頼→Live2Dリガー分割・リギング依頼、または自分でCubism)。

## ComfyUI の使いどころ・限界

- レイヤー分割PSD自動生成は不可能(ネイティブ機能無し)
- SAM系ノード(`ComfyUI-Impact-Pack`, `comfyui_segment_anything`)で疑似自動分割可能だが精度微妙、境界ガタつき・隠れ部分破綻
- 実務向き: パーツ別inpaint生成でLive2D差分(まばたき/口パク)作成
- 現実解: ComfyUIでベース絵/差分生成→人力でレイヤー分け・加筆(ハイブリッド)

## 画像編集ツール

Adobe税回避: **Krita**(無料、PSD互換、レイヤー編集最強格)一本で足りる。Clip Studio Paintは有料だがペン入れ重視ならアリ。

## 配信ツール(Windows前提)

3D(VRM)モデル用:
- **VSeeFace** — デファクト標準。無料・軽量・トラッキング精度良、個人勢3D多数派
- **VNyan** — 後発、OSC/Web連携等拡張性高い。ユーザー数はVSeeFaceがまだ多い

2D(Live2D)モデル用:
- **VTube Studio** — デファクト標準。Mac版もあり

Mac単体運用時の代替(参考): VTube Studio(Live2D、Mac対応)、Animaze(VRM対応サブスク課金)、Wakaru(VRM、ブラウザベース、Mac動作報告あり要検証)。

## Live2D Cubism Editor 費用

基本無料。Free版: 個人利用ほぼ無料、商用でも直近1年売上一定額(数万ドル規模)以下なら無償枠。モデリング機能自体Freeでほぼフル。投げ銭/スパチャ程度の個人勢なら当面Free版で足りる。稼げてきたらPro版(買い切り/サブスク)検討。

## 結論

3D(VRoid+Blender)ルートが手札に一番フィット。ComfyUIはテクスチャ/差分生成補助として使い、レイヤー分割は人力前提で組む。
