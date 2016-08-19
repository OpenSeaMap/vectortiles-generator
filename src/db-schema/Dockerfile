FROM mdillon/postgis:9.5
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
 && rm -rf /var/lib/apt/lists/*

ENV VT_UTIL_DIR=/opt/postgis-vt-util \
    VT_UTIL_URL="https://raw.githubusercontent.com/mapbox/postgis-vt-util/v1.0.0/postgis-vt-util.sql" \
    SQL_FUNCTIONS_FILE=/usr/src/app/functions.sql \
    SQL_VIEWS_FILE=/usr/src/app/views.sql

RUN mkdir -p /usr/src/app \
    mkdir -p "$VT_UTIL_DIR" \
 && wget -P "$VT_UTIL_DIR" --quiet "$VT_UTIL_URL"

WORKDIR /usr/src/app
COPY . /usr/src/app/

CMD ["./create-schema.sh"]
