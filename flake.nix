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
      url = "github:minusKou/damx-flake/an515-57-hotfix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    chaotic,
    damx,
    ...
  }@inputs:
  let
    username = "alhanz";
  in {
    nixosConfigurations.yae = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
      ];
    };
  };
}
