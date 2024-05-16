SUMMARY = "Enapter Linux Image."

IMAGE_INSTALL = "shim-efi grub-efi"

WKS_FILE = "enapter-linux-image.wks"

IMAGE_OVERHEAD_FACTOR = "1.0"
IMAGE_ROOTFS_EXTRA_SPACE = "300000"

inherit core-image

do_rootfs[depends] += "enapter-linux-rootfs:do_image_complete enapter-linux-initramfs:do_image_complete virtual/kernel:do_deploy sbsigntool-native:do_populate_sysroot"

copy_files_to_boot () {
    mkdir -p ${IMAGE_ROOTFS}/boot/EFI/enapter

    KERNEL_FILE="${IMAGE_ROOTFS}/boot/EFI/enapter/bzImage"
    GRUB_EFI_FILE="${IMAGE_ROOTFS}/boot/EFI/BOOT/grubx64.efi"

    echo "${DISTRO_VERSION}" > ${IMAGE_ROOTFS}/boot/EFI/enapter/version.txt

    cp ${DEPLOY_DIR_IMAGE}/enapter-linux-rootfs-${MACHINE}.rootfs.squashfs-zst ${IMAGE_ROOTFS}/boot/EFI/enapter/rootfs.img
    cp ${DEPLOY_DIR_IMAGE}/enapter-linux-initramfs-${MACHINE}.cpio.gz ${IMAGE_ROOTFS}/boot/EFI/enapter/initrd
    cp ${DEPLOY_DIR_IMAGE}/bzImage ${KERNEL_FILE}
    mv ${IMAGE_ROOTFS}/boot/EFI/BOOT/grub-efi-bootx64.efi ${GRUB_EFI_FILE}

    if [ -f ${SECURE_BOOT_SIGNING_CERT_DER} ]; then
        cp ${SECURE_BOOT_SIGNING_CERT_DER} "${IMAGE_ROOTFS}/boot/Enapter.cer"
    else
        bbfatal "SECURE_BOOT_SIGNING_CERT_DER is required but not defined"
    fi
}

ROOTFS_POSTPROCESS_COMMAND += "copy_files_to_boot;"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
