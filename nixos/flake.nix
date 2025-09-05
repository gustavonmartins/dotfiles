{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, lix-module, ... }@inputs: #{
    let
      system="x86_64-linux";
      pkgs=import nixpkgs {
        inherit system;
      };
    in {
      nixosConfigurations = {
      blackview = nixpkgs.lib.nixosSystem {
        specialArgs={inherit inputs system;};
        modules =[
        ./configuration.nix
          lix-module.nixosModules.default
          home-manager.nixosModules.home-manager
        ];
        
      };
        
        
      };
    };
  #};
}

