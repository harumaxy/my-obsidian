---
title: ゲーム用 AI 3D パイプライン比較 (Superhive)
description: 生成・リトポ・UV・リグ・モーションを横断比較。ARP + VHD 持ち前提の使い分け、口コミ調査メモ付き
# permalink:  # don't use
aliases:
  - comparison-game-pipeline
tags:
  - blender
  - superhive
  - gamedev
  - comparison
draft: false
date: 2026-11-18
---

# ゲーム用 AI 3D パイプライン比較 (Superhive)

親: [[superhive-blender-gamedev-tools]]

調査日 2026-11-18。ページ記載ベース。動作検証なし。

## 前提

- 画像 → 3D の出力はどれも「出発点」。ゲーム用のトポロジー・フロー・UV は後工程が必要。
- Blender MCP は、アドオンのオペレーターを bpy で呼べるなら原理的に何でも叩ける。ただし各アドオンが bpy から呼べる設計かはページから不明。購入後に実機確認。

## 画像 → 3D 生成の比較

### トポロジー

- [[bizen3d]]: クアッドリメッシュ (既定1万、指定可) + ベイク 1本。最強。
- [[genmesh]]: クアッドリメッシュ + 三角形予算。エッジループ保証なし。
- [[image-to-3d-milad]]: 面数指定のみ。リトポなし → [[smart-remesh]] 併用前提。
- [[image-to-3d-local-zeg]]: 記載なし。

### UV

- 4製品とも docs に UV 記載なし。自動生成の質は不明。
- Bizen3D はリメッシュ後ベイクなので UV 新規作成のはず (推測)。
- [[auto-unwrap]] で制御可能。

### テクスチャ

- Image to 3D (Milad): 4K、Enhance Texture、Multi View。最強。
- Bizen3D: Pixel Match、Real-ESRGAN 2倍、最大 4096。
- GenMesh: PBR + 512〜4K アトラスベイク。
- ZEG: 最大 2048、斑点報告あり。

### カスタマイズ性

- AI 生成は全部1体物向き。着せ替え・体型変更前提のプレイヤーキャラは不向き。
- カスタマイズ可能キャラ → パラメトリック系 (AutoCharacters、Eden + Wrap)。AI は服・小物・武器に。

### Blender MCP

- 明示サポートは GenMesh のみ (Claude Desktop / Codex / Antigravity。Claude Code 記載なし)。
- GenMesh の MCP は構造化モデリング。画像生成とは別物。
- 他は記載なし。今の Blender MCP に `generate_3d` あり。ローカル系は後処理担当が現実的。

## 用途別の見立て

- 敵・メカ・人形 (1体物): Bizen3D 本命。Hunyuan 欲しいなら Image to 3D (Milad) 追加。
- プレイヤーキャラ: AI 生成 + ARP (持ち)。顔リグはどれも無し (AAS の顔は ARP 限定)。
- カスタマイズ可能キャラ: パラメトリック系 + Voxel Weight Transfer で衣装差し替え。
- 量産モブ: AI 生成 → [[rigmend]] で自動リグ → [[instant-rigger-and-animator]] のクリップ等。

## 後処理の原理 (docs で裏取り)

- [[smart-remesh]] 有機: Instant Meshes 同梱 (向きフィールド系)。Windows 実行ファイル。
- [[smart-remesh]] ハードサーフェス: 純 Python。全頂点が元の頂点で、表面を動かさない。
- [[mk-smart-segment]]: 厚み + 凹みの解析を1回、以降スライダーは即時。境界をクリースに吸着。
- [[auto-unwrap]]: 学習済みシーム配置 + OptCuts ベースの展開と記載。最後に Blender 標準パッカー。
- 含意
  - ハードサーフェスは法線がきれいな前提。AI 生成のうねりは n-gon 化を阻む (Merge Shells / 法線修正はその対策)。
  - 向きフィールド系は閉じた多様体が前提。薄板・重なりに弱い (推測)。
  - キャラの関節ループは自動手法では意図的に作られない。

## 口コミ調査メモ

- Reddit / X の製品単体口コミは検索でヒットせず。Superhive Ratings が唯一の実レビュー源。
- 一般論: TRELLIS.2 出力は高ポリ・三角形主体。ゲーム用はリトポ + LOD + UV 確認が定番 (Godot フォーラム等)。
- 変形するヒーローキャラは手作業リトポ推奨 (QuadriFlow 系自動リトポの限界)。

## リグ・ウェイト: ARP + VHD 持ちの使い分け

- 持ち: Auto-Rig Pro (リグ)、Voxel Heat Diffuse Skinning (スキン)
- [[rigmend]] が ARP と重複: 人型リグ生成、Unity / Unreal / Godot 出力、Mixamo アニメ適用
- [[rigmend]] が残す価値: 敵・モブ量産 (マーカー調整なし・一括)、使い捨てプロトタイプ、AI 生成品質の検証
- [[adaptive-auto-skinning]] が VHD より効く場面: 指、顔 (ARP)、体 + 服 + 小物の一括、AI の乱れたメッシュ、速度
- [[adaptive-auto-skinning]] が不要な場面: きれいな手作りメッシュで指・顔を気にしない
- 方針案
  - 主力キャラ: ARP でリグ + AAS で再ウェイト
  - 敵・モブ・小物: Bizen3D / Image to 3D → RigMend で自動リグ
  - 非人型・メカ: ARP の他機能、静的プロップ、パーツ別動き
- 検証順: ①同じ AI メッシュで ARP + VHD → ②RigMend Lite → ③不満が出たら AAS
- 注: ARP の機能は既存知識ベース (ページ未確認)。購入前に実機で確認

## モーション: TL;DR と使い分け

### TL;DR (方針)

- 前提: ARP 対応が必須。**手直しする前提**で、ゼロから手付けする手間を減らす。
- **自分が演じられる動き** → [[motiongen]] (自撮り)。コントロール性が高い。ARP 対応済み (v2.7.5 以降)。
- **演じられない動き / 量産したい動き** → [[blaze-puppeteer]] / [[kimodo-blender-bridge]] (text-to-motion)。
- 組み合わせ: 自撮りで骨格を取り、足りない箇所を Blaze の Inbetweening でつなぐ。
- 3D アニメは「ストップモーションのように手間が多い」ので、AI / 自撮りで「土台」を作って手直しで仕上げる流れが効く。
- 試す順: ①Kimodo Bridge (無料、v1.5.7+) ②MotionGen Lite ($1) ③制御が足りなければ Blaze。
- 未確認: MotionGen の ARP リターゲットが IK/FK コントローラに乗るか (公式未記載。Lite で実機確認 or 作者に質問)。Kimodo の商用ライセンス。

### 設計の噛み合い

- [[blaze-puppeteer]]: ARP 専用プリセット、リターゲット不要で直接書き込み。最も噛み合う。
- [[motiongen]]: ARP リターゲット実績あり (レビューで確認)。動画から取る。IK Controller / Foot Lock / Motion Layer 内蔵。
- [[kimodo-blender-bridge]]: 無料。Mixamo 系 Auto-Match + ベイク。ARP への効き具合は情報なし。
- [[instant-rigger-and-animator]]: 自前スケルトン前提。ARP と競合。

### 手直しフロー (AI / 動画由来のモーション共通)

AI 生成は「質の低いモーキャプ生データ」と同じ扱いにする。Blender 標準機能と ARP の挙動は既存知識 (ページ未確認)。

1. 取り込み: Blaze はコントローラに直接書く。Kimodo Bridge は SOMA に生成 → Auto-Match → Child Of 等で拘束 → ベイクして拘束を外す。MotionGen は専用リグ → リターゲット。
2. キー間引き (編集可能にする): Blaze の Unbaking、MotionGen の Reduce Keyframes / Jitter Cleanup。Kimodo Bridge には機能なし → Graph Editor の Clean Channels / Decimate。
3. 足の接地: Blaze / MotionGen の Foot Lock。残りは ARP の IK 足で接地フレームを固定。貫通は目視で修正。
4. ルートモーション: Blaze の Root Extraction、MotionGen の InPlace。エンジン側の仕様に合わせる。
5. ループ: 始点・終点を一致 (開始・終了アンカーを同じポーズに)。Graph Editor の Cycles モディファイア + 境界ブレンド。Blaze の Loop はクラウド (クレジット制)。
6. 非破壊補正: AI 由来のアクションは触らず、補正は別アクションの NLA レイヤー (Combine) に載せる。MotionGen の Motion Layer / Influence、Instant Rigger の Animation Corrections も同じ発想。
7. 指・細部: 指は手でキー (Blaze は生成しない、MotionGen は取れない)。重さ・予備動作の味付けは手作業。
8. 書き出し: ARP の書き出しでエンジン用スケルトンへ。

### 使い分けの目安

- 向く: アイドル、エモート、NPC の一場面、カットシーン、ブロッキング。
- 主力キャラのフレーム精度が命の動き (攻撃・ジャンプ・歩き走りループ) は、AI / 自撮りを土台にして手で詰める。
- 目安: 数時間かかっていたキーポーズが、生成で30分ほどの土台になり、残りは手直し (Blaze のレビュー)。
- 最初に1本だけ「AI / 自撮り + 手直し」と「手付け」の所要時間を測る。

### 商用前の確認

- Kimodo モデル自体の商用ライセンスは未確認 (保留中)。
- MotionGen は Pro ($29) 以上が商用可。使用ライブラリのライセンスは作者に確認が安全。

## 画像 → リグ付きの検証パイプライン案

Bizen3D / Image to 3D → (Smart Remesh) → (Auto Unwrap) → RigMend Lite → 弱点を Adaptive Auto Skinning で再ウェイト → Blaze Puppeteer / MotionGen でモーション。
