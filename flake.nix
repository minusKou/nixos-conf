{
  description = "A very basic flake";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      #home-manager.follows = "home-manager";
    };

    damx = {
      url = "github:minusKou/damx-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    espidf = {
      url = "github:hnaderi/espidf-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-osu-stable = {
      url = "github:gaavin/nix-osu-stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    chaotic,
    damx,
    espidf,
    nix-osu-stable,
    ...
  }@inputs:
  let
    system = "x86_64-linux";
    username = "alhanz";

    # Instantiates pkgs with the espidf overlay applied for devShells
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ espidf.overlays.default ];
    };
  in {
    nixosConfigurations.yae = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username; };

      modules = [
        ./configuration.nix

        # Read HW Configuration instead of Local
        /etc/nixos/hardware-configuration.nix

        # Chaotic Nyx
        chaotic.nixosModules.default

        # Home Manager
        home-manager.nixosModules.home-manager

        # Lanzaboote
        lanzaboote.nixosModules.lanzaboote

        # Div Acer Manager Max
        damx.nixosModules.default

        # (Optional) Add espidf overlay system-wide in NixOS
        { nixpkgs.overlays = [ espidf.overlays.default ]; }
      ];
    };

    # Exposes `nix develop` devShell with esp-idf toolchain
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.esp-idf
        pkgs.clang-tools
      ];
    };
  };
}
