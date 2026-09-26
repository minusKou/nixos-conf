{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    antigravity-ide
  ];
}
