{
  lib,
  hostConfig,
  ...
}:
{
  config = lib.optionalAttrs hostConfig.isGraphical {
    programs.brave = {
      enable = true;
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
        "nffaoalbilbmmfgbnbgppjihopabppdk" # video speed controller
        "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
      ];

      commandLineArgs = [
        # "--enable-features=UseOzonePlatform "
        # "--ozone-platform=x11"
      ];
    };
  };
}
