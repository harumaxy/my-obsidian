# えっちなAIイラストスレ part24 まとめ

元スレ: https://bbs.animanch.com/board/6970767/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・ボボパン(性行為)描写は外部サイト（d.kuku.lu等）へ、性器はさらにモザイク処理必須
- 画像アップロードは `d.kuku.lu`、長文プロンプトの共有は `writening.net`（ユーザー登録不要でテキスト共有URL発行）
- 画像リンクを直接貼りたい場合はURLから `arc` の部分を消すとよい
- モザイク処理・画像加工は「バナー工房」(bannerkoubou.com)、背景を白/黒に変えるなら Photoroom、正方形リサイズは anytools.pro が使える
- Danbooruタグ検索は dskjal.com、よく検索されるプロンプト（R18含む）も同サイトで確認できる

## サービス比較（PixAI / Tsubaki / anima / SeaArt / ローカル）

- PixAIはTsubaki（Tsubaki.2）モデルとanimaモデルを提供。Tsubakiは絵柄がきれいだが激エロ生成が難しく、LoRA併用でもTsubakiと相性が悪いLoRAがあるとの報告あり
- Tsubaki.2はmature lady（熟女系）のエロ表現が学習深度の関係か不得手
- Tsubaki「ライト」版と「プロ」版は線の綺麗さに若干差はあるが、触手プレイなど生成内容自体にはあまり差が出ないとの報告
- animaは自然言語プロンプトに対応しており、キャラクターの書き分けが楽になる。ただし生成時間が長め
- animaのText Encoderは優秀で、長文の日本語をGoogle翻訳で英訳してそのまま突っ込んでもある程度理解する。ただしプロンプトが長くなりすぎると破綻（貫通、バタ臭くなる）しやすいLoRAもある
- animaは英語ベースだが長文は理解が弱いため、ある程度短く文章を区切ると精度が上がる。danbooruタグも自然言語と併用可能（自然言語で構図指定、タグで細部指定という使い分けができる）
- SeaArtはイラスト生成に加え低コストでエロ動画生成・エロAIチャットができるのが強み。ただし海外のエロ規制の影響を受けやすくバランスは一定しない
- ローカル生成（StabilityMatrix + ComfyUI + animaモデル）ならポイント消費なしで検証し放題。PixAIやSeaArtと基本原理は同じで、構図・タグの工夫、モデル/LoRAの組み合わせ、サンプラー・スケジューラー・ステップ数の調整が仕上がりを左右する
- PixAIでは自動英語変換機能があるが、意図しない要素が混入する不具合が時々報告されている（プロンプトの9割を無視したような画像が出ることもある）

## 挿入・体位・部位別プロンプト

- 竿だけを描写したいときは `disembodied_penis`
- キスしながら手で触るシチュエーションは `kiss, hand_job, touch penis through clothes,`（服の上から）、直接握るなら `kiss, hand_job, grabbing_penis,`
- 単に `hand_job` だけだと首に腕を回して抱きしめる構図が出やすいという報告あり
- パイズリの深度（挟む位置・男性の腰の位置）を制御するプロンプトは見つかっておらず、生成回数で運任せになりがち。パイズリ＋ネガティブに `penis` を入れると乳に埋もれた感じが出るのではという意見もあるが未検証
- 馬乗りパイズリでは `self paizuri` は誤用で、`assisted paizuri` の方が適切という指摘あり。キャラLoRAに `skirt` タグが紛れ込んでいて誤爆した事例も報告された
- 手マン（前から腕を使ってガシガシやる構図）を出すコツ：責める側が正面を描かれすぎないようにしつつ、優位に立っているタグ（`femdom`、`dominatrix` 等）と、責められる側の脱力・限界を示すタグを増やすと構図が寄りやすい。パンツ越しに隠す場合は `fingering` や `fisting` を使うとそれっぽくなる
- 顔の位置を整えるタグの組み合わせ例：`looking_down, looking_at_penis, smelling_penis` や `arched_back, head_back, head_tilt, crying, closed_eyes, looking_back`
- 二丁拳銃でのボボパン（銃撃戦）構図の最低限プロンプト例：
  ```
  1girl, solo, firing, shouting, scenery, dual wielding, torn_clothes, handgun, blood, cracked_glass, broken_window, taking_cover
  ```
  ネガティブに `two-handed,` を入れる。Illustrious系ならこれで銃撃している絵になりやすいが、ガンカタ的な複雑なアクションは依然難しい
- 鬼のツノポーズは Danbooru タグで `horns pose,` が対応
- 疾走感を出すには `motion blur,`
- 全裸ではなく羽毛で体を覆いたい場合のプロンプト例：
  ```
  1girl, (harpy1.5), neked, entire body covered with soft white feathers, (feather skin:1.4), (fluffy feather body:1.3), soft white plumage, dense short feathers, layered chest feathers, fine feather texture, bird-like body, white feathers, minimal feather gaps, natural feather layering, digitigrade,
  ```
  服を着せたくない場合はネガティブに `clothes` を追加
- ザーメンマスク（顔にかかったマスク）を安定させるには `wearing a white mask,cum under mask,` を入れ、ネガティブに `mouth,` を追加すると崩れにくい
- 女性上位で笑顔＋しゃぶる系の表情を両立させたい場合：目の表現（`closed_eyes, half-closed_eyes, one_eye_closed`）や漫画的表現（`turn_pale, anger_vein, +++`）で口に頼らない、女性上位の笑顔を強調して咥えながらでも笑わせる、舐め・甘噛みに切り替えて笑顔が効きやすくする、の3パターンが提案された

## ネガティブプロンプト・崩れ対策

- ネガティブプロンプトはポジティブほど効きが強くないと言われるが、意外と効く場合もありランダム性が高い。推奨ネガティブプロンプトは外さない方が無難
- 指の本数の乱れやへそが複数出る崩れは、画像の縦横比が原因の可能性が指摘されている
- 目の崩れ対策：モデル変更、ステップ数を増やす、目の造形タグ追加、目専用LoRA、顔修正（adetailer等）の併用。バストアップ程度でもすでに目の描写が崩れ始めるケースが報告されており、`detailed eyes,` タグだけでは不十分。ローカルでもPixAIでも、adetailerや顔修正を使わないと現状Illustrious系モデルでは限界がある
- Tsubakiで正面立ちさせると身体に不要な影が出る問題：`shadow,shade,depth,ambient occlusion,cast shadow,self-shadowing,heavy shading` を最大値でネガティブに入れても改善しなかったという報告あり。`backlighting` を試すべきという意見も。根本解決には影の出にくい絵柄LoRAを探す/作るしかなさそうとの結論

## LoRA・学習トラブルシューティング

- LoRA学習素材に文字入り画像を混ぜると、生成結果に文字のなりそこないが出現する不具合が発生。対策として、文字入り素材を除外する、素材から文字を消す（Windowsの画像編集機能で除去可）、cfgスケールを上げてLoRA強度を下げプロンプト側を強くする、キャプションに効果音・台詞タグを付けて学習させる、といった方法が提案された。`no text` `textless` のプロンプト指定だけでは改善しなかった
- 画風LoRAを複数試した結果、特定のLoRAで足がムキムキになりやすい傾向が確認された（クイズ形式で共有）
- ローカルでのanima用LoRA作成ツールが簡単で、以前は半日かかっていた作業が大幅に短縮されたとの報告
- キャラLoRA使用時に目の輪郭が崩れる場合、wai/anima/Illustriousの3系統で試しても改善しないことがあり、LoRAの学習不足が疑われる。自作するか似た見た目のキャラLoRAで代用するのが手

## Danbooruタグ・タグ検索ツール

- タグの暗黙的要素まで拾いたい場合はDeepDanbooruが有効（Score thresholdを下げると細かく出る）。DanbooruタグはDeepDanbooruと役割が異なり並用推奨（DeepDanbooruは暗黙的な雰囲気・構図まで拾う）
- `sailor moon redraw challenge (meme),` というミームタグの存在により、セーラームーン系キャラで意図せず特定の棒立ち構図が出ることがある

## Gemini/ChatGPT等のLLM活用

- 画像から類似シチュエーションを生成するためのシステムプロンプト（画像解析→タグ化のワークフロー）が共有された。「解析」で添付画像を形而上構造（本質/要素/構成/文脈/洗練/様式）と形而下構造（前提/状況/動機/目的/制約/構図/トーン）の2軸で言語化しDanbooruタグ化、「生成」でそのタグから画像生成、という運用
- ログイン無しのGemini/ChatGPTに「1つの箱に2人詰め込む」ような複雑な構図のプロンプト生成を依頼した比較では、Geminiの方が精度が高かったとの報告。GPT-5.3 miniは性的表現に近づくと思考を制限している可能性が指摘された
- Anima用プロンプト生成の比較では、Sonnet5(medium)とGemini3.5 Flashで大きな差はなかったが、エロ表現も出せる分Geminiの方が使いやすいとの評価
- 表情を軸にした生成依頼文にした方がエロさが出やすいという知見も共有された（どんなシチュエーションでも表情がエロければ全体がエロく感じる）

## その他小ネタ

- PixAIでTubaki(Tsubaki)の生成カード配布キャンペーンが実施されていた時期あり
- PixAIの「範囲選択で編集」で色をピックアップする機能を使うとChromeがフリーズする不具合報告あり。キャッシュクリアと拡張機能無効化で改善する場合が多い（Edgeでは問題なく動作）
- ローカル環境構築を検討する人向けにドスパラのコスパPC（Ryzen7 5700X搭載モデル、メモリ16GB/SSD500GB）が紹介された。とりあえず試すだけなら足りるが本格運用には増設推奨

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part25｜あにまん掲示板 https://bbs.animanch.com/board/7016093/
