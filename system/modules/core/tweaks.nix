{ pkgs, ... }:

{
  # CPU Scheduler (sched-ext)
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # Ananicy (Auto-renice daemon)
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos_git;
  };

  # Kernel Sysctl Tweaks (CachyOS Defaults)
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "cake";
    "vm.max_map_count" = 2147483642;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.swappiness" = 10;
  };

  # ZRAM
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };
}
