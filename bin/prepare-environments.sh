# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

export SECURE_BOOT_SIGNING_CERT="/home/build/secure_boot_signing/sign.crt"
export SECURE_BOOT_SIGNING_KEY="/home/build/secure_boot_signing/sign.key"
export SECURE_BOOT_SIGNING_CERT_DER="/home/build/secure_boot_signing/sign.cer"

export RAUC_CERT="/home/build/rauc/production.crt"
export RAUC_KEY="/home/build/rauc/production.key"
export RAUC_KEYRING="/home/build/rauc/ca.cert.pem"

if [ -z "$CI_COMMIT_TAG" ]; then
  export DISTRO_VERSION="${ENAPTER_LINUX_BASE_VERSION}-dev-${CI_PIPELINE_ID:-${CI_COMMIT_SHORT_SHA:-unknown}}"
else
  export DISTRO_VERSION="$CI_COMMIT_TAG"
fi

export IMG_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.zip"
export IMG_FILE_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.img"
export UPDATE_ARTIFACT_NAME="enapter-industrial-linux-update-${DISTRO_VERSION}.zip"
export RAUC_UPDATE_ARTIFACT_NAME="enapter-industrial-linux-update-${DISTRO_VERSION}.raucb"
export VMDK_ARTIFACT_NAME="enapter-industrial-linux-${DISTRO_VERSION}.vmdk"
