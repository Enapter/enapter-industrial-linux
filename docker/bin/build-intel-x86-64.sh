#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

/home/build/bin/sync-sources.sh
/home/build/bin/prepare-sign-keys.sh
/home/build/bin/load-sstate.sh

cd "/home/build/enapter-linux-build"
kas build configs/${DISTRO_TYPE}.yml

/home/build/bin/save-sstate.sh
kas shell configs/${DISTRO_TYPE}.yml -c /home/build/bin/prepare-artifacts.sh
