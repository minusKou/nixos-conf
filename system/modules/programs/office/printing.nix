{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-escpr
    ];
  };
}