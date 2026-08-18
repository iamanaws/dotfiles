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

  specialisation."debug-6.19-test-no-dynamic-of".configuration =
    let
      # This is the release-25.11 revision that packaged linux_testing
      # 6.19-rc5. It reproduces the cached GCC 14.3/Rust 1.91 build recipe.
      kernelPkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/013d93c6d5668866ad46e66beeb547e1988d4af9.tar.gz";
        sha256 = "sha256-DNTo+OuTuf4sJHXIrVfq0ZrlRrf6+j5Vj5L9PHj5u4k=";
      }) { system = pkgs.stdenv.hostPlatform.system; };
      bisectKernel =
        (kernelPkgs.linux_testing.override {
          argsOverride = {
            version = "6.19-rc4";
            modDirVersion = "6.19.0-rc4";
            src = kernelPkgs.fetchFromGitHub {
              owner = "torvalds";
              repo = "linux";
              rev = "4621c338d33f2e49c55d317fa5b1fbc0ae1cccb7";
              hash = "sha256-xkklj2W541PgaxsClXzdmJ5Jqudr5PoMXUlShaz9rrU=";
            };
          };
          # This is the sole generated-config difference between the bad
          # 4621c338 kernel and good e55feea kernel. The bad tree's Raspberry
          # Pi RP1 module selects it, so disable that irrelevant module too.
          structuredExtraConfig = {
            MISC_RP1 = lib.mkForce lib.kernel.no;
            PCI_DYNAMIC_OF_NODES = lib.mkForce lib.kernel.no;
          };
        }).overrideAttrs
          (old: {
            # Compatibility attributes expected by current NixOS modules. Passthru
            # changes do not alter the historical kernel build derivation.
            passthru = old.passthru // {
              buildDTBs = false;
              target = "bzImage";
            };
          });
    in
    {
      # Isolate the only x86 kernel-config change introduced by e55feea while
      # retaining the otherwise known-bad 4621c338 source tree.
      boot.kernelPackages = lib.mkForce (kernelPkgs.linuxPackagesFor bisectKernel);

      # Force diagnostic settings so nix-mineral cannot suppress the console or
      # disable firmware-persistent crash records.
      boot = {
        kernelParams = lib.mkForce [
          "root=fstab"
          "earlyprintk=efi,keep"
          "keep_bootcon"
          "ignore_loglevel"
          "loglevel=8"
          "initcall_debug"
          "nokaslr"
          "no5lvl"
          "mem=32G"
          "dis_ucode_ldr"
          "panic=0"
          "nowatchdog"
          "nmi_watchdog=0"
          "efi_pstore.pstore_disable=0"
          "printk.always_kmsg_dump=Y"
          "module_blacklist=i915,xe,nouveau,nvidia,nvidia_drm,nvidia_modeset,nvidia_uvm,i2c_nvidia_gpu,ucsi_ccg"
          "intel_iommu=off"
          "systemd.log_level=debug"
          "systemd.log_target=console"
          "systemd.show_status=1"
          "rd.systemd.show_status=1"
          "udev.log_level=debug"
        ];
        consoleLogLevel = 8;
        initrd.verbose = true;
        plymouth.enable = false;
        loader.systemd-boot.consoleMode = "keep";
        kernel.sysctl = {
          "kernel.dmesg_restrict" = lib.mkForce "0";
          "kernel.kptr_restrict" = lib.mkForce "0";
          "kernel.panic" = lib.mkForce "0";
          "kernel.panic_on_oops" = lib.mkForce "0";
          "kernel.panic_on_warn" = lib.mkForce "0";
          "kernel.printk" = lib.mkForce "8 8 1 7";
          "kernel.sysrq" = lib.mkForce "1";
        };
      };

      system.nixos.tags = [ "6.19-test-no-dynamic-of" ];
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

      nix-mineral = {
        settings = {
          debug = {
            debugfs = true;
            dmesg-restrict = false;
            efipstore = true;
            kptr-restrict = false;
            panic-reboot = false;
            quiet-boot = false;
            restrict-printk = false;
          };
          kernel = {
            binfmt-misc = true;
            intel-iommu = false;
            oops-panic = false;
            strict-iommu = false;
            sysrq = "none";
          };
        };
        extras.kernel.warn-panic = false;
      };
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
