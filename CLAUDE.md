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

- qiita
- zenn
  - 技術サイトの要約
- youtube
  - 動画を要約した記事
