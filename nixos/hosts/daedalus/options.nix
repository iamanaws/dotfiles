{
  device = {
    system = "x86_64-linux";
    hostname = "daedalus";
    profile = "server";
    users = [
      {
        name = "iamanaws";
        groups = [
          "wheel"
          "input"
          "networkmanager"
        ];
      }
    ];
    displayServer = null;
    stateVersion = "25.05";
    timezone = "America/Tijuana";
    locale = "en_US.UTF-8";
  };
}
