# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

/home/build/bin/prepare-sign-keys.sh
/home/build/bin/sync-sources.sh
/home/build/bin/load-sstate.sh

cd "/home/build/enapter-linux-build/repositories/poky"
source oe-init-build-env ../../machine/
cd ..

# pip3 install -r /home/build/enapter-linux-build/repositories/poky/bitbake/toaster-requirements.txt
# source toaster start webport=0.0.0.0:8080

echo "/home/build/bin/sync-sources.sh && bitbake -k enapter-industrial-linux-image"
