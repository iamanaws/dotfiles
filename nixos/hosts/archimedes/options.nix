{
  device = {
    system = "x86_64-linux";
    hostname = "archimedes";
    profile = "laptop";
    users = [
      {
        name = "iamanaws";
        groups = [
          "wheel"
          "input"
        ];
      }
    ];
    displayServer = "wayland";
    stateVersion = "24.11";
    timezone = "America/Tijuana";
    locale = "en_US.UTF-8";
  };
}
