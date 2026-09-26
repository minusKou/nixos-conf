{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./graphics.nix
    ./storage.nix
  ];

  # ESP32 Rules
  services.udev.extraRules = ''
    KERNEL=="ttyUSB[0-9]*", MODE="0666"
    KERNEL=="ttyACM[0-9]*", MODE="0666"
  '';
}
