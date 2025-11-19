{
  nixosSystem,
  disko 
}:
let
  mkNode = system: config: nixosSystem {
    inherit system;
    modules = [
      disko.nixosModules.disko
      config
    ];
  };
in {
  nixosConfigurations = {
    aarch64-linux = mkNode "aarch64-linux" ./aarch64-linux/configuration.nix;
    x86_64-linux = mkNode "x86_64-linux" ./x86_64-linux/configuration.nix;
  };
}