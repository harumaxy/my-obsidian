# えっちなAIイラストスレ part20 まとめ

元スレ: https://bbs.animanch.com/board/6891475/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・ボボパン（性行為）描写は外部サイト（ファイルなう `https://d.kuku.lu/`）へ。性器はさらにモザイク処理必須
- サムネ回避のため画像は2枚以上まとめてアップするかリストにまとめる。1枚だけだとサムネが表示されてしまう
- 無修正画像はワンクッション置いても削除・BAN対象になりうる
- 長文プロンプトは Writening（`https://writening.net/`）に貼って共有するのが定番
- モザイク以外の画像加工はバナー工房（`https://www.bannerkoubou.com/`）
- 背景を白/黒に統一したい場合はPhotoroomの背景変更機能、正方形化はanytools.proのリサイズツールが便利

## PixAI関連の運用・トラブル

- 非Wi-Fi環境での生成通信量は大したことない。プロンプト送信と画像受信のみで、作品確認だけなら40MB程度、4枚生成でも数十MB程度の消費
- PixAIには「プロンプト自動変換」機能があり、勝手にプロンプトを弄ってくる。プロンプト通りに生成したいならこれをオフにする。ただし日本語入力の場合はオフにできない
- 実際にAIが使用したプロンプトは、生成後の画像個別チェック画面や生成履歴から確認できる。狙った結果が出ない時はここで実際のプロンプトを添削してから自動変換オフで再生成するのが有効な対処法
- センシティブ判定の基準は不明瞭。乳首・乳輪・アナルに該当しなくても、肌面積が多いだけで「nkpn空間送り」（削除）になることがある。バニーガールなども判定がブレる
- ネガティブプロンプトからnsfwを外すだけでボボパン（性行為）表現までいける、との報告あり
- 直近のアップデートで日本語プロンプト入力の方が意図に近い結果が出やすくなったという声も

## LoRA運用

- キャラクターLoRAは画風がLoRA側に強く引っ張られる。画風を崩したくない場合はLoRAの強度（適用の強さ、重み）を下げて調整する
- LoRAなしでキャラクター再現する場合は「キャラクター名 / 作品名」プロンプトの追加もそれなりに効果あり
- 複数キャラクターを一枚に混在させるのはLoRA・タグ指定を尽くしても難しく、要素が混ざりがち。NovelAIなど有料サービスでも完全solidな複数人出力は難しいとの認識
- キャラクター名を作品タグと一緒に指定すると意図しないメインヒロインの要素が混入することがある。回避にはネガティブプロンプトを活用
- 自作LoRA学習の手間はキャプション修正やLoRA選別など、学習自体より前後の作業に時間がかかる。Tagger（自動タグ付け）の精度が低く、手だけ・後ろ向き・巨乳が写っていない等の理由で誤って1boy/heteroタグを大量に付けてしまう問題が頻出
- 絵柄LoRA作成の失敗例: 全身図だけを学習データにすると顔や目の再現度が低くなる。解像度を揃えた多様な構図の画像を十分な枚数用意する必要がある。目・指は崩れやすく、ある程度は諦めが必要
- PixAIの絵柄LoRA機能はユーザーが変更できる項目が画像とトリガーワードのみで、バケッティング（解像度別処理）等の高度な調整機能がない
- 常時ハイライトオフ目のLoRAを作る場合、単に`blank`にすると瞳の模様ごと消えるので`blank stare`という言い回しにし、画風LoRAと合わせて強度を上げるとよい
- マイナー・サ終済みソシャゲキャラなどdanbooruにタグ登録すらされていないキャラの再現は困難。画像を直接読み込ませて自分用LoRAとして登録するのも一手（非公開前提）
- DVDパケ（ジャケット）風LoRAは「AV videography」というLoRAが撮影風景等も含めて統合的に使える
- LoRAなしでDVDジャケット風にしたい場合のプロンプト: `AV cover, dvd cover, DVD box cover, studio logo, title text sexy pose, japan text,`

## 表情プロンプト

- 涙・よだれ・鼻水でぐしゃぐしゃにする表情: `tears, crying, teary eyes, sobbing, snot, runny nose, sweat, sweatdrop,`。仕上げに`happy scream`を足すと歓喜にヨガってる感が出る
- scream系タグを使うと歯が変に出ることがあるので、ネガティブプロンプトに`tooth`を入れると防げる
- あへ顔の「お」の口の形を整えたい場合は`dot mouth`または`;o`（セミコロンとo）が有効。ネガティブに`lip`や`full lip`を入れると唇の厚みを抑えられる
- 何かを頬張っている表情には`puffy cheeks`が有効
- 目に横線が入った視線ブレ表現は「dashed eyes」と呼ばれる。ただしタグのみではほぼ機能せず、専用LoRAが必要
- 赤面・発情の手癖プロンプト: `awaiting tongue, full-face blush, embarrassed,`
- 嫌がりながらパンチラする表情には`disgust, embarrassed, skirt lift, Tearful,`が有効

## 体位・シチュエーション

- 「implied sex」的な、直接的すぎない構図を求める声とは別に、具体的なシチュエーション共有が多数：
- NTR系構図の作例プロンプト: `1boy and 1girl,((1boy,solo,evil smile)),BREAK,((1girl,solo,aroused, blush, screaming,tears,sitting on boy))BREAK,straight on,,full body,throne,throne room,sitting,women on top, facial, on body,`
- ショタ×メス豚のボボパン: `1 shota, faceless boy, 1 girl, clinging, sex from behind…`
- POV種付けプレス構図の詳細プロンプト例あり（Writeningで共有）。腰の位置・構図調整には`crotch focus`の重みを上げ、`man's lower belly`や`head adjacent to crotch/pussy`を追加するとよい、との助言
- povで生成すると`pov hands`（主観視点の手）が一度出るとネガティブプロンプトに入れても消えにくい、という報告複数
- 蔦による拘束表現で蔦の先端がペニス状になってしまう問題が指摘されている（未解決）

## 体液・潮吹き表現

- 潮吹きのタグは`squirt`（`female ejaculation`ではない）。ただしタグのみだと勢いが弱く、白濁してしまう傾向
- 潮吹きLoRAを使うと透明感は出るが、色が黄色っぽくなりがちという弱点あり
- 液体の勢いを補強するプロンプト案: `orgasm`, `excessive pussy juice`, `squirt love juice`
- `squirt`は挿入・非挿入どちらの構図でも使えるが、`invisible man`と組み合わせると液体が変形（tmp化）することがある

## 胸・触感プロンプト

- 手が肉にめり込むような揉み方: `hanging breasts, hard grab, deep skin, soft skin,`に加えて`strong groping, lifting breasts,`を足すとこねくり回す感が強調される
- 胸が大きすぎて指が全体を覆いきれない場合は、`height difference,`や`size difference,`で男性側の体格を大きくすると相対的に手が大きく見え、`strong groping, breast pull, deep skin, crushing grip,`と組み合わせて埋没感を強調できる
- キャラLoRA使用時、体格系プロンプト（`slender, skinny, small`, `flat breasts`等）は後付けで明示しないと反映されにくい。デフォルトだと`big breast`寄りの体格になりがち

## 変身・露出・その他シチュエーション

- 変身シーンの衣装消失表現: `vanishing clothes`, `turning into light particles`に加え、`power_wave, eye trail,`（光の軌跡）、`glowing body,`（発光）、`exploding clothes, torn clothes, convenient censoring,`（衣装爆散＋自然な隠蔽）が有効
- スパンキングの手形はガチャ運もあるが、`spanked`に加えて`handprint`を併用すると安定しやすい
- 露出系のコート脱ぎ全裸化には特別なプロンプトというより単純に衣装指定を外していく運用が主
- 暗い部屋に月明かりだけ差す構図: `night, room, full moon,`＋ネガティブに`room light`で照明の混入確率は下がるが完全には防げない（体感2割は照明が出る）。`dark room`は壁や屋根を貫通して月が描写される不具合が起きやすく非推奨
- 姿の見えない幽霊少女的構図のプロンプト例: `1girl, invisible, invisible female, invisible hands, white gl...`（以下省略、詳細は元投稿の画像添付キャプション参照）
- 低身長×幼児体型で背徳感を強める組み合わせ: `petite, petite_girl, loli, toddler, size difference,`
- 体に意味のある文字を入れたい場合、animaモデルが有効（ただし英語のみ対応）。日本語の文字入れは難しく、`tally`で「正」の字を書かせる程度が現実的な代替
- 3P/4P構図はモデルを問わず崩壊しやすいとの報告（有効なモデル・サンプラーの情報提供求む、として未解決のまま）
- クリトリスの形をパンツ越しに見せる表現は`covered clitoris`をベースに、`(covered clitoris1.2), cameltoe, (erect clitoris1.2), trefoil, (thick fabric1.1)`＋ネガティブに`(pink skin1.5)`を組み合わせると再現度が上がる。プロンプトだけで狙いにくい場合は専用LoRAを探すしかない
- prolapse系（アナル等の反り返り表現）はプロンプトだけである程度可能だが過度な期待は禁物。`B tightly sealed around A`や`strong suction between A and B`を併用すると密着感の描写が強化できる

## モデル/サービス選び

- illustrious系に比べてAnimaはプロンプト忠実度が高く、複雑なデザインのキャラ立ち絵生成に向く。ただしキャラ再現時の「from above」等の構図指定が効きにくいなど癖もある
- ローカルLLM＋画像生成の組み合わせは無料無制限で使える利点がある一方、自然言語プロンプト生成は得意でもDanbooru語生成は今ひとつ、VRAM消費が大きいなどのトレードオフがある、との整理
- ローカル環境構築にはStabilityMatrixが推奨されている。PixAIに近いUIでComfyUIも扱え、A1111系UI（reforge, forge neo等）ともモデル・LoRAを共通で使い回せる。単体でのStable Diffusion環境構築（Git/Pythonのバージョン管理等）の煩雑さを回避できる。日本語UIにも対応
- モデル・LoRAはCivitAIから無制限にダウンロード可能だが、ストレージ消費が激しい点に注意
- NovelAIは未使用者の伝聞情報として、有料だが高品質で複数キャラクターの共存描写に強いとされる
- サービス選びは「PixAIが劣っている」という話ではなく、手軽さ・無料枠重視ならPixAI、環境構築の手間を払っても自由度が欲しいならローカル、という使い分け論で着地

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part21（本文中に次スレリンクあり、URLは本文抽出では取得できず）
