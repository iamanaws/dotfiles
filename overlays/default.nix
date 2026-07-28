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

    t3code = prev.t3code.override {
      t3code-unwrapped = final.callPackage "${
        final.applyPatches {
          name = "t3code-0.0.29-source";
          src = "${prev.path}/pkgs/by-name/t3/t3code";
          patches = [
            (final.fetchpatch2 {
              url = "https://github.com/NixOS/nixpkgs/pull/546533.patch?full_index=1";
              hash = "sha256-Tz2s1jJoLhGLLG8DY6RQc2OCIAw9oVY79I+gKMRXK9s=";
            })
          ];
          patchFlags = [ "-p5" ];
        }
      }/unwrapped.nix" { };
    };
  };
}
