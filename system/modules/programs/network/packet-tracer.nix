{ pkgs, lib, ... }:

{
  # Wrap Packet Tracer in Firejail for Offline Mode
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      packettracer9 = {
        executable = lib.getExe pkgs.ciscoPacketTracer9;

        # Patches the official desktop file in place for app launchers
        desktop = "${pkgs.ciscoPacketTracer9}/share/applications/cisco-packet-tracer-9.desktop";

        extraArgs = [
          # Isolated network namespace to block internet access completely
          "--net=none"

          # Skip security profile sandbox (only enforcing network isolation)
          "--noprofile"
        ];
      };
    };
  };
}
