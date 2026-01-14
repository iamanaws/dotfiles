{
  config,
  lib,
  pkgs,
  systemType,
  hostConfig,
  ...
}:

lib.optionalAttrs (systemType != null) {
  imports = [ ../../../shared/services/flatpak.nix ];

  home.packages = with pkgs; [
    bitwarden-desktop
    cutter
    # gramps
    pcmanfm
  ];

  services.flatpak.packages = lib.optionals (hostConfig.device.hostname == "goliath") [
    rec {
      appId = "com.hypixel.HytaleLauncher";
      sha256 = "sha256-iBYZTbm82X+CbF9v/7pwOxxxfK/bwlBValCAVC5xgV8=";
      bundle = "${pkgs.fetchurl {
        url = "https://launcher.hytale.com/builds/release/linux/amd64/hytale-launcher-latest.flatpak";
        inherit sha256;
      }}";
    }
  ];

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    x11.enable = true;
  };

  # Configure GTK themes
  gtk = {
    enable = true;
    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };
    cursorTheme = {
      name = "WhiteSur-cursors";
      package = pkgs.whitesur-cursors;
    };
    iconTheme = {
      name = "kuyen-icons";
      package = pkgs.kuyen-icons;
    };
  };

  # mimeApps - find / -name '*.desktop'
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/octet-stream" = [ "re.rizin.cutter.desktop" ];
        "application/pdf" = [ "cursor.desktop" ];
        "application/json" = [ "cursor.desktop" ];

        "image/*" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/svg+xml" = [ "imv.desktop" ];
        "image/webp" = [ "imv.desktop" ];

        "text/*" = [ "cursor.desktop" ];
        "text/html" = [ "cursor.desktop" ];
        "text/plain" = [ "cursor.desktop" ];

        "video/*" = [ "com.github.rafostar.Clapper.desktop" ];
        "video/mp4" = [ "com.github.rafostar.Clapper.desktop" ];
        "video/mpeg" = [ "com.github.rafostar.Clapper.desktop" ];
        "video/ogg" = [ "com.github.rafostar.Clapper.desktop" ];
        "video/webm" = [ "com.github.rafostar.Clapper.desktop" ];
      };
    };

    userDirs = {
      enable = true;
      # createDirectories = true;
      # desktop = "$HOME/desktop";
      download = "$HOME/downloads";
      # templates = "$HOME/templates";
      # publicShare = "$HOME/public";
      documents = "$HOME/files/documents";
      music = "/run/media/iamanaws/DATA/Music/FLAC";
      pictures = "$HOME/files/media/pictures";
      videos = "$HOME/files/media/videos";
      extraConfig = {
        #XDG_MISC_DIR = "$HOME/misc";
        #XDG_GAMES_DIR = "$HOME/games";
        #XDG_WALLPAPERS_DIR = "$HOME/repos/dotfiles/media/shared/wallpapers";
      };
    };
  };

  programs.rofi = {
    enable = true;
    # font = "CascadiaCode";
    theme = "Arc-Dark";
    extraConfig = {
      show-icons = true;
    };
  };
}
