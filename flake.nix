{
	description = "alhanz NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

		illogical-flake = {
			url = "github:soymou/illogical-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, illogical-flake, ... }@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hardware-configuration.nix
				./configuration.nix

				home-manager.nixosModules.home-manager

				{
					home-manager.users.alhanz = {
						imports = [ illogical-flake.homeManagerModules.default ];
					};
				}
			];
		};
	};
}
