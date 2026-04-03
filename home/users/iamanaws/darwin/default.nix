{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    ../.
    ../config/shell/zsh.nix
  ];

  home.activation.removeLegacyHomeManagerAppsSymlink =
    lib.hm.dag.entryBefore [ "checkAppManagementPermission" ]
      # bash
      ''
        targetFolder='Applications/Home Manager Apps'

        ourLegacyLink() {
          local link
          link=$(readlink "$1")
          [ -L "$1" ] && [ "''${link#*-}" = 'home-manager-files/Applications/Home Manager Apps' ]
        }

        if [ -e "$targetFolder" ] && ourLegacyLink "$targetFolder"; then
          run rm "$targetFolder"
        fi
      '';

  home = {
    username = "iamanaws";
    homeDirectory = "/Users/iamanaws";
  };
}
