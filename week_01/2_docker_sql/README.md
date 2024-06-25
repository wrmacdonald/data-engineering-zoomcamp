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


