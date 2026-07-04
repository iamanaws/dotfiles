# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions =
    final: _prev:
    import ../pkgs {
      pkgs = final;
    };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # remove after 2026.7.0
    # https://github.com/bitwarden/clients/pull/20448
    # https://github.com/bitwarden/clients/issues/21581
    # https://github.com/bitwarden/clients/pull/20844
    bitwarden-desktop = prev.bitwarden-desktop.override {
      electron_39 = final.electron_39-bin;
    };
  };
}
