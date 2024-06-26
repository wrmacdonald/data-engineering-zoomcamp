# Notes


## Intro to Docker

Build the docker file:

```bash
docker build -t test:pandas .
```

Run the docker image with an argument:

```bash
docker run -it test:pandas 2024-06-24
```


## Ingesting NY Taxi Data to Postgres

Run postgres in docker:

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13
```

Install pgcli: 

```bash
pip install pgcli

pip install --upgrade pip           # to upgrade pip

pip install "psycopg[binary,pool]"  # to install package and dependencies
```

Connect using pgcli:

```bash
pgcli -h localhost -p 5432 -u root -d ny_taxi
```


## Connecting pgAdmin and Postgres

Install pgAdmin in Docker:

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  dpage/pgadmin4
```

Create Docker Network so pgAdmin & Postgres can communicate:

```bash
docker network create pg-network
```

Update running postgres in Docker, to use network:

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
```

Update running pgAdmin in Docker, to use network:

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```


## Dockerizing the Ingestion Script

Run python ingestion script

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

python ingest_data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --url=${URL} \
    --table_name=yellow_taxi_trips
```

Build python ingestion script container: taxi_ingest

```bash
docker build -t taxi_ingest:v001 .
```

Run taxi_ingest container:

```bash
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

## Running Postgres and pgAdmin with Docker-Compose

```bash
docker compose up
```

```bash
docker compose down
```
