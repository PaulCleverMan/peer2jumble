# Peer2Jumble

Backend for managing host load experiments. Application endpoints are currently
stubs; the host agent is planned as a separate Go service managed by systemd.

## Requirements

Docker Engine with Docker Compose v2 or newer. Python, PostgreSQL, Redis,
RabbitMQ and uv do not need to be installed on the host.

## Development

```sh
cp .env.example .env
# Edit .env before starting; do not commit secrets.
./peer2jumble.sh setup
./peer2jumble.sh build
./peer2jumble.sh up
./peer2jumble.sh migrate
./peer2jumble.sh check
./peer2jumble.sh test
```

Django is available at http://localhost:8000. Source code is bind-mounted for
Django autoreload. Restart the Celery worker after changing task code:

```sh
./peer2jumble.sh restart celery
```

The stack contains Django, PostgreSQL, RabbitMQ, Redis, a Celery worker and Flower.
RabbitMQ carries tasks; Redis stores task results. Docker service names are
configured centrally in Compose. `.env.local` and host service management are
no longer supported. Compose injects `.env`; Django does not load dotenv files.

## Commands

```sh
./peer2jumble.sh status
./peer2jumble.sh urls
./peer2jumble.sh logs web
./peer2jumble.sh down
# Create an administrator:
./peer2jumble.sh createsuperuser
```

`up` prints links to the web base URL, Django admin, health endpoint, Flower
(Celery monitoring) and RabbitMQ UI. Use `urls` to display them again. Links use
the currently published Docker ports; stopped services are marked as not running.
These addresses are for a browser on the Docker host. For a remote host, use its
reachable address or an SSH tunnel. The web root has no application page yet;
use `/admin/` to access Django admin.

Run `createsuperuser` after `up` and `migrate` in an interactive terminal. Django
will prompt for the username, email and password. Additional options are forwarded,
for example `./peer2jumble.sh createsuperuser --username admin`. Migrations do not
prompt to create users, so they remain suitable for CI.

`down` preserves named data volumes. `down --volumes` deletes their data and is
intended only for disposable environments. CI uses this option after checking
an isolated stack. The current test suite contains no application tests yet.

Commands accept an optional environment after the command (`up dev`). Production
settings remain in `config/settings/prod.py`, but production deployment is not
implemented; `prod` commands fail explicitly. The development stack must not be
used as a production deployment.

Logs are written to container stdout/stderr with Docker log rotation. The
`/monitoring/health/` endpoint is currently a stub, not a dependency readiness check.

## Layout

- `apps/`: versioned API and domain modules
- `config/`: Django and Celery configuration
- `scripts/docker/`: Docker lifecycle and check commands
- `scripts/common/compose.sh`: shared Compose configuration
- `docker-compose.dev.yaml`: development stack

The server is supported only in containers. The future host agent will run under
systemd independently of the server deployment.
