#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

mkdir "$(dirname "$SECURE_BOOT_SIGNING_CERT")"

echo "$SECURE_BOOT_SIGNING_CERT_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_CERT"
echo "$SECURE_BOOT_SIGNING_KEY_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_KEY"
echo "$SECURE_BOOT_SIGNING_CERT_DER_BASE64" | base64 -d > "$SECURE_BOOT_SIGNING_CERT_DER"
