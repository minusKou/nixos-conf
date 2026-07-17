{ pkgs, inputs, config, ... }:

let
  # 100% dynamic, but uses absolute paths so the OS never gets confused!
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
    davinci-resolve-studio
    fastfetch
    fish
    foot
    fzf
    kitty
    protonup-qt
    starship
    steam
    vesktop
  ];

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
