#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly EXPORT_DIR="/data/export"

function export_geojson() {
    local geojson_name="oseam.geojson"
    node index.js \
      --pg_user "$POSTGRES_ENV_POSTGRES_USER" \
      --pg_passwort "$POSTGRES_ENV_POSTGRES_PASSWORD" \
      --pg_host "$POSTGRES_PORT_5432_TCP_ADDR" \
      --pg_database "$POSTGRES_ENV_POSTGRES_DB" \
      --pg_table "public.osm_seamarks" \
      --outFile "$EXPORT_DIR/$geojson_name"

}

function main() {
  export_geojson
}

main
