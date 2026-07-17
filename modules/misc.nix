{pkgs, inputs, ... }:

{
  # GTA Online Hosts Patch
  networking.extraHosts = ''
    0.0.0.0 paradise-s1.battleye.com
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  # OpenTabletDriver for osu!
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" "hid-uclogic" ];

  # Custom Drives (Jin and Sae)
  fileSystems."/mnt/Jin" = {
    device = "/dev/disk/by-uuid/5102bdc9-8ae0-4f0b-b3de-d5d17fd06f87";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" ];
  };

  fileSystems."/mnt/Sae" = {
    device = "/dev/disk/by-uuid/04400edd-d1aa-4b9c-92c6-f59a9c985739";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" ];
  };
}
