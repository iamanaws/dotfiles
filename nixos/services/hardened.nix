{
  inputs,
  config,
  lib,
  pkgs,
  systemType,
  ...
}:

{
  imports = [
    inputs.nix-mineral.nixosModules.nix-mineral
  ];

  #usbguard
  boot = {
    kernelPackages = pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_hardened;
  };

  security.sudo.execWheelOnly = true;

  services = {
    resolved = {
      # enable = true;
      # dnssec = "true";
      # dnsovertls = "true";
    };
  };

  nix-mineral = {
    enable = true;

    settings = {
      kernel = {
        # cpu-mitigations = "smt-on"; # performance
        # pti = false; # performance
        sysrq = "sak";
      };

      network = {
        # ip-forwarding = true;
      };

      system = {
        # multilib = true; # 32-bit
        yama = "restricted";
      };
    };

    extras = {
      kernel = {
        intelme-kmodules = false;
      };

      network = {
        # bluetooth-kmodules = false;
        #tcp-window-scaling = false;
      };

      misc = {
        # doas-sudo-wrapper = true;
        # replace-sudo-with-doas = true;
        # usbguard = {
        #   enable = true;
        #   gnome-integration = true;
        # };
      };

      system = {
        # lock-root = true;
        minimize-swapping = true;
        secure-chrony = true;

        # Enable unprivileged user namespaces (kernel-level risk)
        # for chromium based apps, flatpacks, and steam sandboxing
        unprivileged-userns = true;
      };
    };
  };

  # Client side SSH configuration
  programs.ssh = {
    ciphers = [
      "aes256-gcm@openssh.com"
      "aes256-ctr,aes192-ctr"
      "aes128-ctr"
      "aes128-gcm@openssh.com"
      "chacha20-poly1305@openssh.com"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    knownHosts = {
      github-ed25519 = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab-ed25519 = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
      codeberg-ed25519 = {
        hostNames = [ "codeberg.org" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIVIC02vnjFyL+I4RHfvIGNtOgJMe769VTF1VR4EB3ZB";
      };
    };
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };
}
