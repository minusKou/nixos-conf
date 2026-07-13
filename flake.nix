{
	description = "alhanz NixOS Configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs: {
		nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hardware-configuration.nix
				./configuration.nix

				home-manager.nixosModules.home-manager
			];
		};
	};
}
