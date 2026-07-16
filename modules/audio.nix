{ config, pkgs, ...}:

{
  # Pipewire Low Latency Patch
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  
  # 1. Configures core PipeWire for native Wayland apps (like Niri)
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 64;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
    };
  
    # 2. Configures the PulseAudio emulation layer for Wine/Proton games (like osu!)
    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "32/48000";
        "pulse.min.frag" = "32/48000";
        "pulse.min.quantum" = "32/48000";
      };
    };
  };
  
  # make pipewire realtime-capable
  security.rtkit.enable = true;
}
