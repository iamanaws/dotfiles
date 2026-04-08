{
  pkgs,
  hostConfig,
  lib,
  ...
}:
let
  mpvCheatsheetSmall = pkgs.mpvScripts.mpv-cheatsheet-ng.overrideAttrs (_: {
    postInstall = ''
      substituteInPlace "$out/share/mpv/scripts/cheatsheet.lua" \
        --replace-fail 'font_size = 8,' 'font_size = 5.5,' \
        --replace-fail 'usage_font_size = 6,' 'usage_font_size = 5,'
    '';
  });
in
lib.optionalAttrs (hostConfig.isGraphical && hostConfig.isLinux) {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      modernz
      (mpv-cheatsheet-ng.overrideAttrs (_: {
        postInstall = ''
          substituteInPlace "$out/share/mpv/scripts/cheatsheet.lua" \
            --replace-fail 'font_size = 8,' 'font_size = 5.5,' \
            --replace-fail 'usage_font_size = 6,' 'usage_font_size = 5,'
        '';
      }))
    ];
    config = {
      osc = "no";
    };
    scriptOpts = {
      stats = {
        font_size = 12;
      };
      modernz = {
        window_controls = "no";
        speed_button_click = 0.10;
        speed_button_scroll = 0.10;
        loop_button = "no";
        screenshot_button = "no";
        ontop_button = "no";
        seekbarfg_color = "#DCDFE4";
        seekbarbg_color = "#5A6374";
        nibble_color = "#DCDFE4";
        hover_effect_color = "#DCDFE4";
        playpause_size = 18;
        midbuttons_size = 16;
        sidebuttons_size = 14;
        title_font_size = 18;
        time_font_size = 12;
        tooltip_font_size = 10;
        speed_font_size = 12;
        hover_effect = "size,color";
        seek_handle_size = 0.55;
      };
    };
  };
}
