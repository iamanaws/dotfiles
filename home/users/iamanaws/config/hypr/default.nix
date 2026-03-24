{
  inputs,
  config,
  lib,
  pkgs,
  hostConfig,
  ...
}:
lib.optionalAttrs hostConfig.hyprland {
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock/hyprlock.nix
    ./hyprpaper.nix
    ./waybar.nix
  ];
}
