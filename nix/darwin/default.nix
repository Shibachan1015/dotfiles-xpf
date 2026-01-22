{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  # Nix configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "takao" ];
  };

  # System-level packages
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
  ];

  # Enable zsh as default shell
  programs.zsh.enable = true;

  # macOS system settings
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.4;
      orientation = "bottom";
      tilesize = 48;
      show-recents = false;
      mru-spaces = false;
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";  # Search current folder
      FXPreferredViewStyle = "Nlsv";  # List view
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    # NSGlobalDomain (general settings)
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };
  };

  # Security
  security.pam.enableSudoTouchIdAuth = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Required for nix-darwin
  system.stateVersion = 4;
}
