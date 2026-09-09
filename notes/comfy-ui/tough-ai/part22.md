# えっちなAIイラストスレ part22 まとめ

元スレ: https://bbs.animanch.com/board/6929421/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（ファイルなう `d.kuku.lu`）へ、性器はさらにモザイク処理必須
- サムネ表示回避のため画像は2枚以上まとめてアップするかリストにまとめる
- 長いプロンプトはWriteningでテキストページ化して共有するのが定番
- モザイク以外の加工はバナー工房が便利
- Danbooruタグ検索は dskjal.com のタグ検索サイトが定番参照先

## 目・顔まわりのトラブル対策

- 目のパーツが滲む問題: ローカルならadetailerで補正、`perfect eyes` タグや `detailed eyes` タグで改善するケースあり。ただし目タグを入れると構図の自由度が下がる傾向
- Loraや補正で改善しない場合、`汗だくsex` で「アイシャドウがにじんでいる」体で誤魔化す裏技も紹介された
- PixAIはオプションの顔修正機能があり、eye detailer系Loraより手軽との評価
- オホ顔（口を縦に尖らせる表情）は `ahegao,` `ohogao,` タグで出ることもあるが再現は難しく、専用Loraを探す方が早い。強めに出したいなら `fucked silly,ahegao,open mouth,puckered lips,heavy breathing,female orgasm,` の組み合わせで強弱調整

## PixAI運用ノウハウ

- Tsubaki.2はLoRA無しでもキャラ名を入れるだけである程度再現でき、プロンプトが雑でも思い通りに出やすいモデルと評判
- HoshinoモデルはLoRA無しで絵師の絵柄を呪文だけで再現しやすいと紹介
- Ultimate Anime Styleモデルでのアニメ塗りができなくなった件は、LoRAバージョン違いかプロンプト自動変換でトリガーワードが外れた可能性が指摘された
- 出力解像度は無料会員で一辺1280px、有料会員で1400pxまで。それ以上はアップスケール機能で対応
- スマホアプリ版は広告視聴で1日5万クレジットもらえる
- 作品投稿ボタンは生成画面・生成履歴の画像ごとに表示される（スマホブラウザ版でも同様、見つからない場合はキャッシュクリアを推奨）

## キャラクター一貫性・再現性

- キャラの一貫性を保つには髪型・髪色・目の色・表情などの造形プロンプトを細かく固定するのが基本
- Seed値を固定すると、同じプロンプトで近い画像を再現でき、要素を一部変更するだけで服装や背景だけ差し替えた差分生成が可能
- 自作LoRA運用で生成結果が初期設定からズレてくる問題は有効な対処法が挙がらず（LoRA作り直し以外の解決策は未提示）

## 服装・脱衣表現

- 二段袖のような複雑な服: `layered_clothes` で同色の重ね着、または `detached_sleeves,` `puffy_detached_sleeves,` `detached_puff_sleeves,` `arm_warmers` で腕の途中に盛り上がりを作ると近い見た目になる。`Three-quarter sleeves over long sleeves` はほぼ効果なし。`layered_sleeves` は重ね着による袖の広がりに有効、シルエットをタイトにしたい場合はネガティブに `tight` 系を追加
- 脱いだ服が足元にある構図: `clothes on floor, unworn serafuku, unworn skirt,` のように `clothes on ○○,` `unworn 〇〇,` を使う
- スカートが落ちる構図: `skirt falling off, skirt dropped at feet, light blue panties at ankles,` の組み合わせで再現可能
- 胸がブルンとなる構図（勢いよく脱がす/破れる）: `unaligned_breasts, bouncing breasts, motion_lines, motion_blur` に加え、服に `lift` `open` `torn` `tearing` `exploding` を付けたり `wardrobe malfunction` を追加すると良い
- 別の実例では `popped button, flying button, wardrobe malfunction, bursting breasts, button gap, breast expansion, motion blur, motion lines, bouncing breasts, emphasis lines, open clothes` などが使われ、`nude,nipple` を足すとちゃんと脱げやすくなったという報告あり
- 服の透明化: `transparent` `translucent` は既存衣装の透明化向け。一から透け感を作るなら `skin-colored` `nude_colored` などの色指定、`silk` `vinyl` などの材質指定、`sheer` `illusion_mesh` などの構造指定を組み合わせる。完全な無色透明を狙うなら `invisible` が最有力との意見
- `undressing` は脱衣表現の王道。`breasts out` は個人的に打率が高いとの報告
- 胸元を露出させる系のプロンプト `shirt open` `shirt pull up` はキャラ固定Loraだと効きにくいことがある（`puffy nipples` が残ったまま生成され不自然に胸元だけ開いた服になった失敗例あり）

## 体型・部位の誇張

- 巨大な胸: `gigantic breasts:2.0` のような強調表記、爆乳系のニーズが多い
- 巨根表現: `gigantic penis` では満足できない層向けに `slender body,small torso,(extremely oversized penis:2.0),(penis dwarfing the body:1.5),(penis much larger than the torso:2.0),(exaggerated proportions:1.4),` の組み合わせが紹介された。玉（睾丸）の言及がないと竿だけ巨大化しがちという指摘もあり
- 低身長キャラの足が浮く表現: `floating,foots dangle,plantar flexion` で足が地面に届かない座り方を再現
- 太ももの「正の字」（tally marks）: `tally on legs` で再現可能。画風やLoRAによって出やすさが変わり、手書き風・古いアニメ調の絵柄だと綺麗に出る傾向
- love handle（横腹の柔肉）のプロンプトは構図によって隠れてしまうことがある

## 挿入・行為系プロンプト

- ペニス複数化のトラブルは `1boy` のように数を明示するタグで抑制。対面人数を固定したい場合は `two characters` も有効
- ガラスに押し付ける構図: 窓の外からのviewを指定した上で「駅弁+back view」「立ちバック+front view」を組み合わせ、該当部位に `pressed flat against window glass` を追加
- 種族間・怪物との行為: `monster,interspecies sex,arm_held_back,groping,hug,` の組み合わせでペニスケース状の構図を再現
- ハンドサイン（性的ジェスチャー）は名前が分からなくてもDanbooruで画像検索して該当タグを特定するのが早い（`fellatio gesture` などが実例として紹介）
- 体位・行為タグはdanbooruタグがそのまま使える: `dogeza,wariza,seiza,yokozuwari,futanari,bukkake,ahegao,torogao,` など
- パンチラ・射精系: `pantyshot,` `skirt lift,` `cum drip,` は服を着たままでもエロさを出しやすい定番タグ

## 装飾品・アクセサリー

- 踊り子系の装飾: `circlet`（頭飾り）、`gold belly chain`（腹チェーン）、`gold armlet`（腕輪）、`gold thighlet`（太もも輪、効果安定せず）、`gold anklet`（足首輪）が基本セット。プロンプトに `:1.5` `:2` の強調をつけると装飾が目立つ（数が増えるとは限らない）。`dancer accessories,` でまとめて強調する方法もある
- 中東風の装飾を足すなら `*_feather_*`（羽）、`fur_*`（ファー）、`flower_*`（花）、`* ruff`（ヒダ飾り）、`*_embroidery`（刺繍）、`hair_ornaments`（頭飾り）、`garter_*`（ガーターベルト）、`*_shawl`（ショール）、`sheer silk cape` などが紹介された（安定性は度外視）
- タトゥーは部位＋デザインを指定すると出やすい（例: `arm_tattoo, butterfly_tattoo` で腕に蝶の入れ墨）

## サービス比較・その他ツール

- ローカルのStable Diffusionが不要な選択肢としてPixAIが挙げられる
- ChatGPT/GeminiにNSFWプロンプトを書かせる際、直接的なタグはフィルタで弾かれやすい。対策として「露出」より「衣装デザイン」寄りの言い回しにすると安定しやすいとの報告
- Gemini 3.5 Flash（軽量版）は性的・暴力的描写を除いたdanbooruタグを経由して質問すると、フィルタを回避してエロ・グロ系のdanbooruタグ/英文/和文を出力してくれるとの情報
- GPT Image 2は水着はOKだが下着はNGという制限報告あり
- 美少女ゲーム風プロンプトで画面端に白黒の謎フレームが出る問題は、ネガティブプロンプトに `frame, border, game ui` と色指定（black/white等）を追加して対処
- pixaiでプロンプト入力欄に出る赤線は単なるスペルチェック的な端末側の表示で、生成には影響しない

## ハードウェア関連の小ネタ

- PCメモリを16GBから32GBに増設後、モニタに何も映らなくなるトラブルが発生。モニタの電源コンセントも含め全て抜いて数分放置すると復旧した事例が共有された

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part23 https://bbs.animanch.com/board/6949239/
