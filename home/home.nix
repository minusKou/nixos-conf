{ pkgs, inputs, ... }:

{
  home.username = "alhanz";
  home.homeDirectory = "/home/alhanz";
  home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

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

  xdg.configFile."niri".source = ./dotfiles/niri;
}
