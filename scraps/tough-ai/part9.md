# えっちなAIイラストスレ part9 まとめ

元スレ: https://bbs.animanch.com/board/6696164/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（kuku.lu）へ、性器はさらにモザイク処理必須
- サムネ隠しは2枚以上まとめてアップが基本。1枚だけ投稿すると乳首が丸見えのままサムネ表示されてしまう失敗例あり

## PixAIモデル選び

- Tsubaki2: 服装表現は優秀で複数キャラの描き分けにも向くが、「汁不足」でエロ表現自体には弱い。レイプ顔などの鬼気迫る表情もHarukaV2に比べて物足りない
- HarukaV2: NSFWに強い反面、服装パターンに乏しく着衣セックスが弱い。指の本数がガチャになりやすい欠点あり
- VXP（ローコスト）: ボボパン専用モデル的な位置づけ。安い分クオリティは低めで、良いLoRAと組み合わせないとマトモな絵が出ない
- Mao2: エロが作りやすいと評判
- wai / nova: 出力の安定を取りたいならこの系統が推奨されていた
- PixAI公式マスコットMioは自社モデルにタグ学習されておらず、`PixAI_girl`や`mio`と入れても反応しない（公式LoRAは別途用意されている）

## ベースモデル系統（ローカル）

- Anima: 新しいが重い
- Flux: 高品質だが重い
- Illustrious: 現状の二次元エロの定番
- Pony: やや古いがLoRA資産が豊富
- SDXL: 半二次元・リアル調
- Forge本体のほか、派生としてreforge / forge classic / forge neo / easy reforgeがあり、初心者にはまずforgeから始めるのが勧められていた

## 複数キャラクター生成・構図制御

- forge coupleというforge拡張機能を使い、プロンプトを`BREAK`で区切って領域ごとにキャラを割り当てる手法が定番。1行目は背景など全体に関わる指定、2行目以降は各キャラの人数・特徴を書く
- 実例（4girls、水着シチュ）:
```
masterpiece,best quality,lucky star,on bed,hotel room BREAK
4girls,izumi konata,blue micro bikini,(evil smile:0.7),sitting BREAK
4girls,hiiragi kagami,yellow striped micro bikini,blush,glare,sitting BREAK
4girls,takara miyuki,pink polka dot micro bikini,glasses,blush,large breasts,light smile,sitting BREAK
4girls,hiiragi tsukasa,aqua micro bikini,blush,embarrassed,sitting,
```
- forge coupleはデフォルトでHorizontal（横方向にキャラ配置）だが、Verticalに切り替えると縦方向配置になり、膝枕構図なども作れる。各行に「このイラストに何人描くか（2girlsなど）」を必ず入れるのがコツ
- 領域分けは範囲を少し被らせても意外と混ざらない
- マスピ（複数人）タグを入れると2girlの出力がされにくくなり、逆に特徴が混ざった1人が出ることがある。学習量の少なさが原因と推測されている。複数人対処はモデルによって効き方が違い、呪文2〜3個で一挙解決するような話でもない
- `1girl`を強調しネガティブに`multiple girls`を入れても複数人になってしまう問題について、「羅列した要素が衝突すると分身させて全部描画しようとする」のが定石的な原因という指摘あり
- ChatGPT等のAIに相談すると`and`構文を勧められるが、効果検証は不確か。ローカル環境（特にSDXL系）では`and`を使うと構図が崩れることがあり使わなくなったという声も
- ローカルでは、キャラを個別にIllustrious等で単体生成し、Qwen editで「お互いにボボパンしてもらおうか」とプロンプト指示して合成する手法も紹介された
- おんぶ体位のおねショタ構図は`piggyback`＋`sex from behind`の組み合わせで再現可能

## 表情・仕草プロンプト

- `peeking through fingers`＝指の間から覗く仕草の定番プロンプト
- `covering own mouth by book`＝本で口元を隠す仕草
- `covering girl's eyes with hand` / `hand up,covered_eyes,covering own eyes,pov,from above`＝目隠しフェラ系の構図に使える仕草プロンプト
- `constricted pupils`＝瞳孔を収縮させ鬼気迫る表情に近づけるプロンプト。ただしやや大袈裟になりすぎるとの声もあり
- 恥じらい顔の実例プロンプト:
```
solo,1girl,upper body,(peeking through fingers),covering own face,looking down,face,fullblash,shy,embarrassing,empty eyes,open mouth,wavy mouth,finger,breasts,penis awe,...
```

## 局部・特殊シチュ表現

- 裸ゼッケン（`naked bib`, `naked race number`）の再現は両方のタグを併用し、さらに上半身の部位ワードを並べて`bare`を多用すると成功率が上がる
- シャワーで優しく洗ってもらうおねショタ系は`showering together,touching shota's penis,`に`soap`/`bubble`を足しても中々狙った構図が出ず、学習データが薄いタイプとの指摘
- 短小の断面図表現は細長くなったり複数描写されたりして安定しない
- 縄を握らせる構図は`grabbing rope,`が有効。実例プロンプト: `A thick rope hangs from the ceiling to chest height, and she is grabbing rope with both hands.`（ただし「縄で縛られる」方向に寄りやすい）
- ネガティブプロンプトは効きが弱いとされ、強度を上げるしかない。ポジティブ側に`no 〇〇`と書くと逆に出やすくなる現象も報告された
- `8k resolution, cinematic raw photo,`を足すと画質がやや向上したという報告

## ローカル生成・LLM活用テクニック

- LM Studioでローカル軽量LLM（Qwen 9B Uncensoredなど）を動かし、「Stable Diffusionでこんな感じのエッチな画像を出せるプロンプトをくれ」と構図参考画像を添えて指示すると、初心者でもプロンプトの叩き台を組める
- ChatGPT/Copilotに直接エロを聞くと弾かれるため、無関係な物（バナナが壁にくっついている等）に置き換えて生成プロンプトを聞き出し、後で対象語（ディルド等）に差し替えるテクニックが紹介された
- ComfyUIで数日格闘した末、モデルをAnimaに固定したところフロー構成やLoRA選択肢が絞られて逆に扱いやすくなったという報告

## LoRA学習ノウハウ

- 公式イラスト1枚を用意し、ChatGPT/Gemini/Grok等で背景を消してポーズや角度を変えた画像を20枚程度生成し、それをLoRA学習素材にする手法
- 学習素材はポーズよりアングルのバリエーションを増やす方が破綻しにくい。顔のドアップ素材も入れるとAIが構造を把握しやすい
- 一枚絵からLoRAを作ると顔の向きが固定化しやすいので、そのLoRAで生成した画像を使って別アングル素材を追加し、LoRAをバージョンアップする手法が有効
- 衣装差分について: コスプレ目的なら複数衣装を混ぜてしっかり服装ごとにタグ付けすれば混ざらない。逆に公式衣装だけで学習すると、コスプレさせた時に公式衣装の要素が漏れて出てくることがある
- 過学習気味のLoRAは他の構図LoRAの影響を受けにくい反面、着せ替えに弱い
- ソシャゲキャラなどに多い「複数衣装を1つにまとめたオールインワンLoRA」は、単一衣装ごとのLoRAに比べて衣装再現精度が落ちる
- コスプレ用途では`cosplay`,`clothes`系タグが定義された服専門LoRAを探すか、原作キャラLoRAから髪型・体型プロンプトを外して使う方法も紹介された

## モザイク・メタデータ管理ツール

- モザイク加工サイト: `www.oh-benri-tools.com`（1px単位でモザイクの粗さを左右キー操作できる）、`www.bannerkoubou.com`
- ふたば（2ちゃんねる系）製のモザイクツールはメタデータが消えない利点があり、AIコミュニティ内で無修正扱いされるリスクが低いと評価されている
- 画像のメタデータ（プロンプト等）が消えるケース: ①ペイント/モザイクツールで後から上書き加工した場合、②PNGをJPGに圧縮した場合、③あにまんに直接投稿した場合（実質JPG圧縮と同義）。逆にPixAI産の画像はそもそもメタデータが入らない
- ローカル/NovelAI生成画像はメタデータにプロンプトや設定値が保持されており、拡張機能「Infinite Image Browsing」等の画像ブラウザで確認できる
- 大量生成画像の並び替えには「FastStone Image Viewer」（ドラッグ&ドロップ対応）が便利という紹介あり

## その他小ネタ

- PixAIのMio2にエロをリクエストすると「よくないけどリクエストに応えなきゃ」といった葛藤するような思考が出力に混じることがあり、ネタとして楽しまれている
- PixAIはモデルによって消費クレジットが異なり、安いモデルは4枚生成で200クレジット程度。安いモデルは相応のLoRAを使わないとクオリティが伸びない
- PixAIの動画生成機能は全年齢向けコンテンツのみ想定されており、プロモードでの扱いは未確認
- ChatGPTでの妊婦・乳揺れ表現は根気よく粘ると出力できることがあるが、絵柄が荒れやすい

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part10 https://bbs.animanch.com/board/6711959/
