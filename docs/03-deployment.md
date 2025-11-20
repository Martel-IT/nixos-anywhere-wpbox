# **Deployment Guide**


## **Prerequisites**



1. **Nix** installed on your local machine.
2. **SSH root access** (or passwordless sudo) to the target machine.
3. SSH key loaded into the local agent:

Since the nixos-anywhere repo already knows how to ssh into the machine, the only thing we have to pass is the key.

Note that we cannot pass `-i` for `--identity` so to achive this we'll run

```bash
ssh-add /path/to/key.pem
```

> **NOTE** <br>
> **_If you just downloaded a key (either rsa or ed25519) from AWS EC2 Launch wizard, you'll have to change its permissions making them more strict or the CLI will nag you._**

Best recommended permissions are:

```bash
chmod 0400 /path/to/key.pem
```

## **Deployment Command (macOS / Apple Silicon)**

Since macOS (Darwin) cannot natively compile Linux packages, we must delegate the build process to the remote machine (or an external builder). We use the `--build-on-remote` flag.


### **For AWS Graviton Node (Production)**

Replace the IP with the current IP of the AWS machine.

**Command Breakdown:**



* `nix run github:nix-community/nixos-anywhere`: Downloads and runs the latest version of the installation tool.
* `--`: Separates Nix commands from arguments passed to the tool.
* `--flake .#aarch64-linux`: Specifies using the configuration defined in this repo (`.`) with the output name `aarch64-linux`.
* `--build-on-remote`: **Crucial for Mac**. Copies `.nix` files to the server and lets the server (which is Linux) compile its own configuration.

Full command:

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#aarch64-linux <USER>@<IP> --build-on-remote
```


## **Deployment Command (Native Linux)**

If running the command from a Linux machine (e.g., another server or x86 Linux laptop), remote build is not strictly necessary.


## **Local VM Deployment (Development)**

To test on a local VM (QEMU) mapped to localhost:

*(Assuming the VM exposes SSH on local port 2222).*

## **Results**

After issued the command, you'll se a bunch of CLI lines where you can appreciate the beauty of nix running the shou with kexec.

After a while, we will get something that looks like this:

```bash
### Installing NixOS ###
Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
installing the boot loader...
setting up /etc...
updating GRUB 2 menu...
installing the GRUB 2 boot loader into /boot...
Installing for arm64-efi platform.
Installation finished. No error reported.
installation finished!
### Rebooting ###
Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
### Waiting for the machine to become unreachable due to reboot ###
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
Warning: Permanently added '<IP>' (ED25519) to the list of known hosts.
ssh: connect to host <IP> port 22: Connection refused
### Done! ###
```

Then, if we try SSH into the machine and run

```bash
lsblk
```

we'll get:

```bash
[root@wpbox-aarch64:~]# lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
nvme1n1     259:0    0  100G  0 disk
└─nvme1n1p1 259:2    0  100G  0 part /var/lib/wordpress
nvme0n1     259:1    0   50G  0 disk
├─nvme0n1p1 259:3    0 1023M  0 part /boot
└─nvme0n1p2 259:4    0   49G  0 part /nix/store
                                     /
```

There's no need for doing that since nix and disko will persist the edits but if you just wanna triple-check, you can reboot the host and ssh-in again:

```bash
[root@wpbox-aarch64:~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        191M     0  191M   0% /dev
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           955M  7.6M  948M   1% /run
/dev/nvme0n1p2   48G  2.5G   44G   6% /
efivarfs        128K  3.0K  126K   3% /sys/firmware/efi/efivars
tmpfs           1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
tmpfs           1.9G  2.2M  1.9G   1% /run/wrappers
/dev/nvme0n1p1 1021M   82M  940M   8% /boot
/dev/nvme1n1p1   98G  2.1M   93G   1% /var/lib/wordpress
tmpfs           382M  4.0K  382M   1% /run/user/0
```


## **Troubleshooting**


### **Error: "I am a 'aarch64-darwin'..."**

If you see this error during the build phase, you forgot the `--build-on-remote` flag. Your Mac is trying to compile Linux binaries but lacks the necessary platform tools.


### **Error: "ssh: connect to host ... port 22: Connection refused"**

If you see this error at the very end of the logs, **it is not a failure**. This message occurs because `nixos-anywhere` attempts to reconnect immediately after installation, but the server is in the process of rebooting. **Solution**: Wait 1-2 minutes for the reboot to complete, then log in normally via SSH.


### **Error: Disk not found**

If deployment fails during the Disko phase, verify using `lsblk` on the target machine that the device names (e.g., `nvme0n1`, `nvme1n1`) match those defined in `disko-config.nix`.
