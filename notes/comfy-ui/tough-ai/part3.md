# えっちなAIイラストスレ part3 まとめ

元スレ: https://bbs.animanch.com/board/6541658/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 胸サイズ表現（補足）

- 強調なし基準: `large`=手に収まるサイズの巨乳、`huge`=手に収まらないサイズの爆乳、`gigantic`=顔よりデカいサイズ、との認識報告
- モデル・LoRA依存で効き方バラつく。hugeでも大きくならない/largeでもデカすぎる、両パターンあり→少しずつ調整必須
- パイズリ量産する勢は結果的にhugeよりlargeの方が丁度いいとの声も
- 現実的な巨乳狙うなら`medium`が丁度いい（AI絵は一回り盛りたがる傾向あるため）

## 縛り・拘束系

- `kikko shibari`/`tortoise shell bondage`（亀甲縛り）→高確率で亀の甲羅を背負った絵になる誤爆報告多数。外して他の縛りプロンプトのみにするのが無難
- 後ろ手縛り: `arms_behind_back`が基本。ただし片手を両手で掴んでる関節技状態になりがち→`guided_arms_behind_back`（誘導する表現）に変えると改善。Danbooruタグ`arm held back`は腕掴み後背位専用
- 大の字磔（X字/キ字架）は狙っても高確率でM字開脚拘束になる、との報告あり（解決策なし）

## 肌質感・ディテール

- 肌の質感アップ: `shiny skin`, `body blush`
- `detailed hands`/`detailed eyes`系クオリティタグは効果体感薄い、焼石に水との声。手修正LoRA使っても劇的効果は曖昧
- クオリティタグを他所から寄せ集めて大量投入するとタグ同士がバッティングして足を引っ張り合う→最小限から始めて少しずつ増やして効果検証が推奨
- illustrious系はi2iを重ねると手が自然に綺麗になる傾向

## 陰毛・体毛

- 陰毛を消したい: 手動で肌色に塗りつぶし→i2iで仕上げが定番
- ネガに`pubic hair`入れても効かないことがある（運ゲー）
- 陰毛一本くわえ表現: 狙って出すの非効率、自分で書き足す方が早いとの結論。ネガで下の毛だけ消す工夫も一応あり

## プロンプト順序・構文Tips

- プロンプトは**上から順に処理**される→キャラA/Bを隣接して書くと混ざりやすい。混ざる時はキャラ間に別プロンプト挟むと軽減
- カンマ後の空白・改行は生成結果に**一切影響しない**（人間の可読性のためだけ）。重要なのは書く順序
- `masterpiece`は先頭に置くのが良いとの指摘（後方に置くと効きにくいとの体感）
- style系LoRAのトリガーワードは先頭に置かないと発動しないことがある

## モデル比較（2026/03時点、illustrious/NoobAi系派生）

- Haruka2: 破綻しにくいが絵柄の変化に乏しい
- Tsubaki2: 自然言語対応、複数キャラいける、コスト高め
- WAI-illustrious: 安定・更新頻繁
- Nova anime xl: 更新頻繁、Novaシリーズ内で選択肢多い
- NoobAi: ピーキー、使いこなせれば強力
- JANKU: 更新頻繁、NoobAiよりマイルド
- Obsession: 使いやすくなったNoobAi系
- NTR MIX: NoobAi+Illustriousの中間、更新終了済み
- WAI-Branch-Rouwei: WAI混合でマイルド安定
- 今どきの人気ILモデルは大体NoobAiが混ぜ込まれている
- 新規格モデルの一発目は「ベースを超えるベース」＝暴れ馬。使いやすい派生モデルは後発の有志が作る、というのが界隈の慣例

## Anima（新興ローカルモデル）

- 画風制御はまだ難しい（登場間もないため発展途上）
- プロンプト読み取り能力はillustrious系列より優秀。似たキャラを複数描いても安定
- 百合の受け攻め制御は苦手→役割を英文で入念に指定すればある程度安定するが手間大、気軽にガチャれない
- 生成時間はかかる。将来性込みで評価する声多い
- ふたなりで小さい方を攻めにする指定、Animaでの打率は6〜7割程度との報告

## 複数キャラ処理

- SDXL系（illustrious等）で複数キャラそれぞれに別の指示を出すのは基本ギャンブル。ただし感情表現（気弱系→泣く、強気系→怒る）は学習データの相関強く出やすい
- 対照的属性（大男×ロリ等）はillustriousでもそのまま出やすい
- 似た属性同士を並べたい→regional prompter等の領域分け拡張を使う
- 領域分けできない絡み合い構図（百合等）→SDXL系は無理、Tsubaki/NovelAI/Flux/Lumina/Animaを推奨
- Latent Couple機能でも複数キャラ対応可
- NovelAIはキャラ別にプロンプト設定できるため複数キャラの混線・役割入れ替わりが起きにくい（月額は高い）
- PixAIでキャラの表情を個別指定できるのはTsubaki（自然言語系モデル）のみ
- 2girl指定で意図しない3人目が湧く不具合報告あり
- 複数人を横並びにしたい場合、1人ずつ出力して並べてからi2iで馴染ませる荒業も有効
- ハーレム（男1女4等）はNAIキャラボックスでも収まりきらないことあり→妥協してインペイントで追加、`girl sandwich`/`harem`タグも一定効果あり、side-by-sideで並べてから竿役をインペイントする手法も

## 体位・プレイ系プロンプト

- 触手プレイ: `(tentacle coil around breasts:1.2), nipple tweak, nipple stimulation, (tentacle grab breasts:0.7)` + 触手補助LoRA併用。変形強調は`deep breast compression, soft flesh deformation`追加。巻き付き面積必要なため貧乳キャラには効果薄い（失敗すると乳首にリング状に巻き付くだけになる）
- 69: `2girls,69,yuri,cunnilingus` + 好みの体勢を追記。奇形化しやすいので試行回数を要する
- 脇見せ羞恥: `arm pit, arm behind head, embarrassed`
- パンツ関連: `panties aside`（脱がさず横にずらす）、`panty pull`（途中まで下ろす、太腿で止める）、`no panties`（露出/公然羞恥向き）。`panty pull`/`clothes pull`は衣服が増殖するバグ報告あり
- 残像・複乳表現: `(bouncing breasts, afterimage, motion blur, multiple breasts:1.5)`程度が目安。強度3で乳4つ、3.5で乳6つになるほど暴走するので数値注意。`bouncing breasts`単体でも複乳化することがある
- ダンス表現: `dancing, dynamic pose` + `belly dancing`/`samba`等具体的ジャンル追加。視点は横やや見下ろしなら`from side, from above`、`profile`は`from side`よりさらに真横向き
- 股濡れ表現（`juice`回避）: `stained_panties`（ただし血痕と誤認され血染めになるリスクあり）、`squirt`、`spread pussy`、`female ejaculation`、`vaginal secretion`
- 谷間系: `apron between breasts`は効くが`school swimsuit between breasts`は効きにくい→`white school swimsuit, breast out, swimsuit between breasts`で代替可能
- アナル固め: `reverse suspended congress`で一発成功した報告。`holding legs against neck, arms locking neck`等併用
- 生き恥ウェディング: 下着に`nipple cutout`, `breast cutout`でそれっぽくなる
- 乳首サイズ調整（Tsubaki向け例）: `exposed chest,(tiny nipples:1.35),(tiny areolae:1.35),(pointy nipples:1.3),(protruding nipples:1.2),neat nipples, round areolae, symmetrical breasts,soft pink nipples, smooth skin, delicate skin texture,soft shading on chest,elegant, refined` — 流用を重ねると徐々に乳首が肥大化していく報告あり要注意
- 自舐め: `large breasts, soft skin,one hand squeezing her own breast, fingers pressing into soft skin,kiss to her nipple,kiss to her own body`
- 小さめ乳首が反映されない: `small nipples, small areolae`は弱い→ネガに`huge nipples`追加、それでもダメなら乳首slider系LoRA頼み（学習素材不足の可能性）
- flat chest + erectile nipples の組み合わせ好評
- ボテ腹（デベソにしない）: `pregnant`タグ使わないとデベソにならない傾向

## リョナ・凌辱系プロンプト（作中共有そのまま）

- バッドエンド/心が折れた表情: `(hopeless laughing), bad end, derangement, frenzy, (sit on floor), both hands on floor, backing away, on floor, weakness, (before rape), (before sex), (dying), (drooling), front of stone wall, stone prison, dark room, empty eyes, narrowed eyes, blank expression, (teary eyes), tears on face, (crying), (fearful), (wince), (dispair), ((hart broken expression)), parted lips,(painful), agony,(sweating), (trembling)` — `drooling`外すと口元の「人生終わった感」が落ちる
- リョナ全般: `rough_sex, constricted_pupils, injury, torn_clothes, clenched_teeth, bruise, tearing_up, scared, bite_marks`
- ゴミ捨て場ヤリ捨て事後例: `open shirt,alley, trash bag, rain,bare breast, scared, crying with eyes open, rolling eyes, blank stare,uneven eyes, heavy breathing, :o,pout,open mouth, pubic hair,(very tired:1.6), tired hair, messy hair, from above, nsfw,(lying on back:1.5),(lying:1.5),overhead shot,1girl, shade,(bottomless:1.3),after sex,(cumdrip:1.5),(bukkake:1.5),cum, trembling, intense cum, hearts, overflow`
- 上記の改良版: `wide shot`追加、`spread legs, (cum on body, cum on hair:2.5),wet clothes,(leaning back:1.5),(tally,body writing:1.5), used condom`を追記

## 背景・構図

- 背景に馴染ませる: 行為プロンプト（`sex from behind`等）＋風景プロンプト（`autumn, forest, dam`等）＋キャラ位置指定（`two are positioned towards right side of illustration`のように中央以外を指定）の組み合わせが有効
- ControlNet: 3Dソフトや現実で人形にポーズ取らせた参照画像（拾い画像でも可）を使うと狙ったポーズのガチャ成功率が上がる
- NovelAI精密参照: 強度・忠実度は数字クリックで1以上に設定可能、1.5〜の値を試す価値あり

## LoRA・モデル運用

- 画風LoRA＋キャラLoRA併用時、同強度だとキャラの学習量次第で画風側が負けて元の画風が勝つことがある→画風側を強度4〜5まで下げる調整が有効
- PixAI自作LoRAは非公開設定可能（投稿しなければ他人に見えない仕様）
- PixAI: LoRA毎月3個までスタートプランで無料作成可
- PixAI: 公開LoRAは他人が使用するとポイント還元される（1事例: 20k使用者で20万ポイント）。エロLoRA自体の公開は規約上OK、ただしサンプル画像でセンシティブ表示するとNG
- PixAIのモデル/LoRA配布欄には、ローカル勢が使う配布サイトのURLを直接貼ってDLできる機能が実装済み
- 画像1枚からプロンプトを逆生成する機能もPixAIにあり（image-to-prompt）

## ローカル vs PixAI/NovelAI/クラウド

- forge推奨理由: 生成画像にプロンプト・生成環境が丸ごと埋め込まれる→後から履歴を追いやすい（プロンプト試行錯誤の記録に有効）
- PixAIの中身もStable Diffusionベースのチューンに過ぎない→大体のことはローカルでも再現可能だが手間は大きい
- PixAI Reference Proの中身はNano Banana Proという説（真偽不明）。その影響でムフフ要素が弾かれやすいとの声
- Geminiでキャラクターシート的なものは作れるが精度・クオリティはPixAIより上、こだわりなければGemini推奨との意見
- Radeon（AMD）グラボでもローカル生成は可能との報告あり

## PixAI課金

- 年間プランはセール時が狙い目
- 生成ターボ目当てだけならスタートプランで十分。動画拡張機能が欲しいならプラスプラン以上必須（スタートには無い）
- クレジット消費バランスは動画生成で特に激しい

## その他小ネタ

- highleg panties タグの存在
- 星条旗ビキニ、金ビキニ、金マイクロビキニは評判良好
- Geminiでセンシティブ画像は基本弾かれるが、工夫次第でそれっぽい生成は可能との報告（詳細な手法言及なし）
- PixAIは2023〜24年頃はセンシティブ画像だらけのカオス状態だったが、現在は健全サイト路線に転換済み
