{
  lib,
  pkgs,
  hostConfig,
  ...
}:
{
  programs.vscode = lib.optionalAttrs hostConfig.isGraphical {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      userSettings = lib.mkMerge [
        {
          "editor.fontFamily" =
            if hostConfig.isDarwin then "'CaskaydiaMono Nerd Font', monospace" else "'CaskaydiaCove NF'";
          "editor.tabSize" = 2;
          # "extensions.autoUpdate" = false;
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "update.mode" = "none";
          "window.menuBarVisibility" = "toggle";
          "workbench.colorTheme" = "Tokyo Night Storm";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.productIconTheme" = "fluent-icons";
          "[vue]" = {
            "editor.defaultFormatter" = "Vue.volar";
          };
        }
        (lib.optionalAttrs hostConfig.isDarwin {
          "editor.fontSize" = 14;
          "terminal.integrated.fontSize" = 14;
        })
      ];
      extensions = with pkgs.vscode-extensions; [
        asciidoctor.asciidoctor-vscode
        bmewburn.vscode-intelephense-client
        enkia.tokyo-night
        foxundermoon.shell-format
        jnoortheen.nix-ide
        mechatroner.rainbow-csv
        miguelsolorio.fluent-icons
        ms-pyright.pyright
        ms-python.python
        nomicfoundation.hardhat-solidity
        oderwat.indent-rainbow
        pkief.material-icon-theme
        tamasfe.even-better-toml
        tomoki1207.pdf
        redhat.vscode-xml
        redhat.vscode-yaml
        vue.volar
      ];
    };
  };
}
