SUMMARY = "Enapter Linux Image."

IMAGE_INSTALL = "shim-efi grub-efi"

WKS_FILE = "enapter-industrial-linux-image.wks"

IMAGE_OVERHEAD_FACTOR = "1.0"
IMAGE_ROOTFS_EXTRA_SPACE = "300000"

inherit core-image

do_rootfs[depends] += "enapter-industrial-linux-rootfs:do_image_complete enapter-industrial-linux-initramfs:do_image_complete virtual/kernel:do_deploy sbsigntool-native:do_populate_sysroot intel-microcode:do_deploy"

copy_files_to_boot () {
    mkdir -p ${IMAGE_ROOTFS}/boot/EFI/enapter

    GRUB_EFI_SOURCE="${IMAGE_ROOTFS}/boot/EFI/BOOT/grub-efi-bootx64.efi"
    INITRD_SOURCE="${DEPLOY_DIR_IMAGE}/enapter-industrial-linux-initramfs-${MACHINE}.cpio"
    KERNEL_SOURCE="${DEPLOY_DIR_IMAGE}/bzImage"
    MICROCODE_SOURCE="${DEPLOY_DIR_IMAGE}/microcode.cpio"
    ROOTFS_SOURCE="${DEPLOY_DIR_IMAGE}/enapter-industrial-linux-rootfs-${MACHINE}.rootfs.squashfs-zst"

    GRUB_EFI_TARGET="${IMAGE_ROOTFS}/boot/EFI/BOOT/grubx64.efi"
    INITRD_TARGET="${IMAGE_ROOTFS}/boot/EFI/enapter/initrd"
    KERNEL_TARGET="${IMAGE_ROOTFS}/boot/EFI/enapter/bzImage"
    MICROCODE_TARGET="${IMAGE_ROOTFS}/boot/EFI/enapter/microcode.cpio"
    ROOTFS_TARGET="${IMAGE_ROOTFS}/boot/EFI/enapter/rootfs.img"

    if ! sbverify --cert "${SECURE_BOOT_SIGNING_CERT}" "${GRUB_EFI_SOURCE}"; then
        bbfatal "grubx64.efi sbverify failed"
    else
        bbnote "grubx64.efi signatures: $(sbverify --list --cert "${SECURE_BOOT_SIGNING_CERT}" "${GRUB_EFI_SOURCE}")"
    fi

    if ! sbverify --cert "${SECURE_BOOT_SIGNING_CERT}" "${KERNEL_SOURCE}"; then
        bbfatal "bzImage sbverify failed"
    else
        bbnote "bzImage signatures: $(sbverify --list --cert "${SECURE_BOOT_SIGNING_CERT}" "${KERNEL_SOURCE}")"
    fi

    echo "${DISTRO_VERSION}" > ${IMAGE_ROOTFS}/boot/EFI/enapter/version.txt

    cat "${MICROCODE_SOURCE}" "${INITRD_SOURCE}" | gzip > "${INITRD_TARGET}"

    cp ${KERNEL_SOURCE} ${KERNEL_TARGET}
    cp ${ROOTFS_SOURCE} ${ROOTFS_TARGET}
    mv ${GRUB_EFI_SOURCE} ${GRUB_EFI_TARGET}

    if [ -f ${SECURE_BOOT_SIGNING_CERT_DER} ]; then
        cp ${SECURE_BOOT_SIGNING_CERT_DER} "${IMAGE_ROOTFS}/boot/Enapter.cer"
    else
        bbfatal "SECURE_BOOT_SIGNING_CERT_DER is required but not defined"
    fi
}

ROOTFS_POSTPROCESS_COMMAND += "copy_files_to_boot;"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
