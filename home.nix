programs.fish.enable = true;

programs.neovim = {
  enable = true;
  extraPackages = with pkgs; [ ripgrep ];
  plugins = with pkgs.vimPlugins; [
    lazyvim telescope-nvim nvim-treesitter
  ];
};

home.packages = with pkgs; [
  git gh delta starship
];
