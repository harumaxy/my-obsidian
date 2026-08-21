# えっちなAIイラストスレ part6 まとめ

元スレ: https://bbs.animanch.com/board/6616084/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部アップローダー（d.kuku.lu等）へ、性器はさらにモザイク処理必須
- モザイク加工ツールとして `www.oh-benri-tools.com` が紹介されている
- サムネ隠しの小細工（1枚目をダミー画像にする等）は、複数ファイルをまとめてリストアップロードすればサムネ自体が表示されないので不要という情報あり
- 画像ではなく文字（プロンプト）だけ貼りたい場合は `writening.net`（テキスト共有サービス、登録不要でURL発行）が使われている

## 背景・構図の一貫性問題

- 複数枚生成すると部屋の壁色・家具・ベッド位置がバラつく問題が頻出。対策としては以下が挙がった
  - アングルを変えて背景を最初からぼかす
  - `(任意の色)room` で色を指定して統一感を出す（それでもバラつくことはある）
  - `white room, white wall, plain wall` を入れても壁材が微妙に食い違うことがある
  - いっそ `white background`, `transparent background`, `blank background` で背景自体を消す
- セリフ入りの一枚絵に仕立てようとすると背景のパースや装飾の細かい不一致が気になりやすい。pixivのAI絵に背景真っ白が多いのもこれが一因ではという指摘

## 表情プロンプト（絶頂・アヘ顔系）

感じている顔のバリエーションを求める質問に対して集まった回答:

```
(closed eyes) in heat,
shy, embarrassed, full face blush,
flustered, orgasm, embarrassed,
wavy mouth, tightly, clenching jaw,
```
- `in heat`=発情、`full face blush`=顔全体赤面、`flustered`=取り乱し、`wavy mouth`=震える口元、`clenching jaw`=歯を食いしばる、という訳が付けられている
- 絶頂表現には `screaming` が有効（ただし画風によってはセリフ・吹き出しが勝手に生えることがある）
- `out-tongue`, `crying`, `empty eyes` の組み合わせ。必要に応じて `rolling eyes` を少量足す。`rolling eyes` は単体だと過剰なアヘ顔になりがちなので慎重に
- `wistful face` は和姦・凌辱どちらにも使え、他の表情と組み合わせで「もっと激しくして欲しい」的な雰囲気を出せる
- `fucked silly, puckered lips, heavy breathing` の組み合わせで、顔面崩壊・舌出し白目を避けつつビクビクいく様子を表現できる
- `constricted pupils`（瞳孔を小さくする）も有効
- 表情を見せたくない場合は `head back` や `covering face` で"モノ扱い"的に処理する手もある
- `torogao`（とろ顔）も使用例あり

## PixAIモデル運用・NSFW設定

- プリセットモデルの多くはネガティブプロンプトに「NSFW禁止」的なタグがこっそり含まれている。ネガティブプロンプト側を編集すれば完全に除去できる（無料でも可能）
- Tsubaki 2はプロ版にするとネガティブプロンプトが閲覧でき、NSFW除外タグは含まれていないためライト版のままエロ生成が可能
- 個人作成モデルはそもそもNSFW除外タグが入っていないことが多い
- プロンプト自動変換機能のON/OFFは、タスク詳細を見るとどう変換されたか確認できるので、それで判断すると良い
- 生成が不安定な場合、LoRAは強度を下げすぎず0.7程度を保ち、プロンプト自体を短くコンパクトにまとめてLoRAの持ち味を活かす方向で誘導する方が安定するという意見
- 強調構文 `(word:1.2)` のような数値指定は普通に効く。複数キャラがいる場面では効きすぎて邪魔になることもある
- 年齢操作（loli/mature）、毛量変更、複合表情から一つだけ強調したい時などに強調構文が有効

## LoRA運用のコツ

- 特定絵師風にしたい場合、LoRA未使用でも出るような絵柄はLoRAの影響が薄れるので避けた方がよい
- キャラクターLoRAの質が悪い時はアーティストLoRAで補う手がある
- 同一LoRA・同一プロンプトでも生成ごとに顔の崩れ方が変わることがある（原因不明、ガチャ運要素）
- 特殊性癖はプロンプトの強調だけでは限界があり、安定させるには専用LoRAが必要という意見が複数

## キャラクター固定・参考画像機能

- 「参考画像」機能は構図・ポーズの参考に使うもので、キャラクターの固定には向かない（その構図から動かなくなりがち）
- キャラクターを固定したいなら「キャラ参照」機能を使う方がよい（それでも細部のブレは残る）
- 好みのキャラができたら、量産・厳選してLoRA化するのが結局の近道という意見

## 男性キャラ（竿役）の扱い

- 男の顔がキモくなる問題への対処として、ふたなりや触手に逃げる人もいる
- 男の表情が女性側に感染したように崩れる（アヘ顔化する）問題への対策
  - `happiness girl` / `sadness man` のように正反対の性質・表情語を入れてプロンプトの意図しない伝播を防ぐ試み（成功率は不安定）
  - 専用LoRAを使う
  - 見せたくない部分は `frame out` させる
- 顔なし男性のプロンプト例:
  ```
  1boy, generic boys, no eyes, no nose, mouth only, faceless, blank face, featureless face
  ```
  （まれに顔ありになるが基本的にはこれで対応可能）
- `faceless male`／`faceless men` は効くが、逆に「男を必ず描け」という圧が強くなり構図の自由度が下がる可能性が指摘されている
- 竿役だけ見せたい場合は一人称視点（POV）にする方法があるが、POVだと男が寝転ぶ構図になりがちで、立位を指定すると崩れやすい
- 男を透過・幽霊化する試み: `(flame out man), (girl and invisible man having sex), (invisible man), (translucent man), (spectral man), (glass skin man), (glass body man), (phantom man), (translucent body man)` を全部入れてもそこまで透過率は上がらない（学習データにない組み合わせだと逆にmanが強調されるだけという分析）
- 竿役がデブ・色黒になるのを防ぎたい場合、ネガティブプロンプトに `fat man, ugly man, dark-skinned man` を入れる
- 竿役の見た目に構わないなら、NTR設定として割り切って黒人化する開き直り案も出た

## 体位・アングルのトラブルシューティング

- リバースフェラチオでの口元ズレが調整できない問題。`lying on sheet, lying on side` 系はなかなか反映されず苦戦（`(EyesHD:1.2)` 等の品質タグと組み合わせても難しい）
- POV視点で男性を立たせたい／椅子に座らせたい場合、`penis out of frame` を使っても男性の姿勢がアクロバティックになりがちで解決が難しい
- 触手による産卵・卵出産表現
  - `egg in pussy` だけでは不十分という報告
  - `gibing birth, egg fom pussy, from below, pussy focus` ＋ネガティブに `vaginal` で改善したとの報告
  - `eggs, egg laying`（egg lyingではない点に注意）
  - 強調構文を使った例: `(the girl giving birth the tentacle's eggs:1.6), (huge egg in pussy:1.3)` で安定しないが大きい卵の産卵を再現できた
  - 触手そのものを産ませる試みは150枚規模で試行錯誤しても再現できず、LoRA化かNovelAI移行が現実的という結論
  - 触手出産と触手姦をAIが区別しにくいという指摘あり（生成が難しいシチュエーション）
- 舌を「べっと」出す表現は `tongue out` だけでは弱く、`tongue out, closed mouth, :p` の組み合わせでガチャを回すのが良い
- ハイレグの過剰な食い込み表現:
  ```
  Super high leg cut, wedgie,
  exposed_labia major, partially visible vulva, hip joint, groin, crotch outline, pussy outline
  ```
  `Super high leg cut` で角度を急にし、`wedgie` で食い込ませ、外陰部強調タグ群で仕上げる構成
- 逆に浅い食い込み（ロリ系コスチューム等）を出すのは難しく、`low leg` を試しても効果薄。`(wedgie:0.6)` のように強度を下げて調整する案が出た
- チン嗅ぎ（顔を局部に近づける）表現は「顔を寄せる」程度は出せるが、`precum` が鼻先に付くレベルまで密着させるのは難しく、`close to〜` はあまり効かないとの報告

## 衣装・シチュエーション定番プロンプト

- 穴あきビキニアーマー: `cupless`/`crotchless` だけだと上半身が完全なトップレスになりやすい。`nipple cutout, pussy cutout` の組み合わせで改善したという報告
- お風呂・タオルシーン: `naked towel` だけだと複数のハンドタオルを巻いたような浴衣状になることがある。布団を意味する `under covers` にtowelを加えると改善
- 密着で自然に顔を隠す: `hugging tightly`
- 拘束衣は英語で `straitjacket`
- コンドームベルト系: `Condom Belt`、`used condom, condom belt, multiple condoms, belt buckle`
- 教師コスプレ×エロ衣装の合体例:
  ```
  alternate costume, teacher, glasses, red-framed eyewear, hairclip, fishnet top, midriff,
  black jacket, open jacket, navel, black bra, mini skirt, black garter straps, black lace panties,
  ```
  飽きたら `see-through bra` / `see-through panties`、さらに `nipple cutout` / `crotchless panties` で味変
- 祭り衣装: `japanese festival, shrine, happi, nejiri hachimaki, fundoshi`
- ウェディング系: `wedding dress, micro bikini, showgirl skirt, bridal veil, cleavage, navel, necklace, long gloves, thighhighs, frills, embroidered, laces, jewelry, flower accessory`
- ドレス系: `evening gown` が高評価
- ハーレム系: `harem outfit, see-through`。着ぐるみに `wet` や `very sweaty` を足すとムレムレ演出になる
- 豹柄下着: `leopard print lingerie`
- 触手責め背景: `tentacle pit, tentacle floor, tentacle wall`（緊縛系プロンプトと合わせると拘束表現が強化される）
- B地区（乳輪・乳首）を隠しつつ胸の形は見せる表現: `no nipples, no areolae`

## 漫画的コマ割り表現

- `multiple views` や `comic` を入れるとコマ割り風の構図になりやすい
- 謎の文字・吹き出しが混入するのを防ぐには、ネガティブに `text`, `speech bubble` を入れる、または `comic` の代わりに `silent comic` を使う
- `multiple views` は変になりやすい部位（手など）も複数化するリスクがあるため注意（手が4本5本に増える事故が起きやすい）
- 同時に実現不可能な複数シチュ（立ち絵＋種付けプレス＋事後の舌出し等）を一括で詰め込むと、AIが構図を分割してそれぞれを再現しようとする現象が報告されている（定番の分割構図パターンなら雑なプロンプトでも起きやすいとのこと）

## Gemini/Grok活用術

- Geminiにエロプロンプトを直接要求すると拒否されやすいが、「danbooruでこういうタグを調べてほしい」という体で下手に出ると徐々に協力的になっていくという体験談（口調の工夫でガードを下げる）
- 既に形になっているプロンプトの「添削」なら比較的抵抗なく応じてくれる傾向
- 画像からプロンプトを生成するツール `anifun.ai`（Free Image to Prompt Generator）を使い、参考イラストからプロンプト化 → Geminiに「背景・ポーズ情報を除去してキャラクター情報だけ抽出しろ」と指示 → 別途シチュエーション画像も同様に処理 → 両者を合体、という手順で狙ったキャラ×シチュのプロンプトを作る手法が紹介された
- 公式のシンプルな立ち絵から抽出する方が精度が高い傾向
- 生成後に不満があれば「この要素を追加しろ」と繰り返し指示して詰めていくワークフロー
- 海外BDSM系hentai画像からPixAI用プロンプトを作らせる用途では、Gemini Pro（thinking/canvasモードではなく通常のPro）の方が精度が高いという報告。canvas外で聞くと通しやすいとのこと
- Grokは通常版は規制が厳しいが、X（Twitter）上のGrokは緩いとの報告あり（差の理由は不明）

## 参考サイト・ツール

- danbooru.donmai.us（タグ検索の定番）
- NoobAI-XL 1.0のアーティストブレンド解説: dskjal.com
- nax.moe
- Anima 2B Style Explorer（thetacursed.github.io） - Anima 2Bモデル用に2万種以上のアーティストスタイルを視覚データベース化、Danbooruアーティスト比較・プロンプトコピー可能
- AIBooru（aibooru.online） - AI生成画像専用のbooruサイト
- Writening（writening.net） - プロンプト文字列を画像化せず共有できるテキスト共有サービス
- Free Image to Prompt Generator（anifun.ai） - 画像からプロンプトを逆生成
- PixAIモデル例: `https://pixai.art/ja/model/1902584965072384866`（食い込み系に強いLoRA）

## その他小ネタ・トラブルシューティング

- センシティブ判定を回避できてしまう単語（例: `penetration`）で検索すると、本来非公開にすべき過激な画像が意図せず公開状態のまま見つかることがあるとの報告。センシティブタグの判定漏れに注意喚起
- 絵柄再現について: Danbooru掲載枚数がそこそこ多い絵師名であれば、PixAIのtext-to-imageでもポン出しで絵柄を再現できてしまう（具体的な絵師名や画像を大っぴらに出すのは避けるようにという注意付き）
- スレ内で「クオリティが高い/低い」のような曖昧な基準でサービス間・ローカル/クラウド間の優劣を煽る書き込みには要注意という指摘。過去に他板で同種の対立煽りからスレが分裂・消滅した事例が語られている
- 動物耳＋尻尾系キャラは、他パーツの再現度に気を取られて尻尾の存在を生成側が忘れがちという指摘

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part7 https://bbs.animanch.com/board/6645068
