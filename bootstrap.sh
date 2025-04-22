#!/usr/bin/env bash
set -eux

# 1) chezmoi
command -v chezmoi >/dev/null 2>&1 || \
  sh -c "$(curl -fsLS get.chezmoi.io)"  # ダウンロード&インストール :contentReference[oaicite:0]{index=0}
chezmoi init --apply takao

# 2) Nix (マルチユーザ版)
if ! command -v nix; then
  sh <(curl -L https://nixos.org/nix/install) --daemon  # :contentReference[oaicite:1]{index=1}
fi

# 3) home‑manager (flakes)
nix run home-manager/master -- switch --flake ~/dotfiles#$(whoami)

echo "Bootstrap complete! -> Reload shell"
