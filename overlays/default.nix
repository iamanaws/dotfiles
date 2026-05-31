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
    # remove when reaching nixos-unstable https://nixpk.gs/pr-tracker.html?pr=522705
    pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
      (_pythonFinal: pythonPrev: {
        jedi-language-server = pythonPrev.jedi-language-server.overridePythonAttrs (_oldAttrs: {
          pythonRelaxDeps = [ "jedi" ];
        });
      })
    ];

    # remove when reaching nixos-unstable https://nixpk.gs/pr-tracker.html?pr=519637
    jitterentropy-rngd = prev.jitterentropy-rngd.overrideAttrs (oldAttrs: {
      postPatch = ''
        ${oldAttrs.postPatch or ""}
        substituteInPlace jitterentropy.service.in \
          --replace-fail "mincore mlock personality" "mincore mlockall personality"
      '';
    });

    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
