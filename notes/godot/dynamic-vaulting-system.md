---
title: Godot 動的ヴォルティングシステム
description: RayCast3DとBezier tweenを使った任意の物体に対応するヴォルティング実装
# permalink:  # don't use
aliases:
  - dynamic-vault
  - parkour
  - raycast-vault
tags:
  - godot
  - game-mechanics
  - movement
  - parkour
draft: false
date: 2026-06-23
---

# Godot 動的ヴォルティングシステム

**参考動画：** [Build a DYNAMIC Vaulting System from SCRATCH | Godot 4 Tutorial - Rembot Games](https://www.youtube.com/watch?v=oUOC6cUjwuk)

**リソース：**
- [Free FPS Template](https://www.patreon.com/posts/148001891)
- [Project Files (Patreon)](https://www.patreon.com/posts/155654938)

## 概念

任意の物体に対して**実行時に動的に登り越すメカニクス**。事前定義ではなく、RayCast3Dで検出した地点に対してBezier曲線を使ったアニメーションで滑らかに移動させる。

ゲーム中のどんな障害物にも対応でき、空中からのキャッチやパルクール的な動きが可能になる。

## Static vs Dynamic 比較

### Static 方式（事前定義型）
- 登り可能な箇所を事前にマークする
- Portal のように特定の壁だけが登れる
- **利点：** 制御が単純、バグが少ない
- **欠点：** 不規則な地形に対応できない、実装手間が多い

### Dynamic 方式（検出型）⭐ 推奨
- RayCast3D で実行時に地点を検出
- **すべての物体に対応可能**
- ギザギザの地形、斜めの台、ランダム配置にも対応
- ゴルフカートなどの移動物体にも対応
- 空中キャッチでパルクール的な動きを実現

## 実装アーキテクチャ

### 1. RayCast3D の配置

プレイヤーの前方に設置し、接触地点を検出：

```
位置: プレイヤーから0.4m前方
高さ: 約2.25m（プレイヤーの胸部より上）
向き: 下方向
長さ: 1.5m
```

### 2. Bezier Tween アニメーション

3点間の **二次ベジェ曲線** で滑らかな運動を実現：

```
点1: 開始地点（プレイヤーの現在位置）
  ↓
点2: 中間地点（開始と目標の中点 + 上方向オフセット）
  ↓
点3: 目標地点（RayCast衝突点 + 前方オフセット）
```

**数学的な計算：**

```gd
# t: 0 → 1 のアニメーション進度
var a = start.lerp(mid, t)      # 開始から中点へ
var b = mid.lerp(end, t)        # 中点から目標へ
position = a.lerp(b, t)         # 最終位置（Bezier曲線）
```

**Tween設定：**
```gd
tween.set_ease(Tween.EASE_IN_OUT)  # イージング
tween.set_trans(Tween.TRANS_SINE)  # 正弦波補間
duration: 0.4 秒
```

### 3. Head Check（クリッピング防止）

ヴォルティング先に十分な頭上スペースがあるか確認：

```gd
var space_state = get_world_3d().direct_space_state
var query = PhysicsRayQueryParameters3D.create(
    ledge_point,
    ledge_point + Vector3(0, 2.0, 0)  # 2m上まで検査
)
query.exclude = self  # プレイヤー自身を除外
var result = space_state.intersect_ray(query)

if result:
    return false  # スペース不足 → Vault失敗
```

### 4. Jump システムとの統合

```gd
if vault_ray_cast.is_colliding():
    if do_vault(vault_ray_cast.get_collision_point()):
        return true  # Vault成功 → 通常ジャンプをスキップ
    
elif is_on_floor():
    velocity.y = jump_force  # 通常ジャンプ
```

## 実装の主要フロー

### コア変数

```gd
var is_vaulting: bool = false           # ヴォルティング中フラグ
var vault_ray_cast: RayCast3D
var vault_duration: float = 0.4         # アニメーション時間
```

### do_vault 関数の流れ

1. **フラグ設定**
   ```gd
   is_vaulting = true
   velocity = Vector3.ZERO  # 既存の速度をリセット
   ```

2. **ベジェポイント計算**
   ```gd
   var forward = -global_transform.basis.z  # 前方向
   var destination = ledge_point + forward * 0.1  # 登り先
   var start = global_position
   var mid = start.lerp(destination, 0.5) + Vector3(0, 0.5, 0)  # 山型
   ```

3. **Tween アニメーション実行**
   ```gd
   var tween = create_tween()
   tween.set_ease(Tween.EASE_IN_OUT)
   tween.set_trans(Tween.TRANS_SINE)
   tween.tween_method(bezier_move.bind(start, mid, destination), 0.0, 1.0, vault_duration)
   tween.tween_callback(func(): is_vaulting = false)
   ```

4. **Head Check**
   ```gd
   # destination に十分なスペースがあるか確認
   # → あれば return true（Vault成功）
   # → なければ return false（Vault失敗）
   ```

### Mid-Air Vaulting

`is_on_floor()` 判定を削除して実装：

```gd
if vault_ray_cast.is_colliding():
    do_vault(...)  # 地面判定なし → 空中でも登れる
elif is_on_floor():
    velocity.y = jump_force
```

**利点：**
- ジャンプ中に宙空で台をキャッチ
- 台から落下しながら再度つかむ
- パルクール的な流動的な動き

## 設計の工夫

### 1. Tween メソッドバインディング

```gd
func bezier_move(t: float, start: Vector3, mid: Vector3, end: Vector3) -> void:
    var a = start.lerp(mid, t)
    var b = mid.lerp(end, t)
    global_position = a.lerp(b, t)

# Tween内で使用
tween.tween_method(bezier_move.bind(start, mid, destination), 0.0, 1.0, duration)
```

### 2. ジャンプロジック の再構築

```gd
if input.is_action_just_pressed("jump"):
    if vault_ray_cast.is_colliding():
        if not do_vault(...):  # Vault失敗時
            pass  # 何もしない
    elif is_on_floor():
        velocity.y = jump_force  # 通常ジャンプ
```

### 3. パラメータの外部化

```gd
@export var vault_duration: float = 0.4
@export var head_check_height: float = 2.0
@export var vault_forward_offset: float = 0.1
```

## ゲームプレイの可能性

- ✅ 任意高さの障害物に対応
- ✅ 不規則な地形への自動適応
- ✅ 空中からのエッジキャッチ
- ✅ パルクール的な流動的なムーブメント
- ✅ 斜めの台にも対応
- ❌ 左右の移動は未対応（前方のみ）

## Static 方式との比較

[[vaulting-implementation]] は複数レイキャスト + 事前判定 のアプローチでしたが、このDynamic方式は：

| 項目 | Static (複数RC) | Dynamic (単一RC) |
|-----|------------|----------|
| 汎用性 | 低（設定した場所のみ） | 高（すべての物体） |
| 実装複雑度 | 中 | 低 |
| パフォーマンス | 良好 | 同等 |
| Head Check | 複数RC配列で管理 | Raycastで動的判定 |
| パルクール対応 | 限定的 | 優れている |

## トラブルシューティング

### Vault失敗後のジャンプができない
→ `do_vault()` が bool を返すようにして、失敗時のフォールバックを実装

### 地形に埋まる
→ Head Check で接触判定を追加し、スペース不足時は Vault をスキップ

### アニメーションが急峻すぎる
→ `vault_duration` や `mid` のY値（0.5）を調整

## 参考

- [[vaulting-implementation]] - Static方式のアプローチ
- Godot Tween API
- PhysicsRayQueryParameters3D
