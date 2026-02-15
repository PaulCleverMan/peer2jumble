# Peer2Jumble

Backend service based on Django with modular app architecture and API versioning.

## Requirements

- Python 3.13.x
- PostgreSQL 15+
- Docker 24+
- Docker Compose v2+

Tested with:

- Python 3.13.5
- PostgreSQL 17.8
- Docker 29.2.1
- Docker Compose 5.0.2

## Architecture

- Django (modular apps)
- API versioning: ```/api/v1/<app>/```
- Domain logic separated from API layer
- Monitoring endpoint
- Dev/Prod settings split
- Environment variables via .env

## Project Structure

```
peer2jumble/
├── apps/
│ ├── accounts/
│ ├── services/
│ ├── scenarios/
│ ├── simulations/
│ ├── incidents/
│ ├── metrics/
│ ├── monitoring/
│ ├── orchestration/
│ └── audit/
├── config/
│ ├── settings/
│ │ ├── base.py
│ │ ├── dev.py
│ │ └── prod.py
│ ├── env.py
│ ├── urls.py
│ ├── asgi.py
│ └── wsgi.py
├── manage.py
├── .env.example
├── docker-compose.yml (planned)
├── Dockerfile (planned)
```

## Local Development Setup

### Create virtual environment

```
python3.13 -m venv env
source env/bin/activate
pip install -r requirements.txt
```

### PostgreSQL setup

Open PostgreSQL shell: ```sudo -u postgres psql ```

```
CREATE USER peeruser WITH PASSWORD 'strong_password';
CREATE DATABASE peer2jumble OWNER peeruser;
ALTER ROLE peeruser SET client_encoding TO 'utf8';
ALTER ROLE peeruser SET default_transaction_isolation TO 'read committed';
ALTER ROLE peeruser SET timezone TO 'UTC';
\q
```

### Environment

Copy example:

```cp .env.example .env```

Adjust variables accordingly.

### Apply migrations and create superuser

```
python manage.py migrate
python manage.py createsuperuser
```

### Run server

```python manage.py runserver```

## API

Versioned API:

```/api/v1/<app>/```

Monitoring shortcut:

```/monitoring/health/ ```

## Current Status

- Settings split (dev/prod)
- API routing implemented
- Monitoring stub implemented
- Git initialized
- Docker stack planned

## Logging

- Dev: file-based logging (logs/)
- Docker/Prod: stdout (StreamHandler)


## Production (planned)

- Gunicorn
- Dockerized deployment
- PostgreSQL service container
