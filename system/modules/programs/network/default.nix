{
  imports = [
    ./filezilla.nix
    ./warp-cli.nix
  ];

  networking = {
    hostName = "yae";
    networkmanager.enable = true;
  };
}
