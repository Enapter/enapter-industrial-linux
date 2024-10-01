#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

wic_file="enapter-industrial-linux-image-intel-corei7-64.rootfs.wic"
root_ext4_file="enapter-industrial-linux-rootfs-intel-corei7-64.rootfs.ext4"
efi_enapter_dir="EFI/enapter"
efi_boot_dir="EFI/BOOT"

update_dir=/home/build/update
images_dir=/home/build/images
deploy_dir=/home/build/tmp-glibc/deploy/images/intel-corei7-64
enapter_files="rootfs.img bzImage initrd version.txt"
boot_files="grubx64.efi grub.cfg"
img_path="$deploy_dir/$IMG_FILE_ARTIFACT_NAME"

# Cleanup from previous run
rm -rf "$update_dir"
rm -vf "$images_dir/enapter-industrial-linux-"*

# Copying industrial Linux img file with another name
# to make this script easier to test
cp "$deploy_dir/$wic_file" "$img_path"

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
