---
title: 読めない言語がWebを支配していた話【Perl】
description: Perl の誕生・Web覇権・転落・遺産
aliases:
  - Perl歴史
tags:
  - perl
  - programming-history
  - web
draft: false
date: 2026-08-02
---

# 読めない言語がWebを支配していた話【Perl】

動画: [IT技術屋のボヤキ](https://www.youtube.com/watch?v=QW7cumriWgw) / 2026-07-04

## 誕生 (1987)

- 作者 Larry Wall、ユニシス社 システム管理者
- ログ集計に AWK 弱い、C 重い → 自分で言語作った
- 言語学専攻 → 設計思想「やり方は1つじゃなくていい (TIMTOWTDI)」
- 自由すぎる → 記号の嵐 → 読めない欠点の根本

## Web との出会い (1993〜)

- 1993年 NCSA が CGI 実装 → Web が初めて「動いた」
- Perl が CGI 言語に選ばれた理由:
  - Web はテキストの塊 → 正規表現が刺さる
  - Unix サーバーに最初から入ってた
  - コンパイル不要、即動く
- 1995年 CPAN 誕生 → 世界最大モジュール倉庫
- Matt's Script Archive → フォームメール・カウンターがコピペで動く → 90年代個人サイトの定番

## 全盛期 (1990年代後半)

- Amazon・Yahoo・Slashdot・IMDB・Craigslist・Movable Type → 全部 Perl
- 1998年「インターネットをつなぎ止めるダクトテープ」と命名
- ヒトゲノム計画まで Perl で DNA テキスト処理

## 転落

- 1995年 PHP 誕生 → HTML の中にコードを書く発想 → 初心者に優しい
- **2000年 マグカップ事件**: Perl 6 を「0から作り直す」宣言
- Perl 6 安定版: **2015年** (着手から15年)
- 2019年 Perl から名前が外れ「Raku」に
- **オズボーン効果**: 次世代予告 → 現行版への投資が止まる
- 待ってる間に Python・Ruby・Rails 台頭 → 主役交代

## 遺産

- **正規表現文法**: Python・JavaScript の正規表現は Perl が原型 (PCRE)
- **CPAN**: npm・pip・RubyGems のモデル → パッケージ共有文化が Perl 発
- Craigslist・Booking.com・cPanel → 今も裏方現役

## Perl の言語特性

```perl
# $_ = 暗黙のデフォルト変数。for/while/正規表現全体に貫通
for (1..5) { print "$_\n" }   # $_ に勝手に入る

while (<STDIN>) {
    next if /^#/;   # $_ =~ /^#/ の省略形
    print;          # print $_ の省略形
}

# コンテキスト: 左辺が文脈を決める
my @arr = (1, 2, 3);
my $count = @arr;   # スカラーコンテキスト → 3 (要素数)
my @copy  = @arr;   # リストコンテキスト → (1, 2, 3)
```

- `$_` 暗黙変数が言語全体に貫通 → 自然言語の主語省略に近い設計
- 同じ式がコンテキストで動作変化 → 追うのが辛い
- TIMTOWTDI → チームで書き方バラバラ

## 消えた本質的理由

「書く人の天才性に依存する言語」。1人職人ツールとして最強、複数人・長期保守では負債。

- IDE の静的解析が重要な時代に暗黙コンテキストは追えない
- TypeScript・Go・Rust で「コンパイル時エラー検出」が主流価値に
- AI コーディングも型情報があるほど精度が上がる → Perl コードは AI にも読みにくい

「天才が1人で書く」→「チームで保守する」パラダイムシフトに乗れなかった言語。
