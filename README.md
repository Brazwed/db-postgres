# db-postgres

PostgreSQL 16 Docker container pre-configured.

## Option 1: Use with Database Toolkit (Recommended)

```bash
git clone --recurse-submodules https://github.com/Brazwed/Database.git
cd Database
sudo ./setup.sh install postgres
```

## Option 2: Standalone with Docker Compose

```bash
git clone https://github.com/Brazwed/db-postgres.git
cd db-postgres
cp .env.example .env
docker compose up -d
```

## Default Connection

```
Host:     localhost
Port:     5432
User:     postgres
Pass:     postgres_dev_2026
Database: devdb

psql -h localhost -p 5432 -U postgres -d devdb
```

## Configuration

Edit `.env`:

```env
PG_USER=postgres
PG_PASS=postgres_dev_2026
PG_DB=devdb
PG_PORT=5432
```

## Part of Database Toolkit

https://github.com/Brazwed/Database
