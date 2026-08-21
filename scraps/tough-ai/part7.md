# えっちなAIイラストスレ part7 まとめ

元スレ: https://bbs.animanch.com/board/6645068/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（d.kuku.lu）へ、性器はさらにモザイク処理必須
- 画像アップロード先は引き続き d.kuku.lu（https://d.kuku.lu/index.php）
- 局部が浮き出ていたり形が透けていたりすると、モザイク処理済みでもあにまん直アップはアウト判定になりやすい

## PixAI決済・クレジット運用トラブル

- クレジットカード（Visa/PayPay等）で追加パック購入時に「High Risk」判定で決済エラーになることがある。1週間程度待つと解消するケースが多い（ログインクレジットで凌ぎ、1週間後に会員クレジット再付与を待つ運用）
- カード決済が通らない場合はコンビニ払いも選択肢
- センシティブ画像を多用しても即アカウント制限などにはなっていない模様
- 低クレジット運用の定番設定: モデルはHaruka V2、Sampling Stepsは8、ネガティブプロンプトからNSFWを外す
- Tsubaki2は高コスト（ネガティブプロンプト付きで4枚生成に6000クレジット消費）な代わりに複数キャラをしっかり出せる強みがある

## モデル/LoRA選び

- ボボパン（局部露出）系はHarukaV2が定番人気だが、Hoshino v2を好みで使う人もいる
- ケモノ系にはNova Furry XL ILが候補に挙がる
- Tsubaki2はバストアップ構図になりやすく全身構図が苦手、アクションポーズの引き出しも少なめ。名前を入れるだけでLoRAなしでも絵柄がかなり寄る（LoRA3枠を節約できる）
- Mao2はジェムが毎日もらえるわけではなく基本課金制、記念配布のみ
- LoRA強度を1.7くらいまで上げないと効かない場合、学習素材の枚数・選別不足が原因のことが多い。用途に応じた適正枚数を意識する
- 特殊性癖系（人格排泄・スライム排泄等）は自作より該当ジャンル特化のLoRAを使う方が確実

## 箱化・ボディコン・チャイナドレスなど衣装系プロンプト

- 箱化LoRAはPixAIのLoRA検索欄で「箱化」と検索すればヒットする。強度0.7では弱く、マックスまで上げるくらいが目安
- ボディコン: `bare shoulders,tight dress,mini skirt,strapless,sleeveless`
- チャイナドレス露出系: `ultra micro mini china dress,ultra micro mini length,sexy china dress,((see-through)),backless,open_front,deep_cleavage,sleeveless,,hip joint,groin,((pussy visible,pussy exposed)),((butt_crack,exposed pussy crack)),navel cutout,((no bra,no panty)),((breasts out,ass out,pussy out)`
  - スリット関連の指示を入れると前垂れが長いタイプのチャイナドレスになりやすい（AIが学習した一般的なチャイナドレスが前垂れ型のため）
  - シンプルに`crotchless dress`だけの方がうまくいくこともある
  - `china dress`だけでなく`mini skirt`など部分指定を足すとうまくいく場合がある
  - 露出させたい部位は`exposed(部位)`や`(部位)+cutout`で強調
  - `explosed clothes`（typo表記だが元スレママ）で服が弾け飛ぶ脱衣KO/アーマーブレイク風描写の補助になる
- サンタ服系: `tight cleavage,red santa cap,red santa costume,red micro mini skirt,navel cutout,((no bra,no pan)),((breasts out,nipples visible))`。さらにミニ丈にしたい場合`ultra micro mini`を追加（モデルによっては効きが薄い）
- 網タイツ（透明・色なし系）: `fishnet tights`/`fishnet pantyhose`が基本。`bare legs`を足すと透け感は出るが安定せず、強すぎると素足化する
- taimanin suit: 対魔忍風スーツを着せるプロンプト。過去スレ（part6の「続対魔忍スーツを型月キャラが着たら」スレ）にも関連プロンプト蓄積あり

## 露出・部分表現プロンプト

- 浮き乳首（服の上から輪郭だけ）: ネガティブに`see-through,`または`see-through ○○（服の名称）,`を追加
- areola slip（乳輪すべり）: AIの検知・センシティブ判定をすり抜けることがあり効果的との報告
- g-string,heart maebari, でハート型の局部隠し紐パンが出せる
- 開脚（後ろに手をつくポーズ）: `spread legs,leaning back, arm support`
- つま先立ち: `tiptoes`
- welcomeポーズ（手招き）: `welcome pose`

## 挿入・アナル・特殊プレイ系

- アナル舐め（1boy1girl向け）:
```
from side:2, solo focus, extreme his butt close up, extreme her face close up, 1boy, 1girl, hetero, completely nude,
((her tongue into his anal, licking his ass hole,))
((oral, groping, intense groping, licking his anal, intense licking his anal, a girl face in his ass, a girl is fingering his ass, anilingus, his anal, his ass, hand job, a girl is inserting her tongue into his anal, hand job, intense hand job, hand job motion lines:2,))
a girl: lower body out of frame, holding his ass, hand on his ass, spreading his ass, tongue out, tongue in his anal;
a boy: upper body out of frame, feet out of frame, erection penis;
```
  - 先頭行（"her tongue into his anal"）を最初に置かないと動作を多重認識してチンポや手が増殖しやすい
  - `licking ass`より`licking anal`の方が精度が上がるとの指摘あり
- 異物挿入: `objects insertion`の頭に`vaginal,`/`anal,`/`double,`を付けて種類を出し分け。バイブ系はコードが伸びる描写になりがちなので、あえて`vibrator`を外して異物挿入だけにすると綺麗に出る。`dildo vibrator`もたまに良い結果を出す
- 人格排泄・スライム排泄: `anal object insertion, slime (substance)`
- お腹ぐりぐり（見せ槍のシルエット）: `penis awe,looking at penis, penis on stomach,imminent penetration,`。腕のポーズを指定しないと手が邪魔してお腹に当たらない構図になりやすいので、手の位置指定プロンプトを併用推奨
- リョナ・事後表現:
```
((ryona)), (bruise), (bruised skin),(many bruised face), (blood dripping from mouth), (contusion), (abrasion), (scratches), (grazed skin), (dirty face), (bloody skin), (bloody pussy), (torn pussy), (after rape), craziness, (after sex), (after vaginal), (cum on face), (lying on back), (fours limbs on ground loosely), half-spread legs, (dying),(looking away),(weakness), (messy hair), (empty eyes), (teary eyes), (narrowed eyes), (blank expression), (crying), (drooling), (dispair), (agony), (parted lips), (wince), (anguish)
```
  - 括弧付きは任意で強度を上げて使う。`fours limbs on ground loosely`は事後描写に特に有効との評価
- お漏らし: `library, hand covered mouth, standing,pigeon-toed,(female orgasm,orgasm:1.8), full-face blush, saliva, tears, crying,`
- ショタの年齢を下げたい場合: `shortstack`、`aged down`、`child`、`Toddler`、`chibi`、ショタコン系絵師タグを併用
- ショタを巨根化したい場合: ショタ生成LoRA＋`erection male`の組み合わせ

## 複数人・構図制御

- 3P生成で竿役が一人称視点になり下腹部だけ映る問題は`1 boy,2 girl, wide shot, long shot`で改善報告あり
- 複数人レズキス: `multiple girls, yuri, face focus, open mouth, tongue out, saliva trail, french kiss, from above, looking at viewer,`
- 縦長構図の方が3人以上を出しやすい。正方形だと2人に収束しやすい

## 表情差分・参考画像（img2img的機能）

- PixAIの「参考画像」機能でstrength（強度）を調整して表情差分を作る
- 全裸で表情だけ変えたい場合はstrength体感0.5〜0.6が目安。周囲の服やオブジェクトが多いとその強度でも構図が変化しやすいので、着衣状態なら0.3〜0.4程度まで下げると良い
- 編集（マスク）機能をオンにして顔を指定する必要がある。既に描かれた絵をそのまま塗り替えるのは苦手
- NovelAIはマスク機能で表情差分が作りやすいと評判

## プロンプトの調べ方・学習法

- Danbooruに投稿されたイラストのタグを手動で確認していくのが最も基本的な学習法
- タグ付け（interrogator）機能、特にeva02モデルを使ったtaggerで参考画像からタグを抽出する方法が有効
- PixAIには画像を読み込ませてプロンプトを抽出する機能がある
- ChatGPT/Geminiに「この日本語をStable Diffusionタグ英語に翻訳してください」「英語タグを自然な生成用タグに翻訳してください」と頼むと、直接NSFW生成を頼むより通りやすく、実質的に激エロプロンプトの添削・翻訳をしてもらえる
- Grokは激エロ生成に比較的対応している
- 紹介された外部サイト・ツール:
  - 「呪文（プロンプト）一覧【※エロ系有り】｜AIエロイラスト.com」（aieroi.com、700種類以上のプロンプトを用途別掲載）
  - 「猿のたまり場」（masturbation-monky.vercel.app）
  - 「NovelAIプロンプト管理」ツール（hiroabeshi.github.io、プロンプト管理・組み立て支援）

## プロンプトの書き方・順序

- キャラの特徴（髪色・性別等）は前方に、`sex`や`kiss`などの行為指定は後方に置く方が絵が崩れにくいという意見あり
- 服装参考は良い感じの画像をinterrogatorをeva02にしたtaggerに通してタグ化する方法が有効。ファッションサイトを見て良さそうな服をそのままプロンプト化する運用も
- PixAIは何もしないと衣装を「地雷系」に寄せてくる癖がある
- seed値は下絵ノイズのピクセル分布を決めるだけで、生成の続きの構図やキャラの一致度を保証するものではない（steps消化後は構図以外の一致度が下がる）という指摘あり

## 履歴・データ管理

- 生成履歴の整理法として、小説投稿サイト「ハーメルン」をメモ帳代わりに使い、プロンプトを本文として書き込んで保存する運用が紹介された。開きっぱなしで自動保存され、外部ストレージ代わりとして機能する
- 失敗作でも一応「作品」として公開しておくと、モデル・LoRA・プロンプト情報が保存され、クレジットも貰え、非公開設定にしておけば人目にも触れない。さらに「参考作品」として同条件のまま再生成できる利点がある
- 過去の生成履歴を疑似LoRAのように参照して使う運用者もいる

## その他小ネタ

- 浣腸プレイ系: AIが「注射器＋針」の概念をうまく読み取れず、シュールな絵になりがち。長いチューブもホース状になりやすい
- 卵子に精子が群がるカット: `Fertilization`のみでそれらしい構図が出るとの報告
- 刻印虫のような小型触手生物: `worm`では普通の触手にしかならず、`crest worm`を試すも一部モデルでは認識されなかった（モデル依存）
- SDのinpaint機能は竿役の髪色変更や余計な汗の除去などに便利
- グラフィック生成アプリの広告に出るモナリザ風画像が独特の崩れ方をすることが話題に

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part8｜あにまん掲示板（本文中にリンクカードのみでURL未取得のため省略）
