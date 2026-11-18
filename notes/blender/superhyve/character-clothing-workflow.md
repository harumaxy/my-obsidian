---
title: キャラ土台と服の方針 (ゲーム用)
description: 自作 Hero・ゾンビ・モブ量産向けの土台と服の選定メモ。AutoCharacters 寄り、既製の服を改変、Blender 完結
# permalink:  # don't use
aliases:
  - character-clothing-workflow
tags:
  - blender
  - superhive
  - character
  - clothing
  - gamedev
draft: false
date: 2026-11-18
---

# キャラ土台と服の方針 (ゲーム用)

親: [[superhive-blender-gamedev-tools]]

調査日 2026-11-18。ページ記載ベース。動作検証なし。推測は明記。

## 前提・好み

- アニメ・トゥーン調、または特徴を減らした無個性寄りのデザイン。西洋リアル調は好みでない。
- 用途: ①自作 Hero (SF、メカ・武器のインプラント、表情・服・アタッチメント) ②ゾンビ・人型クリーチャー (腐肉をシェーダー/テクスチャで) ③モブ・NPC 量産。
- ソフトの往復は避ける。量産の速度が落ちる。Blender 内で完結させる。
- 既製の服で十分。必要なら少し編集して改変する。

## 土台の結論

- **本命: [[autocharacters]]** (Complete)。
  - 無表情・無個性寄りの土台。上から味付けしやすい (ユーザー所感)。
  - 体型プリセットにスタイライズ6種、アニメヘアあり。トゥーン適性はギャラリーで要確認。
  - 衣装 168 着、体型追従 morph、リグ、ポーズ、ランダム化 (ロック・シード・JSON)。
  - ゲームは Commercial 必須。素材の再配布不可、ゲーム内抽出対策が必要。
- 外す:
  - [[eden-character-studio]]: 顔が個性的 (西洋寄り) で、土台向きでない (ユーザー所感)。Wrap 目的なら再検討。
  - [[human-generator]]: リアル写実。スタイライズ志向と逆。顔リグ・ARKit が要るときだけ。
  - [[infinity-style-bundle]]: モデル集。機能なし。
- 異形・クリーチャー: [[autocreatures]] (Blender 5.2 限定、新規で実績なし。様子見)。

## 用途別の流れ

### 自作 Hero (SF)

1. AutoCharacters で体型・髪・服を決める。
2. メカ・武器・インプラントは別オブジェクトで作る。AI 生成 ([[bizen3d]] / [[image-to-3d-milad]]) → [[smart-remesh]] ハードサーフェス、または手モデリング。
3. 体に溶接せず、ボーンに親子付け。変形する部分は [[adaptive-auto-skinning]] / VHD でウェイト。
4. 表情: AutoCharacters に顔リグの記載なし。シェイプキーを自作 (要確認)。作者にメッセージ可。

### ゾンビ・人型クリーチャー

- 体型・ポーズ・リグは土台、腐肉は**テクスチャ/シェーダー差し替え**。
- 傷・欠損のジオメトリはディスプレイスメント (Cycles) かノーマルマップ。ゲーム向けはノーマルに焼く。
- 異形 (腕が多い、翼) は AutoCreatures。

### モブ・NPC 量産

- AutoCharacters のランダム化 (ロック・シード・JSON プリセット) + 既製の服 + 髪で多様化。
- 色・柄違いは共有マテリアルで一括。
- 量産前に 1 体で、リグを ARP 化するか同梱リグのままかを確定。
- 敵のモブ: [[rigmend]] Lite で自動リグ、または AutoCreatures。
- 後工程: LOD、マテリアル統合 (アトラス化)、体の見えない部分の削除。

## 服の方針

- 優先順位: **既製 → 既製を改変 → 自作**。最初から自作に行かない。
- AutoCharacters の服: 体型 morph + リグウェイトで追従。布シミュではない。貫通は服の Basis シェイプキーを Edit Mode で手直し。作業順は 体型 → 服 → ポーズ → 微調整。アニメ付け後の体型変更は不可。
- 既製を改変する場合: 複製した服を Edit Mode で編集 (SF 風の継ぎ目、装飾)。シェイプキーを壊さない範囲で。
- 自作の服 (必要時):
  - 柔らかい服: [[simply-cloth]] (所持済み) で型紙 → 縫製 → ベイク。同じ Blender 内で完結。
  - 硬い服・SF アーマー: 手モデリング (体を複製して Shrinkwrap など)。
  - 同一リグに親子付け + ウェイト転写 (VHD / [[adaptive-auto-skinning]] / Voxel Weight Transfer)。
  - 体型 morph に追従させるには服側にもシェイプキーが必要 (Blender 一般の仕組み)。
  - AutoCharacters の自作アセット取り込みは v3.1 予定 (現状なし)。
- Marvelous Designer は使わない方針。理由: ソフト往復で量産が遅くなる、ゲーム用は結局リトポ・ベイクが要る。
- 一般の主流 (参考): リアル・映像は MD / CLO、スタイライズ・ゲームは Blender 手モデリング + スキニング転写。

## 次に確認すること

1. AutoCharacters の衣装カタログ (商品ページ内) で SF・ゲーム向きの服の有無、各服のトライアングル数。
2. アニメ・トゥーン調に合う顔・体か (ギャラリー・Gumroad・YouTube)。
3. 同梱リグと ARP の相性 (再リグか、そのままか)。
4. 表情のシェイプキー・顔リグの有無 (作者に質問)。
5. 買い方: Base Commercial で試し、Complete へ $15 クーポンでアップグレードする手 (クーポンは期限あり)。

## 関連

- [[comparison-game-pipeline]] (リグ・ウェイト・モーション)
- [[simply-cloth]]
