{ config, pkgs, ... }:

{
  # zsh is managed by chezmoi (oh-my-zsh + p10k)
  # This module provides additional shell tools

  home.packages = with pkgs; [
    # Shell utilities
    zsh
    starship
    direnv

    # Terminal multiplexer
    tmux
  ];

  # Starship prompt (backup/alternative to p10k)
  programs.starship = {
    enable = true;
    enableZshIntegration = false;  # Using p10k instead
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  # direnv for automatic environment loading
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    extraConfig = ''
      # Better prefix
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Vi-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Reload config
      bind r source-file ~/.tmux.conf \; display "Config reloaded!"
    '';
  };
}
