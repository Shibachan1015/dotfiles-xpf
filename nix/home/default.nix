{ config, pkgs, lib, ... }:

{
  imports = [
    ./shells.nix
    ./editors.nix
  ];

  home.username = lib.mkDefault "takao";
  home.homeDirectory = lib.mkDefault "/home/takao";
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Common packages for all systems
  home.packages = with pkgs; [
    # Development tools
    git
    gh
    delta
    lazygit
    ripgrep
    fd
    jq
    yq
    fzf
    bat
    eza
    tree
    htop
    btop

    # Network tools
    curl
    wget
    httpie

    # Archive tools
    unzip
    zip

    # Text processing
    gnused
    gawk
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "takao";
    userEmail = "siba1015@cpost.plala.or.jp";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # bat (cat replacement)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  # eza (ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };
}
