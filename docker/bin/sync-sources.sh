#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [[ -z "${SKIP_SOURCES_SYNC}" ]]; then
  rsync --exclude='.git/' --delete-after -za /home/build/enapter-linux-build-source/ /home/build/enapter-linux-build
else
  echo "Skipping sync-sources..."
fi
