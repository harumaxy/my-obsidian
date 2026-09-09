# えっちなAIイラストスレ part4.5 まとめ

元スレ: https://bbs.animanch.com/board/6581822/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 画像は https://d.kuku.lu/index.php 経由推奨。2枚以上まとめてアップしないとサムネが表示されアウト判定になる
- 局部が写る系はモザイク処理必須。無修正は自粛推奨
- 乳首・性器・性行為描写・排泄物・R18は掲示板ルールで禁止

## 衣装系プロンプト

- ふんどし: `fundoshi, traditional, topless`
- メイド発展形(肩布だけ残し胸出し): `topless, (unconventional maid, maid headdress, black shrug (clothing), white collar, puffy short sleeves, white wrist cuffs, g-string, thighs)`（`shrug`単体だと「肩をすくめる」動詞と誤認識される）
- 魔法少女系: `magical girl`, `crop top, breast curtains`
- 露出0のフリフリ服: `Baroque Lolita, long dress, tiered dress, frilled dress, cross-laced dress, sleeves past wrists, very long sleeves, ruffled sleeves, full bonnet, hair bow, large bow, small bow, hair flower, layered ruffles, ribbon, ribbon lacing, glove`
- 上記に`huge breasts, exposed breasts, breast slip, breasts out`を足すと胸だけ露出させられる
- 裸エプロン発展形(胸の間に挟む): `apron (head between breasts)` — ただし手で胸を押さえるだけの絵になりがちとの報告あり

## 胸を丸出しにするコツ

- `open front see-through shirt`ではなく`open front, see-through shirt`とカンマで区切る
- `breasts out`を入れる
- `nipple slip`は「乳首チラ見え」の意味なので丸出し目的なら入れない
- 他の手法: `(exposed shoulder, off shoulder, breast slip, breasts out, unbutton, shirt slip:1.3)`、または`(exposed chest), (breasts out), (underbust)`
- 強調表現`()`や`:数値`を使わないと反映弱い

## 絵柄・スタイル指定

- danbooruで好みのスタイルをまず1つ検索して決め、そこから絵柄・色味・塗りの近い名前を2〜3個追加していくのがコツ（増やしすぎ＝3個超えると平均化して薄まる）
- Illustrious/anima系はプロンプトに絵師名を入れるだけでスタイル調整可。danbooru投稿数100〜200以上ないと反映されにくい
- モデルによっては`artist:名前`のプレフィックスが必要な場合あり

## 体格差・身長差

- 身長を数字（`190cm`等）で指定してもAIはほぼ無視する
- `size difference`, `tall male`/`tall girl`など学習時に使われた定型プロンプトを使うしかない
- 体格差を直接主張するより`mating press`や`full nelson`のような体格差が出やすい体位を選ぶ方が反映されやすい

## 体位・プレイ系

- 対面座位・貝合わせ系: `crotch to crotch`, `tribadism`
- 3P: 女2男1は`ffm threesome`、女1男2は`fmm threesome`
- 事後の精液: `semen spills out`, `cum in(on) pussy`, `pussy juice puddle`, `after sex`, `spread pussy` — 男性器を消すと非挿入の事後描写が安定しやすい
- 目隠しプレイの表情: `one hand covering eyes` / `one hand sliding over eyes` / `one hand pressed over eyes` + `blushing`
- 見せつけ: `penis awe, looking at penis`
- お風呂プレイ: `nipples, collarbone, hetero, nude, solo focus, 1boy, girl on top, breast press, bouncing breasts, bathroom, mixed-sex bathing, soap`
- ガラス押し付けバック: `breasts pressed against glass`
- ディープキス: `french kiss`（日本語の「軽いキス」のイメージと違い、本来は深いキスの意味）
- とろけ顔・メロメロ表情: `seductive smile`, `lovestruck`, `heart-shaped pupils`
- 可愛い系絵柄のエロ表情: `open mouth, wavy mouth`
- 他人の服を脱がす: `pantsing`, `assisted exposure`, `pulling another's clothes`, `forced exposure`

## トラブルシューティング

- 「開いてもキャラの特徴が別キャラ寄りになる」問題（コスプレLoRA使用時など）: LoRAのトリガーワードから服装以外の要素を削る/キャラの特徴をより詳しく明記する
- 局部が無修正にならず勝手にモザイク・修正がかかる: 自動変換設定がONになっていないか確認（意図せずONになるバグ報告あり）
- センシティブ判定がつくと自分・他人問わずNSFW画像が閲覧不可になる
- 生成結果が急に頭身崩壊・プロンプト無視するようになった場合、自動変換設定の予期しないONが原因のことがある

## ローカル環境（VRAM目安）

- VRAM 8GBはSDXL系だと余裕がなく、hires適用は厳しい。1024x1024, 856x1152, 768x1344あたりから試すのが無難（xformers使用前提）
- VRAM 12GBあれば856x1152のhires2倍・LoRA学習も可能
- 推奨は16GB
- SDWebUIからComfyUIへの乗り換えで同スペックでも生成速度が大きく改善したとの報告あり（RX7600 8GBで1024x1024が高速化）

## その他小ネタ

- クレジット稼ぎ: 会員登録すれば最安プランでも月30万クレジット+デイリーボーナス12000。アプリ版の広告視聴でもクレジット獲得可（Web版と併用推奨）
- 低コストモデルでのプロンプト実験、画像サイズを小さくしての試し生成もクレジット節約になる
- リテイクで結果が大きく変わることがある。一度NGになったプロンプトが再試行で通ることもある
- TS(女体化): LoRAでキャラ指定した上で`1girl, solo`を入れると自動でTSされる。体型・胸サイズ・髪型を明示すると精度上がる
- ロリ/ショタタグの想定イメージがモデルによって想像とズレる場合がある。幼すぎる場合は`small breasts`で調整すると良いとの報告

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part5（あにまん掲示板）
