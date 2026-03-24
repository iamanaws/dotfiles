# graphical.nix
{
  inputs,
  outputs,
  config,
  hostConfig,
  lib,
  pkgs,
  nixosModules,
  ...
}:
{
  imports = [
    nixosModules.programs.firefox
  ]
  ++ lib.optional hostConfig.hyprland nixosModules.display.hyprland
  ++ lib.optional hostConfig.gnome nixosModules.programs.gnome;

  fonts.packages = with pkgs; [
    nerd-fonts.caskaydia-cove
    nerd-fonts.ubuntu-mono
  ];

  services = {

  };

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = (
    with pkgs;
    [
      brave
      clapper
      imv
      # ghostty
      fuse

      brightnessctl
      playerctl
      tray-tui

      rofi
      dmenu-wpctl
      rofi-bluetooth
      networkmanager_dmenu
    ]
    ++ lib.optionals hostConfig.hyprland [
      grim
      slurp
      hyprpaper
      hyprpicker
      hyprsysteminfo
      # hyprlock
      hyprsunset
      hyprpolkitagent
      wl-clipboard
    ]
  );

  xdg.portal = {
    enable = true;
    extraPortals =
      with pkgs;
      [
        xdg-desktop-portal-gtk
      ]
      ++ lib.optionals hostConfig.hyprland [
        xdg-desktop-portal-hyprland
      ];

    config = {
      common = {
        # Use xdg-desktop-portal-gtk for every interface unless otherwise specified
        default = [ "gtk" ];
      };
    }
    // lib.optionalAttrs hostConfig.hyprland {
      hyprland = {
        # For Hyprland sessions, use the hyprland portal first, then gtk as a fallback
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  security.polkit.enable = true;
}
