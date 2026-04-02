# db-postgres

PostgreSQL 16 Docker container pre-configured. Ready to use, zero conflicts.

## Quick Start

```bash
git clone https://github.com/Brazwed/db-postgres.git
cd db-postgres
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

Edit `.env` (created automatically from `.env.example`):

```env
PG_USER=postgres
PG_PASS=postgres_dev_2026
PG_DB=devdb
PG_PORT=5432
```

## Part of Database Toolkit

This repo can be used standalone or with other databases via [Database Toolkit](https://github.com/Brazwed/Database).
