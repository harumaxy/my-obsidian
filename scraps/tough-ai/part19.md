# えっちなAIイラストスレ part19 まとめ

元スレ: https://bbs.animanch.com/board/6868168/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・ボボパン（性行為）描写は外部サイト（ファイルなう `https://d.kuku.lu/`）へ。性器はさらにモザイク処理必須
- サムネ回避のため画像は2枚以上まとめてアップするかリストにまとめる。1枚だけだとサムネが表示されてしまう
- 無修正画像はワンクッション置いてもスレ削除の対象になりうる
- 長文プロンプトは Writening（`https://writening.net/`）に貼って共有するのが定番
- モザイク以外の画像加工はバナー工房（`https://www.bannerkoubou.com/`）
- Danbooruタグ検索は`dskjal.com`、猿のたまり場（`masturbation-monky.vercel.app`）などを利用
- LoRA用の背景処理にはPhotoroomの背景白/黒化機能、正方形化にはanytools.proのリサイズツールが便利

## モデル比較（WAI-ANIMA / WAI-SDXL / illustrious系）

- WAI-ANIMAはWAI-SDXLよりプロンプト追従度が高く、キャラ再現の幅も広い。illustrious系はv2.0時点のキャラしか出ずLoRA頼りになりがちだが、ANIMAはその制約が少ない
- 一方で手足の描写精度はSDXLの方が優れ、生成速度もANIMAは大幅に遅い。Turbo LoRAで速度改善はできるが絵柄が大きく変わってしまい実用に耐えないとの報告
- Geminiに自然言語で作らせたラフなプロンプトでも、ANIMAはSDXLよりコンセプトに近い絵を出す。ただしエロ衣装（明示的な着せ方）は自然言語だけでは難しく、Danbooruタグとの併用が必要
- グロ・機械娘の破壊描写・モンスター娘の異形表現はANIMAの方が得意との報告
- Turbo系低ステップ低CFG LoRAを使うと、モデルごとの絵柄の違いが出にくくなる傾向（turbo時step8/cfg1、通常時step30/cfg5で比較した報告）
- PixAIのtsubaki2モデルは参照画像からのi2iが不安定になることがあり、他モデルへの変更で改善したとの報告

## LoRA作成のコツ

- キャラLoRAは「ポーズより角度」が重要。印象の強いポーズの画像を少数でも混ぜるとそのポーズに強く引っ張られるため、気をつけの姿勢で様々な角度から撮った素材が理想
- 絵柄LoRAはdim/alphaを32/16か16/8に収める作例が多い。キャプションは賛否あるが付けた方がよいとの意見が優勢。ANIMA系LoRAは1000ステップ程度で形になる
- 顔やボディを部位ごとに切り分けて学習素材を分けるべきかは意見が割れており明確な結論は出ていない
- LoRA学習素材（生成物）の差異がどこまでなら許容範囲かという質問も出たが、明確な回答はなし

## ポーズ・構図系プロンプト

- 犬の立ち小便のような片膝立て足上げポーズは `all fours, lifted leg, one knee up` で再現できる
- 足をピンと伸ばすポーズは `legs extended straight, straight legs, fully extended legs, legs together` 等では効きにくい。`dangling legs, plantar flexion` が有効との報告。確実性を求めるなら専用LoRAが推奨される
- 仰向けで足を伸ばした構図の実用プロンプト例:
```
positive: 1girl,solo, from_above, full_body, lying, on_floor, ,legs_together,straight_legs, arms_at_sides, feet_visible, dorsiflexion,
negative: bent knees,knees up,curled legs,folded legs, knee...
```
- 頭部装飾（被り物）を外したい場合はネガティブに `nun headdress, headwear` を追加するか、`scapular, cassock, habit, black dress` などベール以外の要素を個別指定する
- マント/リボン状の装飾はDanbooruで近いキャラのタグを流用すると再現しやすい（例: `cape, magical girl, pink feathers`）
- 鬼の角は `oni` タグで出せる。`oni girl` のつもりで `onigiri` と打ち間違えるとおにぎりが出る事故報告あり
- 局部などを透明化したい場合は `invisible man` の組み合わせが有効（例: `invisible man, large penis`）

## 体型・胸系プロンプト

- 貧乳＋大人顔の両立には `skinny` を入れつつ `narrow waist, tall female` で大人らしさを演出、`small breasts`/`flat chest` はプロンプト先頭付近（`1girl,solo,`の直後）に配置、`narrowed eyes` や `red lips` で大人びた表情を作る。Tsubaki2系では年齢を `40 years old` など高めに指定する手法も紹介された
- 垂れ乳（長乳）は `hanging breasts` でおおむね再現可能。低い位置の乳にしたい場合は `sagging breasts` を強めにかけるか、`sagging breasts` に `pointy breasts`・`perky breasts` を加えつつ服で根本を隠して `breasts out` させ、正面から疑似的に垂れて見えるようにする方法が挙がった
- 極小面積の垂れ布衣装（魔王パム風）は `breasts curtain`、股間も隠すなら `crotch curtain` を追加。さらに布面積を絞るなら `narrow breasts curtains`

## 性描写・性器系プロンプト

- 挿入のほのめかし表現の使い分け： `implied sex` は「挿入してそう」というほのめかし止まりで、露骨な構図には効果が薄い。`deep penetration` は挿入の深さを明示するため逆に竿（penis）がはっきり描写されやすい。深挿入・密着を狙うなら `balls deep` が最も有効だが、玉が増殖したり女性側に玉が生えることがある
- 根本まで挿入した密着構図が安定しない場合、`implied sex` にネガティブで `penis` を入れると直接描写を避けつつ奥まで入っているように見せられる。ネガティブの `penis` を弱め（`(penis:0.8)` 程度）にかけると、huge penis指定と密着構図を両立できたとの報告
- 舐める描写のバリエーション：先端をチロチロ舐める程度なら `lick, licking`。舌をベタッと当てる描写は `sucking, inhaling` で吸わせつつ少し舌を出させる、または `licking` + `on_cheek` の組み合わせが有効。実例:
```
lick, licking penis, penis on cheek, inhaling, handjob, kissing, licking penis on vein,
```
- Mating press（種付けプレス）構図は横長キャンバスにし、`open legs` を入れてプレス以外の呪文を極力削ると安定する。実例:
```
playboy bunny,
sex, hetero, splead legs,lying, on back,
1boy, mating press, boy on top,
from behind…
```
- ふたなり×mating press系の実例（cum_overflow等併用）:
```
2girl, multiple_girls, futanari, futa_with_female, mating_press, deep_penetration, ahegao, grin, scared, drooling, sweat, cum_overflow, missionary, lying_on_person, from_back, from_behind, from_...
```
- オナホは danbooruタグでは `onahole` ではなく `artificial_vagina`。単独プレイなら `futanari_masturbation`、二人プレイなら `handjob` + `used_artificial_vagina` の組み合わせが有効。ただし精液がオナホ本体から吹き出す・子宮脱のような誤生成が起きやすく、`sex_toy` や `penis` と誤認されている可能性がある。参考プロンプト:
```
1girl, solo, futanari, pussy, artificial_vagina, handjob, used_artificial_vagina,cum_overflow, cum_in_pussy, rolling_eyes, annoyed, whistling, parted_lips, motion_blur, motion_lines,after_vagina...
```
- フタナリで玉なしを狙う場合、`intravaginal futanari` に `no testicles` を加えても安定しないとの報告（未解決）
- 尿道責め（尿道オナ）はLoRA＋トリガーワード調整でも再現困難。尿道イキ指定をしても潮吹き・仰け反り絶頂の絵にすり替わりやすい
- 触手・機械姦でX線的な断面描写（`x-ray view`）をさせるとtmp（男性器）が誤って混入しやすい。学習データの断面図素材の大半がtmp由来のためと推測されている。女性器由来の断面図は無理やり自作しても再現度が低い

## サービス・ツール比較

- PixAIの動画生成はエロ目的では品質がいまいちでポイント消費も大きく、試行回数を増やしにくい。過去にセンシティブ動画機能自体が停止された経緯もある
- ChatGPT/GeminiはNSFWに厳しく、工夫しないとテキストですら拒否されやすい。無料版と有料版の差は主に生成枚数・アップロード枚数・チャット量の上限で、精度自体に大差はないとの意見
- ログインせずに使えるGeminiでエロプロンプトを出す運用も報告されている。Danbooruタグ生成の精度はどのAIを使っても専用モデルでない限り大差ないとの見方
- Grokは規制はあるものの他サービスより比較的寛容。局部露出さえなければ際どい水着でも通りやすく、タトゥーの再現精度も高いとの報告
- ComfyUIではLoraManagerのLoraStackerが便利。トリガーワードごとLoRAを一括で切り替えられる

## 生成トラブルシューティング

- 同じプロンプトでも指定していない褐色肌キャラなどが出る場合、肌色・耳の形など「未指定の要素」はAIが自由に補完するため、それが原因になりやすい
- 裸・裸足を明示的に指定してもハイヒールやサンダル、服の一部が生えてくる現象が報告されている。`standing` を入れると特に服が生えやすくなり、`no high heels` をネガティブに入れても完全には防げないケースがある
- LoRAのトリガーワードを胸や尻の強調目的で追加すると、他のプロンプトの効きが悪くなったり画面が崩壊することがある。プロンプトは要素を絞り、構図確定後に体の状態を追加する順番が推奨される
- 画質向上目的で手癖に入れているクオリティ系タグがLoRAの効きを悪くすることがあるため、プロンプトはシンプルに保つのが無難
- 生成キャンバスの縦横比によって構図の主役が変わる（縦長なら手前の要素、横長なら背景寄りの要素が強調される）。複数人物を1枚に収めたい場合はキャンバスを大きめ・比率調整すると分離しやすい
- 複数人物の描写はStable Diffusion系モデル全般が苦手。Regional Prompterを使ってもLoRAが混ざる・破綻するケースがあり、確実な方法としては背景を1枚生成してからi2i＋インペイントで個別配置していく手法が挙げられている
- 羽根や角など特定パーツのタグを強めすぎると、そのタグの影響が本来の位置（背中など）からズレて出ることがある。関連タグを増やしすぎず最低限に絞るのが無難

## その他小ネタ

- 洗面所を `bathroom` で指定すると海外の感覚で風呂場が出てしまう。日本の洗面所感を出すには `sink` の方が近い
- NovelAIで絵柄プロンプトに「style」という単語を含めるかどうかで再現度が変わることがある（要検証、未解決のまま）
- Writening/ファイルなうは登録不要ですぐ使えるため、長文プロンプトや画像の一時共有先として定番
- Danbooruタグからのキャラクター再現は、人気キャラなら基本キャラタグ＋最低限の服装タグで概ね再現可能。マイナーキャラは有名キャラの髪型・色を変えて代用する手法も紹介された

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part20（本文中に次スレリンクあり、URLは本文抽出では取得できず省略）
