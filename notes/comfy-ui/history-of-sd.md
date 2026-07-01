https://romptn.com/article/55076

主に対応解像度、アーキテクチャで分類

- Stable Diffusion
  - 1.x : 512x512、最も枯れている、SD1.5が最新
  - 2.0/2.1: 768x768に最適化。普及せず
  - XL : 1024 x 1024, テキストエンコーダー2つで性能向上
  - 3 : 新しいアーキテクチャ
  - 3.5: 3の改良版

各バージョンに互換性はない

## MMDiT
Multi-Modal Diffusion Transformer

DiT はトランスフォーマーを画像生成の文脈で使う
分割されたパッチで構成された画像を、トランスフォーマーで推論

Multi Modal とは？
画像とテキスト2つのTransformer が並列、Attention で共通情報を共有
(text embeddings, image embeddings -> Attention を joint)

テキスト理解、スペリング能力の向上 = 画像内の文字が正確になる


## SD3 のバージョン

　Medium, Large, Ultra があるが、一般公開されてるのは Medium だけ。
Medium は Stability AI によって、コミュニティ期待を満たすものでないとして改善して SD 3.5 を公開。



## SD3.5

MMDiT-X を採用
MMDiT の改良版

SD3.5 にも Large, Large Turbo, Medium とバージョンがあるが
これらは**全て商用・非商用問わず無料で利用可能**


## vs 他モデル

DALL-E, Midjourney = プロプライエタリでカスタム性無し
Flux = パラメータ数が Flux のほうが多い (120億)、SD3.5 のほうが安価なGPUで実行できる、両者ともOSS
