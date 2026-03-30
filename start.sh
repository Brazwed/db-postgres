#!/usr/bin/env bash
set -euo pipefail

DB_NAME="PostgreSQL"
DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE="docker compose -f $DIR/docker-compose.yml"
DATA_DIR="$DIR/data"

cd "$DIR"

check_docker() {
    if ! command -v docker &>/dev/null; then
        echo "[error] Docker not found. Install it first."
        exit 1
    fi
    if ! docker info &>/dev/null; then
        echo "[error] Docker daemon not running. Start it first."
        exit 1
    fi
}

load_env() {
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "[init] .env created from .env.example"
    fi
    set -a
    source .env
    set +a
}

wait_healthy() {
    local container=$($COMPOSE ps -q postgres 2>/dev/null)
    [ -z "$container" ] && return 1

    echo -n "Waiting for $DB_NAME to be ready"
    local retries=30
    while [ $retries -gt 0 ]; do
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "starting")
        if [ "$health" = "healthy" ]; then
            echo " ready!"
            return 0
        fi
        echo -n "."
        sleep 1
        retries=$((retries - 1))
    done
    echo " timeout!"
    return 1
}

usage() {
    echo "Usage: $0 {up|down|restart|logs|status|shell|psql|clean}"
    echo ""
    echo "  up        Start $DB_NAME container"
    echo "  down      Stop $DB_NAME container"
    echo "  restart   Restart $DB_NAME container"
    echo "  logs      Follow $DB_NAME logs"
    echo "  status    Show container status"
    echo "  shell     Open shell in container"
    echo "  psql      Open psql shell"
    echo "  clean     Stop and remove data (DATA LOSS)"
}

cmd_up() {
    check_docker
    load_env
    $COMPOSE up -d
    if wait_healthy; then
        echo "[$DB_NAME] running on port $PG_PORT"
    else
        echo "[warn] $DB_NAME started but healthcheck didn't pass. Check: $COMPOSE logs"
    fi
}

cmd_down() {
    check_docker
    load_env
    $COMPOSE down --timeout 10
    echo "[$DB_NAME] stopped"
}

cmd_restart() {
    cmd_down
    cmd_up
}

cmd_logs() {
    $COMPOSE logs -f
}

cmd_status() {
    $COMPOSE ps
}

cmd_shell() {
    $COMPOSE exec -it postgres sh
}

cmd_psql() {
    load_env
    $COMPOSE exec -it postgres psql -U "$PG_USER" -d "$PG_DB"
}

cmd_clean() {
    echo "This will delete all $DB_NAME data in $DATA_DIR/"
    read -p "Are you sure? [y/N] " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        $COMPOSE down -v --timeout 10 2>/dev/null || true
        rm -rf "$DATA_DIR"
        echo "[$DB_NAME] cleaned"
    else
        echo "Cancelled"
    fi
}

case "${1:-}" in
    up)       cmd_up ;;
    down)     cmd_down ;;
    restart)  cmd_restart ;;
    logs)     cmd_logs ;;
    status)   cmd_status ;;
    shell)    cmd_shell ;;
    psql)     cmd_psql ;;
    clean)    cmd_clean ;;
    *)        usage ;;
esac
