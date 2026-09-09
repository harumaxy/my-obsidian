# えっちなAIイラストスレ part2 まとめ

元スレ: https://bbs.animanch.com/board/6523378/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## モデル/サービス選び

- PixAI: `VXP_illustrious (low cost version)` 安い（1400クレジット vs 通常3000〜4800）。下書き・構図確認向け。品質求めるなら人気モデル推奨
- danbooruタグ検索: 珍しいポーズ・小物は先にdanbooruで似た絵探してタグ確認が近道
- Illustrious系: 出現1年超で安定。anima/Tsubaki等新モデルはまだ様子見段階（26/03時点）
- pixai産画像はメタデータ載らない、あにまん投稿もJPG変換でメタデータ消える → 学習元探すなら他所の掲示板が早い

## プロンプト構文Tips

- PixAIは`BREAK`構文・`woman left:`/`foreground:`等の領域指定構文は**効かない**（NAI用構文の流用不可）
- NAI複数キャラ: `{2girls_A_and_B,}A_girl_have_〇〇,B_girl_have_〇〇,`で表情/ポーズ分離可能な場合あり
- NAI絵柄ブレンド: `-2::artist collaboration::`を入れないと「1絵師1キャラ」の合作絵みたいになる
- 絵柄ミックス人数: 3〜5人が無難（6人以上で破綻増）、強度は0.2〜0.8目安
- 参照画像使うなら正面だけでなく複数アングル撮って3面図合成、忠実度/強度は数字クリックで1.5〜2まで上げ可能

## 背景系プロンプト

- 露天温泉: `outdoors, onsen, wooden fence, wooden house, water surface, steam, nature` + 季節タグ
- 水面隠し: `(opaque water, blue water:1.5)`で水面濁らせ下半身隠す。眼鏡濁らせるなら`opaque glasses`
- 湯の深さ調整: 正/ネガに`navel`/`thighs`/`knee`を使い分け
- 部屋を空にしたい: `empty room`
- スク水系: `locker room`

## セリフ・効果音

- AIは日本語テキスト苦手→ネガティブプロンプトで吹き出し自体をブロックし後からアイビスペイント/メディバンで描き足すのが定番
- セリフ位置の目印としては`speech bubble`

## 性癖別プロンプト（作中で共有されていたもの、そのまま）

- 喘ぎ声: `orgasm`, `screaming`, `moaning`
- レイプツリー: `tree are heavily laden with numerous soiled women's undergarments`, `hanging limply from the branches`
- クリボックス/クリリード: 学習データ絶対量が少ない特殊タグ（クリリードは70〜100枚程度と推定）、反映されにくい
- 白濁大量: `cum_on_○○○`を部位ごとに全部列挙+強調が有効。lora使うなら「cum slider」系
- マジックミラー構図: `against_glass`, `breast_press`, `breasts on glass`
- ウェッジー: `wedgie`単体だと食い込み止まり→`hanging_wedgie`や`suspension`系タグ併用
- だいしゅきホールド: `leg lock`
- 陰毛一本くわえ: `stray pubic hair`
- アナル周り調整: ポジ`(anal:0.8)`+`excessive cum overflow from anal`、ネガに`deformed anus, puckered anus, dark anus`
- スリングショット水着(乳首だけ出す): `nipple cutout` + `slingshot swimsuit`（`crotchless`はオメコまで開くので不要なら外す）
- 足ぶらぶら: `hanging legs`

## 絵柄・画風

- 手描き風: `traditional media`（ネガに`border`推奨、枠が出やすい）
- 古い雑誌風で質感アップ: `megami magazine`, `1990s (style)`, `official art`, `cel shading`, `anime coloring` — 特に`official art`は無条件で品質上がる感触あるとの報告
- リアル質感+アニメ顔の最近流行り絵柄は旧世代モデル(SD1.5等)の絵柄由来という説

## 光源・色味の注意

- `lighting`系タグは潜在空間的に無彩色の白に寄りやすい→光源描写が明確でない限り多用しない方がいいという意見
- キャラの色味崩れはアーティストタグの影響が大きい

## その他小ネタ

- Grok: 個人情報使わず画像編集(剥ぎコラ)の下ごしらえに使う人あり。ただし際どい表現は弾かれる
- ローカル環境はComfyUI一強、reforgeから移行できず苦戦する声も
- PixAIで複数キャラ絡み目的ならDiT系モデル必須、SDXLベースはほぼ無理
- モデル特有の学習lora混入で「その漫画家キャラ寄り」になる問題→lora強度下げる/自前loraを画風逆コンパイルして作るのが対策
- danbooru閉鎖懸念に対し「pixivで訓練すればいい」「ローカルにモデル/lora待避すればいい」との声

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part3（あにまん掲示板）
