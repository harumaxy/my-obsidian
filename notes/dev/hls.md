---
title: HTTP Live Streaming (HLS)
description: Appleが開発したビデオストリーミングプロトコル
aliases:
  - HTTP Live Streaming
tags:
  - video
  - streaming
  - protocol
  - media
draft: false
date: 2026-06-25
---

# HTTP Live Streaming (HLS)

Appleが開発したストリーミングプロトコル。iPhoneやiPad、Apple TV、macOSなどのデバイスにオーディオとビデオをHTTPを経由して配信する。

## 主な特徴

- **プラットフォーム対応**: iOS、tvOS、macOS対応
- **複数ビットレート対応**: ネットワーク速度に応じて自動調整
- **ライブ・オンデマンド対応**: ライブ放送とVOD対応
- **メディア暗号化**: コンテンツ保護とユーザー認証機能
- **動的適応**: ネットワーク帯域幅に応じてプレイバック最適化
- **スケーラビリティ**: 標準的なWebサーバーで配信可能

## HLSの3つのコンポーネント

### 1. サーバーコンポーネント（エンコード）

- ハードウェアエンコーダーが入力されたオーディオ/ビデオを処理
- HEVC（H.265）またはH.264にエンコード
- AC-3またはAACオーディオにエンコード
- フラグメント化されたMPEG-4またはMPEG-2トランスポートストリームとして出力
- ストリーム分割ソフトウェアがメディアを短いセグメントに分割
- インデックスファイル（プレイリスト）を生成・管理

### 2. 配信コンポーネント（ディストリビューション）

- WebサーバーまたはCDNがメディアとインデックスを配信
- 標準的なWebサーバー機能で対応（カスタムモジュール不要）
- HTTPプロトコルで配信

### 3. クライアントコンポーネント（再生）

- プレイヤーがインデックスファイルを取得
- メディアファイルを順序通りダウンロード
- 暗号化されたファイルは復号化
- 連続したストリームとして再生

## 対応コーデック

### ビデオコーデック

| コーデック | 対応状況 | 説明 |
|----------|---------|------|
| **H.264** (MPEG-4 AVC) | 必須・全デバイス対応 | 低帯域幅環境向け標準 |
| **H.265** (HEVC) | 推奨・Apple全般対応 | H.264の約2倍の圧縮効率、4K対応 |
| **AV1** | 対応（近年追加） | iPhone 12以降（A14 Bionic〜）、fMP4のみ |
| **VP9** | **非対応** | WebM/Google陣営向け。HLS仕様に存在しない |

#### H.264（MPEG-4 AVC）

- **MPEG-4 AVC** = Moving Picture Experts Group の Advanced Video Coding
- **MPEG-4 AVC** と **H.264** は同じコーデックの異なる呼び方
  - H.264 → ITU-T（国際電気通信連合）の標準
  - MPEG-4 AVC → ISO/IEC（国際標準化機構）の標準
- 広い互換性、低い処理負荷

#### HEVC（H.265）

- **HEVC** = High Efficiency Video Coding
- H.264の後継コーデック
- **約2倍の圧縮効率** — 同じ画質でファイルサイズは約半分
- 4K/8K映像に対応

#### AV1

- 近年HLSに追加されたコーデック
- **fMP4（.m4s）コンテナのみ対応**（.ts は非対応）
- iPhone 12以降（A14 Bionic チップ〜）でハードウェアデコード対応
- Apple が AV1 を HLS に正式サポートしたのは2021年頃

#### VP9 が非対応な理由

- VP9 は Google が WebM コンテナ向けに開発した陣営が異なるコーデック
- Apple は H.265 に投資しており VP9 採用を拒否
- HLS の MPEG-TS / fMP4 コンテナに VP9 を入れる仕様が存在しない
- VP9 を使いたい場合は **DASH（Dynamic Adaptive Streaming over HTTP）** を使う

> **DASH** とは Chrome や YouTube が採用している HLS と同様のアダプティブストリーミングプロトコル。VP9/AV1 を含む幅広いコーデックに対応している。

### オーディオコーデック

| コーデック | 説明 |
|----------|------|
| **AAC** | Advanced Audio Coding — 標準的で広い互換性 |
| **AC-3** | Dolby Digital — サラウンドサウンド対応 |

## Appleサポートフレームワーク

- **AVKit** — ビデオ再生UI
- **AVFoundation** — 低レベルのメディア制御
- **WebKit** — Webブラウザでの再生

サポート歴史: iOS 3.0以降、Safari 4.0以降で標準対応

## クライアント実装のポイント

1. インデックスファイル（プレイリスト）をURLから取得
2. 利用可能なメディアファイルとビットレートを取得
3. 暗号化キーを取得・復号化処理を実装
4. ユーザー認証に対応
5. メディアファイルをシーケンスでダウンロード
6. 十分なデータがバッファされたら再生開始
7. **EXT-X-ENDLISTタグ** が出現するまで続行
   - ライブの場合はタグなしで周期的にプレイリスト更新

## 低遅延HLS（LL-HLS）

- リアルタイムストリーミング向けの遅延削減技術
- スケーラビリティを維持しながら低遅延を実現

## アダプティブビットレート（ABR）

HLS の核心機能。ネットワーク速度に応じて解像度・ビットレートを自動切り替えする。

解像度とビットレートはほぼセットで変わる：

```
360p  →  800 kbps
720p  →  2 Mbps
1080p →  5 Mbps
4K    → 15〜25 Mbps
```

プレイヤーはネットワーク速度を常に監視し、ダウンロードが追いつく中で一番高画質なストリームを自動選択する：

```
Wi-Fi 良好  → 1080p を選択
4G 中程度   → 720p に切り替え
トンネル内  → 360p に落とす
Wi-Fi 復帰  → また 1080p に戻す
```

YouTube・Netflix がバッファなくスムーズに再生できるのもこの仕組み。

マスタープレイリスト（.m3u8）にビットレート別のストリームURLが列挙されており、プレイヤーがその中から適切なものを選んでメディアプレイリストを取得する。

## ファイルフォーマット

### プレイリストファイル

#### .m3u8（M3U Playlist）

- **M3U** = "MPEG Audio Layer III Uniform Resource Locator"
- **.m3u8** = UTF-8版のM3U形式
- **テキストファイル** — メディアセグメントへのパスと再生順序が記録される
- プレイヤーがまずこれを取得して、再生すべきメディアファイルのリストを確認する

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXTINF:9.9,
segment-0.ts
#EXTINF:9.9,
segment-1.ts
#EXT-X-ENDLIST
```

### メディアセグメント

| 拡張子 | 正式名 | 説明 |
|--------|--------|------|
| **.ts** | MPEG Transport Stream | ビデオ・オーディオデータ（従来形式） |
| **.fmp4** / **.m4s** | Fragmented MP4 | MP4形式のメディアセグメント（最新推奨） |
| **.aac** | AAC Audio | オーディオのみセグメント |
| **.ac3** | Dolby Digital | AC-3オーディオセグメント |

### その他

| 拡張子 | 説明 |
|--------|------|
| **.key** | 暗号化キーファイル |

## m3u8 フォーマット詳細

### 2種類のプレイリスト

#### マスタープレイリスト（Multivariant Playlist）

プレイヤーが最初に取得するファイル。ビットレート別のメディアプレイリストURLを列挙する。

```m3u8
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=640x360,CODECS="avc1.42c01e,mp4a.40.2"
360p.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,CODECS="avc1.42c01e,mp4a.40.2"
720p.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=5000000,RESOLUTION=1920x1080,CODECS="hvc1.1.6.L123.00,mp4a.40.2"
1080p-hevc.m3u8
```

#### メディアプレイリスト（Media Playlist）

実際のセグメントURLが書かれているファイル。

```m3u8
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXT-X-MEDIA-SEQUENCE:0

#EXT-X-KEY:METHOD=AES-128,URI="https://example.com/key",IV=0x00000000000000000000000000000001

#EXTINF:9.9,
segment-0.ts
#EXTINF:9.9,
segment-1.ts
#EXTINF:8.3,
segment-2.ts

#EXT-X-ENDLIST
```

### タグ一覧

| タグ | 意味 |
|-----|------|
| `#EXTM3U` | ファイルヘッダー。拡張M3U形式の宣言 |
| `#EXT-X-VERSION` | HLSプロトコルのバージョン番号 |
| `#EXT-X-TARGETDURATION` | セグメントの最大長（秒）。全セグメントはこれ以下 |
| `#EXT-X-MEDIA-SEQUENCE` | 最初のセグメントのシーケンス番号。ライブでは増加する |
| `#EXT-X-KEY` | 暗号化方式・キーURL・IV（初期化ベクター） |
| `#EXT-X-STREAM-INF` | 続く行のURLが指すバリアントストリームの情報 |
| `#EXTINF` | 次の行のセグメントの再生時間（秒） |
| `#EXT-X-ENDLIST` | VODの終端マーカー。**これがないとライブとして扱われる** |

### ライブとVODの違い

| 特徴 | VOD | ライブ |
|------|-----|--------|
| `#EXT-X-ENDLIST` | あり | なし |
| プレイヤーの動作 | 一度取得して終了 | 定期的にm3u8を再取得 |
| `#EXT-X-MEDIA-SEQUENCE` | 常に0 | セグメントが追加されるごとに増加 |

### CODECSの文字列（RFC 6381形式）

| 値 | コーデック |
|----|----------|
| `avc1.xxxxx` | H.264 |
| `hvc1.xxxxx` | H.265 (HEVC) |
| `av01.xxxxx` | AV1 |
| `mp4a.40.2` | AAC |
| `ac-3` | AC-3 (Dolby Digital) |

## HLS配信の流れ

1. プレイヤーが **マスタープレイリスト（.m3u8）** を取得
2. ネットワーク速度に合ったビットレートの **メディアプレイリスト（.m3u8）** を選択
3. リスト内の **.ts** または **.fmp4** をシーケンスでダウンロード
4. 暗号化されている場合、**.key** で復号化
5. 順序通りに再生

## 参考リンク

- [Apple HLS Developer Documentation](https://developer.apple.com/documentation/http-live-streaming)
- HLS authoring specification for Apple devices
- Low-Latency HLS documentation
