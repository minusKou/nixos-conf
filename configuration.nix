{ config, pkgs, ... }: {
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nix";
	networking.networkmanager.enable = true;

	time.timeZone = "Asia/Manila";

	users.users.alhanz = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ];
		packages = with pkgs; [
			git
			curl
			wget
			neovim
		];
	};

	nixpkgs.config.allowUnfree = true;
	system.stateVersion = "26.05";

	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.backupFileExtension = "backup";
	home-manager.users.alhanz = { pkgs, ... }: {
		home.username = "alhanz";
		home.homeDirectory = "/home/alhanz";

		home.packages = with pkgs; [
			fastfetch
			btop
		];

		programs.home-manager.enable = true;
		home.stateVersion = "26.05";

		programs.illogical-impulse = {
			enable = true;
			dotfiles = {
				fish.enable = true;
				kitty.enable = true;
				starship.enable = true;
			};
		};
	};

	# Hyprdots Implementation
	programs.hyprland.enable = true;
	programs.dconf.enable = true;
	services.geoclue2.enable = true;

	fonts.packages = with pkgs; [
		rubik
		nerd-fonts.ubuntu
		nerd-fonts.jetbrains-mono
	];
}

