#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [[ -z "${SKIP_SOURCES_SYNC}" ]]; then
  rsync --delete-after -za /home/build/enapter-linux-build-source/ /home/build/enapter-linux-build
  cd /home/build/enapter-linux-build
  # KAS_CLONE_DEPTH=1 kas checkout --force-checkout configs/enapter-industrial-linux.yml
else
  echo "Skipping sync-sources..."
fi
