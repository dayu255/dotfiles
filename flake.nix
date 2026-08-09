{
  inputs = {
    # NixOS packages are stable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Home-Manager packages are unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Plasma-Manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Walker
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Zen-Browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Antigravity
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      ...
    }@inputs:
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
            inherit username;
          };
          modules = [
            ./nixos/lollipop/configuration.nix
            ./nixos/lollipop/hardware-configuration.nix
          ];
        };
      };

      # Home-Manager
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
        # nixpkgs-unstableを渡す
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          inherit username;
        };
        modules = [
          { nixpkgs.config.allowUnfree = true; }

          ./home-manager/home.nix
          plasma-manager.homeModules.plasma-manager
          inputs.walker.homeManagerModules.default
        ];
      };
    };
}
