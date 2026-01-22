# Dotfiles

> zsh (oh-my-zsh + Powerlevel10k) をメインシェルとした WSL/macOS 両対応の dotfiles 管理環境

## 概要

| ツール | 役割 |
|--------|------|
| **chezmoi** | OS別テンプレート、シークレット暗号化、シンボリックリンク管理 |
| **Nix/Home-Manager** | パッケージ管理、エディタ設定の宣言的管理 |
| **nix-darwin** | macOSシステム設定（Homebrew含む） |

## ディレクトリ構造

```
~/dotfiles/
├── README.md
├── bootstrap.sh                   # ワンコマンドインストーラー
│
├── .chezmoi.toml.tmpl             # OS検出・設定
├── .chezmoiexternal.toml          # 外部依存（oh-my-zsh等）
├── .chezmoiignore                 # OS別除外ルール
│
├── dot_zshrc.tmpl                 # zsh設定（メイン・テンプレート）
├── dot_p10k.zsh                   # Powerlevel10k設定
├── dot_config/                    # ~/.config配下
│
└── nix/                           # Nix設定
    ├── flake.nix                  # メインフレーク
    ├── home/
    │   ├── default.nix            # 共通設定
    │   ├── shells.nix             # シェル設定
    │   ├── editors.nix            # エディタ設定
    │   ├── wsl.nix                # WSL固有
    │   └── darwin-home.nix        # macOS固有
    └── darwin/
        ├── default.nix            # macOSシステム設定
        └── homebrew.nix           # Homebrew管理
```

## クイックスタート

### 新しいマシンでのセットアップ

```bash
curl -fsSL https://raw.githubusercontent.com/shibachan1015/dotfiles/main/bootstrap.sh | bash
```

### 手動セットアップ

```bash
# 1. chezmoi インストール
sh -c "$(curl -fsLS get.chezmoi.io)"

# 2. dotfiles 適用
chezmoi init --apply shibachan1015/dotfiles

# 3. Nix インストール (マルチユーザー)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 4. Home Manager 適用
nix run home-manager/master -- switch --flake ~/dotfiles/nix#$(whoami)
```

## OS別設定

### WSL (Windows Subsystem for Linux)

- **SSH Agent**: keychain で SSH エージェントを永続化
- **ブラウザ**: wslview で Windows ブラウザを使用
- **X11転送**: Windows 側の X Server (VcXsrv等) と連携可能

### macOS

- **SSH Agent**: 1Password SSH Agent を使用
- **Homebrew**: nix-darwin で宣言的に管理
- **システム設定**: Dock、Finder、キーボードなどを自動設定

## 主要な設定

### シェル (zsh)

- **テーマ**: Powerlevel10k (rainbow スタイル)
- **プラグイン**:
  - zsh-autosuggestions (コマンド補完)
  - zsh-syntax-highlighting (シンタックスハイライト)

### エイリアス

```bash
# Claude Code
cc   # claude
ccc  # claude --continue
ccd  # claude --dangerously-skip-permissions
ccdc # claude --dangerously-skip-permissions --continue
ccup # Claude Code アップグレード

# Git
g    # git
lg   # lazygit

# その他
vim  # nvim
ll   # ls -l
la   # ls -la
```

### パッケージ (Nix で管理)

- **開発ツール**: git, gh, delta, lazygit, ripgrep, fd, jq, fzf, bat, eza
- **エディタ**: neovim (+ LSP, treesitter)
- **シェルツール**: tmux, direnv, starship

## 日常的な操作

| 操作 | コマンド |
|------|----------|
| dotfiles を更新 | `chezmoi update` |
| dotfiles を適用 | `chezmoi apply` |
| パッケージを更新 | `cd ~/dotfiles/nix && nix flake update` |
| Home Manager を適用 | `home-manager switch --flake ~/dotfiles/nix` |
| 変更をプレビュー | `chezmoi diff` |

## 検証方法

```bash
# 1. dry-run で変更内容を確認
chezmoi apply --dry-run

# 2. 適用
chezmoi apply

# 3. SSH 接続テスト
ssh -T git@github.com
```

## ライセンス

MIT
