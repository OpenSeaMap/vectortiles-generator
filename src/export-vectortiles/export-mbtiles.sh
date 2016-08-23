#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly PROJECT_DIR="/tm2source"
readonly EXPORT_DIR="/export"
readonly RENDER_SCHEME=${RENDER_SCHEME:-pyramid}
readonly MIN_ZOOM=${MIN_ZOOM:-0}
readonly MAX_ZOOM=${MAX_ZOOM:-20}
readonly BBOX=${BBOX:-"11.96 54.042 12.24 54.23"}

function export_local_mbtiles() {
    local mbtiles_name="oseam.mbtiles"

    exec tl copy \
        -s pyramid \
        -b "$BBOX" \
        --min-zoom="$MIN_ZOOM" \
        --max-zoom="$MAX_ZOOM" \
        "tmsource://$PROJECT_DIR" "mbtiles://$EXPORT_DIR/$mbtiles_name"
}

export_local_mbtiles
