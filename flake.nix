{
  inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		# Home-Manager
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		# Zen-Browser
		zen-browser.url = "github:youwen5/zen-browser-flake";
		zen-browser.inputs.nixpkgs.follows = "nixpkgs";
		
		# Plasma-Manager
		plasma-manager = {
			url = "github:nix-community/plasma-manager";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};
	};

	outputs =
		{ self, nixpkgs, home-manager, plasma-manager, ... }@inputs:
		let
			system = "x86_64-linux";
			username = "dayu";
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};
		in
		{
			# Nixos
			nixosConfigurations = {
				lollipop = nixpkgs.lib.nixosSystem {
					inherit system;
					specialArgs = {
						inherit inputs;
					};
        	modules = [
						./nixos/lollipop/configuration.nix
						./nixos/lollipop/hardware-configuration.nix
						./nixos/modules/font.nix
					];
				};
			};

			# Home-Manager
			homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				extraSpecialArgs = {
					inherit inputs;
					inherit username;
				};
				modules = [
					./home-manager/home.nix
					plasma-manager.homeModules.plasma-manager
				];
			};
		};
}
