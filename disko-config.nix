{
  disko.devices = {
    disk = {
      
      # --- DISCO 1: OS & BOOT (50GB) ---
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # Partizione di Boot (UEFI)
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            
            # Partizione Root (OS)
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos" ]; 
              };
            };
          };
        };
      };

      # --- DISCO 2: DATA WORDPRESS (100GB) ---
      data = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "gpt";
          partitions = {
            wordpress_data = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/var/lib/wordpress";
                extraArgs = [ "-L" "data" ];
              };
            };
          };
        };
      };
      
    };
  };
}