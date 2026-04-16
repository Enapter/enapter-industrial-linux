# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

/home/build/bin/sync-sources.sh
/home/build/bin/prepare-sign-keys.sh
/home/build/bin/load-sstate.sh

# ./oe-init-build-env ~/enapter-linux-build/build/

cd "/home/build/enapter-linux-build"
echo "/home/build/bin/sync-sources.sh && kas build configs/${DISTRO_TYPE}.yml"
