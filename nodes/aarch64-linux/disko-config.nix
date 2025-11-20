{
  disko.devices = {
    disk = {
      
      # --- DISCO 1: OS & BOOT (Root Volume) ---
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            #(UEFI)
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "defaults" ];
              };
            };
            
            #Root (OS)
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

      # --- DISCO 2: DATA WORDPRESS
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