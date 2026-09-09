# えっちなAIイラストスレ part16 まとめ

元スレ: https://bbs.animanch.com/board/6800870/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・ボボパン(性行為)は外部サイト（d.kuku.lu等）へ、性器はさらにモザイク処理必須
- 画像1枚だけをリストにアップするとサムネイルに直接表示されてしまうため、2枚以上まとめてアップするのが基本
- テンプレはWritening（外部メモサービス）にまとめられている

## ショタ・幼女系の出力

- `goblin shota` はそのままゴブリンになる、`ugly shota` はメス・ブタ寄りのショタになるなど、望んだ「クソガキ」感が出にくい
- `faceless male, 1boy, shota, buzz cut, mounting` でそれっぽくはなるが、モデルに「ガキ」概念が学習されていないと本格的な再現にはLoRAが必要
- ロリキャラの生成はモデル側のペナルティが大きいため、服装をレオタードなどで保険をかける投稿者もいる

## 局部の隠し方・意図しない露出対策

- 獣人（黒犬系）で意図せず性器が丸出しになる場合、多くはうっかり性器系プロンプトを入れているか、使用LoRAに性器系プロンプトが仕込まれているパターン
- 対策：ネガティブプロンプトに `pussy` を追加する。ビキニアーマーは `bikini armor` でそのまま出せるが、細かい再現にはLoRAが必要
- 隠したい部位があるときは `covered ○○` を使うと良い
- 犬耳獣人衣装の例: `furry_female, dog_ears, furry tail, black_ears, black_tail, black_body_hair, bikini_armor, warrior`（WAIモデルでは人間と同じプロンプトで丸出しにはならなかった報告あり）

## 挿入・体液・断面図表現

- `cross section` と書くと必ずペニスがセットで生成されてしまう問題あり
- `after vaginal` で膣内に体液が溜まった様子を出そうとしても、なぜか棒（ペニス）が入ってしまう
- `cum` はAIが「エロい・男性器あり」と自動判断しやすいため、代わりに `fluid` を使うと良い（ChatGPTに相談して得た知見）
- 医学図解風に女性器断面を出すための呪文例（ChatGPT提案、幽玄の愛用呪文）:
```
medical anatomical illustration,
educational anatomy diagram,
cross-section view,
cutaway anatomical diagram,
x-ray view,
partially transparent abdomen,
female reproductive organs,
uterus and vaginal canal cross section,
visible inside the uterus,
internal fluid visualization,
anatomy focus,
clinical visualization,
after scene,
after vaginal,
fluid overflow,
body fluid detail,
no penis,
no male genitalia,
no male body,
no penetration,
not a couple scene,
```

## 顔・表情・目の破綻対策

- 目が溶けないようにする方法（確実なのは最後の方法との報告）
  - 指示やLoRAを少なくして破綻を減らす
  - 専用LoRAを使う
  - 解像度を上げる
  - 画面分割や顔だけ別出力して解像度を上げる（ComfyUIのFaceDetailerが有効。画像を渡すだけで顔認識して書き換えてくれるが、効かせすぎると別人になったり余計な書き換えが起きることがある）
- 顔に影がかかる構図（見上げ構図）を再現したいという相談があったが、具体的な解決プロンプトは本文からは特定できず
- Animaモデルは顔に陰毛がかかる描写や、2人以上を綺麗に描くのが苦手という報告
- リアス系の「伝家の宝刀」表情プロンプト `embarrassed, blush, torogao, orgasm` をAnimaでそのまま使うとイメージ通りにならない
- 敵意と発情を両立させた表情を出すのが難しいという相談に対し、「頬を赤らめてハアハア=発情要素」「目・口は敵意表現に使う」「steam, blush 程度に留める」との回答

## ポーズ・構図系プロンプト

- 見上げ構図（from_side, from_above等）: `(from_side:1.2), (from_above:0.8), facing_to_the_side, looking_at_viewer, large_breasts, off-shoulder dress, bare shoulders`。視点の再現性は低く調整が必要
- 犬の散歩でリードを手前に引っ張る表現: `1boy, holding leash, POV,`（引っ張っている側の主観視点として表現）
- パイズリで両腕を交差させ胸を抱きしめるポーズ: `paizuri under clothes, hugging paizuri, arm press, crossed arms, covering privates, covering breasts, breast press, breasts squeezed together`。NAIでの別解として `paizuri, 1.5::crossed arms, covering breasts with arms, grabbing own arm.png::,` という強調構文も報告
- 両目を隠してスカートをたくし上げるポーズが上手くいかない相談に対し、「ネガティブプロンプトに目の要素（瞳の色など）を入れると解決する」との回答。実際に上手くいった報告あり
- 目隠しシチュを出すには、瞳の色・形のプロンプトを消したほうが良い（目隠しなのに瞳が描写されて破綻しやすいため）
- 箱詰め・瓶詰め系ポーズ: `lying on back, flat on her back, legs spread wide, m-shaped legs, hands tied behind back, full body inside a cardboard box,`。上から見た構図には `top view` の指定が効いた模様。縦長のガラス瓶に詰める場合は箱と違い縦の出し方が分からず苦戦したとの報告
- 逆さまに入れてガラスを叩かせると、お尻で叩く構図になりやすいという知見
- タオルを広げるシチュ: `open towel, opened by self, spread arms` で一定の再現はできるが、俯瞰構図になりがち。`perspective` 系や `focus_○○` を組み合わせるとエロさが増す
- パレオ・腰布系: `sarong pass, see-through sarong, pareo` で対応可能。アーチャー風の腰マント自体は再現方法不明
- ショウガールスカート系: `open front skirt` が良さそうという検証結果あり。全身を出したい場合は横長より縦長画像の方が向いている
- 水のオーラ・渦の表現: `surrounded by streams of water`
- 濡れた毛を乾かすため頭を振るプロンプト（`motion_blur, shaking_body, shaking_head, wringing_clothes, drying, splashing, trembling, water_drop` 等）は全滅したとの報告あり、有効な代替は見つかっていない

## LoRA・モデル運用のコツ

- 見せ槍（挿入部が見える構図）はLoRAが豊富なので探すと良い
- ゴム（コンドーム）が引っ張られる構図はLoRAが少なく再現が難しい
- 濁点付き喘ぎ声（「お゛っ゛」等）はプロンプトでの再現が難しく、`speech bubbles` でガチャするか、切り貼りで対応するのが手っ取り早い
- 同じプロンプト・LoRAを使い続けても精度自体は変わらないが、生成のたびにシード値が変わるため結果は毎回変化する。「なんか違う」程度の不満なら再生成で改善することがある
- 絵柄LoRAと塗りLoRAを分離して使うのは技術的に可能だが、需要が少なく自作が必要で難易度も高いためおすすめされていない
- 好みの絵柄画像を見つけたら、その絵柄でLoRAを自作するのが手っ取り早い。複数絵師の要素が混ざった絵の場合は特定困難
- 自作絵柄LoRAは他人にそのまま渡すと再現性が低く「ちゃんぽん」状態になるため、共有を断られるケースもある

## モデル・サービス比較

- Tsubaki.2は生成が遅い、Haruka2の方が速いという報告。高速生成をオフにするとキャンセルされる不具合があり、高速生成オンにすると正常に生成できたとの報告
- Tsubaki.2はモードを「ウルトラ」など高級にするとプロンプト認識精度が上がる可能性があるとの検証あり（サラシ+化粧回しでの四股ポーズなどはうまく再現できた）
- Tsubaki.2は汁気表現や表情の乏しさが弱点と思われていたが、ボボパン（性行為）自体は和物3P・体位再現など得意という報告
- Animaは英語であれば文字（書き文字）も出力可能。チェキ風画像の再現に向いている
- チェキ風の再現プロンプト: `fake photograph, white border, blank space, handwritten text on polaroid, Text color is pastel pink, extra handwritten hearts doodles`
- PixAIのNagiモデルで、通常のイラストは普通に描けるがボボパン時に白黒画像になりやすい問題が報告された。原因検証では「漫画家名を含めると1/4程度の確率で白黒化」した例あり、余計なプロンプト混入が疑われる

## PixAI運用・クレジット節約

- スマホアプリ版PixAIに登録すると、1日10回広告視聴で5万クレジットがもらえる（ただし2026年5月時点でアプリは不具合により配布停止中、公式から再ダウンロード不可のアナウンスあり）
- クレジット節約には `dmd2_sdxl_4step_lora` の使用が有効。CFGスケールは2以下にしないと絵柄が崩れる
- Sampling Stepsを7程度に下げてもCFGスケールを2以下にすれば問題なく生成できるとの報告
- LoRA学習1回につき75000クレジット消費。広告報酬（1日5万）を使えば2日程度で1つLoRAを作成できる計算
- LoRA作成自体はクレジットさえ払えば無料会員でも回数無制限（月間上限などの噂は誤り）
- PixAIのUIは度々不具合や改悪があり、画像拡大ビュー時に下部が隠れる問題（後に修正）、モデル検索スクロール時の表示落ち、重さの増加などユーザーからの不満が多い

## 顔修正・後処理テクニック

- ComfyUIのFaceDetailerを使うと、画像を渡すだけで自動的に顔を認識して書き換えてくれる。複数人物やモンスター娘混在でもある程度識別できるが、利かせすぎると別人になったり余計な書き換えが起きることがある
- 手書き修正以外にも、顔だけ別解像度で出力する等の高解像度化テクニックが有効

## その他小ネタ

- 版権キャラの髪色違い（alternate hair color）や版権衣装のコスプレ・カラー違い（cosplay, alternate costume color）を組み合わせると、オリキャラというより「2Pカラー」的なバリエーションを手軽に量産できる
- 背景色の変更・除去には無料ツール「Photoroom」が便利
- ChatGPT（チャッピー）に医学的な観点からアプローチしてもらうことで、エロ方向に寄りすぎない断面図表現のヒントが得られた例あり
- Gemini（無料版）は一度に大量のプロンプト生成を頼むと断られるが、4回程度に分割すれば長大な衣装プロンプト依頼文を作成できる。修道女服を最高のエロ衣装だと繰り返し提案してくる癖があるとの報告
- 衣装プロンプトをGeminiに考えさせる際の依頼文フォーマットはWriteningに共有あり（danbooru語での細かい指示はできない前提で方向性のみ指示する形式）

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part17 https://bbs.animanch.com/board/6826113/
