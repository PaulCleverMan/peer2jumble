import os
from pathlib import Path
from dotenv import load_dotenv

BASE_DIR = Path(__file__).resolve().parent.parent

DJANGO_ENV = os.getenv('DJANGO_ENV', 'dev').lower()
USE_DOCKER = os.getenv('USE_DOCKER', 'False').lower() == 'true'

def read_secret(file_name: str) -> str:
    path = f'/run/secrets/{file_name}'
    with open(path) as f:
        return f.read().strip()

if DJANGO_ENV == 'dev' and not USE_DOCKER:
    load_dotenv(BASE_DIR / '.env')

if DJANGO_ENV == 'prod' and USE_DOCKER:
    os.environ['SECRET_KEY'] = read_secret('secret_key')
    os.environ['POSTGRES_PASSWORD'] = read_secret('db_password')