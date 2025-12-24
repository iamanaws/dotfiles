{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  darwinModules,
  homeUsersRoot,
  ...
}:

{
  imports = [
    darwinModules.default
    ./homebrew.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  system.primaryUser = "iamanaws";

  fonts.packages = with pkgs.nerd-fonts; [ caskaydia-mono ];

  environment.systemPackages = with pkgs; [
    asciidoctor
    cachix
    code-cursor
    colima
    docker
    docker-compose
    # flameshot
    # google-chrome
    jetbrains-toolbox
    jujutsu
    libreoffice-bin
    mongodb-compass
    # mongodb-atlas-cli
    # mongodb-cli
    ngrok
    nsnake
    postman
    # spotify
    nodejs
    corepack
    bun
  ];

  system.defaults = {
    controlcenter.WiFi = lib.mkForce true;

    dock = {
      autohide = true;
      expose-group-apps = true;
      magnification = false;
      minimize-to-application = true;
      mru-spaces = false;
      persistent-apps = [
        "/System/Applications/Notes.app"
        "/System/Applications/System Settings.app"
        "/Applications/Google Chrome.app"
        "/Applications/Nix Apps/Cursor.app"
        "/Applications/Nix Apps/Ghostty.app"
        "/Applications/Nix Apps/MongoDB Compass.app"
        "/Applications//Nix Apps/Postman.app"
        # "/Applications/Nix Apps/Spotify.app"
        "/Applications/ClickUp.app"
      ];
      show-recents = false;

      wvous-bl-corner = 14;
      wvous-br-corner = 4;
      wvous-tl-corner = 5;
      wvous-tr-corner = 2;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "Nlsv";
      FXRemoveOldTrashItems = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file:///Users/iamanaws/Downloads/";
      ShowPathbar = true;
      _FXShowPosixPathInTitle = false;
      _FXSortFoldersFirst = true;
      _FXSortFoldersFirstOnDesktop = true;
    };
  };
}
