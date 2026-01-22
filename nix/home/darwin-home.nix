{ config, pkgs, lib, ... }:

{
  imports = [
    ./default.nix
  ];

  home.username = lib.mkForce "takao";
  home.homeDirectory = lib.mkForce "/Users/takao";

  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS utilities
    coreutils
    findutils
    gnugrep
    gnutar

    # macOS development
    cocoapods
  ];

  # macOS-specific settings
  home.sessionVariables = {
    # Use 1Password SSH agent
    SSH_AUTH_SOCK = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };
}
