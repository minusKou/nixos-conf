{ pkgs, ... }:

{
  # Hyprdots Implementation
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.damx.enable = true;

  # Noctalia Requirements
  hardware.bluetooth.enable = true;
  services.tuned.enable = true;
  services.upower.enable = true;

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      # 1. Autologin: Boot straight into Niri without prompting for a password
      initial_session = {
        command = "niri-session";
        user = "alhanz"; #
      };

      # 2. Fallback / Lockscreen: If you log out, you get tuigreet
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Theming and Desktop Packages
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    bibata-cursors
    lxqt.lxqt-policykit
    nwg-look
    papirus-icon-theme
    qt6Packages.qt6ct
    thunar
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

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;
}
