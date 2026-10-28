{ inputs, ...}:
{
  imports = [ inputs.nix-osu-stable.homeModules.osu-stable ];

  programs.osu-stable = {
    enable = true;
    offsetCalculator.enable = true;
    # OTD absolute mode on Wayland is auto-detected; override if needed:
    environment = {
      WINE_ENABLE_ABS_TABLET_HACK = "2";
      WINE_OSU_USE_X11 = "1";
    };
    # location = "${config.xdg.dataHome}/nix-osu-stable";
  };
}