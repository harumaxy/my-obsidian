# えっちなAIイラストスレ part12 まとめ

元スレ: https://bbs.animanch.com/board/6728533/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 画像投稿ルール・運用

- 画像アップロードは d.kuku.lu を使うのが基本。乳首・乳輪・アナル・性行為描写はここに上げ、性器はさらにモザイク処理必須
- モザイク加工ツール: `www.bannerkoubou.com`（モザイク加工）、`www.oh-benri-tools.com`（無修正回避用）
- 背景を白/黒に変えるツール `www.photoroom.com`（AI背景変更、無料）。1024×1024への一括リサイズは `anytools.pro`
- ぶっかけ等の「量」を出したい表現は、生成しただけでは限界があるため白ペンで描き足してからi2iで再生成すると量を盛れる
- inpaint機能（🖌️描く）はPC版ブラウザには見当たらず、スマホ版ブラウザでのみ表示されるという報告あり

## プロンプトによる体位・構図制御

- うつ伏せにしたい時は `lying on stomach` や `facing away` では仰向け正面向きになりがち。`prone` の方が効く
- from below（下からのアングル）は `back view, back shot, from below, looking away, looking up,` の組み合わせで狙い通りの構図になったという報告
- スカート丈は `knee length skirt` や `medium skirt` を入れてもミニスカ化しやすい。ネガティブに `thigh` を入れるより、具体的な丈（膝丈など）を明示した方が確実
- 細身は `slender` だけでは不足する場合があり、`emaciated` まで強めると狙った痩せ方になる
- lifted up top と exposed tits の組み合わせ、missionary position のまま sit on bed させる指定などは身体の崩れ（奇形）を誘発しやすい
- 水着の上にパーカーを羽織らせようとすると高確率で水着とパーカーが一体化してしまう問題は未解決のまま質問止まり
- ガニ股や腰浮きなど、体勢が思い通りに潰れない・ベッド内に収まらない問題も複数報告されたが決定打の解決法は出ず

## 性別・キャラクター数の制御

- `1male` や `solo male` を入れてもネガティブで人数制御しても竿役が2人出ることがある。AIが `1boy` ベースで学習している可能性が指摘されている
- ショタにアヘ顔をさせたいのに女性側がアヘ顔になってしまう問題は、AIが基本的に女性優先でプロンプトを反映する傾向によるもの。対策として、ショタ側のプロンプトを丸ごと括弧でまとめる、`ahegao_male` のように性別を明示的に指定する、などが有効
- 男性が女性の胸を掴む・母乳を出す表現には `boy grabbing another's breast` と `breast milk` の併用が有効という報告

## 具体的なプロンプト例

- 顔隠し構図: `from side, eyes are hidden by hair, no eyes, hair over eyes, blush`
- ふたなり自己挿入系の完成プロンプト（使用モデル haruka v2）: `1 dickgirl,solo,black short hair,closed eyes, face blush,huge breast,intravaginal futanari,large penis,no testicles,ahegao,cum in mouth,nude,sitting on bed,autofellatio,glistening penis,penis between breasts,pushing own breasts together both hands,motion lines,afterimage`
- 喉ボコ（イラマ）表現: `on bed,(deepthroat:〇),face focus,from side,` に加えて `detailed neck shading,(pronounced throat bulge:〇), neck stretched slightly,` を強めの倍率でガチャすると出やすい
- 好みの呪文として挙がったもの: `just the tip`、`happy sex` と `intense sex` の同時使用、表情差分には `wavy mouth` が有効
- 膣内射精の断面図でオチンチンだけ抜きたい場合、`penis` をネガティブに入れれば `cross-section` 無しでも半分程度は狙い通りになる。controlnetやIP-Adapter、断面図と全身図を別生成してi2i合成する手法も提案された

## モデル・サービス選び

- Tsubaki.2はdanbooruタグ形式より自然言語プロンプトの方が理解力が高い
- クレジット節約用の低コストモデルとして `VXP_illustrious (low cost version)` と `VXP_XL v2.2 (Hyper)` が紹介された
- Tsubaki.2のシンプル平塗り絵柄を他モデルで再現しようとするのは非推奨。どうあがいても別物にしかならないため、SDXL系LoRAでTsubaki.2の絵柄を上回る好みのLoRAがあれば乗り換え、無ければTsubaki.2をそのまま使う方が良いという意見
- Anima導入者の感想: IP-Adapterが無くLoRAも乏しいためスタイル固定が難しい。danbooruタグ形式のキャラ名は `:1.05` 程度の重み付けをしないと反映されにくい印象
- Mio.2は明示的に指示しない限りいつも通りの絵柄になるが、ストーリーやムードを説明するだけでも雰囲気は変化する。LoRAは使われないため大きく画風を変えたいなら自分で1枚作らせてから手動編集が必要

## LoRA作成・運用

- SDXL系のLoRAはSDXLモデルでしか使えず、Tsubaki.2など別系統のモデルとは互換性がない
- Tsubaki.2でLoRAを使いたいならTsubaki.2上でLoRAを作るしかない。同一クレジット消費なら学習に10万クレジット程度は見込んでおくべきという意見
- LoRA強度を強くしないと髪色や服装がブレる現象の原因は不明瞭（LoRA自体の作り方の問題か仕様かは結論出ず）
- キャラの顔だけを学習させるLoRAも作成可能
- 4枠以上LoRAを併用する場合は「キャラ・画風・衣装orディテール系」の組み合わせで使うという運用例
- 自作LoRAで手持ち画像が少ない・データ不足だと再現度は妥協せざるを得ない。時間切れでLoRA化自体を断念する例もあった
- LoRAに含まれる `flat color` タグを外すと立体感が出過ぎてバランスが崩れることがあり、絵柄と立体感はLoRA側のタグでバランスを取っている場合がある
- LoRA学習用素材としてスクリーンショット由来の縦長・横長画像しかない場合、無理に黒帯付きで正方形化するより、i2iでリサイズ・水増しする方が良い

## クレジット・課金運用

- 無課金でも毎日のログインボーナス（15000クレジット程度）だけで、高速生成やTsubaki.2・動画生成を使わなければ十分まかなえる
- 年会費割引時にスタートプラン（月30万クレジット支給）に加入し、1回800クレジットの生成を毎日行っても100万前後をキープできたという報告
- 複数アカウントでログインボーナスだけ集める運用もあるが、一度課金の快適さ（LoRA数増加・高速生成）を味わうと課金アカウントに一本化しがちという声

## ローカル生成・パラメータ

- サンプリングステップ数とストレージ（HDD/SSD）は本来無関係。ただしHDD環境ではステップごとのモデル読み込み・書き出しの負担が大きくなる
- WAI-illustrious系モデルの適正ステップ数は20〜30程度とされ、50〜60ステップは過剰との指摘
- 環境例: RTX3060Ti(8GB VRAM)、Forge WebUI、WAI-illustrious-SDXL、50〜60ステップ+Hires.fix15ステップ、CFG5〜7。ADetailer導入後は低ステップ（20程度）でも問題なく動いたという報告
- explicit（露骨な性描写）はsensitiveと学習データの傾向が異なるため、同じ構成でも画風や塗りが変わりやすい。絵師タグやLoRAで縛る、サンプラーを調整するなどが安定化に有効

## その他小ネタ

- ニッチな性癖を再現したい場合、まず類似LoRAを探す、ピンポイントの参考画像をtagger（画像→タグ変換ツール）にかけてタグを抽出する、という手順が定番
- danbooruタグの調べ方の定番フロー: danbooruで検索 → 検索エンジンでも検索 → 単語・文章を翻訳、という手順
- Geminiに露骨なプロンプトを聞く際は、思考モードで一度NSFWプロンプトの提供に同意させると答えてくれるようになるという報告
- LM Studioでローカルにgemma/qwen系の無検閲(uncensored)版LLMを導入すれば、画像を見せて「この構図に必要なプロンプトを教えて」と聞いても検閲なく回答してくれる
- PixAIの機能整理: txt2img=プロンプトのみで生成、img2img=参考画像を使用、ControlNet=ポーズ制御、inpaint=部分的な描き込み修正
- danbooruタグの記述順は `[品質/メタ/年/安全性タグ] [人数] [キャラクター] [シリーズ] [アーティスト] [一般タグ]` の順が推奨とされ、キャラ名を書く場合でも容姿を軽く書き添えるとモデルが認識しやすくなる

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part13 https://bbs.animanch.com/board/6742835/
