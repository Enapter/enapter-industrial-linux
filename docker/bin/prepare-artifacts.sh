#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

wic_file="enapter-industrial-linux-image-intel-corei7-64.rootfs.wic"
root_ext4_file="enapter-industrial-linux-rootfs-intel-corei7-64.rootfs.ext4"
efi_enapter_dir="EFI/enapter"
efi_boot_dir="EFI/BOOT"
rauc_manifest="manifest.raucm"
install_bundle_name="install.raucb"
img_path="$deploy_dir/$IMG_FILE_ARTIFACT_NAME"

update_dir=/home/build/update
rauc_update_dir=/home/build/rauc-update
images_dir=/home/build/images
deploy_dir=/home/build/tmp-glibc/deploy/images/intel-corei7-64
rauc_conf="system.conf"
rauc_kernel_files="initrd bzImage"
rauc_boot_files="unicode.pf2 bootx64.efi mmx64.efi grubx64.efi"
rauc_bootloader_update="bootloader.vfat"
rauc_bootloader_update_dir="bootloader"
rauc_kernel_update="kernel.tar.gz"
rauc_kernel_update_dir="kernel"
rauc_rootfs_update="rootfs.ext4"
rauc_enapter_cert_file="Enapter.cer"
enapter_files="rootfs.img bzImage initrd version.txt"
boot_files="grubx64.efi grub.cfg"

# Cleanup from previous run
rm -rf "$update_dir"
rm -rf "$rauc_update_dir"
rm -vf "$images_dir/enapter-industrial-linux-"*

# dummy config for rauc extract to work
# we specifying all required settings and
# check-purpose=any is only important for us
cat << EOF > "$deploy_dir/$rauc_conf"
[system]
compatible=Enapter Linux
bootloader=grub
bundle-formats=-plain

[keyring]
check-purpose=any
EOF

# Copying industrial Linux img file with another name
# to make this script easier to test
cp "$deploy_dir/$wic_file" "$img_path"

# Temporary dirs for industrial Linux update
mkdir -p "$rauc_update_dir"
mkdir -p "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT"
mkdir -p "$rauc_update_dir/$rauc_kernel_update_dir"

# Copy build rootfs ext4 image to update folder
cp "$deploy_dir/$root_ext4_file" "$rauc_update_dir/$rauc_rootfs_update"

# Copy grub stuff into bootloader image temp folder
for f in $rauc_boot_files; do
  wic cp "$img_path:1/$efi_boot_dir/$f" "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT"
done

# Enapter.cer file will be part of bootloader image
wic cp "$img_path:1/$rauc_enapter_cert_file" "$rauc_update_dir/$rauc_bootloader_update_dir/$rauc_enapter_cert_file"

# Copying bzImage and initrd to kernel update image temp folder
for f in $rauc_kernel_files; do
  wic cp "$img_path:1/$efi_enapter_dir/$f" "$rauc_update_dir/$rauc_kernel_update_dir"
done

# We are using special grub config for system when it is installed on disk
wic cp "$img_path:1/$efi_boot_dir/grub.cfg.install" "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT/grub.cfg"

# Creating vfat image for bootloader
mkfs.vfat -n "enp-boot" -C "$rauc_update_dir/$rauc_bootloader_update" 16384 # 16Mb
mcopy -i "$rauc_update_dir/$rauc_bootloader_update" -s "$rauc_update_dir/$rauc_bootloader_update_dir"/* ::

# Creating kernel update image
tar -czf "$rauc_update_dir/$rauc_kernel_update" -C "$rauc_update_dir/$rauc_kernel_update_dir" --strip-components 1 .

cat << EOF > "$rauc_update_dir/$rauc_manifest"
[update]
compatible=Enapter Linux
version=$DISTRO_VERSION

[bundle]
format=verity

[image.rootfs]
filename=$rauc_rootfs_update

[image.bootloader]
filename=$rauc_bootloader_update

[image.kernel]
filename=$rauc_kernel_update
EOF

# Remove temp dir from update bundle folder
rm -rf "${rauc_update_dir:?}/$rauc_kernel_update_dir"
rm -rf "${rauc_update_dir:?}/$rauc_bootloader_update_dir"

# Creating update bundle in output folder
rauc bundle --keyring="$RAUC_KEYRING" -c "$deploy_dir/$rauc_conf" \
  --cert="$RAUC_CERT" --key="$RAUC_KEY" \
  "$rauc_update_dir/" "$images_dir/$RAUC_UPDATE_ARTIFACT_NAME"

# Put update bundle as install bundle file inside disk image
wic cp "$images_dir/$RAUC_UPDATE_ARTIFACT_NAME" "$img_path:1/$install_bundle_name"

# Creating temp dir for building legacy update bundle
mkdir -p "$update_dir"

# Extracting system images from .img into temp folder
for f in $enapter_files; do
  wic cp "$img_path:1/$efi_enapter_dir/$f" "$update_dir/"
done

# Extracting bootloader files and grub.cfg from .img into temp folder
for f in $boot_files; do
  wic cp "$img_path:1/$efi_boot_dir/$f" "$update_dir/"
done

# Legacy update bundle checksums
cd "$update_dir"
# shellcheck disable=SC2086
sha256sum $enapter_files $boot_files > SHA256SUMS
# Build legacy update bundle (simple zip archive) into output dir
# shellcheck disable=SC2086
zip -0 "$images_dir/$UPDATE_ARTIFACT_NAME" $enapter_files $boot_files SHA256SUMS

# Calculate .img file checksum
hashsum=$(sha256sum "$img_path" | awk '{ print $1 }')
echo "$hashsum  $IMG_FILE_ARTIFACT_NAME" > SHA256SUMS
# Create zip file with .img and hashsum
zip -rj "/tmp/$IMG_ARTIFACT_NAME" "$img_path" SHA256SUMS

# .img and .vmdk images are ready
cp "/tmp/$IMG_ARTIFACT_NAME" "$images_dir/$IMG_ARTIFACT_NAME"
qemu-img convert -O vmdk "$img_path" "$images_dir/$VMDK_ARTIFACT_NAME"
