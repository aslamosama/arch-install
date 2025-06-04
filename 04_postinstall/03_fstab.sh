#!/usr/bin/env sh

echo "Mount C,D and E using the dmenu script"
sleep 2
mounter
sleep 2
mounter
sleep 2
mounter
genfstab / >~/fstab
echo "ntfs-3g           defaults,uid=1000,gid=1000,umask=0022,windows_names 0 0" >>~/fstab
echo "Edit correct values for the windows drives and copy them. Opening nvim..."
sleep 2
nvim ~/fstab
echo "Paste the copied entries in fstab now. Opening nvim..."
sleep 2
sudo nvim /etc/fstab
echo "Now check if mounted partitions work as expected"
