{
  imports = [
    ./filezilla.nix
    ./packet-tracer.nix
    ./warp-cli.nix
  ];

  networking = {
    hostName = "yae";
    networkmanager.enable = true;
  };
}
