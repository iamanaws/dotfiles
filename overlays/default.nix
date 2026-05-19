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
    # TODO: remove once jitterentropy-rngd 1.3.1's systemd unit fix lands in nixpkgs.
    jitterentropy-rngd = prev.jitterentropy-rngd.overrideAttrs (oldAttrs: {
      postPatch = ''
        ${oldAttrs.postPatch or ""}
        substituteInPlace jitterentropy.service.in \
          --replace-fail "LimitMEMLOCK=0" "LimitMEMLOCK=2M" \
          --replace-fail "mincore mlock mlockall personality" "mincore mlockall personality"
      '';
    });

    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
