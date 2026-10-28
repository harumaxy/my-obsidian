# macOS で DRM 画面をスクショする

Netflix 等の DRM 保護画面は、macOS のウィンドウサーバーレベルでキャプチャAPIをブロックする。`screencapture`、OBS、ffmpeg などすべて同一APIを通るため、通常は黒塗りになる。

## 解決策: ブラウザのハードウェアアクセラレーションを切る

ハードウェアアクセラレーションを無効にすると、動画がソフトウェアレンダリングになりウィンドウにDRMフラグが付かない。これで `screencapture` 等の標準ツールで撮れる。

### Chrome

```
設定 → システム → 「ハードウェアアクセラレーションが使用可能な場合は使用する」→ OFF → 再起動
```

またはフラグ付き起動（普段遣いはそのままGPU有効でOK）:

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --disable-gpu
```

### Firefox

```
about:config → gfx.webrender.all → false
           → layers.acceleration.disabled → true
```

## ハードウェアアクセラレーション無効の副作用

- スクロール・アニメーションがカクつく
- バッテリー消費が増える
- 4K動画再生が重い

→ 普段遣いはGPU有効のまま、DRM画面を撮る時だけオフにする

## OBS CLI スクショ (`obs-shot`)

OBS WebSocket 経由で CLI からスクショを撮るスクリプト。`~/bin/obs-shot` に設置済み。

```bash
# OBS起動（最小化）
open -a OBS --args --minimized-to-tray

# ソース一覧確認
obs-shot --list

# スクショ撮影
obs-shot                          # デフォルトパスに保存
obs-shot "ソース名" output.png    # ソース名・パス指定
```

**注意**: macOS版OBSもウィンドウサーバーAPIを通るため、DRM画面は黒になる。OBSのDRM回避は Windows の Game Capture (DXGI) のみ対応。

## 参考情報

- macOSのDRMは `kCGWindowLayer` でウィンドウに保護フラグを付ける
- すべての標準キャプチャAPI（CoreGraphics, AVFoundation）がこのフラグを尊重
- WindowsのOBS Game Captureのみ、DXGI Desktop Duplication APIで下位フレームバッファを直接読むためDRMを回避可能
