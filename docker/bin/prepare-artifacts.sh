#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

wic_file="enapter-linux-image-intel-corei7-64.rootfs.wic"
vmdk_file="enapter-linux-image-intel-corei7-64.rootfs.wic.vmdk"
update_file="enapter-linux-update.zip"

update_dir=/home/build/update
images_dir=/home/build/images
deploy_dir=/home/build/tmp-glibc/deploy/images/intel-corei7-64

mv "$deploy_dir/$wic_file" "$deploy_dir/$IMG_FILE_ARTIFACT_NAME"

img_path="$deploy_dir/$IMG_FILE_ARTIFACT_NAME"
vmdk_path="$deploy_dir/$vmdk_file"

rm -rf "$update_dir"
rm -f "enapter-linux-*"

mkdir -p "$update_dir"
enapter_files="rootfs.img bzImage initrd version.txt"
boot_files="grubx64.efi grub.cfg"

for f in $enapter_files; do
  wic cp "$img_path:1/EFI/enapter/$f" "$update_dir/"
done

for f in $boot_files; do
  wic cp "$img_path:1/EFI/BOOT/$f" "$update_dir/"
done

cd "$update_dir"
# shellcheck disable=SC2086
sha256sum $enapter_files $boot_files > SHA256SUMS
# shellcheck disable=SC2086
zip -0 "$update_file" $enapter_files $boot_files SHA256SUMS

hashsum=$(sha256sum "$img_path" | awk '{ print $1 }')
echo "$hashsum  $IMG_FILE_ARTIFACT_NAME" > "$img_path".sha256sum
zip -rj "/tmp/$IMG_ARTIFACT_NAME" "$img_path" "$img_path".sha256sum

cp "$update_file" "$images_dir/$UPDATE_ARTIFACT_NAME"
cp "/tmp/$IMG_ARTIFACT_NAME" "$images_dir/$IMG_ARTIFACT_NAME"
cp "$vmdk_path" "$images_dir/$VMDK_ARTIFACT_NAME"
