#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset


function exec_sql_file() {
    local file_name="$1"
    PGPASSWORD=$POSTGRES_ENV_POSTGRES_PASSWORD psql \
        -v ON_ERROR_STOP=1 \
        --host="$POSTGRES_PORT_5432_TCP_ADDR" \
        --port="5432" \
        --dbname="$POSTGRES_ENV_POSTGRES_DB" \
        --username="$POSTGRES_ENV_POSTGRES_USER" \
        -f "$file_name"
}

function main() {
    echo "Create VT-UTIL functions"
    exec_sql_file "$VT_UTIL_DIR/postgis-vt-util.sql"
    echo "Creating functions"
    exec_sql_file "$SQL_FUNCTIONS_FILE"
    echo "Creating generated functions"
    exec_sql_file "$SQL_VIEWS_FILE"
}

main
