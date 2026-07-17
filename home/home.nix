{ pkgs, inputs, config, ... }:

let
  dotfilesDir = "${config.home.homeDirectory}/nixos-conf/home/dotfiles";
  link = subpath: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${subpath}";
in

{
  home.username = "alhanz";
  home.homeDirectory = "/home/alhanz";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    btop
    eza
    fastfetch
    fish
    fzf
    kdePackages.kdenlive
    kitty
    protonup-qt
    starship
    steam
    vesktop
  ];

  home.file.".config/Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=MaterialAdw
  '';

  home.file.".config/qt5ct/qt5ct.conf".text = ''
    [Appearance]
    style=kvantum
    custom_palette=false
    standard_dialogs=default

    [Fonts]
    general="Geist Sans,11,-1,5,50,0,0,0,0,0"
  '';

  home.file.".config/qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=kvantum
    custom_palette=false
    standard_dialogs=default

    [Fonts]
    general="Geist Sans,11,-1,5,50,0,0,0,0,0"
  '';

  home.file.".local/share/fonts/windows-fonts" = {
    source = ./fonts;
    recursive = true;
  };

  gtk = {
      enable = true;

      theme = {
        name = "Orchis-Dark";
        package = pkgs.orchis-theme;
      };

      iconTheme = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-icon-theme;
      };

      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
        size = 24;
      };

      font = {
        name = "Geist Sans";
        size = 11;
      };
    };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
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

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  xdg.configFile = {
      # Niri
      "niri".source = link "niri";

      # Kitty
      "kitty/kitty.conf".source = link "kitty/kitty.conf";
      "kitty/scroll_mark.py".source = link "kitty/scroll_mark.py";
      "kitty/search.py".source = link "kitty/search.py";

      # Fish
      "fish/config.fish".source = link "fish/config.fish";
      "fish/fish_variables".source = link "fish/fish_variables";

      # Foot
      "foot/foot.ini".source = link "foot/foot.ini";
      "starship.toml".source = link "starship.toml";
    };
}
