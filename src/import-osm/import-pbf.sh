#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly PG_CONNECT="postgis://$POSTGRES_ENV_POSTGRES_USER:$POSTGRES_ENV_POSTGRES_PASSWORD@$POSTGRES_PORT_5432_TCP_ADDR/$POSTGRES_ENV_POSTGRES_DB"
readonly DB_SCHEMA="public"

function import_pbf() {
    local pbf_file="$1"
    imposm3 import \
        -connection "$PG_CONNECT" \
        -mapping "$MAPPING_YAML" \
        -overwritecache \
        -cachedir "$IMPOSM_CACHE_DIR" \
        -read "$pbf_file" \
        -dbschema-import="${DB_SCHEMA}" \
        -write
}

function main() {
    local pbf_file
    for pbf_file in "$IMPORT_DATA_DIR"/*.pbf; do
        import_pbf "$pbf_file"
        break
    done
}

main
