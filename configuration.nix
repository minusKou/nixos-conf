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
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system}.linuxPackages-cachyos-bore-lto-x86_64-v4;

  networking.hostName = "yae";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = true;
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
}
