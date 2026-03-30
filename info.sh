#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$DIR/.env" ]; then
    echo "[error] .env not found. Run ./start.sh up first."
    exit 1
fi

source "$DIR/.env"

echo ""
echo "=== PostgreSQL ==="
echo "Host:     localhost"
echo "Port:     ${PG_PORT}"
echo "Database: ${PG_DB}"
echo "User:     ${PG_USER}"
echo "Pass:     ${PG_PASS}"
echo ""
echo "Connect:"
echo "  psql -h localhost -p ${PG_PORT} -U ${PG_USER} -d ${PG_DB}"
echo ""
