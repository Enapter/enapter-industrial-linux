#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

set -ex

repository="enapter/enapter-industrial-linux"

upload_asset() {
    release_id="$1"
    asset_name="$2"
    file_name="$3"

    curl -L \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer $GITHUB_TOKEN" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -H "Content-Type: application/octet-stream" \
      "https://uploads.github.com/repos/$repository/releases/$release_id/assets?name=$asset_name" \
      --data-binary "@$file_name"
}

create_release_response=$(curl -sL \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$repository/releases \
  -d "{\"tag_name\":\"$DISTRO_VERSION\",\"name\":\"$DISTRO_VERSION\"}")

release_id=$(echo "$create_release_response" | jq '.id')

upload_asset "$release_id" "$IMG_ARTIFACT_NAME" "${BUILD_STORAGE_DIR}/intel-x86-64-images/$IMG_ARTIFACT_NAME"
upload_asset "$release_id" "$UPDATE_ARTIFACT_NAME" "${BUILD_STORAGE_DIR}/intel-x86-64-images/$UPDATE_ARTIFACT_NAME"
upload_asset "$release_id" "$VMDK_ARTIFACT_NAME" "${BUILD_STORAGE_DIR}/intel-x86-64-images/$VMDK_ARTIFACT_NAME"
