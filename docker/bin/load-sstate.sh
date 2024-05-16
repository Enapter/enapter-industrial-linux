#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

if [[ -z "${SKIP_SSTATE_LOAD}" ]]; then
  sudo rsync -za /home/build/sstate-cache-source/ /home/build/sstate-cache
  sudo chmod -R a+rw /home/build/sstate-cache
else
  echo "Skipping load-sstate..."
fi
