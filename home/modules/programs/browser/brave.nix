{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
  ];
  xdg.configFile."brave-flags.conf".text = ''
    --disable-features=BraveRewards,BraveWallet,BraveVPN,BraveNews,BraveTalk,BraveAIChat
  '';
}