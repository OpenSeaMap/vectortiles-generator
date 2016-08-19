FROM golang:1.4

# Install imposm3
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libprotobuf-dev \
      libleveldb-dev \
      libgeos-dev \
      postgresql-client \
      wget \
      --no-install-recommends \
 && ln -s /usr/lib/libgeos_c.so /usr/lib/libgeos.so \
 && go get github.com/omniscale/imposm3 \
 && go install github.com/omniscale/imposm3 \
 && apt-get purge -y --auto-remove \
    g++ gcc libc6-dev make git \
 && rm -rf /var/lib/apt/lists/*

ENV IMPORT_DATA_DIR=/import \
    IMPOSM_CACHE_DIR=/cache \
    MAPPING_YAML=/usr/src/app/mapping.yml

WORKDIR /usr/src/app
COPY . /usr/src/app/

CMD ["./import-pbf.sh"]
