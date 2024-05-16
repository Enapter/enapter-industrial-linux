INITRAMFS_SCRIPTS ?= "\
                      initramfs-framework-base \
                      initramfs-module-debug \
                      initramfs-module-udev \
                     "

PACKAGE_INSTALL = "\
                   ${IMAGE_FS_TOOLS} \
                   ${IMAGE_KERNEL_DEPS} \
                   ${INITRAMFS_SCRIPTS} \
                   ${VIRTUAL-RUNTIME_base-utils} \
                   ${VIRTUAL-RUNTIME_dev_manager} \
                   base-passwd \
                   coreutils \
                  "

IMAGE_FEATURES = ""
export IMAGE_BASENAME = "enapter-linux-initramfs"
IMAGE_NAME_SUFFIX ?= ""
IMAGE_LINGUAS = ""
IMAGE_INSTALL = ""
LICENSE = "MIT"

IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"

inherit core-image

clobber_unused() {
  rm -rf ${IMAGE_ROOTFS}/boot/*
}

ROOTFS_POSTPROCESS_COMMAND:append = " \
  clobber_unused; \
"
