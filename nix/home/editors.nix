{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Language servers
    nil  # Nix LSP
    lua-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON LSP
    pyright

    # Formatters
    nixpkgs-fmt
    stylua
    nodePackages.prettier
    black

    # Tools for nvim
    tree-sitter
  ];

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc  # for treesitter
      gnumake
      nodejs
    ];

    # Plugins managed separately or via lazy.nvim
    # This just ensures neovim is installed with proper dependencies
  };

  # Vim (fallback)
  programs.vim = {
    enable = true;
    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
    };
    extraConfig = ''
      set encoding=utf-8
      set fileencoding=utf-8
      syntax enable
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase
      set autoindent
      set smartindent
      set clipboard=unnamedplus
    '';
  };
}
