{
  description = "Home manager configuration for mwarner";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, ... }:
    let
      system = "aarch64-darwin";
      username = "mwarner";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        # Specify the path to your home configuration here
        configuration = import ./nix/.config/nixpkgs/home.nix;

        inherit system username;
        homeDirectory = "/Users/${username}";
      };
      # output a default package for usage by `nix run`
      defaultPackage.${system} = self.homeConfigurations.${username}.activationPackage;
    };
}

