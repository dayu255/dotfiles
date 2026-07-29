{
  inputs = {
    # nixosはstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # home-managerはunstable
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

      myWallpaper = pkgs.fetchurl {
        url = "https://github.com/dayu255/assets/blob/main/flower.jpg?raw=true";
        name = "flower.jpg";
        hash = "sha256-2JcFtKoTr5f2XJLGzl0pcybD3LHM7QSQK+87W/ohgCc=";
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
            inherit myWallpaper;
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
        # nixpkgs-unstableを渡す
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs;
          inherit username;
          inherit myWallpaper;
        };
        modules = [
          { nixpkgs.config.allowUnfree = true; }

          ./home-manager/home.nix
          plasma-manager.homeModules.plasma-manager
        ];
      };
    };
}
