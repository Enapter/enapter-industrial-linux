#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

mkdir "$(dirname "$SECURE_BOOT_SIGNING_CERT")"

echo "$SECURE_BOOT_SIGNING_CERT_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_CERT"
echo "$SECURE_BOOT_SIGNING_KEY_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_KEY"
echo "$SECURE_BOOT_SIGNING_CERT_DER_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_CERT_DER"

mkdir "$(dirname "$MODSIGN_SIGNING_CERT")"

echo "$MODSIGN_SIGNING_CERT_BASE64" | base64 -d > "$MODSIGN_SIGNING_CERT"
echo "$MODSIGN_SIGNING_KEY_BASE64" | base64 -d > "$MODSIGN_SIGNING_KEY"

mkdir "$(dirname "$RAUC_CERT")"

echo "$RAUC_CERT_BASE64" | base64 -d > "$RAUC_CERT"
echo "$RAUC_KEY_BASE64" | base64 -d > "$RAUC_KEY"
echo "$RAUC_KEYRING_BASE64" | base64 -d > "$RAUC_KEYRING"
