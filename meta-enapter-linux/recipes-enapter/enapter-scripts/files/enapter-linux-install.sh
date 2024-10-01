#!/bin/bash
# SPDX-FileCopyrightText: 2023 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -o errexit

. /usr/share/scripts/enapter-functions

install() {
    yes="$1"

    findmnt "$boot_mount" -o LABEL -P | grep "LABEL=\"$disk_usb_boot_label\"" > /dev/null || {
      lsblk -P -p -o "NAME,SIZE,MOUNTPOINTS,LABEL"
      fatal "Enapter Linux appears to be already installed. Please review the partitions and mounts."
    }

    if [[ ! -L "$hdd_boot_device" ]]; then
      fatal "The partition with the label enp-os (installation disk) was not found. Please proceed with the Enapter Gateway setup first."
    fi

    if [[ $yes -ne 1 ]]; then
        while true; do
          read -p "Are you sure you want to proceed with installing Enapter Linux on the HDD? (y/n) " yn

          case $yn in
            [yY] ) info "Ok, we will proceed.";
              break;;
            [nN] ) info "Exiting...";
              exit;;
            * ) info "Invalid response. Please use (y/n).";
              exit 1;;
          esac
        done
    fi

    info "Mounting the HDD boot partition."
    mkdir -p ${hdd_boot_mount}
    mountpoint -q ${hdd_boot_mount} || mount -v ${hdd_boot_device} ${hdd_boot_mount}

    os_files=$(find "$boot_mount" -not -path '*/.*' -type f | sed 's|^/boot/||')

    while IFS= read -r f; do
      if [[ -n "$f" ]]; then
        if [[ -f "$hdd_boot_mount/$f" ]]; then
          fatal "Enapter Linux appears to be already installed on the HDD (/mnt/boot), but the system has booted from a USB. If you wish to overwrite the installed files, please remove them manually."
        fi
      fi
    done <<< "$os_files"

    if [[ ! -w ${hdd_boot_mount} ]]; then
      fatal "The HDD boot partition is not available for writing. Please check the logs above for more details."
    fi

    info "Copying system files, please wait..."

    while IFS= read -r f; do
      if [[ -n "$f" ]]; then
        if [[ -f "$boot_mount/$f" ]]; then
          mkdir -v -p "$hdd_boot_mount/$(dirname "$f")"
          cp -v -f "$boot_mount/$f" "$hdd_boot_mount/$f" || fatal "Failed to copy the $f file, aborting the installation halfway. Please perform a cleanup before rebooting."
        fi
      fi
    done <<< "$os_files"

    info "Syncing disks."
    sync; sync; sync

    info "Unmounting the HDD boot partition."
    umount ${hdd_boot_mount} || info "Failed to unmount the HDD boot partition, but it should be OK."

    info "Enapter Linux has been successfully installed on the HDD. Please remove the installation media (USB stick) and reboot the PC."
}

LONGOPTS=yes
OPTIONS=y

# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out "--options")
# -pass arguments only via   -- "$@"   to separate them correctly
# -if getopt fails, it complains itself to stdout
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@") || exit 2
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

yes=0

while true; do
    case "$1" in
        -y|--yes)
            yes=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

install "$yes"
