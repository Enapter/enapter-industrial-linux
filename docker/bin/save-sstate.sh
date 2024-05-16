#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [[ -z "${SKIP_SSTATE_SAVE}" ]]; then
  /home/build/enapter-linux-build/repositories/poky/scripts/sstate-cache-management.py --stamps-dir=/home/build/tmp-glibc/stamps -y --cache-dir=/home/build/sstate-cache
  sudo rsync -za --delete-after /home/build/sstate-cache/ /home/build/sstate-cache-source
else
  echo "Skipping save-sstate..."
fi
