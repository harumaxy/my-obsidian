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
