# Universal Dotfiles & Dev Environment

> **Works on macOS (Apple Silicon & Intel), Windows 11 + WSL2, and any Docker‑based workspace (VS Code Dev Container / GitHub Codespaces).**

---

## 1  Why this repo?

| Goal | How it’s achieved |
|-----|------------------|
| **Dotfile templating & secrets** | [`chezmoi`](https://www.chezmoi.io/) |
| **Declarative packages & editor plugins** | [`Nix` + `home‑manager`](https://nix-community.github.io/home-manager/) |
| **Identical Linux everywhere** | VS Code **Dev Container** / **Remote‑WSL** |

Everything lives in one Git repo, bootstrapped by a single script. Bring‑up time on a fresh machine is ≈3 minutes (network speed permitting).

---

## 2  Repository layout

```
▾ dotfiles/
  bootstrap.sh          # One‑liner setup for new hosts
  flake.nix             # Nix flake entry‑point
  home.nix              # Common Home Manager module
  darwin.nix            # macOS‑specific options (nix‑darwin)
  .chezmoirc.tmpl       # chezmoi config – template aware
  ▾ dot_files/          # Actual dotfiles (can be *.tmpl)
  ▾ .devcontainer/
    devcontainer.json   # VS Code Dev Container config
    Dockerfile          # Pre‑baked Nix image for speed
```

---

## 3  Quick Start

### 3‑1  New machine bootstrap

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/dotfiles/main/bootstrap.sh | bash
```

What the script does:
1. **Install & run `chezmoi`** → dotfiles placed under `$HOME`.
2. **Install multi‑user Nix** (`--daemon`) – required for WSL/macOS.
3. **Activate Home‑Manager**: `home-manager switch --flake ~/dotfiles`.

> **macOS**: after Nix install, `nix-darwin switch --flake ~/dotfiles` gives system‑wide settings (keyboard, brew casks, etc.).
>
> **Windows**: run inside *Ubuntu‑22.04* on WSL2. Enable systemd by adding `systemd=true` to `/etc/wsl.conf`, then restart WSL.

### 3‑2  Dev Container / Codespaces

1. Open the repo in VS Code → *“Reopen in Container”* prompt appears.
2. The provided `Dockerfile` + `devcontainer.json` install Nix & run `home-manager switch` automatically.
3. Fish shell + Neovim + pinned CLI tools are ready to use.

---

## 4  Secrets & private data

* Any file ending in `.age` or `.gpg` is encrypted and safe to commit publicly.
* Decryption happens on‑the‑fly with `chezmoi`. Keep your private key on a USB YubiKey or `~/.config/age/keys.txt` **outside** the repo.
* Example: `dot_files/.ssh/id_ed25519` ⇒ committed as `id_ed25519.age`.

---

## 5  Daily workflow

| Action | Command |
|--------|---------|
| **Update packages/plugins** | `nix flake update` → `home-manager switch --flake .` |
| **Add new global tool** | Edit `home.nix` → `home-manager switch` |
| **Edit dotfile** | Modify under `dot_files/` → `chezmoi apply` |
| **Push to GitHub** | `git commit -am "feat: ..." && git push` |

Codespaces/WSL containers only need `git pull && home-manager switch` to sync.

---

## 6  Troubleshooting

| Symptom | Fix |
|---------|-----|
| **Flake lock gigantic** | `nix flake lock --update-input nixpkgs --recreate-lock-file` |
| **Neovim Treesitter build fails (mac M‑series)** | Add `libiconv` & `pkg-config` to `extraPackages` |
| **Fish completion broken** | Ensure `direnv hook fish | source` is in `config.fish` |
| **Dev Container slow to build** | Push pre‑built image to `ghcr.io` and reference it in `devcontainer.json` |
| **Corporate proxy stalls Nix** | `nix.settings.http-connections = 0` in `flake.nix` |

---

## 7  FAQ

### Q : *Can I swap fish for zsh?*
Add `programs.zsh.enable = true;` and flip default shell in `home.nix`.

### Q : *Do I **need** Docker on macOS?*
No. Native macOS runs via `nix-darwin`. Docker is only for isolated projects or Codespaces.

### Q : *What about ARM Linux servers?*
Add `aarch64-linux` to the `systems` array in `flake.nix`; everything else stays the same.

---

## 8  Contributing / Extending

1. Fork and clone the repo.
2. Make your edits **only** in `dot_files/`, `home.nix`, or `.devcontainer/`.
3. Test with `nix develop --command fish` locally; if it works there, it will work everywhere.

PRs are welcome! Please run `./scripts/lint.sh` before pushing.

---

## 9  License

All code and configs are MIT‑licensed. Encrypted secrets belong to you – do **not** push your private decryption keys.

---

Happy hacking – may your environments finally behave the same wherever you open a terminal ✨

