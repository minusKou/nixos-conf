{ pkgs, ... }:

{
  # Hyprdots Implementation
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.damx.enable = true;

  # Noctalia Requirements
  hardware.bluetooth.enable = true;
  #services.tuned.enable = true;
  services.upower.enable = true;

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      # 1. Autologin: Boot straight into Niri without prompting for a password
      initial_session = {
        command = "niri-session";
        user = "alhanz";
      };

      # 2. Fallback / Lockscreen: If you log out, you get tuigreet
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Global Environment Variables
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";

    # Force native Wayland rendering and let Kvantum handle window rules
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_USE_PORTAL = "1";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  # Theming and Desktop Packages
  environment.systemPackages = with pkgs; [
    bibata-cursors
    gnome-themes-extra
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    nwg-look
    orchis-theme
    papirus-icon-theme
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    thunar-archive-plugin
    xwayland-satellite
  ];

  fonts = {
    packages = with pkgs; [
      geist-font
      inter
      nerd-fonts.fira-code
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
    ];

    # Set up system-wide default aliases
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Geist Sans" "Inter" ];
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

  xdg.mime = {
    enable = true;
    defaultApplications = {
      # Video Formats
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ];

      # Audio Formats
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/x-wav" = [ "vlc.desktop" ];
      "audio/ogg" = [ "vlc.desktop" ];
      "audio/mp4" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  # Memory Optimization
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
  };
}
