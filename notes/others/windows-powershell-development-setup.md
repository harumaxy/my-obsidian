---
title: Windows PowerShell 開発環境セットアップガイド
description: macOS から Windows への移行ガイド。PowerShell 7 + Scoop を使った開発環境構築、WSL との使い分け、実践的な落とし穴対策を網羅
aliases:
  - PowerShell 開発環境
  - Windows 開発環境
tags:
  - Windows
  - PowerShell
  - 開発環境
  - ComfyUI
draft: false
date: 2026-06-25
---

## 背景

macOS/zsh + Homebrew + ghq/fzf の開発環境を Windows に移植する際の実践的ガイド。特に ComfyUI のようなホストマシン側の GUIツール + Python 環境 を扱う場合、Windows ネイティブ(PowerShell) が WSL よりも効率的な判断をまとめたもの。

## 用途別：WSL vs PowerShell ネイティブの判断基準

### Web 開発・CLI で完結する場合 → **WSL2 一択**

Node.js、Python、Ruby、Docker などのエコシステムは基本的に Linux ファーストで設計されているため、Windows ネイティブだと細かい非互換やハマりどころが出やすい。本番環境もほぼ Linux なので、開発環境を合わせられる意味は大きい。

**ただし注意：** プロジェクトのファイルは **WSL 側のファイルシステム** ( ~/projects/ など) に置くこと。Windows 側 (/mnt/c/...) に置いて WSL からアクセスするとファイル I/O が極端に遅くなり、npm install やホットリロードが体感で重くなる。

### ホスト側 GUIツール + Python の場合 → **Windows ネイティブ + PowerShell**

- **Unity**: 実質 Windows ネイティブアプリ。プロジェクトと IDE も Windows 側で統一するのが自然
- **ComfyUI**: Python ベースだが、GPU 構成のシンプルさを考慮すると Windows ネイティブが無難。ファイルI/O が頻繁で、大量の モデルファイル (数GB〜数十GB) を扱うワークロードでは `/mnt/c` 越えのペナルティが効く

## 足回りの準備

### PowerShell 7 のインストール

Windows 標準の「Windows PowerShell 5.1 (powershell.exe)」は古い別物なので避ける。PowerShell 7+ (pwsh.exe) を使う。

```powershell
winget install Microsoft.PowerShell
```

### ターミナル

Windows Terminal (iTerm2 相当)。Windows 11 なら標準搭載。

### 実行ポリシーの設定

自作スクリプト・プロファイルが動かない場合、以下を実行（要管理者権限）：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## パッケージ・ツール管理

Windows には複数のパッケージマネージャがあり、用途で使い分ける：

| ツール | 立ち位置 | 用途 |
|--------|--------|------|
| **winget** | OS 標準・公式 | GUIアプリ、Git、ランタイム系 |
| **Scoop** | ユーザー空間・管理者不要 | Unix 系 CLI ツール（Homebrew に最も近い） |
| **Chocolatey** | システム全体・要管理者 | 必要に応じて |

**Scoop** が Homebrew の精神的後継。ユーザーディレクトリにインストールされ、UAC を出さず、manifest ベース。CLI 系はこれで揃えるのが快適。

### Scoop 導入と基本ツールのインストール

```powershell
# Scoop 導入
irm get.scoop.sh | iex
scoop bucket add extras

# Unix な道具一式（mac で使ってたやつの Windows 版）
scoop install git fzf ghq ripgrep fd bat zoxide starship jq delta
```

### Python 環境

ComfyUI 用途なら **uv (Astral)** を強く推奨。pyenv-win は Windows では挙動が微妙で、uv なら Python 本体の取得・venv・依存解決が一括で速く、クロスプラットフォーム対応。

```powershell
scoop install uv
# または
winget install astral-sh.uv
```

## シェル設定 ($PROFILE = .zshrc 相当)

```powershell
notepad $PROFILE   # ファイルがなければ New-Item -Path $PROFILE -ItemType File -Force で作成
```

実用的なスターター設定：

```powershell
# --- PSReadLine: 履歴予測 + メニュー補完（zsh-autosuggestions 相当）---
Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView -EditMode Emacs
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# --- zoxide (z コマンド) / starship プロンプト ---
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Invoke-Expression (&starship init powershell)

# --- curl/wget の罠つぶし（詳細は落とし穴セクション参照）---
Remove-Item Alias:curl -ErrorAction SilentlyContinue
Remove-Item Alias:wget -ErrorAction SilentlyContinue

# --- エイリアス例 ---
Set-Alias g git
```

PSReadLine と starship/zoxide が入るだけで、体感が zsh + プラグイン に近づく。

## ghq + fzf の活用

両方とも Go バイナリで Windows ネイティブで動く。

### リポジトリ移動コマンド

```powershell
# $PROFILE に追記
function repo {
    $dir = ghq list -p | fzf
    if ($dir) { Set-Location $dir }
}
```

### ghq のセットアップ

```powershell
git config --global ghq.root "$HOME/ghq"
```

### PSFzf (fzf キーバインド統合)

Ctrl+T、Ctrl+R での履歴検索が欲しければ：

```powershell
Install-Module PSFzf -Scope CurrentUser

# $PROFILE で
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
```

## 環境変数

macOS と異なり、セッション内・永続で構文が分かれる：

```powershell
# その場（セッション内）— export 相当
$env:FOO = "bar"

# 永続（ユーザー単位）
[System.Environment]::SetEnvironmentVariable("FOO", "bar", "User")
```

永続設定は新しいシェルを開かないと反映されない（現セッションには効かない）。

PATH は区切りが `:` ではなく `;`。.env の自動読み込みは標準にないので、プロジェクト単位なら uv/各ツールの .env 機能か direnv (Scoop にあり) を使う。

## 特有の落とし穴

### 1. curl / wget がエイリアス（重要）

PowerShell では curl が `Invoke-WebRequest` のエイリアスで、本物の `curl.exe` を隠す。モデルのダウンロードをCLIでやる場合、これは致命的。

対策：上の $PROFILE に `Remove-Item Alias:curl` を入れるか、明示的に `curl.exe` と打つ。確認：

```powershell
Get-Command curl
```

### 2. MAX_PATH 260文字制限

ComfyUI / Python の深い site-packages や node_modules で踏む。長パス有効化（要管理者）：

```powershell
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name LongPathsEnabled -Value 1
git config --global core.longpaths true
```

### 3. OneDrive の Documents リダイレクト

\$PROFILE が置かれる Documents が OneDrive 同期下にあると、プロファイルが見つからない・同期で壊れるなどの混乱が起きる。$PROFILE を実際に開いて場所を確認しておく。

### 4. Windows Defender のリアルタイムスキャン

小さいファイル大量操作 (pip/uv install、モデル展開) を遅くする。開発フォルダとモデル置き場を除外推奨（要管理者）：

```powershell
Add-MpPreference -ExclusionPath "C:\Users\you\ghq"
Add-MpPreference -ExclusionPath "D:\comfyui"
```

### 5. 改行コード (CRLF)

macOS と揃える：

```powershell
git config --global core.autocrlf input
```

### 6. シンボリックリンク・引数渡し

symlink は「開発者モード」を ON にしないと管理者権限が要る。ネイティブ exe への引数渡しは PowerShell 7.4+ の `$PSNativeCommandArgumentPassing` で改善している。

### 7. ファイルシステムの大小文字区別

ファイルシステムは大小文字を区別しない。これは macOS デフォルトと同じなので混乱は少ない。

## WSL のアンインストール手順

WSL を完全に削除したい場合の手順。

### 注意

WSL 内のファイル領域 (~/以下など) は削除操作で完全に消えて復元できない。残したいファイルがあれば先に Windows 側へ退避：

```powershell
# WSL内のファイルをWindows側にコピー
copy \\wsl$\Ubuntu\home\yourname\keep .\backup\ -Recurse
# (\\wsl$\<ディストリ名>\... で Windows のエクスプローラ/PowerShell から WSL 内が見える)
```

### 手順 1: 入っているディストリを確認

```powershell
wsl --list --verbose
```

NAME 列の正確な名前（Ubuntu など）を控える。

### 手順 2: ディストリを登録解除（ファイル領域を完全削除）

vhdx ファイルごと消える：

```powershell
wsl --unregister Ubuntu
```

Ubuntu の部分は実際の名前に置き換え。複数あるなら一つずつ実行。

### 手順 3: WSL システム自体を無効化（オプション）

#### (A) WSL の仕組みは残すが、ディストリだけ消したい

手順 2 までで完了。後で別ディストリを入れられる。

#### (B) WSL 機能そのものを Windows から消す

Microsoft Store 版の WSL アプリをアンインストール：

```powershell
winget uninstall "Windows Subsystem for Linux"
```

Windows の機能を無効化（要管理者）：

```powershell
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

⚠️ VirtualMachinePlatform は Docker Desktop など他の仮想化機能でも使っているので注意。

再起動で完了。

### 手順 4: 残骸の掃除（任意）

%LOCALAPPDATA%\Packages 配下にディストリ関連フォルダが残ることがあるが、通常は手順 2 の --unregister でディスク実体は消えているので不要。

## WSL 削除が高速な理由

`wsl --unregister` で数十GB がほぼ一瞬で消える場合、2段階の仕組みがある：

### からくり 1: 消しているのは「1個の大きなファイル」

WSL2 のディストリのファイル領域は、Windows から見ると **ext4.vhdx** という単一の仮想ディスクファイル 1 個として存在。WSL 内の何万個ものファイルは、この 1 ファイルの「中身」として ext4 ファイルシステムの形で詰まっているだけ。

wsl --unregister がやるのは：

1. レジストリからディストリの登録情報 (GUID、BasePath など) を削除
2. その ext4.vhdx ファイルを 1 個削除

OS にとっては「巨大なファイルを 1 個消す」だけなので、中に何万ファイル入っていようと関係ない。

### からくり 2: ファイル削除は「中身を消さない」

ファイル削除は、データ本体を上書き消去する操作ではなく、ファイルシステムが「この領域は空きですよ」とメタデータ上のマークを書き換えるだけ。実際のデータのビット列はディスク上に残り、後で別のデータに上書きされるまで放置される。だから削除サイズが 10MB でも 100GB でも、所要時間はほぼ変わらない（消す対象が「1 個」である限り）。

**対比：** もし WSL 内のファイルが Windows のディスク上に「素のファイル群」として展開されていたら、削除はもっと遅かった（1ファイルごとにメタデータ更新、ディレクトリエントリの走査、Defender のスキャン…を何万回も繰り返す）。node_modules の削除が遅いのと同じ原因。WSL2 はファイル群を vhdx の中に「封じ込めて」いるおかげで、この問題を回避できている。

### ディスク容量の小ネタ

WSL を使い続ける場合、vhdx は使うと膨らむ一方で、中のファイルを消しても自動では縮まない（シックプロビジョニング的挙動）。手動コンパクションが必要になることがある（diskpart や Optimize-VHD）。今回丸ごと消した場合は無関係。

## ComfyUI × Claude Code の補足

Claude Code CLI も MCP も Windows ネイティブで動かせる。ComfyUI 操作用の MCP サーバーはいくつか公開されているが、具体的な導入はそれぞれの設定で異なる。

基本的な環境は「PowerShell 7 + Windows Terminal + Scoop で CLI 一式 + uv で Python/ComfyUI 環境」で固まれば、macOS とほぼ同じ感覚で開発・運用できるようになる。

## まとめ表

| ユースケース | 推奨 | 補足 |
|-----------|-----|------|
| Web 開発・CLI 完結 | WSL2 | ファイルは WSL 側に置く / VS Code + WSL 拡張 |
| Unity | Windows ネイティブ + PowerShell | プロジェクトもツールも Windows 側で統一 |
| ComfyUI | Windows ネイティブが無難 | WSLでも可能。ファイルI/O とGPU構成で優位 |

現実的には両方入れて「Linux っぽい開発は WSL、GUIツールは Windows ネイティブ」と役割分担するのがベストプラクティス。VS Code がその橋渡しをしてくれるので、行き来のストレスは小さく済む。
