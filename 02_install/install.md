---
title: Arch Install Instructions
---

## 1. Set a Bigger TTY Font

```bash
setfont iso01-12x22
```

## 2. Connect to WiFi

```bash
iwctl
station wlan0 connect <wifi_name>
exit
ping google.com
```

## **Important:** Avoid Updating Before Install

Do **not** run `pacman -Syu`, update the keyring, or install any packages using `pacman -Sy` at this stage.

## 3. Inspect Current Partitions

```bash
lsblk
```

## 4. Create New Partitions

Identify your target drive (usually `/dev/sda`), then create partitions using `cfdisk`:

```bash
cfdisk /dev/sda
```

* Locate the unallocated space.
* Create a **separate EFI partition** for Linux.
* The **Linux EFI** should come *before* the Windows EFI.
* Allocate **\~500MB** for each EFI partition.
* Do **not** create separate `/home` and `/root` partitions.
* Create a single Linux partition of **at least 50GB**.

Re-check the partition layout:

```bash
lsblk
```

## 5. Format the Partitions

Format the **EFI partition** (e.g., `/dev/sda5`) as FAT32:

```bash
mkfs.fat -F32 /dev/sda5
```

Format the **Linux root partition** (e.g., `/dev/sda6`) as EXT4:

```bash
mkfs.ext4 /dev/sda6
```

## 6. Mount the Partitions

Mount the Linux root partition:

```bash
mount /dev/sda6 /mnt
```

Create and mount the EFI directory:

```bash
mkdir -p /mnt/boot
mount /dev/sda5 /mnt/boot  # Replace with actual EFI partition
```

Re-check the partition layout:

```bash
lsblk
```

## 7. Run the Arch Install Script

Launch the guided installer:

```bash
archinstall
```

* When asked about the partition layout, choose **"premounted configuration"**.
* Provide `/mnt` as the mount point.
* After installation, say **"yes"** to `chroot` into the new system.

---
