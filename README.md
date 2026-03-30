# db-postgres

PostgreSQL 16 Docker container pré-configurado. Pronto pra usar, sem conflitos.

## Uso rápido

```bash
git clone https://github.com/seu-user/db-postgres.git
cd db-postgres
./start.sh up
./info.sh
```

## Comandos

| Comando | Descrição |
|---------|-----------|
| `./start.sh up` | Iniciar (cria .env automaticamente) |
| `./start.sh down` | Parar |
| `./start.sh restart` | Reiniciar |
| `./start.sh logs` | Acompanhar logs |
| `./start.sh status` | Status do container |
| `./start.sh shell` | Shell no container |
| `./start.sh psql` | Abrir psql |
| `./start.sh clean` | Remover dados (com confirmação) |
| `./info.sh` | Dados de conexão |

## Conexão padrão

```
Host:     localhost
Porta:    5432
Usuário:  postgres
Senha:    postgres_dev_2026
Banco:    devdb

psql -h localhost -p 5432 -U postgres -d devdb
```

## Configuração

Edite `.env` (criado automaticamente de `.env.example`):

```env
PG_USER=postgres
PG_PASS=postgres_dev_2026
PG_DB=devdb
PG_PORT=5432
```

## Parte do Database Toolkit

Este repositório pode ser usado standalone ou junto com outros bancos via [Database](https://github.com/seu-user/Database).
