import os
from pathlib import Path
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent

DJANGO_ENV = os.getenv('DJANGO_ENV', 'dev').lower()
ENV_SOURCE = os.getenv('ENV_SOURCE', 'local') # 'local' - load_dotenv | 'injected' - docker, ci, systemd | 'secrets' - docker secrets / vault

def read_secret(file_name: str) -> str:
    path = f'/run/secrets/{file_name}'
    with open(path) as f:
        return f.read().strip()

if ENV_SOURCE == 'local':
    load_dotenv(BASE_DIR / '.env.local')
elif ENV_SOURCE == 'secrets':
    os.environ['SECRET_KEY'] = read_secret('secret_key')
    os.environ['POSTGRES_PASSWORD'] = read_secret('db_password')