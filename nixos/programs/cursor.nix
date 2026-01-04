{
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;
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
}
