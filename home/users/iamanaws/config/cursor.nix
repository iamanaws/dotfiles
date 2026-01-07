{
  lib,
  pkgs,
  systemType,
  ...
}:

{
  programs.vscode = lib.optionalAttrs (systemType != null) {
    enable = true;
    package = pkgs.code-cursor;
    profiles.default = {
      userSettings = lib.mkMerge [
        {
          "editor.fontFamily" =
            if systemType == "darwin"
            then "'CaskaydiaMono Nerd Font', monospace"
            else "'CaskaydiaCove NF'";
          "editor.tabSize" = 2;
          # "extensions.autoUpdate" = false;
          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;
          "update.mode" = "none";
          "window.menuBarVisibility" = "toggle";
          "workbench.colorTheme" = "Tokyo Night Storm";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.productIconTheme" = "fluent-icons";
        }
        (lib.optionalAttrs (systemType == "darwin") {
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
        ms-python.python
        oderwat.indent-rainbow
        pkief.material-icon-theme
        tamasfe.even-better-toml
        tomoki1207.pdf
        redhat.vscode-xml
        redhat.vscode-yaml
        vue.volar

        #anysphere.cursorpyright
        #dsznajder.es7-react-js-snippets
        #miguelsolorio.fluent-icons
        #nomicfoundation.hardhat-solidity
      ];
    };
  };
}
