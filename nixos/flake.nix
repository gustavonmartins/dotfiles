{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    #lix = {
    #  url = "https://git.lix.systems/lix-project/lix/archive/2.93.3-1.tar.gz";
    #  flake = false;
    #};

    #lix-module = {
    #  url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  #inputs.lix.follows = "lix";
    #};
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  #outputs = { self, nixpkgs, home-manager, lix-module,lix, ... }@inputs: #{
  outputs = { self, nixpkgs,home-manager, ... }@inputs: #{
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
            ./blackview-hardware-configuration.nix
            ./configuration.nix
            ./blackview.nix

            home-manager.nixosModules.home-manager
				{
				  home-manager.useGlobalPkgs = true;
				  home-manager.useUserPackages = true;
				}
          ];
        
      };
        
        
      };
    };
  #};
}

