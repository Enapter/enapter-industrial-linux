IMAGE_INSTALL = "\
                 packagegroup-core-boot \
                 ${IMAGE_ROOTFS_INSTALL} \
                "

DEPENDS:remove = "grub-efi"
IMAGE_FEATURES = ""
IMAGE_FSTYPES = "squashfs-zst"
KERNELDEPMODDEPEND = ""
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

IMAGE_CLASSES += "extrausers"
EXTRA_USERS_PARAMS = "\
    usermod -s /bin/bash root; \
"

inherit core-image

clobber_unused() {
  rm -rf ${IMAGE_ROOTFS}/boot/*
}

ROOTFS_POSTPROCESS_COMMAND:append = " \
  clobber_unused; \
"
