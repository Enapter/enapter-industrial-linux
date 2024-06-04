#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

/home/build/bin/prepare-sign-keys.sh
/home/build/bin/sync-sources.sh
/home/build/bin/load-sstate.sh

cd "/home/build/enapter-linux-build/repositories/poky"
source oe-init-build-env ../../machine/
cd ..

bitbake enapter-industrial-linux-image

/home/build/bin/save-sstate.sh
/home/build/bin/prepare-artifacts.sh
