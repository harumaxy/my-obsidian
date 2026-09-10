---
title: NVIDIA Kimodo - 人型モーション生成モデル
source: https://github.com/nv-tlabs/kimodo
date: 2026-09-09
---

# NVIDIA Kimodo

拡散ベース モーション生成モデル。テキスト+運動学的制約 → 3D人間/ロボットモーション生成。

## 概要

- 学習データ 700時間 商用モーキャプ（非公開、コードのみOSS）
- 対応スケルトン: SOMA / Unitree G1(ロボット) / SMPL-X
- 制御: フルボディキーフレーム、エンドエフェクタ位置、2D経路、2Dウェイポイント
- 生成時間 2〜5秒、10秒尺上限
- VRAM 17GB（CPU設定で3GB未満まで軽量化可）
- 2026年3月 NVIDIA Toronto AI Lab リリース

## 実用性

強み:
- RTX3090クラスで動作
- Webタイムラインデモ→キーフレーム打たず動作生成
- ダンス/日常動作/戦闘等バリエーション豊富

弱み:
- 力学(トルク)未考慮 → 物理破綻ポーズ混入リスク
- 10秒上限 → 長尺タスク不可
- 非リアルタイム → インタラクティブ制御向かない
- 学習データ非公開 → 独自再学習不可

総評: プロトタイプ/叩き台生成向け。本番品質フル自動には向かず、後処理前提。ロボティクス文脈が本流、ゲーム/映像は副次用途。

## Blender + Auto Rig Pro リマップ手順(SMPL-X経由)

1. Kimodo生成: `--skeleton smplx` でAMASS npz出力
2. Blender: SMPL-X Blender Add-on導入、AMASS sequence loaderでnpz読込 → SMPL-Xリグ+アニメ生成
3. Auto Rig Pro Remap: Source=SMPL-Xリグ、Target=自キャラARPリグ。プリセット無し→手動ボーンマッピング(pelvis/spine/arm/leg)
4. 調整:
   - `foot_contacts`配列参照→接地タイミング特定→IK footロックで滑り修正
   - ルートモーションずれ再調整
   - 複数クリップ繋ぐ場合NLAブレンド、つなぎ目手動補正
5. 仕上げ: smooth keys、指/表情は生成対象外なので別途手付け

懸念: SMPL-Xとキャラ体型差(腕長さ等)大きいとRemap後ポーズ崩れ→目視修正ほぼ必須。G1/MuJoCo系はロボット制御用でBlender用途外。

## 出典

- [GitHub](https://github.com/nv-tlabs/kimodo)
- [The Code Is Open. The Data Isn't.](https://blog.pebblous.ai/blog/kimodo-text-to-motion/en/)
- [Riding the Wave](https://akmaier.substack.com/p/riding-the-wave-how-nvidias-kimodo)
