{
  inputs,
  config,
  pkgs,
  ...
}:

let
  homebrew-cask = pkgs.runCommand "homebrew-cask-flameshot-override" {
    src = inputs.homebrew-cask;
  } ''
    cp -R "$src" "$out"
    chmod -R u+w "$out"

    substituteInPlace "$out/Casks/f/flameshot.rb" \
      --replace-fail $'\n  depends_on :macos\n' $'\n'
  '';
in
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    # enableRosetta = true;

    # User owning the Homebrew prefix
    # user = "iamanaws";

    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;

    # Optional: Declarative tap management
    # Ensure to name the key as a unique folder starting with homebrew-
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    masApps = { };

    brews = [ ];

    casks = [ ];

    # handle delcaratively by nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;
  };
}
