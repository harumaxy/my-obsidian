# えっちなAIイラストスレ part8 まとめ

元スレ: https://bbs.animanch.com/board/6675320/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（d.kuku.lu等）へ、性器はさらにモザイク処理必須
- モザイク処理ツール: www.oh-benri-tools.com
- 無修正投稿はスレ削除リスクがあるので厳禁

## サービス・モデルの基礎知識（Stable Diffusion / PixAI / NovelAI）

- Stable Diffusionは「モデルではなくエンジン（技術の中核）」。PixAI・NovelAIはそのSD系エンジンを使った完成サービスという整理
- ChatGPT・Gemini・GrokはSDとは別系統の独自モデルを採用
- ローカル環境（Stable Diffusion系）と、PixAI/NovelAIのようなクラウドサービスは中身の技術系統は近いが別物として扱う

## Loraの作り方・キャラ再現

- マイナーキャラなど学習対象にないキャラは呪文だけでは描けない。既存Loraがあれば使う、なければ自作
- 有名ソシャゲキャラは「名前+作品名」のプロンプトだけで髪飾りや服のディテールまで再現できることがあるが、マイナーキャラはLoraなしだと目や髪の色が同じだけの別人になりがち
- Lora学習用画像は同一キャラなら複数枚まとめて投入してよいが、複数キャラ混在・作品ロゴ入り・淡い色彩の原画だと出力にロゴが出たり画風Loraとの併用が必要になったりする
- Geminiなどで白背景・フラットな画風のキャラ正面/背面/側面画像を生成し、それを学習素材にする手法が有効
- 際どい（ボボパン系）学習画像はモザイクがそのまま反映されることがあるので注意
- 絵師特定（誰の画風か当てる）は非常に困難。複数絵師の画風が混ざっていることも多く、探すよりAI生成画像を自分で学習させた方が早いという意見

## 精液・体液系プロンプト

- 量を増やしたい場合は強調構文を使う: `(bukkake: 3), (facial:1.4), (cum on body:2.7), (cum overflow from pussy: 1.4), (cum on floor: 3.8)`
- さらに増量したい場合: `cum_puddle`, `cum bath` を追加
- img2imgで白線を描き込んでから以下のタグを入れる手法も有効: `excessive cum,massive cum,cum overflow,cumdrip,bukkake,cum on body,cum on face,cum in mouth,cum in pussy,cum pool,projectile cum,cum string`

## 服装・露出系プロンプト

- 地雷系ファッション: `frilled shirt,long skirt,cross-laced skirt,frilled skirt,jiraikei`（服装プロンプトまとめサイト: sorenuts.jp「服装のプロンプト(呪文)一覧」も参照先として紹介された）
- 手つなぎ・恋人つなぎ: `holding hands,interlocked fingers`
- 水着がずれる・脱げる系: `wardrobe malfunction, untied bikini, falling bikini top, string bikini`
- スリングショット水着で胸をずらす: `strap pull, strap gap, slip nipples`
- 古代エジプト風衣装: `ancient egyptian clothes,` が全般タグとして機能。首元からハの字に布を垂らす形は `criss-cross halter`。露出強調には `Revealing clothes` を追加
- エジプト風王冠: `pharaoh-like golden headpiece` / `Egyptian-style crown` / `Egyptian-style royal tiara`。中央に宝石を入れたい場合は `with a central jewel` を追加。サークレット系なら `circlet` も候補
- 幼稚園児コスプレ系Loraのトリガーワード例: `((Small-sized kindergarten uniform micro mini skirt)),((Small-sized clothes ,tight_clothing)), ((open_front , off shoulder,shifted_clothing)),((exposed breasts,exposed shoulder,exposed navel)), ((breasts out)),((nipples shot,nipples visible,exposed nipples ,breasts visible)),yellow hat, yellow bag, tulip name tag,`

## アダルト行為・体位系プロンプト

- 首輪＋尻尾プラグの犬プレイ: `anal fake dog tail, fake dog ear headband,` が成功率高め（そのままだと尻尾が増殖したり耳が頭から直接生えるバグが出やすい）
- 複数人プレイ（乱交・輪姦）: `2 girl, multiple boys, gangbang, group sex, double penetration` 系。ネガティブに `nsfw` が入っていると人体合体や竿が空中に生える不具合が出やすいので確認する
- 宙に浮く竿バグ対策のネガティブプロンプト: `disembodied_penis`
- 複数キャラの人体融合バグ対策: ネガティブ側で `fused body` を強調すると改善
- 逆さ吊り（upside-down）は呪文だけだと成功しづらい、Lora頼みになりやすい
- レズプレイでタチ役の筋肉量が男性寄りになりがちな問題は、tsubaki2プロ版＋ネガティブプロンプト調整でほぼ解消できたという報告あり
- 耳標プレイ: `(ear tag:2.1),` でメスの耳に牛の耳標をつける。ケモミミ化を防ぐネガティブプロンプト: `cow horn,cow ear,kemomimi,animal ears`
- 授乳・搾乳系: `lactation,breastsucking,breastfeeding`
- 抱き枕カバー構図を手軽に出したい場合: `dakimakura`
- レスリング技構図はSDXL系では複雑な人体絡みの学習が薄く、プロンプトのみでは限界がある。個別シチュのLoraを探す/作るのが早い（PixAIで`wrestling`検索でも転載あり）

## Tsubaki.2 / Haruka v2 などPixAI主力モデルの特性

- Tsubaki.2は赤肌系のエロアニメ塗りが出しにくい。対策としてアニメ塗りLoraを併用するか、`artist:〇〇`は効きが弱いので好みのLoraを使う方が確実
- 塗りの質感狙いなら `body blush, anime coloring, shiny skin` の強調も有効という報告
- Tsubaki.2はPro版以上でないとネガティブプロンプトを編集できず、デフォルトのネガティブに`nsfw`が入っているため、無料版だとNSFW耐性が低く感じられる
- Tsubaki.2 / Haruka v2は股間まわりの描写がやや弱い傾向、milfやmature lady系のムチムチ体型描写にはむしろ強い
- 節約Lora（低コストで画風変化を狙うLora）がTsubaki.2では使えなくなったという声あり、代替を模索中

## PixAIクレジット・運用Tips

- 画像公開ボーナスは1枚あたり1000クレジット、1日10枚まで（上限1万クレジット）。デイリーログインボーナスは1万クレジット
- 1日の獲得目安: ログボ10000＋公開1000×10＋SNS共有1000×3＋いいね100×20＋アプリ広告5000×10
- 他人のNSFW投稿は基本非公開（自分の投稿のみ閲覧可）。コンテンツ設定でセンシティブ作品表示を有効化しておく必要あり
- アプリ版は特定ワードで生成が弾かれることがあるため、ブラウザ版の利用が推奨される
- センシティブ判定をすり抜けて他人のNSFW作品が一時的に見える/検索に出ることがある（バグ的挙動、時間が経つと非表示になるケースあり）
- 実在ポルノ女優をモデルにしたLoraが、本家配布サイトでは削除済みでもPixAI転載版は放置されているケースが報告されている
- Loraの学習には順番待ちの時間がかかる。「このバージョンは利用できません」等の表示は学習順番待ち中の正常な状態であることが多い

## ローカル生成環境

- VRAM 8GB（RTX3060ti/3070クラス）でもforge/reforge系なら動作可能。ただし将来的にはVRAM増強が推奨される
- forge派生（reforge, forge classic, forge neo等）は乱立していて選定に迷う人が多い。日本人作者のeasy reforgeも候補
- RTX3060(12GB版)の再販が噂されており、VRAM重視なら有力な選択肢という声
- ComfyUI導入時は拡張機能Impact_Packの導入が推奨されている

## 外部AI（Gemini/Grok/ChatGPT）の活用と癖

- Geminiの画像編集機能で、生成画像に混入した不要な文字を無料で消せる（ただし右下にGeminiの透かしマークが残る）
- PixAI編集機能でも文字消しは可能だがクレジットを消費する
- Grok/Geminiにディープリサーチさせてプロンプトを作らせる手法があるが、多人数シチュエーションだとキャラ混同やBREAK構文が効かない問題が起きやすい
- ChatGPTはNSFWワードをほぼ出してくれないため、この用途では不向き。Grokの方が緩いという声
- Geminiは未成年判定を避けるため「〇〇の20歳のような外見」等の言い回しで年齢を明示すると拒否されにくい
- Grokは最近（1ヶ月ほど前から）規制が強化され、動画生成が完全有料化。精液描写など際どい表現も以前より弾かれやすくなった

## その他小ネタ

- 吹き出し内にキャラを浮かせる演出: `distorted perspective, floating inside speech bubble,`
- 色が薄い・淡い出力の対策: ネガティブプロンプトに`monochrome`を追加、CFGスケールを上げる、または`artist:〇〇`で彩度の濃い画風を指定
- プールの隠語で`rei no pool`と入れると意図通りのプールが出て笑い話になった例あり
- 画像に想定外の要素が混ざる場合、プロンプトを一度英訳し直すと改善することがある

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part9 https://bbs.animanch.com/board/6696164/
