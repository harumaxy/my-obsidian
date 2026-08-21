# えっちなAIイラストスレ part13 まとめ

元スレ: https://bbs.animanch.com/board/6742835/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 乳首・乳輪・アナル・性行為描写は外部サイト（d.kuku.lu）へ、性器はさらにモザイク処理必須
- モザイクツール: `www.oh-benri-tools.com`、`www.bannerkoubou.com`（モザイク加工サイト）
- 長すぎるプロンプトを貼りたい時は `writening.net`（テキスト共有サイト）を使うと便利
- 画像を1枚だけアップするとサムネイルでNSFWがそのまま見えてしまう。複数枚まとめてアップするか、「アップロードしたファイル→リスト→リストにまとめる」機能を使えば1枚でもサムネが隠れる

## 挿入・体位系プロンプト

- 竿がほぼ見えない深い挿入を狙う場合：ポジティブに `implied sex`、ネガティブに `penis, deep penetration` を入れる（参考: dskjal.com「よく検索されているプロンプト」）
- お気に入りの座りポーズ: `folded, legs up, feet apart, hugging own thighs, knee to chest`
- 肉感を出す方向: `curvy,plump,skindentation`
- 反り返らせたい時は `screaming` や `arched back`、`head back` を強調すると効果あり
- 妊娠・玉座位系の実例プロンプト
  ```
  1girl, 1boy, pregnant, standing
  sex,standing back sex, boy grabbing another's ass, gigantic breasts, huge sagging breasts, ntr, sex, faceless black male, sound effefts, creampie, tounge out, large puffy inverted nipples, fully nude, wet skin covered in soap bubbles, breast milk, blushing, shy smile, slightly squinted eyes, slightly open mouth, pressing body and breasts hard against glass window, breasts squished and deformed softly on glass, luxurious hotel bathroom, viewed through glass
  ```

## 表情・視線プロンプト

- 流し目にしたい場合は `sideways glance` に `half-closed eyes`（または `half closed eyes`）を併用
- `from side` を入れずに `sideways glance` だけ使うと、カメラから視線を逸らした横目になってしまう（狙いと違う結果になりがちなので注意）
- 首ごとカメラ方向に向けたい（グイっと向かせたい）場合は `from side, looking to the side, looking at viewer`
- 辞書的な意味での「視線だけ動かす流し目」にしたいなら `from_side, looking_at_viewer, (facing_ahead:1.3), (sideways_glance:1.2)` のように `facing_ahead` を1.1以上効かせる必要がある（danbooruタグ的に `sideways glance` には `looking to the side` と `looking back` の意味が含まれるため）
- 目を細めさせるだけなら `looking ○○`、`narrowed eyes` の組み合わせ

## 陰毛・体型調整系Tips

- 陰毛を消したい場合、ネガティブプロンプトに入れるか、あるいは一切指定しないほうが効きやすい。`"no pubic hair"` はポジティブに書くと逆効果になりやすい（モデル/LoRA依存）
- 痩せ細った身体（肋骨が見える細身）を再現するなら `emaciated` に `slender` を併用すると効果的
- 雑魚っぽさ・弱そうな見た目を出したいなら `skinny male` や `smaller male` を追加する
- ムチムチ感を出したいがデブに寄せたくない場合は `curvy, plump, skindentation` から始め、それでも足りなければ脂肪追加系プロンプトを足す（デブ化とのバランス調整が必要）

## LLMを使ったプロンプト生成テクニック

- ChatGPT/Geminiにえっちなプロンプトを英語化・最適化させるテンプレ:
  ```
  以下の日本語をpixai(使ってるAIの名前)向けの英語に翻訳、pixai向けのプロンプトに最適化してください。
  ```
  「○○向けの英語に翻訳してください」「日本語訳も教えてください」という文言を入れないと拒否されやすい。より詳しく知りたい場合は「チャットGPTでNSFWのプロンプトを添削してもらう裏技を教えてくれよ」と直接聞くと教えてくれることがある
- ただし「anima向けの英語に翻訳」等サービス名を直接書くと利用規定違反として弾かれるケースもあり、安定しない
- Grokは快適に応じてくれるが、利用制限に達するのが早い
- ComfyUI環境内でLLM（Llama 3、Gemma、qwen等）をローカルで動かすと検閲フリーで使える。ただしマシンスペックを消費するため、画像生成と同時にLLMを動かすのは重くなる。ollamaはあくまでモデル実行用のソフト名で、LLM自体ではない
- 自然言語で書いたプロンプトはdanbooruタグの羅列よりも検閲に引っかかりやすい傾向がある
- ollama+qwenでローカルLLMを組んでも、おセンシ（NSFW）内容は拒否されることがある

## LoRA作成・運用

- LoRA学習用画像は多少画質が落ちていても基本問題ない。低解像度画像を1024にアップスケールする場合は `waifu2x-caffe` が有用
- 絵柄LoRAを学習する場合もキャラLoRAと同じ要領で作成可能（画像を集めて学習させるだけでOK、背景処理必須というわけではない）
- LoRA適用で絵柄が元と混ざってしまう問題は、LoRAの重み（強度）を下げる以外に確実な回避策はない
- キャラLoRAが本来の見た目と違う顔つきで出力される場合、学習元のチェックポイント（ベースモデル）との相性が原因のことが多い。LoRAの説明欄に学習元チェックポイントやプロンプトが書かれていることがあるので確認すること
- LoRAの評価数（高評価）だけで判断せず、モデルやキーワードが合っているか確認する。合わないと感じたら学習元タグをツールで確認するのもおすすめ
- PixAIのLoRA検索では「Pixai学習LoRA」と外部サイト（通称Cサイト）からの無断転載LoRAが以前はアイコンの色以外で区別されていたが、現在は表記上の区別がわかりにくくなっている。転載元の使い方説明が全くないLoRAも珍しくない
- マイナーキャラのLoRAを作る際は、参照画像を白背景化するツールでキャラ以外の要素を除去し、必要ならGemini/GPTに読み込ませて三面図や細部が分かる画像を作らせてから学習に使うと良い
- トリガーワードには、人気キャラの衣装差分LoRAなら服の特徴も入れたほうがよい。マイナーキャラでLoRAが少ない場合はキャラ名だけで十分なこともある
- 複数人（2girls等）を同時に出すとプロンプトの要素が混ざる問題への対策: ネガティブプロンプトに `male, 1boy, 3girls` 等を追加。ComfyUIのregional prompting（attention couple含む）を使っても完全には分離しきれないことがある。参考画像＋ポーズコントロール機能の併用が手っ取り早いという意見もある
- LoRA同士（竿役とヒロイン役）が同じLoRAキャラで「ミラーマッチ」してしまう問題には `1boy, faceless man` を試すとよい

## モデル/サービス比較

- WAI-illustrious-SDXL: プロンプトへの忠実度が高く、Harukaより指示に忠実という評価
- Tsubaki: 複数人でもプロンプトをきっちり作れば構図が破綻しにくい（無課金だと4枚中2〜3枚は破綻することもある）
- Haruka/Harukav2: 設定例は Sampling Steps 16、CFGスケール 7。絵柄・塗りの呪文としては `anime coloring, shiny skin` がよく使われる
- Anima: face detailerとupscalerを併用できる。最新版のアップデートあり
- qwen-edit（画像編集AI、ComfyUI経由）: NSFW表現は受け付けるが弱め。先人のワークフローがComfyUI環境で共有されている
- PixAIのセンシティブ判定基準は不明瞭で、自転車に乗る女の子やシスターなど通常の絵柄でもセンシティブ扱いされることがある

## その他小ネタ・ツール紹介

- Danbooruタグ検索サイト: `dskjal.com`（Danbooruタグ検索）。挿入表現などの検索によく使われるプロンプト集としても参照されている
- NovelAIでは「ぴんくろーたー」等の日本の造語は認識されない。`small pink vibrator` のように英語で明示的に書く必要がある（Grok情報）
- `egg vibrator` は産卵プレイ系のタグとして機能する
- ハーピーキャラの羽の模様に色を入れたい場合、`hair` を `feather` に置き換えると効果があるかもという提案あり（未検証）
- 乳首周りに精子が集まっているようなデザインのタトゥーを狙っても、薔薇や髑髏ばかり出てしまう問題は未解決のまま
- 目のディテールがプロンプト・生成方法を変えていないのに崩れていくトラブル報告あり（原因不明）

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part14｜あにまん掲示板（本文中で次スレ立て報告あり、URLは本文からは取得できず）
