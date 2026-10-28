{ pkgs, ... }:
{
  # Intel tweaks
  boot.initrd.kernelModules = [ "i915" ];

  # Intel Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      nvidia-vaapi-driver
    ];
  };

  # Nvidia Drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    package = pkgs.nvidia_cachyos-bore;
  };

  # Persistent DRM symlinks to prevent dynamic card-shuffling on boot
  services.udev.extraRules = ''
    # NVIDIA GA107M [GeForce RTX 3050 Mobile] (0000:01:00.0)
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-card"
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="renderD*", SUBSYSTEMS=="pci", KERNELS=="0000:01:00.0", SYMLINK+="dri/nvidia-render"

    # Intel TigerLake-H GT1 [UHD Graphics] (0000:00:02.0)
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="card*", SUBSYSTEMS=="pci", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-card"
    ACTION=="add|change", SUBSYSTEM=="drm", KERNEL=="renderD*", SUBSYSTEMS=="pci", KERNELS=="0000:00:02.0", SYMLINK+="dri/intel-render"
  '';
}
