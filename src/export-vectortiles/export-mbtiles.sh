#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly PROJECT_DIR="/tm2source"
readonly EXPORT_DIR="/export"
readonly RENDER_SCHEME=${RENDER_SCHEME:-pyramid}
readonly MIN_ZOOM=${MIN_ZOOM:-7}
readonly MAX_ZOOM=${MAX_ZOOM:-14}
readonly BBOX=${BBOX:-"5.8559113 45.717995 10.5922941 47.9084648"}

function export_local_mbtiles() {
    local mbtiles_name="natural_earth.mbtiles"

    exec tl copy \
        -s pyramid \
        -b "$BBOX" \
        --min-zoom="$MIN_ZOOM" \
        --max-zoom="$MAX_ZOOM" \
        "tmsource://$PROJECT_DIR" "mbtiles://$EXPORT_DIR/$mbtiles_name"
}

export_local_mbtiles
