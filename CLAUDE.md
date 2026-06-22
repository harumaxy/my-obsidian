# my-obsidian

Obsidian を使用せず好きなエディタ(zed, vscode)でメモとか勉強ノートを書くリポジトリ。

グラフビューだけ quartz で再現


## structure

- notes/**/*.md
    - メモ、ノート、コンテンツ
- Makefile
    - タスクランナー記述
- template.md
    - quartz 対応のフロントマター付き md テンプレート

他に色々あるが、見なくて良い\
`.zed/settings.json -> file_scan_exclusions` で無視している。\
(快適な執筆作業のため無駄なため)

claude でのコード生成などでも上記ファイル・ディレクトリだけ見れば良い


## scripts

- `make setup` - 初回のみ実行。Quartz のセットアップを行う
- `make preview` - notes のプレビューサーバーを起動。ブラウザで http://localhost:3000 でアクセス可能
- `make new <path/title>` - 新しいノートを作成。例: `make new notes/javascript/basics`


## directries

主に、 `notes/*` ディレクトリ以下に markdown ファイルを配置する


- notes/
  - qiita
  - zenn
    - 技術記事サイトの要約 + それに対するコメント・やり取りのまとめ
  - youtube
    - 動画を要約した記事
  - その他メモ ... フラットに配置。

## youtube 要約

youtube の URL を貼られたら、字幕をダウンロードして `/baoyu-youtube-transcript` スキルで字幕をDLして要約を**日本語**で表示すること。
`notes/youtube` にはユーザーから指示があるまで書き込まない。確認もしない。
(保存したいと思ったものだけ保存するため)


 `cd /Users/harumaxy/.claude/skills/baoyu-youtube-transcript` しないように
 このディレクトリ内でスクリプトを実行すること
