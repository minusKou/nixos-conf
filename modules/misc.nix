{pkgs, inputs, ... }:

{
  # DaVinci Resolve Studio Patch
  nixpkgs.overlays = [
      (final: prev: {
        davinci-resolve-studio = let
          # 1. Patch the underlying raw binary package directly
          davinci-patched = prev.davinci-resolve-studio.davinci.overrideAttrs (oldAttrs: {
            postInstall = (oldAttrs.postInstall or "") + ''
              TARGET="$out/opt/resolve/bin/resolve"
              if [ ! -f "$TARGET" ]; then
                TARGET="$out/bin/resolve"
              fi

              echo "Hoisting the sails and patching $TARGET..."
              ${final.perl}/bin/perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/g' "$TARGET"
              ${final.perl}/bin/perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/g' "$TARGET"
              ${final.perl}/bin/perl -0777 -pi -e 's/\x74(.\xBF\x16\x00\x00\x00\xBE.\x01\x00\x00\xE8..\x05)/\x75$1/g' "$TARGET"
            '';
          });
        in
          # 2. Re-route the launcher script, dereferencing the symlink!
          prev.runCommand prev.davinci-resolve-studio.name {
            nativeBuildInputs = [ prev.makeWrapper ];
            meta = prev.davinci-resolve-studio.meta;
          } ''
            mkdir -p $out
            for dir in ${prev.davinci-resolve-studio}/*; do
              if [ "$(basename "$dir")" = "bin" ]; then
                cp -rL "$dir" $out/
              else
                ln -s "$dir" $out/
              fi
            done

            # MAKE BOTH THE DIRECTORY AND THE FILE WRITABLE!
            chmod +w $out/bin
            chmod +w $out/bin/davinci-resolve-studio

            sed -i "s|${prev.davinci-resolve-studio.davinci}|${davinci-patched}|g" $out/bin/davinci-resolve-studio
          '';
      })
    ];

  # GTA Online Hosts Patch
  networking.extraHosts = ''
    0.0.0.0 paradise-s1.battleye.com
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  # OpenTabletDriver for osu!
  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  boot.blacklistedKernelModules = [ "wacom" "hid-uclogic" ];

  # Custom Drives (Jin and Sae)
  fileSystems."/mnt/Jin" = {
    device = "/dev/disk/by-uuid/5102bdc9-8ae0-4f0b-b3de-d5d17fd06f87";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" ];
  };

  fileSystems."/mnt/Sae" = {
    device = "/dev/disk/by-uuid/04400edd-d1aa-4b9c-92c6-f59a9c985739";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" ];
  };
}
