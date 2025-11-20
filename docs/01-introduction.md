# **Introduction**


## **Why do we use this approach?**

Instead of configuring servers like monkeys (gpart or parted, SSH, apt-get install, manual config editing), this project treats the entire infrastructure as **code**.

By using **NixOS** with **Flakes**, we achieve:



1. **Reproducibility**: The same code will always produce the exact same system, bit by bit, regardless of how many times it is executed.
2. **Immutability**: We do not modify the "live" server. We modify the code, commit to Git, check it thru nix flake check or a CI/CD pipeline and apply the new configuration. If something breaks (it shouldn't, after those Best practices) we can instantly roll back to the previous generation thanks to NixOS. (God bless you, Nix guys!)
3. **Centralization**: All configuration for all nodes resides in this single repository.


## **The Tools**


### **NixOS Anywhere**

This tool allows installing NixOS on **any** Linux machine accessible via SSH, without requiring a specific ISO image. It utilizes `kexec` to load a minimal NixOS into the target server's RAM (temporarily overwriting the running OS such as Ubuntu, Debian, or Amazon Linux) and proceeds to partition disks and install the final system from there.


### **Disko**

Managing partitions (fdisk, parted, mkfs, mount, fstab) via scripts is painful and error-prone. **Disko** allows defining the disk layout **declaratively** (inside `.nix` files). NixOS automatically generates the scripts to format, mount, and configure disks exactly as described in the code.


### **Flakes**

Flakes make the project hermetic. The `flake.lock` file locks the exact versions of all dependencies (Nixpkgs, Disko, etc.), ensuring that if the deployment works today, it will work a year from now, even if packages on GitHub have changed.