# えっちなAIイラストスレ part10 まとめ

元スレ: https://bbs.animanch.com/board/6711959/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト(d.kuku.lu)へ、性器はさらにモザイク処理必須
- 無修正投稿はワンクッション置いても削除・スレ荒れのリスクあり
- ファイルなう(d.kuku.lu)へのアップロードはパスワードを付ければ流出防止になる(実際にパス付きで動画共有された例あり)

## サービス・モデル比較

- PixAIアプリ版はストア規制のため生成が弱い(プロンプト抽出不可、サンプリングステップ調整不可)。使うならWeb版が推奨
- PixAI標準モデルはTsubaki.2(最新)。日本語プロンプトでもそのまま通じる。BREAKは不要
- WAI-illustrious-SDXLはローカル界隈の定番モデル。安価でド定番、迷ったらこれをDLしろという声が多い
- SFW用途ならGrok/Gemini/ChatGPTの3強が性能で頭一つ抜けている。NSFWをやるならNovelAIかローカル、動画も欲しいならローカル一強
- Geminiは衣装の側面図・背面図まで理解して描くのが得意。ChatGPTは衣装理解がやや弱い
- 品質タグはシンプルでよい(waiモデル作者の推奨): `masterpiece,best quality,amazing quality` 程度。アニメ塗りにしたいなら `anime screencap, anime coloring` を追加する程度で十分

## プロンプト集(体位・行為表現)

- `symmetrical pose` は1つのプロンプトなので途中にコンマを入れると壊れる(誤: `symmetrical, pose`)
- 挿入・複数プレイの実例プロンプト:
```
from side, anime coloring, 2girls, medium breasts, full nude, pussy to pussy, orgasm,screaming, crying, symmetrical pose, group sex, anal, reverse suspended congress, m legs, lifting person, holding another's legs, double dildo, shared objects insertion, vaginal objects insertion, 2boys, boy sandwich, best quality, very aesthetic, absurdres, perfect anatomy,
```
- ぶっかけの量を増やすのは強調(数値強化)しても誤差レベル。`excessive`(過剰な)、`exaggerated`(誇張された)、`intense` あたりの形容詞で多少強化できるが、専用LoRAを探した方が確実
- ディープスロート表現は `deep throat` を追加しネガに `penis` を入れると良い。`licking` だけだと先っちょ舐めになりがちで、`fellatio` か `iramatio` の方が自然。`fellatio` と併用すると根本から舐め上げる絵になりやすい
- 尻尾プレイは背中がアングル外の構図なら付け尻尾だけで表現できるが、尻を正面や上から映す指定をすると元のアングル指定と喧嘩して破綻しやすい
- ドレスの露出を強化する実例プロンプト:
```
((Golden coktail_dress,high slit,sleeveless dress,halter_dress,backless_outfit,glitter_dress,knee length)),spaghetti_strap,center_opening,cleavage,dress,((cowl_neck,plunging_neckline,full_cleavage)),halter neckline exposing shoulders,jewelry,necklace,navel,no_panties,no_bra,high-heeled sandals,covered_nipples,(glitter,shiny),BREAK
```
- `strap gap`(ブラ紐の隙間)で胸のパツパツ感を強調できる
- 拘束系の実例プロンプト:
```
High quality, Ultra detailed, best quality, insanely detailed, beautiful, blunt bangs,1girl, solo,(no eyes,blindfold,lace blindfold:1.2),(black body suit,skin tight, Lace Bodysuit:1.3),covered nipples, puffy nipples,huge nipples,erect nipples,arms up, t-pause, head tilt, standing,open hands, zombie pose, marionette,black string bondage,y-shaped suspension,leaning to the side,
```
- 特定キャラのコスプレLoRA併用時の実例(バニー衣装):
```
le malin \(listless lapin\) \(azur lane\) \(cosplay\),,bunny ears, white leotard, strapless leotard, cleavage, bunny tail, white tail,cross necklace, white wrist cuffs, white hair flower,white crotchless pantyhose,covered pussy,
```
  別キャラに着せる場合、ネガに元キャラの髪色や瞳の形(`white hair`, `cross-shaped pupils` 等)を入れないと元キャラの特徴が混ざりやすい
- 対面座位を狙っても騎乗位もどきになる問題: 画像を横長にすると対面座位っぽく出やすく、縦長だと騎乗位寄りになりがち
- 洋式便器拘束は背景の便器とのサイズ差が出やすく難しい。便器の形状は国ごとに差があるので注意。`light smile, heart` を足すといちゃラブ系の雰囲気になる

## コマ割り・分割表示トラブル

- ネガに `split view,grid view,multiple views,multiple panels` を入れても改善しないケースがある
- 有効だった例: ネガに `(manga, multiple views, 2koma, 4koma:1.4),` を追加(数値1.4は経験則)。`ahegao` などと同様、日本語の「koma」もタグとしてそのまま機能する
- ただし `manga` の語をネガに入れても絵柄自体への影響はほぼ見られなかったという報告もあり、保証はできない
- 同じプロンプトでもコマ割りが再現しないケースがあり、原因は使用しているLoRA側にある可能性が指摘された
- モデルが再現しきれない複雑なシチュエーション(体位や構図)を要求すると、勝手にコマ割り(分割カット)で表現してしまう傾向がある

## センシティブ判定の癖

- 単なるストレッチ(手足を上げるポーズ)がセンシティブ判定される一方、片足上げは判定されないなど基準が不安定
- `wide spreading own pussy` がセンシティブ判定されて原因特定に時間がかかった例あり
- `censored` タグを入れると露出度を上げつつ隠す表現になるが、実際はあまり隠せていないことが多い
- `cum puddle` をプロンプトに残したまま生成し続けると常に中出し済みの絵になってしまう。使い回すプロンプトは消し忘れに注意

## LoRA作成・学習

- ローカルでのLoRA学習時間の目安(ChatGPTによる回答): 標準(画像50~100枚・512~768px・10~20epoch)で約1.5~4時間、やや重め(SDXL・768px以上・枚数多め)で約4~10時間以上
- dim/alphaを上げると再現度が上がるが要求VRAMも増える(4070sでも不足するケースあり)
- `lazyhand`、`lazylori` などのembeddingは必ずネガティブプロンプト側に入れる。ポジティブに入れると逆効果(手が崩れる/意図せずロリ化する)
- facedetailerの導入も合わせて推奨されている

## 高速化・生成設定

- DMD2を使うと4stepで生成可能になり時短になるが、step数の推奨値はモデルごとに異なるので使い回しは注意
- Turbo系の高速化LoRAを使うと生成は速くなるが画風指定が崩れやすく、CFGやSTEPの見直しが必要。使わない場合と絵柄が変わるのがデメリット
- PixAIの低コスト生成候補として `Hyper SDXL`、`dmd2_sdxl_4step_lora`、`VXP_XL v2.2 (Hyper)` などが挙がった。PixAI内検索で「low cost」+人気順に並べると見つけやすい

## ローカル環境・ComfyUI

- ComfyUIはノード接続がわかりやすく導入自体は容易な部類。ただしワークフローを増改築していくとスパゲッティ化しやすく、後で見返すと構造が分からなくなりがち
- 非力なGPU(AMDのRX6600等)ではSDXLの1024×1024生成すら厳しく、900×900まで落としても10分近くかかることがある。AMD GPUはCUDA非対応のため特に不利
- civitai.redが二次元絵作成向けのComfyUIワークフロー配布先として紹介された
- Anima/illustriousなど複数チェックポイントをまたいだインペイント修正はうまくいかないことがある(load checkpointでの読み込みエラー等)

## 動画生成

- Wan2.2で5秒動画を生成する場合、RTX3060だと1本あたり600~900秒程度かかる
- Wan2.2の720p・5秒動画は5090を使っても約2分かかる。解像度を落とせば速くなる
- ComfyUI上のFramePack(flamepack)はRTX3060だと動作が不安定という報告あり
- 手軽な代替としてSeaArtの動画生成機能(なめらか10秒)が紹介された。無料会員でも1日2回動画生成可能
- GPUクラウドで処理能力だけ借りるサービスもあり、5090を1時間120円程度でレンタルできる

## その他小ネタ

- 擬音(sound effects)を追加すると効果音的な書き文字が出るが、文字になっていない模様になりがち。ネガに `speech bubble` を入れておくと吹き出し自体は防げる
- プロンプト・構図のリファレンスとしてDanbooruのタグを見るのが定番(タガー・danbooruを見れば大抵は何とかなるという意見)
- ポーズ集サイトとしてclip studio assetsのポーズ検索(https://assets.clip-studio.com/ja-jp/search?type=pose&order=dl)が紹介された

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part11 https://bbs.animanch.com/board/6722190/
