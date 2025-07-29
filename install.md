---
title: Arch Install Instructions
---

## 1. Set a Bigger TTY Font (Optional)

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

- Locate the unallocated space.
- Create a **separate EFI partition** for Linux.
- Allocate **\~500MB** for each EFI partition.
- May create separate `/home` and `/root` partitions.
- May create a `swap`.

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
mount /dev/sda6 /mnt  # Replace with actual root partition
```

Mount the Linux home partition if separately created:

```bash
mount /dev/sda7 /mnt  # Replace with actual home partition
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

- When asked about the partition layout, choose **"premounted configuration"**.
- Provide `/mnt` as the mount point.
- After installation, say **"yes"** to `chroot` into the new system.

## 8. Exit Chroot and Reboot

If everything seems alright exit chroot and reboot into Arch.
Now get the postinstall scripts:

```bash
pacman -S git
git clone https://github.com/aslamosama/arch-install.git
cd arch-install
```

First run `pre-gui` script and reboot:

```bash
./pre_gui.sh
```

Then run `post-gui` script.

```bash
./pre_gui.sh
```

---
