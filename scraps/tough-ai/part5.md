# えっちなAIイラストスレ part5 まとめ

元スレ: https://bbs.animanch.com/board/6600024/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（kuku.lu等）へ、性器はさらにモザイク処理必須
- モザイクの呪文: `mosaic censoring::,`
- サムネ隠しは2枚以上まとめてアップが基本。1枚目はダミー画像にしておくと安全
- Reverse image検索や自作モザイクツール（ふたばのお兄ちゃん製）を使う人も

## 服従・複数キャラ描写のテクニック

- 2キャラを個別制御: `(characterA:1girl, ponytail, brown hair, school uniform, smile, ribbon tie, necktie grab), (characterB:1boy, black hair, glasses, necktie, flustered, light blush), eye contact,` の形式で`()`を分節、`:`を属性代入として扱う書き方が有効（Tsubaki2で報告）
- モデルによってはこの構文が効かないこともあるので併記して使用モデルを明記するのが推奨
- 竿役が見分けつかない/表情が同化する問題は根強い。Tsubaki2は綺麗なボーイミーツガールは得意だが複数人の描き分け（例: ffm threesomeで表情差）は苦手との報告

## 挿入・貫通表現

- `implied sex`＝「これ挿入ってるよね」というほのめかし。露骨に見えている構図には効果薄い
- `deep penetration`＝挿入の深さを明示する意味合いが強く、逆に竿(penis)がしっかり描写されてしまう
- `balls deep`＝陰嚢が接触するレベルの深挿入を狙うなら一番有効。ただし「玉が接触していること」を優先するあまり玉が増殖したり女性側に玉が生えることがある
- 根元まで挿入させたい場合、上記以外のペニス関連プロンプトは削るか、いっそネガティブに回す方が効きやすいとの意見
- 断面図(x-ray)でちょん切れたペニスになる問題: `x-ray, holding cum, uterus`をベースに`cumdrip, after vaginal, internal cumshot`などを追加すると改善するとの報告
- 事後のコンドーム: `condom left inside, condom on penis, condom pull, after sex`、使用済み: `used condom in pussy`

## 精液・体液表現

- 派手に噴出させたい: `cum explosion`, `cum splatter`、`cum in pussy`や`excessive cum`との組み合わせ、`female ejaculation`でも代用可
- 大人しくなりがちな`cumdrip`だけでは物足りないとの声多数
- 断面図系ぶっかけLoRAの紹介あり（本文に直リンクあり、要検索）
- 放尿: `squatting, spread legs, looking down, arched back, peeing`。仰け反りすぎる場合は`arched back`を弱めるか`leaning back`に変更

## 蛇娘・触手など特殊系

- 蛇娘の細身体型: `lamia, monster girl, snake tail` + `small breast, long tongue`、ネガティブに`foot, leg`とロリ系単語を入れる
- 四肢を呑み込む触手拘束: `on tentacles pit, (many wet tentacles), (swallowed both arms by tentacles wall), (bound arms by tentacles), spread legs, (swallowed both thighs by tentacles wall), (((swallowed fours limbs by tentacles wall)))`
- 乳首をねぶる触手ブラシは再現困難（`tweaked nipples by tentacle brushes`では触手の子供のようなヒル状のものになりがちとの報告）

## タトゥー・落書き

- 判読不能でもそれっぽい文字: `tally`（正の字）が解像度を上げても崩れにくく安定
- 全身タトゥー: `full body tattoo`や`(部位)tattoo`を列挙、専用LoRA併用も有効

## モデル・環境の使い分け

- 質問時は使用モデル（SDXL系/NovelAI/DiT系/Anima等）を併記するのが暗黙のルール。同じ要求でもモデルにより難易度が大きく変わる
- Anima(preview)はStable Diffusion系と学習方式が根本的に異なり、既存LoRAの資産は使えない。英文で直接指示すれば特定ポーズ用LoRAへの依存は減るとの報告。ただしニッチな性癖・ピンポイントな拘りではまだIllustrious+LoRA資産の蓄積に及ばない
- ComfyUI移行に迷う人多数。ワークフローはネット配布のテンプレ利用が基本、拡張機能を増やすとノードがスパゲッティ化しがちでFaceDetailerだけで妥協する人も。当面はA1111/Forge系でも実用上問題ないとの意見
- おすすめモデル例: Hoshino, Haruka, Hinata, Tsubaki, Noob, Pony, Nova Anime, JANKU, hoseki, WAI illustrious
- プロンプト検索・タグ調べ用サイト: danbooru.donmai.us、Anima 2B Style Explorer（thetacursed.github.io、Anima用アーティストタグ確認）、AIBooru（aibooru.online）、NovelAI用はnax.moe、日本語タグ検索は「猿のたまり場」（メタデータ確認・画像圧縮機能付き）

## プロンプトの反映優先度

- プロンプトは基本的に上から順に処理される
- 反映が弱い場合は強弱記号`()`や`:数値`で補う
- 相反する属性（例: ロリ+成熟表現など）を同時に入れると競合してどちらも中途半端になりやすい

## PixAI細かい操作Tips

- ネガティブプロンプト欄はTsubaki2だと「プロ」プラン以上でないと表示されない。Haruka/Hoshinoはプリセットのネガティブに元からNSFW関連ワードが複数箇所（二重）仕込まれていることがあるので要確認・削除
- ベース画像機能（Reference Pro以外）は元絵の雰囲気を残しつつ絵柄変更や手描き修正の馴染ませに使うもので、別物への大胆な加工はできない
- PixAI Reference Proのみ指示通りの大胆な加工が可能
- クレジット節約: Sampling Steps削減、高速化LoRA（SDXL Lightning LoRAs, DMD2, PCM Normal CFG, Hyper SDXL等）、低コストモデル、生成サイズを小さくして実験
- アプリ版広告視聴で5000クレジット×8回/日（時期により変動、要間隔）

## その他小ネタ

- NovelAI課金: PayPal規制強化中、クレカ請求先住所が必要なケースが増加。ultrapay等の一時利用サービス経由で払う人も（詳細はNovelAI 5chWiki課金スレ参照）
- Grok: 露出表現は通ることがあるが本番・四肢切断系はガードが固い。作品/キャラによって生成拒否の基準が不透明（同ジャンルでもキャラ次第で通らないことがある）
- Gemini: エロ画像自体は生成拒否だが、プロンプト添削やdanbooruタグの提案は普通に応じてくれることが多い（思考モード経由や間接的な聞き方で通りやすいとの報告）
- `female`のdanbooru学習量は`woman`よりはるかに多い（伝聞ベース、女性描写での語彙選択に影響との説）
- 着衣 vs 全裸: 全裸の方が服の解釈違いによる失敗が少なく安定するという意見と、脱がし・透けなどの過程を含む着衣エロに魅力を感じるという意見が両方ある

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part6（あにまん掲示板）
