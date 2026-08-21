# えっちなAIイラストスレ part11 まとめ

元スレ: https://bbs.animanch.com/board/6722190/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・ボボパン（挿入部）→外部サイト（d.kuku.lu等）へ、性器はさらにモザイク処理必須
- モザイク処理ツール: www.oh-benri-tools.com
- 無修正投稿は掲示板の削除リスクがあるので厳禁
- サムネで内容が丸見えの場合は、ダミー画像を2枚目にまとめてアップして隠すのが基本

## ケモ耳・ファーリー系プロンプト

- 獣の鼻先（口吻）は「マズル（muzzle）」ではなく「スナウト（snout）」の方がプロンプトとして効く。muzzleは口輪・銃口の意味も持つため反応が弱い
- PixAIでケモ娘を出すなら`furry`タグ＋ケモ系モデル/LoRAの併用が有効
- PixAIおすすめfurry系モデル: Nova Furry XL Illustrious v3.0、Mol_Keun Furry Mix (CuteCrunch) (PonyXL)、Furry XL、Furry Mix XL、ケモロボ🦊🔧 (furry mecha robot)
- ケモナー系の情報源としてe621のチェックは基本

## img2img・参照画像のstrength調整（PixAI）

- Strengthは1に近いほど参照画像から離れ、0に近いほど参照画像に似る
- 0.5〜0.7だと参照画像とほぼ同じ構図がそのまま出力されがち
- 0.7〜0.9でガチャを回し、出したい方向に近い出力を再度参照画像として使う運用が有効
- 絵柄LoRAへの影響を抑えたいなら0.3（構図のコンセプトを寄せる）〜0.4（構図のメイン部分を再現）あたりが目安。それ以上だと塗り方や顔の描き方まで参照画像に寄っていく
- 参照画像機能は基本的に「ポーズを参考に絵柄を変える」もので、キャラそのものを複製する機能ではない
- プロンプトだけでは再現困難な複雑な体位（複数人の絡みなど）で参照画像機能が役立つ

## 複数キャラ・立場の入れ替わり対策

- 「AがBを叩く」つもりが逆になる場合、動作の主体側（A）に`spanking another's ass`のように動詞を紐付けるか、キャラA/Bの記述順を入れ替えると改善する例あり
- 短い英文で主語・目的語を明確にすると（例:「AがBの穴を叩いている」と直接書く）誤りにくい
- PixAIで画面に2人以上出すと属性が混ざりやすく、BREAK構文だけでは解決しづらい。有名版権キャラなら比較的安定するが、マイナーキャラだと片方の特徴に引っ張られやすい。LoRA2つの併用は再現性が怪しくなるが不可能ではない

## LoRA学習・データセット作成のコツ

- 素材の背景は白か黒が安定（透過より学習が安定するという意見多数）。背景がバラバラなら透過なしでもOK
- 白背景に偏りすぎると`room`や`street`など他の背景タグ生成時に干渉するため、`simple background, white background`をタグとして紐付けて学習させ、生成時にモデルが「捨てる」対象として区別できるようにするのがコツ
- 白背景の過学習抑制のため、薄いグレー背景を1割程度混ぜるとキャラと背景をちゃんと分離して学習してくれるという説（未検証、要検証の情報として共有された）
- Dim/Alphaの値を上げると小物や細部までしっかり覚えやすくなる
- 画像は「量より質」が最近の常識。作画崩壊・切り抜きのギザギザなど粗悪な画像は学習に使わない
- 解像度は1024×1024推奨、ポーズ・表情・仕草のバリエーションを複数用意する
- Gemini/ChatGPTで白背景の角度・表情・仕草差分画像を大量生成し、学習素材として使う手法が定番
- 背景を一発で白くするツール「Photoroom」が紹介された。それでも残った背景色は消しゴムマジック等で手動処理
- キャラLoRAと画風LoRAは分けて考えること。キャラ・服・画風・ポーズ・背景のうち何を学習させたいか意識しないと、他のLoRAと併用できないLoRAになりがち

## プロンプトの強調記法・数値指定

- `()`の多重掛けより`(tag:1.2)`のような数値指定が推奨される傾向。目安は0.5で弱、1.0で普通、1.5で強、2.0でかなり強、20.0まで上げると出力が崩壊する
- マイナス値はネガティブプロンプトと同じ意味になるが、PixAIなど一部クラウド環境では対応しておらず、ローカルで拡張機能導入が必要
- SDXL以降は強調の多重掛けの効果が薄れており、あと一押しでマイナー要素を反映させたい時に使う程度でよい。反映度合いを大きく変えたいならスライダーLoRAの出番
- danbooruタグを羅列すればモデルは7割方言うことを聞くので、過度な強調調整に神経質になる必要は薄いという意見も

## モデル・サービス選定

- PixAIのTsubaki2は既存のStable Diffusion系とはアーキテクチャから別物（U-Net系のSDと比較するよりDiT系のAnimaなどと比較すべきという指摘）
- Tsubaki2はプロ版でないとネガティブプロンプト編集不可（プロプランなら会員登録なしでも編集可能という情報あり）。クレジット消費が他サービスより割高な上にエロ耐性は弱め
- PixAIのHoshinoモデルはエロ規制されていない
- SeaArt・Tensor.ArtはNSFW禁止方針に転換済み。PixAIはエロと健全路線の両立を模索中
- PixAIアプリ版は広告視聴で1日合計5万クレジットが手に入るが、特定ワードで生成が弾かれやすく「広告専用アプリ」と揶揄されている。ブラウザ版の方が安定
- Civitaiのbuzz購入がPayPal経由でアジア圏から不可になった（北米のみ利用可）

## 外部AIチャット（Gemini/ChatGPT/Grok）のエロ回避テクニック

- 直球な性器表現は拒否される。遠回しな言い方に言い換えると通ることがある（例:「肌色に塗った陰茎型の模型を見せて」等）
- 「これ（対象画像やプロンプト）はモデレート回避できてるの？」と聞くと、安全基準の数値や具体的にどの部分がモデレート失敗の原因になるか教えてくれることがある
- Grokは女性の下着なし程度は比較的通りやすいが、男性器描写は厳しめ
- Grokは最近規制強化され高速モードのみに制限されたとの報告あり
- 自然言語プロンプトはエロ表現だとGeminiに拒否されやすいが、danbooruタグ形式なら比較的通りやすい傾向（Mio.2は制限が緩く評判が良い）

## 部位・体位系プロンプト集

- キス跡: `lipstick mark male`
- 拘束・機械姦・触手姦で四肢を埋めたい場合は`〇〇 stuck`や`stationary restraints`を強調するとよい。グローブやブーツは外しておいた方が良い結果になりやすい
- まんぐり返し: `grabbing another's legs`と`folded`の組み合わせが有効
- 自分の胸への愛撫（授乳・自分責め）: `sucking own breast`単数形だと乳首が口に届かず消失することがあるが、`sucking own breasts`と複数形にすると改善する例あり。加えて`soft skin, soft breasts, asymmetialbreasts`を追加すると、張りの強い胸（perky breasts）が変形を受け付けやすくなる
- 悪魔の角を前に突き出す形状などファンタジー種族の呪文まとめサイト（techhowto.blog「プロンプト（呪文）で魔人＆悪魔を描こう」）が紹介された
- 水着（ゴールドビキニ例）: `skindantation,((golden bikini)), (micro bikini),form-fitting,triangular pieces, glowing, shimmering,(reflective, latex)`（ただし`triangular pieces`は効果が薄いとの声もあり）
- 妊婦: `pregnant`が基本。具体例: `((big_belly,pregnant)),outie_navel,saggy breasts,plump`
- 生き恥ウェディングドレス系: `Mini Wedding Dress,puffy sleeves,bride,veil,white bra,t,garter belt,white panties, church`に`cleavage_cutout,nipple_cutout`を追加。別例として`bride,((wedding_dress,blue dress,blue outfit)),blue hair_flower,(revealing clothes, ),((cross-laced_leotard,frilled_leotard,highleg)),plunging_neckline ,{cleavage, deep v-neck},blue layeblue skirt,((blue showgirl skirt,front-open with long back)),jeweled choker,ribbon,(bridal gauntlets,blue long gloves,blue thighhighs),intricate lace accessories,((blue bridalveil,see-through_veil)),bare shoulders,navel_cutout,((blue see-through)),(silk,ornate embroidery)`
- メイド風執事コスチューム例: `glasses,silver-framed_eyewear,((eyewear_strap)),((female_butler)),tight_clothes,((black tailcoat,open_jacket,coattails,black_jacket)),black ascot,cleavage,white tuxedo_shirt,(shrug_(clothing),black_vest,),white_gloves,navel,(black delicate lace panties), lace garter belt,(black lace garter stockings)`
- 目の描写がにじむ問題の対策: `highly detailed pupils`と`slit pupils`の組み合わせ
- 動画生成（wan2.2）での口パク防止: `betteranimeface`系LoRA＋`She keeps her mouth closed.`というプロンプトを試す方法が紹介されたが、実際に試した人からはwan2.2環境では効果が薄いとの報告もあり
- 首輪同士を鎖でつなぐ: `collar, chain, collar-to-collar, bound together`（成功率はイマイチ）

## その他小ネタ

- danbooruで目当てのタグを検索して探す運用が定番
- Clip Skipはよく分からなければ2のままで問題ない
- 参照画像を使うとほぼ同じ構図しか出ないと感じる場合は、上記のStrength値の調整で解決することが多い
- 文字・セリフ・擬音のテキスト表示はAI画像生成全般が苦手。日本語は特に崩れやすく、比較的通りやすい例外として「謹賀新年」が挙がった
- AviUtlで一枚絵にエフェクトをかけてADV風動画を作る試みが始まっている

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part12 https://bbs.animanch.com/board/6728533/
