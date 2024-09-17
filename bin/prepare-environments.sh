# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

export SECURE_BOOT_SIGNING_CERT="/home/build/secure_boot_signing/sign.pem"
export SECURE_BOOT_SIGNING_KEY="/home/build/secure_boot_signing/sign.key"
export SECURE_BOOT_SIGNING_CERT_DER="/home/build/secure_boot_signing/sign.der"

export MODSIGN_SIGNING_CERT="/home/build/modules_signing/sign.pem"
export MODSIGN_SIGNING_KEY="/home/build/modules_signing/sign.key"

export RAUC_CERT="/home/build/rauc/production.pem"
export RAUC_KEY="/home/build/rauc/production.key"
export RAUC_KEYRING="/home/build/rauc/ca.cert.pem"

if [ -z "$CI_COMMIT_TAG" ]; then
  export DISTRO_VERSION="${ENAPTER_LINUX_BASE_VERSION}-dev-${CI_PIPELINE_ID:-${CI_COMMIT_SHORT_SHA:-unknown}}"
else
  export DISTRO_VERSION="${CI_COMMIT_TAG:-$CI_COMMIT_REF_SLUG}.$CI_PIPELINE_ID"
fi

export DISTRO="enapter-industrial-linux"

export IMG_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.zip"
export IMG_FILE_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.img"
export UPDATE_ARTIFACT_NAME="enapter-industrial-linux-update-${DISTRO_VERSION}.zip"
export RAUC_UPDATE_ARTIFACT_NAME="enapter-industrial-linux-update-${DISTRO_VERSION}.raucb"
export VMDK_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.vmdk"
export VEX_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}-vex.json"
export ROOTFS_SPDX_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}-rootfs-spdx.zip"
export INITRAMFS_SPDX_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}-initrd-spdx.zip"
