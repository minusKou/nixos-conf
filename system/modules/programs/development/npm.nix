{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Runtimes & Package Managers
    nodejs_22
    pnpm
    bun

    # TypeScript
    typescript

    # Language Servers (top-level in Nixpkgs)
    svelte-language-server
    typescript-language-server
    vtsls
  ];
}
