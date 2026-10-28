---
title: きゃらくる(Charakuru) 技術メモ
description: 1枚絵から VRM を作る AI エージェント駆動キット。構成・Tripo 操作・Blender 後処理・自作時の参考点
# permalink:  # don't use
aliases:
  - Charakuru
tags:
  - 3d
  - tripo
  - blender
  - ai-agent
draft: false
date: 2026-10-28
---

## 何これ

- イラスト1枚 → VRM アバター 作るキット。作者 Nano 氏。GitHub `nanocle/Charakuru`。Tripo 公式スポンサー付き(公式ツールではない)
- 元記事: https://gigazine.net/news/20261020-charakuru/
- 本体は GitHub の clone ではなく Releases の zip。clone は docs のみ
- 実体 = Codex 用の自己完結ワークスペース。`AGENTS.md` + `skills/`(10個) + `scripts/` + ローカル Web UI。プラグインではなくフォルダ丸ごと配布

## 構成

- Electron なし。npm 依存ゼロ。Node 22+ の素の http サーバー(`server*.mjs` 523行) が `127.0.0.1:8766`
- フロント = 素の ES modules SPA。three.js r170 + three-vrm 同梱。3D 編集はしない、確認ビューアのみ
- 状態は `project.charakit` 1ファイル。API は `/api/session/*`(start, save, progress, complete, fail 等)
- 使い方: Codex でフォルダ開く → エージェントが `npm start` → Chrome で開く。画面で「次へ」→ 依頼文コピー → Codex チャットに貼る → エージェント作業 → `complete` でアプリ再読込
- 判断の質問(分離できない部位など)は **チャット** で来る。アプリに質問 UI なし

## Tripo は API ではなくブラウザ操作

- Tripo API キー不使用。Tripo Studio を Codex の Chrome 拡張 / Computer Use で操作
- Playwright / Puppeteer 等は不使用(grep 0件)。操作はエージェント任せ、手順書は「UI は変わる」前提
- 決定的コードは Export 後のファイル受け取り検査のみ(`receive.mjs`: サイズ安定・FBX ヘッダー・SHA256)
- 指定値: Smart Mesh P2.0 / 四角面 / 25,000面 / 生成数4 / マルチビュー4方向、再テクスチャ 4K 固定、Smart UV 先行

## 工程

1. 元絵 → 部位画像8枚(頭=髪込み4方向、体=Tポーズ4方向)、画像生成
2. Tripo で頭・体を別々に候補4つ生成 → ユーザーが選ぶ
3. 三角化 GLB を Tripo で粗くセグメンテーション → ローカルで連結成分列挙(Union-Find) → エージェントが目視で5分類(髪/頭/上半身/下半身/アクセ)
4. グループ毎に前後ワイヤーガイド + 参照画像を画像生成(×N) → Tripo で Smart UV → 4K 再テクスチャ(×N)
5. `restore_uv`: 返却 UV/材質を **元の基準メッシュ** へ座標一致で移植。トポロジー変化は失敗扱い。MToon 化
6. ユーザーが頭身調整 → Tripo リグ(骨配置のみ採用) → Blender で素体からウェイト転送 → 揺れ骨 → VRM 出力 → 物理 ON/OFF 90フレーム比較で機械検査

## ウェイト転送(参考になる所)

- 同梱 `weighted-body.blend`(ウェイト付き素体) を対象キャラの体型へ変形(`fit`) → `BVHTree` 最近傍三角形の重心補間で写す(`transfer`)
- fit: 骨名別名辞書(Mixamo/VRoid 等)でランドマーク対応 → hips/首/head の3点エルミート補間で胴体、四肢は骨毎の回転+長さ補正
- 上位4影響に絞って再正規化。素体から 5cm 超の頂点数をレポート。誤転送しやすい: 脇・股・指・衣装離れ部分
- Tripo のウェイトは捨てる。骨=Tripo、ウェイト=素体
- メリット: 作り込み済み品質を継承、汚い AI メッシュ・離れた部品に強い、全キャラ同じ動き、ヘッドレス自動化。弱点: 体型が違うと破綻、ゆるい衣装は別扱い必須
- 素体はライセンス上 **持ち出し・再利用禁止**(ローカルのフィット/転送専用)。アルゴリズムだけ参考にし、素体は自前

## 注意点

- **規約**: Tripo 規約(2025-07-11) 3.1/3.2/3.3(e) に「自動ツールでのデータ抽出・scrape 禁止」。明示的許可の例外あり。エージェントの Export が該当するか **グレー**。サブスク停止は返金なし(10.3)。使う前に support@tripo3d.ai か Discord で確認が安全
- 有料ユーザーのみ出力の広い権利あり(5.2)。ゲーム商用は有料必須
- クレジット: 候補生成から消費。回数/金額上限・残高確認の仕組みなし(手順書の文言のみ)。工程毎の再承認もしない
- プロンプトインジェクション: 対策は AGENTS.md の一文のみ。ログイン済み実ブラウザを使う設計なのでリスクあり。専用アカウント・信頼できる元絵が無難
- きゃらくる自身のライセンス: 私的改変・コピー OK、再配布/組込みは要連絡、同梱アセット単体持ち出し禁止、年商 or 調達額 1億円以上は別契約

## 自作(ゲームアセット)へ流用するなら

- 流用しやすい: 連結成分の分離、`restore_uv` 方式(形状固定で UV/テクスチャだけ差し替え)、背面 Blender 実行(`--background --factory-startup --python-exit-code 1`)、Export 後の実ファイル検査、チェックポイント停止設計
- キャラ専用で不要: VRM / MToon / SpringBone / 5分類
- Web UI は不要かも。Blender の `look` + チャット承認で足りる
- Claude Code 化: Codex 固有部分は画像生成とブラウザ操作のみ。ブラウザ=Claude in Chrome、画像生成=ComfyUI 等を足す
- ARP 構想: 共通スケルトン + 完璧スキニング素体を1つ作る → 量産時は ARP は骨配置のみ、ウェイトは素体から転送。骨名が一致するので対応辞書不要。体型別に素体を数種、転送後スムージング、極端ポーズの自動検証が要る(ARP の API/自動化可否は未検証)
- 頭と体の別生成: 頭に面数・テクスチャ予算を寄せる考えは Tripo 公式チュートリアル(Head Extraction)と整合。顔が弱点になりやすいのも一般的な知見。ただし別生成→結合を直接説明する資料は見つからず、学習データの影響は不明

## MToon と Godot

- MToon = VRM 標準のトゥーンシェーダー(`VRMC_materials_mtoon`)。2階調の影(Lit/Shade)、リムライト、MatCap、アウトライン、発光、UVアニメ、透過。PBR と違い物理無視、立ち絵の見た目優先
- きゃらくるは Tripo の PBR 材質を `mtoon-export.py` で全メッシュ MToon 化。完成検査も PBR 残りを拒否
- Godot で再現可(公式ドキュメント確認済み):
  - 2階調影: `light()` で `dot(NORMAL, LIGHT)` を `step`/`smoothstep`、`DIFFUSE_LIGHT` へ `+=`。簡易版は `render_mode diffuse_toon, specular_toon;`
  - リム: `RIM`/`RIM_TINT` か、法線×視線のフレネル自前計算
  - アウトライン: 反転ハル。`next_pass` に `cull_front` マテリアル、頂点を法線方向に押し出し。角が硬いメッシュは隙間が出る
  - MatCap: ビュー空間法線で sampler を引く
- 注意: `light()` は vertex_lighting / Force Vertex Shading(モバイル既定ON)だと動かない。`next_pass` の描画順は保証されない
- 方針案: ゲーム用は Blender 側を PBR のまま出し、Godot 側でトゥーン化が手間少。VRM をそのまま使うなら Godot 用 VRM アドオンの MToon 対応状況を要調査(未確認)
