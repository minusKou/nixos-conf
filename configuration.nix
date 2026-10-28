{ inputs, username, ... }:
{
  imports = [
    ./system/modules
  ];

  # Custom Drives
 fileSystems."/mnt/Sae" = {
   device = "/dev/disk/by-uuid/2c14bfc6-d3b9-4fc9-af2c-8e7a380e002d";
   fsType = "btrfs";
   options = [
     "noatime"
     "compress=zstd:3"
     "ssd"
     "discard=async"
   ];
 };

  fileSystems."/mnt/Jin" = {
    device = "/dev/disk/by-uuid/5102bdc9-8ae0-4f0b-b3de-d5d17fd06f87";
    fsType = "btrfs";
    options = [ 
      "noatime"
      "compress=zstd:3"
      "ssd"
      "discard=async"
    ];
  };

  fileSystems."/mnt/Jin" = {
    device = "/dev/disk/by-uuid/5102bdc9-8ae0-4f0b-b3de-d5d17fd06f87";
    fsType = "btrfs";
    options = [ 
      "noatime"
      "compress=zstd:3"
      "ssd"
      "discard=async"
    ];
  };
  
  # System-wide Font Directory
  fonts.fontDir.enable = true;

  time.timeZone = "Asia/Manila";

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    extraSpecialArgs = { inherit inputs username; };
    users.alhanz = import ./home/home.nix;
  };

  system.stateVersion = "26.11";
}
