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
      userSettings = {
        "editor.fontFamily" = "'CaskaydiaCove NF'";
        "editor.tabSize" = 2;
        # "extensions.autoUpdate" = false;
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
        "update.mode" = "none";
        "window.menuBarVisibility" = "toggle";
        "workbench.colorTheme" = "Tokyo Night Storm";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.productIconTheme" = "fluent-icons";
      };
      extensions = with pkgs.vscode-extensions; [
        asciidoctor.asciidoctor-vscode
        enkia.tokyo-night
        foxundermoon.shell-format
        jnoortheen.nix-ide
        pkief.material-icon-theme
        tamasfe.even-better-toml
        tomoki1207.pdf

        #dsznajder.es7-react-js-snippets
        #miguelsolorio.fluent-icons
        #nomicfoundation.hardhat-solidity
      ];
    };
  };
}
