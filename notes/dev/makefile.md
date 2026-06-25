---
title: Makefile 入門
description: C/C++ ビルドツールとしての Makefile、現代での使われ方、基本概念
aliases:
  - make
tags:
  - build
  - c
  - tools
draft: false
date: 2026-06-25
---

## Makefile とは

元々は **C/C++ のビルド自動化ツール**。コンパイル・リンク作業を自動化し、ファイルの変更箇所のみ再コンパイルすることで時間短縮を実現。

最近は **スクリプトランナー** として使われることも多い（`package.json` の `scripts` のような使い方）。

## 基本概念

### ターゲット（Target）
```makefile
program:
	gcc -o program main.o
```
- 本来は **出力ファイル名**
- `make program` で実行される

### 依存関係（Dependencies）
```makefile
program: main.o utils.o
```
- コロンの後ろに列挙
- `program` を作成する前に必要なファイル

### レシピ（Recipe）
```makefile
program: main.o utils.o
	gcc -o program main.o utils.o
```
- ターゲット作成時に実行するコマンド
- **タブ文字でインデント**（スペースはエラー）

### 変数
```makefile
CC = gcc
CFLAGS = -Wall -O2
program: main.o utils.o
	$(CC) $(CFLAGS) -o program main.o utils.o
```
- `$(変数名)` で参照

### 自動変数
```makefile
%.o: %.c
	gcc -c $< -o $@
```
- `$<` - 最初の依存ファイル
- `$@` - ターゲット名
- `$^` - すべての依存ファイル

### .PHONY
```makefile
.PHONY: clean
clean:
	rm -f *.o program
```
- 実在しないターゲット（ファイルではなくコマンド）を宣言
- ないと、実ファイル `clean` が生成されて以降の実行がスキップされる

## Make の実行メカニズム

Make は **ファイルの更新時刻（mtime）** で差分判定：

```
target が存在する？
├─ なし → レシピ実行
└─ あり ↓
   target の mtime < 依存ファイルの mtime？
    ├─ YES → 依存ファイルが新しい = レシピ実行
    └─ NO → 最新 = スキップ
```

実例：
```bash
$ make program
gcc -c main.c -o main.o
gcc -o program main.o

$ make program              # 2回目
make: 'program' is up to date.

$ touch main.c              # 更新時刻を変更
$ make program              # 差分のみ再実行
gcc -c main.c -o main.o
gcc -o program main.o
```

## 依存関係の自動解決

```makefile
program: main.o utils.o
main.o: main.c
utils.o: utils.c
```

`make program` 実行時：
1. `main.c` の mtime > `main.o` の mtime なら `main.o` を再構築
2. `utils.c` の mtime > `utils.o` の mtime なら `utils.o` を再構築
3. 上記のどちらか実行されたら `program` を再構築

鎖状に依存関係を解決する。

## 現代での使われ方

Node.js の `package.json` scripts と同じ感覚で使われることが多い：

```makefile
.PHONY: setup preview new

setup:
	npm install
	npm run build

preview:
	quartz build -o public
	python -m http.server 3000

new:
	mkdir -p notes/$(path)
	cp template.md notes/$(path)/index.md
```

この場合、依存関係チェック機能は活用されていない。単なるコマンド短縮形。

## まとめ

- **本来の用途** - ファイル依存関係を管理したビルドシステム
- **重要** - 更新時刻で差分判定して効率化
- **現代での使い方** - シェルスクリプトの代わりのコマンドランナー
