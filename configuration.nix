{ config, pkgs, inputs, ...}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/audio.nix
    ./modules/graphics.nix
    ./modules/desktop.nix
    ./modules/misc.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;

  # # Battery Save :'))
  # boot.blacklistedKernelModules = [
  #   "nvidia"
  #   "nvidiafb"
  #   "nvidia-drm"
  #   "nvidia-uvm"
  #   "nvidia-modeset"
  # ];
  # services.udev.extraRules = ''
  #   # Remove NVIDIA Audio devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"

  #   # Remove NVIDIA VGA/3D graphics controller devices entirely
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{remove}="1"
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{remove}="1"
  # '';

  networking.hostName = "yae";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 25565 ];
  };

  time.timeZone = "Asia/Manila";

  users.users.alhanz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      caprine-bin
      curl
      feishin
      filezilla
      git
      hunspell
      libreoffice-qt
      linuxPackages.v4l2loopback
      neovim
      nixd
      prismlauncher
      proton-pass
      proton-vpn
      vlc
      wget
      wpsoffice
      zed-editor
    ];
  };

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };

    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
    ];
  };

  # Enable the core Polkit framework
  security.polkit.enable = true;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
      INTEL_GPU_MIN_FREQ_ON_BAT = 350;
      INTEL_GPU_MAX_FREQ_ON_BAT = 600;
      INTEL_GPU_BOOST_FREQ_ON_BAT = 600;
    };
  };

  # Create the systemd background user service
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "GNOME Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.systemPackages = [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-stable
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-discord-ipc-bridge
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit inputs; };
    users.alhanz = import ./home/home.nix;
  };

  # zeditor related fixes
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    nil
    zlib
    glib
  ];
}
