# えっちなAIイラストスレ part1 まとめ

元スレ: https://bbs.animanch.com/board/6515253/
あにまん掲示板。PixAI/NovelAI/ローカル生成 中心のNSFWプロンプト情報交換スレ。

## 品質タグ・基本

- マスターピース系タグ不要論多数。マスピ顔誘発の恐れあり→避けてもいい
- 品質タグよりモデル・LoRA・絵師タグ選定の方が結果に効く
- プロンプト順: 優先したいもの手前に置く
- `simple background` で背景描き込み量コントロール
- pixaiは日本語自動変換対応。句読点区切ると精度上がる報告あり。翻訳は万能でない、最終的に英語知識必要

## 胸サイズ表現

- 無乳: `flat chest`
- 貧乳: `flat chest, pointy/round breasts`
- 普乳: `small breasts`
- 美乳: `small breasts, round breasts`
- 巨乳: `medium breasts`
- 爆乳: `large breasts`（`gigantic breasts`は暴走しがち、注意）
- `side boob`/`under boob`: アングル・露出度に影響
- `breasts apart`（離れ乳）でリアリティ向上
- `breasts` という単語自体、胸を大きくする効果強い

## 体位・プレイ系プロンプト

- 挿入直前: `just the tip`, `imminent penetration`
- 亀頭のみ挿入も同上 `just the tip`
- 揺れる胸: `bouncing breasts`（連打強調）, `motion line, trembling, sparkling sweat`
- 竿役の顔を映さない: `faceless man/male`、ネガに `boy face, boy expression`
- パーツだけ見せない: `disembodied penis`。`transparent`/`invisible_man`は効き薄いとの報告
- 3P以上で余計な男が乱入する→`couple`指定、ネガに`group sex`
- マウント体位: `mounting, clinging`
- ノーブラノーパン再現: 通常タグだけでは弱い→ネガに `print_bikini, highleg_bikini, micro_bikini, panty, brassiere` 等下着系ワード入れて反映率アップ
- 愛液: `pussy juice`より`wet pussy`の方がブレにくいとの体感報告
- `veiny penis`: 竿の血管表現、事後も竿を残しやすくなる
- 目元隠し: `covering_privates, covering own eyes, hand up`

## 衣装系

- 逆バニー: `skin tight bodysuits, white rabbit ears headband, detached collar, necktie, exposed chest, heart shaped pasties, gloves, exposed stomach, crotchless pantyhose`
- ウエディング: `wedding dress, micro bikini, showgirl skirt, bridal veil, cleavage, navel...`
- 紐だけ水着: cutoutでなく布自体を消す指定必要（`cupless bikini, crotchless panties`）
- 胸チラ: `nipple slip`/`slip nipple`。露出なしにしたいなら`slip`外し`topless`/`breast cutout`強調

## LoRA・モデル運用

- PixAIでLoRA自作: 画像サイズ揃える、無地背景推奨。35枚程度でも画風LoRA十分との報告
- 画像1枚からでもLoRA作成できるとの言及あり（他スレ）
- サンプリングステップ削減LoRA: DMD2が定番
- キャラLoRAとモデルの不一致が生成失敗の原因になりうる
- キャラの髪色だけ抽出したい場合、Forgeでそのキャラのlora入れて髪要素だけ抜き出す手法

## ローカル vs PixAI/クラウド

- ローカル最大の壁はPCスペック。Forgeは導入簡単との声複数
- ローカルのメリット: 制限なし、adetailer等拡張使える。一度覚えると戻れないとの声
- ローカル(SDXL/illustrious系)の弱点: 自然言語指示・複数キャラ描写弱い。Flux/Lumina/Anima実用化待望
- ComfyUI + Qwen-Image-Editで対話的編集が現状可能（中華製ゆえNSFWフィルタ不透明の懸念あり）
- PixAIコスパ: 200〜800クレジット程度が普段使いの相場という声多数
- キャラ再現の学習元はpixivいいね数でなくdanbooru登録数という説（真偽不明）

## トラブルシューティング

- 複数人物・multiple view構図で中央だけ破綻しやすい→試行回数増やす/マスク機能で部分再生成/解像度フルHD以上にする
- `pussy focus`指定でケツ側と顔側に画面分割される問題→顔・髪関連プロンプト削除で解消した報告あり
- 生成がうまくいかない時はLoRA名込みでプロンプト丸ごとLLMに相談すると解決しやすいとの意見複数
- センシティブ判定画像は非公開設定ミスっても他人に見えない仕様→安心して運用可

次スレ: えっちなAIイラスト作ってるやつ集合だーー！！part2（あにまん掲示板）
