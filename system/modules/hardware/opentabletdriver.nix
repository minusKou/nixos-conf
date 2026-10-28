{
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
    blacklistedKernelModules = [ "hid-uclogic" "wacom" ];
  };
  
  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
}
