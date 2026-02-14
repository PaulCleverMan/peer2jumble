# Peer2Jumble

Backend service based on Django with modular app architecture and API versioning.

## Architecture

- Django (modular apps)
- API versioning: /api/v1/<app>/
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
│ └── urls.py
├── manage.py
├── .env.example
├── docker-compose.yml (planned)
├── Dockerfile (planned)
```



## Environment

Copy example: 

``` cp .env.example .env ```

Adjust variables accordingly.

## API

Versioned API:

``` /api/v1/<app>/ ```

Monitoring shortcut:

```/monitoring/health/ ```


## Current Status

- Settings split (dev/prod)
- API routing implemented
- Monitoring stub implemented
- Git initialized
- Docker stack planned
