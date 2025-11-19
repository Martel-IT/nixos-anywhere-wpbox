{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }:
    let
      nodes = import ./nodes {
        nixosSystem = nixpkgs.lib.nixosSystem;
        disko = disko; 
      };
    in
    nodes;
}