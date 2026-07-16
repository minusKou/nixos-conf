{ config, pkgs, inputs, ...}: 

{
nixpkgs.overlays = [
    (final: prev: {
      davinci-resolve-studio = let
        # 1. Patch the underlying raw binary package directly
        davinci-patched = prev.davinci-resolve-studio.davinci.overrideAttrs (oldAttrs: {
          postInstall = (oldAttrs.postInstall or "") + ''
            TARGET="$out/opt/resolve/bin/resolve"
            if [ ! -f "$TARGET" ]; then
              TARGET="$out/bin/resolve"
            fi

            echo "Hoisting the sails and patching $TARGET..."
            ${final.perl}/bin/perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/g' "$TARGET"
            ${final.perl}/bin/perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/g' "$TARGET"
            ${final.perl}/bin/perl -0777 -pi -e 's/\x74(.\xBF\x16\x00\x00\x00\xBE.\x01\x00\x00\xE8..\x05)/\x75$1/g' "$TARGET"
          '';
        });
      in
        # 2. Re-route the launcher script, dereferencing the symlink!
        prev.runCommand prev.davinci-resolve-studio.name {
          nativeBuildInputs = [ prev.makeWrapper ];
          meta = prev.davinci-resolve-studio.meta;
        } ''
          mkdir -p $out
          for dir in ${prev.davinci-resolve-studio}/*; do
            if [ "$(basename "$dir")" = "bin" ]; then
              cp -rL "$dir" $out/
            else
              ln -s "$dir" $out/
            fi
          done
          
          # MAKE BOTH THE DIRECTORY AND THE FILE WRITABLE!
          chmod +w $out/bin
          chmod +w $out/bin/davinci-resolve-studio
          
          sed -i "s|${prev.davinci-resolve-studio.davinci}|${davinci-patched}|g" $out/bin/davinci-resolve-studio
        '';
    })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = inputs.nix-cachyos-kernel.legacyPackages.${pkgs.system}.linuxPackages-cachyos-bore-lto-x86_64-v4;

  networking.hostName = "yae";
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = true;

  # GTA Online Hosts Patch
  networking.extraHosts = ''
    0.0.0.0 paradise-s1.battleye.com
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  time.timeZone = "Asia/Manila";

  users.users.alhanz = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
      git
      curl
      wget
      neovim
      zed-editor
      feishin
      proton-pass
      proton-vpn
      prismlauncher
      filezilla
      vlc
      wpsoffice
      caprine-bin
      linuxPackages.v4l2loopback
    ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

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
    pkgs.xwayland-satellite
    pkgs.davinci-resolve-studio

    # Theming
    pkgs.papirus-icon-theme
    pkgs.adwaita-icon-theme
    pkgs.thunar
    pkgs.thunar-archive-plugin
    pkgs.lxqt.lxqt-policykit
    pkgs.nwg-look
    pkgs.qt6Packages.qt6ct
    pkgs.bibata-cursors
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.alhanz = { pkgs, ... }: {
    home.username = "alhanz";
    home.homeDirectory = "/home/alhanz";
    home.enableNixpkgsReleaseCheck = false;

    home.packages = with pkgs; [
      fastfetch
      btop
      kitty
      fish
      vesktop
      steam
      protonup-qt
      davinci-resolve-studio
    ];

    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      # No package override needed anymore; HM will default to the fixed flake package!

      settings = { 
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path = "/path/to/wallpapers/wallpaper.png";
        };
      };
    };

    programs.home-manager.enable = true;
    home.stateVersion = "26.05";
  };

  # Hyprdots Implementation
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.damx.enable = true;

  fonts = {
    packages = with pkgs; [
      # Modern NixOS 25.11+ / 26.11 split namespace for Nerd Fonts!
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.iosevka

      # Clean UI Fonts
      geist-font
      inter
    ];

    # Set up system-wide default aliases
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Geist Sans" "Inter" ];
      };
    };
  };

  # Noctalia Requirements
  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;

  # NVIDIA Drivers
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Intel iGPU Video Acceleration (VA-API)
      vpl-gpu-rt           # modern Intel QuickSync/oneAPI video runtime
      nvidia-vaapi-driver  # Allows VA-API backend on your NVIDIA card
    ];
  };

  # OpenTabletDriver for osu!
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" "hid-uclogic" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.bleeding_edge;
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
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

  # Pipewire Low Latency Patch
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

# 1. Configures core PipeWire for native Wayland apps (like Niri)
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };

    # 2. Configures the PulseAudio emulation layer for Wine/Proton games (like osu!)
    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "32/48000";
        "pulse.min.frag" = "32/48000";
        "pulse.min.quantum" = "32/48000";
      };
    };
};

  # make pipewire realtime-capable
  security.rtkit.enable = true;

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      # 1. Autologin: Boot straight into Niri without prompting for a password
      initial_session = {
        command = "niri-session"; # Or "${pkgs.niri}/bin/niri"
        user = "alhanz"; #
      };

      # 2. Fallback / Lockscreen: If you log out, you get tuigreet
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [ "gnome" ];
	  "org.freedesktop.impl.portal.Screencast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;
}
