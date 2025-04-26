#!/bin/bash

dpkg-query -W --showformat='${Installed-Size}\t${Package}\n' | sort -nr | less
echo "Select an ISO!"
isoname=""
read -p "Enter Directory For Your ISO to be created: " isoname
mkdir -p /mnt/"$isoname"  # Create the directory if it doesn't exist
sudo mount -o loop "$isoname" /mnt/"$isoname"

echo "Creating chroot environment (if you want chroot mode)"
upath=""
read -p "Enter Username For Your ISO to be created: " upath
mkdir -p /mnt/"$isoname"/home/"$upath"/{bin,lib64}  # Ensure the directories exist

# Copy binaries into the ISO
cp /bin/bash /mnt/"$isoname"/bin/
cp /bin/ls /mnt/"$isoname"/bin/
cp /bin/cat /mnt/"$isoname"/bin/

# Copy necessary libraries
ldd /bin/bash /bin/ls /bin/cat | grep -o '/lib[^ ]*' | while read lib; do
  cp "$lib" /mnt/"$isoname"/lib64/
done

# Now copy additional libraries (if you know they are needed)
cp /lib64/libtinfo.so.5 /mnt/"$isoname"/lib64/
cp /lib64/libdl.so.2 /mnt/"$isoname"/lib64/
cp /lib64/ld-linux-x86-64.so.2 /mnt/"$isoname"/lib64/
cp /lib64/libselinux.so.1 /mnt/"$isoname"/lib64/
cp /lib64/librt.so.1 /mnt/"$isoname"/lib64/
cp /lib64/libcap.so.2 /mnt/"$isoname"/lib64/
cp /lib64/libacl.so.1 /mnt/"$isoname"/lib64/
cp /lib64/libc.so.6 /mnt/"$isoname"/lib64/
cp /lib64/libpthread.so.0 /mnt/"$isoname"/lib64/
cp /lib64/libattr.so.1 /mnt/"$isoname"/lib64/
cp /lib64/libpcre.so.1 /mnt/"$isoname"/lib64/

echo "ISO creation complete. Chroot!"
sudo chroot /mnt/"$isoname" /bin/bash
