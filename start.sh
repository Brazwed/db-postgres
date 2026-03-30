#!/usr/bin/env bash
set -euo pipefail

DB_NAME="PostgreSQL"
DIR="$(cd "$(dirname "$0")" && pwd)"
COMPOSE="docker compose -f $DIR/docker-compose.yml"
DATA_DIR="$DIR/data"

cd "$DIR"

load_env() {
    if [ ! -f .env ]; then
        cp .env.example .env
        echo "[init] .env created from .env.example"
    fi
    set -a
    source .env
    set +a
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
    load_env
    $COMPOSE up -d
    echo "[$DB_NAME] running on port $PG_PORT"
}

cmd_down() {
    load_env
    $COMPOSE down
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
    $COMPOSE exec postgres sh
}

cmd_psql() {
    load_env
    $COMPOSE exec postgres psql -U "$PG_USER" -d "$PG_DB"
}

cmd_clean() {
    echo "This will delete all $DB_NAME data in $DATA_DIR/"
    read -p "Are you sure? [y/N] " confirm
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        $COMPOSE down -v 2>/dev/null || true
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
