"""Container environment; Compose injects configuration from .env."""
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
ENV_SOURCE = os.getenv('ENV_SOURCE', 'injected')

if ENV_SOURCE == 'secrets':
    for variable, filename in [('SECRET_KEY', 'secret_key'), ('POSTGRES_PASSWORD', 'db_password')]:
        os.environ[variable] = (Path('/run/secrets') / filename).read_text().strip()
elif ENV_SOURCE != 'injected':
    raise RuntimeError('ENV_SOURCE must be injected or secrets; local mode was removed')
