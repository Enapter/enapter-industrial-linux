#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <repositories config>"
    exit 1
fi

grep -v "^#" "$1" | while read p; do ./bin/git-fetch.sh $p || exit 1; done
