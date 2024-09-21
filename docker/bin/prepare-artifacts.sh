#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

wic_file="enapter-industrial-linux-image-intel-corei7-64.rootfs.wic"
vmdk_file="enapter-industrial-linux-image-intel-corei7-64.rootfs.wic.vmdk"
root_ext4_file="enapter-industrial-linux-rootfs-intel-corei7-64.rootfs.ext4"
update_file="enapter-industrial-linux-update.zip"
efi_enapter_dir="EFI/enapter"
efi_boot_dir="EFI/BOOT"
rauc_manifest="manifest.raucm"
install_bundle_name="install.raucb"

update_dir=/home/build/update
rauc_update_dir=/home/build/rauc-update
images_dir=/home/build/images
deploy_dir=/home/build/tmp-glibc/deploy/images/intel-corei7-64

cp "$deploy_dir/$wic_file" "$deploy_dir/$IMG_FILE_ARTIFACT_NAME"

img_path="$deploy_dir/$IMG_FILE_ARTIFACT_NAME"
vmdk_path="$deploy_dir/$vmdk_file"

rm -rf "$update_dir"
rm -rf "$rauc_update_dir"
rm -vf "$images_dir/enapter-industrial-linux-"*

mkdir -p "$update_dir"
enapter_files="rootfs.img bzImage initrd version.txt"
boot_files="grubx64.efi grub.cfg"

for f in $enapter_files; do
  wic cp "$img_path:1/$efi_enapter_dir/$f" "$update_dir/"
done

for f in $boot_files; do
  wic cp "$img_path:1/$efi_boot_dir/$f" "$update_dir/"
done

rauc_version_file="version.txt"
rauc_kernel_files="initrd bzImage"
rauc_boot_files="unicode.pf2 bootx64.efi mmx64.efi grubx64.efi"
rauc_bootloader_update_dir="bootloader"
rauc_kernel_update_dir="kernel"
rauc_rootfs_update="rootfs"
rauc_enapter_cert_file="Enapter.cer"

mkdir -p "$rauc_update_dir"
mkdir -p "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT"
mkdir -p "$rauc_update_dir/$rauc_kernel_update_dir"

cp "$deploy_dir/$root_ext4_file" "$rauc_update_dir/$rauc_rootfs_update.ext4"

wic cp "$img_path:1/$efi_enapter_dir/$rauc_version_file" "/tmp/$rauc_version_file"
wic cp "$img_path:1/$rauc_enapter_cert_file" "$rauc_update_dir/$rauc_bootloader_update_dir/$rauc_enapter_cert_file"

for f in $rauc_kernel_files; do
  wic cp "$img_path:1/$efi_enapter_dir/$f" "$rauc_update_dir/$rauc_kernel_update_dir"
done

for f in $rauc_boot_files; do
  wic cp "$img_path:1/$efi_boot_dir/$f" "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT"
done

wic cp "$img_path:1/$efi_boot_dir/grub.cfg.install" "$rauc_update_dir/$rauc_bootloader_update_dir/EFI/BOOT/grub.cfg"

# tar -czf "$rauc_update_dir/$rauc_bootloader_update_dir.tar.gz" -C "$rauc_update_dir/$rauc_bootloader_update_dir" --strip-components 1 .
mkfs.vfat -n "enp-boot" -C "$rauc_update_dir/$rauc_bootloader_update_dir.vfat" 16384 # 16Mb
mcopy -i "$rauc_update_dir/$rauc_bootloader_update_dir.vfat" -s "$rauc_update_dir/$rauc_bootloader_update_dir"/* ::

tar -czf "$rauc_update_dir/$rauc_kernel_update_dir.tar.gz" -C "$rauc_update_dir/$rauc_kernel_update_dir" --strip-components 1 .

rm -rf "${rauc_update_dir:?}/$rauc_kernel_update_dir"
rm -rf "${rauc_update_dir:?}/$rauc_bootloader_update_dir"

version="$(cat "/tmp/$rauc_version_file")"

cat << EOF > "$rauc_update_dir/$rauc_manifest"
[update]
compatible=Enapter Linux
version=$version

[bundle]
format=verity

[image.rootfs]
filename=$rauc_rootfs_update.ext4

[image.bootloader]
filename=$rauc_bootloader_update_dir.vfat

[image.kernel]
filename=$rauc_kernel_update_dir.tar.gz
EOF

rauc bundle --cert="$RAUC_CERT" --key="$RAUC_KEY" "$rauc_update_dir/" "$images_dir/$RAUC_UPDATE_ARTIFACT_NAME"

# put update bundle as install bundle file inside disk image
wic cp "$images_dir/$RAUC_UPDATE_ARTIFACT_NAME" "$img_path:1/$install_bundle_name"

cd "$update_dir"
# shellcheck disable=SC2086
sha256sum $enapter_files $boot_files > SHA256SUMS
# shellcheck disable=SC2086
zip -0 "$update_file" $enapter_files $boot_files SHA256SUMS

hashsum=$(sha256sum "$img_path" | awk '{ print $1 }')
echo "$hashsum  $IMG_FILE_ARTIFACT_NAME" > SHA256SUMS
zip -rj "/tmp/$IMG_ARTIFACT_NAME" "$img_path" SHA256SUMS

cp "$update_file" "$images_dir/$UPDATE_ARTIFACT_NAME"
cp "/tmp/$IMG_ARTIFACT_NAME" "$images_dir/$IMG_ARTIFACT_NAME"
qemu-img convert -O vmdk "$img_path" "$images_dir/$VMDK_ARTIFACT_NAME"
