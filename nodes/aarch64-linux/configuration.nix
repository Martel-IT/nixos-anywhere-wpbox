{ config, lib, pkgs, modulesPath,  ... }:
{
  imports = [ 

    "${modulesPath}/virtualisation/amazon-image.nix"
    ../../disko-config.nix
  
  ];

  ec2.efi = true;

  networking.hostName = "wpbox-aarch64";
  time.timeZone = "Europe/Amsterdam";

  # Root user con password vuota (può loggare dalla console)
  users.users.root = {
    initialHashedPassword = "";
  };

  # Admin user con sudo senza password
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3Ozoyo+Eday4ke3ddwv+CqXRh+ib3HE4CGKqNO1U5U" ];
  };

  # IMPORTANTE: sudo senza password per wheel
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [ vim wget nano git ncdu curl eza bat htop net-tools zip unzip  ];
  
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = lib.mkForce "yes";
      PasswordAuthentication = false;
    };
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  system.stateVersion = "25.05";
}
