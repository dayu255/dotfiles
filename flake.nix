{
  inputs = {
    # Stable nixpkgs
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    # Unstable nixpkgs
    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
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
    antigravity = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      plasma-manager,
      walker,
      zen-browser,
      antigravity,
      ...
    }@inputs:
    let
      # === const variables ===
      system = "x86_64-linux";
      username = "dayu";
      # =======================

      # pkgs for formatter
      pkgs = nixpkgs-stable.legacyPackages.${system};

      # nixpkgs-unstableをallowUnfreeにしたインスタンス
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # Format Style
      formatter.${system} = pkgs.nixfmt;

      # Nixos
      nixosConfigurations = {
        # nixpkgs-stableを渡す
        lollipop = nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
          };
          modules = [
            ./nixos/default.nix
            ./hosts/lollipop/configuration.nix
            ./hosts/lollipop/hardware-configuration.nix
          ];
        };
      };

      # Home-Manager
      homeConfigurations = {
        "${username}@lollipop" = home-manager.lib.homeManagerConfiguration {
          # nixpkgs-unstableを渡す
          pkgs = pkgs-unstable;
          extraSpecialArgs = {
            inherit inputs;
            inherit username;
          };
          modules = [
            ./home-manager/default.nix
            ./hosts/lollipop/home.nix
            plasma-manager.homeModules.plasma-manager
            inputs.walker.homeManagerModules.default
          ];
        };
      };
    };
}
