{
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    withPython3 = false;
    withRuby = false;
    withNodeJs = false;

    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    configure = {
      customRC = ''
        " here your custom VimScript configuration goes!
      '';
      customLuaRC = ''
        -- here your custom Lua configuration goes!
      '';
      packages.neovimPackages = with pkgs.vimPlugins; {
        # loaded on launch
        start = [ ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };
  };
}
