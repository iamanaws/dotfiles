# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  systemType,
  hostConfig,
  ...
}:

let
  flakeOverlays =
    if outputs ? overlays then outputs.overlays else import ../../../overlays { inherit inputs; };
in
{
  # You can import other home-manager modules here
  imports = [ ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      flakeOverlays.additions
      flakeOverlays.modifications

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Add environment variables
  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "ghmbeldphafepmbegfdlkpapadhbakde" # proton pass
      "dphilobhebphkdjbpfohgikllaljmgbn" # simplelogin
      "fnaicdffflnofjppbagibeoednhnbjhg" # floccus
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
      "oldceeleldhonbafppcapldpdifcinji" # language tool
      "lnjaiaapbakfhlbjenjkhffcdpoompki" # catppuccin github icons
      "gbmdgpbipfallnflgajpaliibnhdgobh" # json viewer
      "gaiceihehajjahakcglkhmdbbdclbnlf" # video speed controller
      "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
    ];

    commandLineArgs = [
      # "--enable-features=UseOzonePlatform "
      # "--ozone-platform=x11"
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "iamanaws";
    userEmail = "78835633+Iamanaws@users.noreply.github.com";
    extraConfig = {
      core.editor = "vim";
      init.defaultBranch = "main";
      fetch.prune = true;
      fetch.prunetags = true;
      merge.conflictStyle = "zdiff3";
      push.autosetupremote = true;
      push.followtags = true;

      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      help.autocorrect = "prompt";

      #log.date = "iso";
      branch.sort = "-committerdate";
      tag.sort = "taggerdate";

      # better submodule logs
      status.submoduleSummary = true;
      diff.submodule = "log";

      # avoid data corruption
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };

    aliases = {
      pu = "push";
      co = "checkout";
      cm = "commit";
    };

    ignores = [
      ".env"

      ".DS_Store"
      # ".vscode"
      # ".idea"
    ];

    hooks = {
      pre-commit = ./pre-commit;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
