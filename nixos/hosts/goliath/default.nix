{
  lib,
  pkgs,
  nixosModules,
  ...
}:

{
  imports = with nixosModules; [
    gaming
    hardened
    services.flatpak
  ];

  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_6_12;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix-mineral.settings.kernel.binfmt-misc = true;

  specialisation."debug-linux-bisect".configuration =
    let
      testKernel = pkgs.linuxKernel.kernels.linux_6_12.override {
        argsOverride = {
          version = "6.14.0-rc1";
          modDirVersion = "6.14.0-rc1";
          stdenv = pkgs.gcc14Stdenv;
          # The current Nixpkgs config does not exactly match this historical
          # source snapshot. Ignore options unavailable at this commit.
          ignoreConfigErrors = true;
          src = pkgs.fetchurl {
            url = "https://github.com/torvalds/linux/archive/3dc8adeeefa0256917d1e3978c8b4a06346816ed.tar.gz";
            hash = "sha256-YBJRaHxbeBgz0t6BYlbHXmSmrXu1tEXclXidhi7DNFE=";
          };
        };
        structuredExtraConfig = {
          PCI_DYNAMIC_OF_NODES = lib.mkForce lib.kernel.yes;
          # Keep Rust out of the test to avoid historical toolchain issues.
          RUST = lib.mkForce lib.kernel.no;
        };
      };
    in
    {
      # First-bad: 1f340724419e PCI: of: Create device tree PCI host bridge node
      # Good parent: 3dc8adeeefa0 (constify of_pci_get_addr_flags)
      # Author: Herve Codina; Acked in pci/devtree-create by Bjorn Helgaas.
      boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor testKernel);
      boot.kernelParams = lib.mkAfter [
        "ignore_loglevel"
        "loglevel=8"
        "oops=continue"
        "panic=0"
        "panic_on_warn=0"
      ];

      system.nixos.tags = [ "bisect-3dc8adeeefa0" ];
    };

  services.xserver.xkb.layout = "latam";

  services.flatpak.packages = [
    "net.sourceforge.VMPK"
    "com.github.tchx84.Flatseal"
    # "io.github.nokse22.asciidraw"
    # "app.drey.EarTag"
    # "xyz.slothlife.Jogger"
    # "com.jeffser.Alpaca"
    # mission center
    # garden.jamie.Morphosis
  ];

  programs.solaar.enable = true;
  programs.zoom-us.enable = true;

  # Keep GNOME as the default, but select Hyprland for iamanaws.
  systemd.services.display-manager.preStart = lib.mkAfter ''
    busctl=${pkgs.systemd}/bin/busctl
    read -r _ account_path < <(
      "$busctl" call \
        org.freedesktop.Accounts /org/freedesktop/Accounts \
        org.freedesktop.Accounts FindUserByName s iamanaws
    )
    account_path="''${account_path//\"/}"

    for setting in SetSession:hyprland SetSessionType:wayland; do
      "$busctl" call org.freedesktop.Accounts "$account_path" \
        org.freedesktop.Accounts.User "''${setting%%:*}" s "''${setting#*:}"
    done
  '';

  environment.systemPackages = with pkgs; [
    aseprite
    egl-wayland
    libva-utils
    libreoffice
    rapidraw
    reaper
  ];

  # Force intel-media-driver (iHD / i915) or nvidia
  environment.sessionVariables = {
    # VDPAU_DRIVER = "va_gl";
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

}
