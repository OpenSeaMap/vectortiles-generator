# Open Sea Map Vector Tiles

Infrastructure to generate vector tiles for [OpenSeaMap ](http://openseamap.org).

## Run Workflow

The entire project is structured in components using Docker containers
to work together. Ensure you meet the prerequisites.

Please note that after changing the configuration files you need to rebuild the
containers. See below for relevant configuration files.

Example: `docker-compose build import-osm`

### Setup

- Install [Docker](https://docs.docker.com/engine/installation/)
- Install [Docker Compose](https://docs.docker.com/compose/install/)

Start up the PostgreSQL database with the PostGIS extension.

```bash
docker-compose up -d postgres
```

Import the required database schema (views, prepared tables and helper functions).

```bash
docker-compose run db-schema
```

### OSM Import

Now download a OSM PBF extract and store it in the `./data` dir.
Import the OSM PBF.

```bash
docker-compose run import-osm
```

Note: The [mapping.yml](import-osm/mapping.yml) determines which tables will be
filled with which nodes and tags.

The mapping syntax is documented [here](https://imposm.org/docs/imposm3/latest/mapping.html).

### Setup export options

To visualize and work with the vector tiles you can spin up Mapbox Studio
in a Docker container and visit [localhost:3000](http://localhost:3000).

Then open the vector tile source with `Browse` and choose from `/projects/vector-datasource.tm2source`.

```bash
docker-compose up mapbox-studio
```

Edit the source settings by adding layers and using SQL queries to fetch data from
the tables created by the `OSM Import` step.

This will modify the [vector-datasource.tm2source](vector-datasource/vector-datasource.tm2source) file.

### Export the vector tiles

Export the vector tiles for the planet.

```bash
docker-compose run export-vectortiles
```

Note: The file [export-mbtiles.sh](export-vectortiles/export-mbtiles.sh) determines
the options for the export. Change the `bbox` according to your data.

### Serve the vector tiles

Use [klokantech/tileserver-gl](https://github.com/klokantech/tileserver-gl) to serve the tiles.

```bash
docker-compose up serve
```

Visit [localhost:8080](http://localhost:8080).

### Export the data as GeoJson

Exports the data as GeoJson

```bash
docker-compose run export-geojson
```

Note: The file [export-geojson.sh](export-geojson/export-geojson.sh) determines
the options for the export.

The data can be upload in [Mapbox Studio](https://www.mapbox.com/studio) to allow
creating of styles using their tools. See the [OSM2VectorTiles doc](http://osm2vectortiles.org/docs/create-map-with-mapbox-studio/)
for details.
