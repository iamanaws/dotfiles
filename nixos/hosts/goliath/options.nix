{
  device = {
    system = "x86_64-linux";
    hostname = "goliath";
    profile = "desktop";
    users = [
      {
        name = "iamanaws";
        groups = [
          "wheel"
          "input"
        ];
      }
      "zsheen"
    ];
    displayServer = "wayland";
    stateVersion = "25.11";
    timezone = "America/Tijuana";
    locale = "en_US.UTF-8";
  };
}
