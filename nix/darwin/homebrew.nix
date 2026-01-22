{ config, pkgs, lib, ... }:

{
  # Homebrew management via nix-darwin
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    # Homebrew taps
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    # CLI tools installed via Homebrew
    brews = [
      "mas"  # Mac App Store CLI
    ];

    # GUI applications installed via Homebrew Cask
    casks = [
      # Development
      "visual-studio-code"
      "iterm2"
      "docker"

      # Browsers
      "google-chrome"
      "firefox"
      "arc"

      # Productivity
      "raycast"
      "1password"
      "notion"

      # Communication
      "slack"
      "discord"
      "zoom"

      # Utilities
      "rectangle"  # Window manager
      "karabiner-elements"  # Keyboard customization
      "stats"  # System monitor

      # Media
      "spotify"
      "vlc"
    ];

    # Mac App Store applications
    masApps = {
      # "App Name" = AppStoreID;
      # Example:
      # "Xcode" = 497799835;
    };
  };
}
