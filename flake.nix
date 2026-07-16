{
	description = "alhanz NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		noctalia = {
			url = "github:noctalia-dev/noctalia";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		damx = {
			url = "path:/home/alhanz/damx-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
		nix-gaming.url = "github:fufexan/nix-gaming";
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";	
	};

	outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, ... }@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";

			specialArgs = { inherit inputs; };

			modules = [
        			(
          				{ pkgs, ... }:
          					{
            						nixpkgs.overlays = [
           							nix-cachyos-kernel.overlays.pinned
            						];

            					# ... your other configs
          					}
        			)

				./hardware-configuration.nix
				./configuration.nix


				inputs.damx.nixosModules.default
				home-manager.nixosModules.home-manager
			];
		};
	};
}
