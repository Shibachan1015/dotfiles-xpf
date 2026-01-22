{ config, pkgs, lib, ... }:

{
  home.username = lib.mkForce "takasiba";
  home.homeDirectory = lib.mkForce "/home/takasiba";

  # WSL-specific packages
  home.packages = with pkgs; [
    # SSH keychain for persistent SSH agent
    keychain

    # WSL utilities
    wslu  # WSL utilities (wslview, etc.)

    # Windows interop
    wsl-open
  ];

  # WSL-specific environment variables
  home.sessionVariables = {
    # Use wslview as default browser
    BROWSER = "wslview";
  };
}
