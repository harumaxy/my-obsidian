# えっちなAIイラストスレ part18 まとめ

元スレ: https://bbs.animanch.com/board/6851579/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト(d.kuku.lu等)へ、性器はさらにモザイク処理必須
- ファイルなうで画像を上げるときは2枚以上まとめてアップするか複数ファイルをリストにすること。1枚だけだとサムネイルがそのまま表示されて危険

## 便利ツール・情報源

- 長文プロンプトの共有には Writening (writening.net) を使う。ユーザー登録不要で即座に共有URLが発行される
- モザイク処理には バナー工房 (www.bannerkoubou.com)。モザイク以外の画像加工にも使える
- Danbooruタグ検索・よく使われるR18プロンプトの一覧は dskjal.com
- 背景を白/黒一色に変えるツールは Photoroom (www.photoroom.com)
- 画像を1024×1024に一括リサイズするツールは anytools.pro
- 画像からプロンプトを逆生成する場合はtagger、またはPixAI内蔵の「翻訳」ボタン機能で近い結果が出せる。ただし不要なタグも混じるので手直しが要る

## モデル/サービスの基礎知識

- SD = SD1.5のこと。2023年まで主流だったモデルで、現在はほぼ使われていない
- SDXL系譜: 2023年秋にanimagineが登場→やがてボボパン向きと分かったpony diffusionに主流を奪われる→2024年秋にillustriousが登場しponyを駆逐、現在まで主流
- ローカル界隈で話題になり始めているanimaというモデルもあるが、PixAIは今のところ大きく取り上げていない。PixAIは自社開発のtsubakiを推している模様
- モデル選びに迷ったらXL系を選ぶのが無難という結論
- 画像生成AI比較: 手の自然さはNano Bananaが優れている。素材画像への忠実度はSeedreamも良いが手が崩れやすいのでNano Bananaで手だけ修正する運用が挙げられていた
- PixAIのLoRA表示: 検索ソートを「外部モデル」にすると文字色が青の「ユーザーLoRA」(CivitAI等からの転載)になり、ページ上部の三点メニューから「編集を申請」「モデルを主張」「通報」が可能。ソートを「pixai」にすると文字色が薄紫の「ユーザーLoRA」になり訓練者名が表示される、こちらがPixAI上で学習されたLoRAとされる

## LoRA運用ノウハウ

- 学習画像の枚数目安はAIに聞くと15〜30枚程度という回答が得られる(ソース不明との注記あり)
- PixAIのLoRA強度は初期値0.7が基準。キャラパーツの反映が強すぎる場合はキャラ側を0.5程度まで下げる、絵柄LoRAは1.0程度まで上げて調整するとよい
- 複数LoRAを重ねると背景や絵柄が破綻しやすい(いわゆる「猿空間」)。プロンプトへの信頼度が落ちるとの声あり
- 体が見えない構図なのにbig_breastsのような身体特徴タグが残っていると、無理に描画しようとして身体が破綻する原因になる。見えない部位のタグは削除するとよい
- キャラLoRA作成時、公式立ち絵が薄着でないと体格が伝わりにくいので、水着が通らない場合はシャツ+ショートデニムなど比較的露出のある服装で出力させるとよい
- 三面図のような1枚に複数人物を含む学習画像は、出力時に背景モブとして分裂して出てくる原因になるため、1人だけが写っている画像を学習させたほうがよい
- 二次創作キャラで絵柄がブレる場合、AIに正面・背面・側面絵を描かせて画像数を増やしてから学習させるとよい
- ControlNet(線画抽出・深度)は、狙った構図が出せない時に使う。LoRA用の学習素材を増やす際は深度・線画のstrengthを強めて似た構図の画像を量産する用途にも使える

## 衣装・露出コントロールのプロンプト

- 露出を減らしたい場合、ネガティブに `bare shoulder`(剥き出しの肩)や`cleavage`(谷間)を入れると効果がある場合がある
- oversizedは子供服っぽさを強めるだけの効果しかない。ぴちぴち感を出したいなら`undersized`を使う。丈の足りない感を出すには`navel,`を加えるのも有効
- 修道服×レオタードの組み合わせは要素が喧嘩しやすい。ネガティブに`long skirt`、`(black leotard`・`(mini skirt)`をweight強めに指定しても布が余分に出る場合、`nun`タグ自体を外すと解消する例あり。より短い丈が欲しい場合は`micro mini skirt`が有効
- 修道服系の後ろのひらひらはnunに付属する上着の裾が原因。`nun headdress, short black dress, showgirl skirt, mini skirt,`の組み合わせで安定するとの報告
- NovelAIでの修道服レオタード再現例: `nun, wimple, leotard, guimpe` をベースに `showgirl skirt` に `layered ruffles` を混ぜて `layered showgirl skirt` とし、質感・丈・色の単語を足したうえで最後に `white frills` を入れるとそれっぽくなった
- おっぱいでボタンが弾け飛ぶ表現: `bursting breasts, flying button, popped button` に加えて `unaligned breasts, bouncing breasts, motion blur` を足すと服のハリ・動きが出る
- 年増・人妻感を出すプロンプト: `mature_female, mature_eyes` をベースに、モデルやLoRAに応じて `wrinkled skin, housewife, sagging_breasts, (cellulite:0.8)` を足す。好みでさらに `curvy, gigantic_breasts, wide_hip, muffin top` を追加。単に`milf`を入れるだけでも大人びた印象は出るが、絵師タグの学習元次第でシワまでは出ないこともある
- 髪色プロンプト例(安定しにくいとの前置きつき): `split-dyed hair, short hair, navy blue hair on one side, bright yellow hair on the other side, high messy twin buns, split hair buns, small star-shaped hair clips on buns, messy bangs, Vibrant orange eyes,`
- カートゥーン/デフォルメ系: `panty & stocking with garterbelt style` のLoRAに `chibi,` `bold,` `bold_line,` を組み合わせるとよい
- PC98風・レトロ塗り再現: `pixel art, retro artstyle, vector art,`

## 体位・プレイ系プロンプト

- 体位のレパートリーに悩んだら dskjal.com の「よく検索されているプロンプト」から探すのも手
- 対面立位、I字バランス`standing split`、逆駅弁`reverse suspended congress`、立ちバック`standing, from side`、`dangling spitroast` が最近の定番(体位四天王)として挙げられている
- 身長差のある立ちバックには「足プラ」(`hanging_legs, hanging_head, lifting person`)を組み合わせるとよい
- 種付けプレスの断面図表現の例(writening共有、一部抜粋): `(standing full body:1.2), wide shot, sweet smile, bedroom, on bed, (lying on bed:1.2), messy sheets, wet bed sheets, (cutaway, x-ray:1.2), internal structure, anatomical diagram, uterus, womb, ...`
- 即落ち2コマ風の種付けプレス: `1girl, instant loss 2koma, mating press, outdoor, shoes, sound,` である程度描写できる。LoRAを併用するとキャラと構図をより固定しやすい
- 種付けプレスでケツとケツをくっつけたい場合は `ass to ass` と `size difference` を使う
- 種付けプレスで上半身が変な位置から生えるなどの崩壊は、見えないはずの部位(胸など)のタグが残っていることが原因になりやすい。penisなどのタグも不要な場合は消しておく
- アナル舐めパイズリ(`anilingus`, `reverse paizuri`)は組み合わせるとキメラ化しやすいとの報告あり、解決策は出ず
- 断面図で挿入している物のサイズをボテ腹相当に大きくする方法は模索中、未解決

## 表情・身体崩壊対策のプロンプト

- 仰け反りイキ表現の断面図系プロンプト(偶然の産物として再現待ち): `sterile_laboratory, liquid_drained, clothes_internal_plug_vibrating, eyes_blank, eyes_rolled_back, heart_eyes, intense_ahegao, chemical_induced_orgasm, body_shivering_uncontrollably,`
- 目が隠れた/白目・忘我系の表情プロンプト: `hair between eyes, no eyes, head back, open mouth, sweatdrop, heavy breathing, nose blush, furrowed brow, three quarter view, from below, leaning back,`。ただし`head back`だけ抜くと成功しても再出力すると目が復活するなど再現性が低く、専用LoRA作成も検討事項として挙がっている
- アヘ顔系は`head back`をベースに`ahegao, tongue out`も併用可
- 拘束具「反省板」はピクシブ百科事典にも項目がある専用の拘束台。プロンプトとしては`pillory`(晒し台)が近く、`restrained, head and wrists are in the pillory`などで補強するとよい
- 絵柄を強く固定したい場合は`(anime style:1.2)`のようにweight数値指定で強調する方法が有効

## AIチャットボットでのプロンプト生成・NSFW回避

- Gemini(Flash)にえっちなプロンプトを直接生成させるのは規制強化で通りにくくなっている。前スレの手法(最初に健全な描写をさせてから内容を継ぎ足す)で回避できる場合がある
- Geminiに性的描写を直接させず、シチュエーションの基盤だけ提案させたうえで、そのシチュ内で「本番シーン」を自己参照的に考えさせるとGeminiの検閲は緩くなる(Gemini用のマスタープロンプトがWriteningで共有されている)。GeminiはFlashで動作、Proだと弾かれやすいとの報告
- Gemini 3.5 Flash(ログイン不要)はdanbooruタグベースであれば際どい内容も出力できていたが、後日「不適切」判定で生成不可になった例あり
- 画像生成と判定されないよう依頼文を書き換えることで回避できる場合がある、との報告
- Grokは規制が緩くNSFW生成に寛容という評価。deepseekはプロンプト生成用途としての検証報告なし

## その他小ネタ・トラブルシューティング

- LoRAを使わずプロンプトだけで年増感・特定シチュを狙うより、専用モデル/LoRA(熟メス儀式など)を使ったほうが効果が強い
- マイナーキャラの再現はサンプル数不足やモデルの学習時期の問題で難しく、対策としてLoRAを自作するか、作品タグを入れると絵柄まで変わってしまうトレードオフがあるため妥協が推奨されている
- 正面からの構図や「片手で目を隠す」など単純に見える指示ほど生成AIは苦手、という報告複数あり
- 箱詰めシチュエーションはGeminiに依頼しても密封感や前後のシーン再現が難しく、フレームワークのみ共有されている(Writeningリンクあり)

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part19 https://bbs.animanch.com/board/6868168/
