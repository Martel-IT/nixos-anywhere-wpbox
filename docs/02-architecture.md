# **Project Architecture**

This repository manages 3 types of nodes, defined in `nodes/default.nix`.

> **NOTE** <br>
>*_In our scenario, the ARM and x86 nodes are basically the same since we just want to support multiple achitectures in a sigle flake. You can tweak the disko-config.nix files for the node you need according to your needs. If multi aarch is not needed in your setup, you can drop the node and tweak the nodes/default.nix by removing the dropped node_*

**If you just cloned the repo and modified the configuration remember to run**

```bash
nix flake check
```

**to make sure the flake is correct and there are no isuses before running the nix run command.**


## **Nodes**


### **1. <code>aarch64-linux</code> (Production AWS Graviton)**



* **Target**: AWS EC2 instances based on ARM processors (Graviton).
* **Configuration**: Optimized for cloud servers, includes specific Amazon Image modules.
* **Path**: `nodes/aarch64-linux/`


### **2. <code>x86_64-linux</code> (Production Standard)**



* **Target**: Standard cloud instances (Intel/AMD) or bare metal x86 servers.
* **Configuration**: Similar to the ARM version but compiled for x86_64 architecture.
* **Path**: `nodes/x86_64-linux/`


### **3. <code>devm</code> (Development VM)**



* **Target**: Local virtual machines (QEMU/KVM).
* **Purpose**: Test environment to verify partitioning and configurations without touching production servers. Configured to run in emulation or virtualization on local hosts (e.g., Mac M3).
* **Path**: `nodes/devm/`


## **Storage Configuration (Disko)**

Production nodes (`aarch64` and `x86`) use a **dual NVMe disk** configuration, defined in the `disko-config.nix` files.


### **Production Layout (AWS Graviton)**



1. **Main Disk (<code>/dev/nvme0n1</code>)**
    * `ESP` (Partition 1): Boot Partition (EFI), mounted at `/boot`.
    * `root` (Partition 2): Main OS partition for NixOS, mounted at `/`.
2. **Data Disk (<code>/dev/nvme1n1</code>)**
    * `wordpress_data` (Partition 1): Partition dedicated to persistent data, mounted at `/var/lib/wordpress`.

    **Note**: The `devm` node uses a similar logical configuration but mapped to `/dev/sda` and `/dev/sdb` for compatibility with standard QEMU virtio-blk drivers.
