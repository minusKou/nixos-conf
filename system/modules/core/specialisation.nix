{ lib, ... }:

{
  specialisation.battery.configuration = {
    system.nixos.tags = [ "battery" ];

    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
      blacklist nvidia
      blacklist nvidia_drm
      blacklist nvidia_modeset
      blacklist nvidia_uvm
      blacklist i2c_nvidia_gpu
    '';

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "i2c_nvidia_gpu"
    ];

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{remove}="1"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{remove}="1"
    '';

    powerManagement.cpuFreqGovernor = lib.mkForce "powersave";
  };

  specialisation.vfio.configuration = {
    system.nixos.tags = [ "vfio" ];

    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];

    boot.kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=10de:25a2,10de:2291"
    ];

    boot.initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
    ];
  };
}
