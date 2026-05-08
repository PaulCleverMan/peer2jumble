import os
import logging
from config.env import BASE_DIR

SECRET_KEY = os.getenv('SECRET_KEY', 'unsafe-secret')

DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'

LOG_TARGET = os.getenv('LOG_TARGET', 'file') # console - output console | file - output in file

LOG_DIR = BASE_DIR / 'logs'

def get_list_env(name):
    return [x.strip() for x in os.getenv(name, '').split(',') if x.strip()]

ALLOWED_HOSTS = get_list_env('ALLOWED_HOSTS')

DJANGO_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]

THIRD_PARTY_APPS = [
    'rest_framework',
    'django_filters',
]

LOCAL_APPS = [
    'apps.accounts',
    'apps.services',
    'apps.scenarios',
    'apps.simulations',
    'apps.incidents',
    'apps.metrics',
    'apps.monitoring',
    'apps.orchestration',
    'apps.audit',
]

INSTALLED_APPS = DJANGO_APPS + THIRD_PARTY_APPS + LOCAL_APPS

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DB', 'peer2jumble'),
        'USER': os.getenv('POSTGRES_USER', 'peeruser'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD'),
        'HOST': os.getenv('POSTGRES_HOST', 'localhost'),
        'PORT': os.getenv('POSTGRES_PORT', '5432'),
    }
}

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

LANGUAGE_CODE = 'ru'

TIME_ZONE = 'Europe/Samara'

USE_I18N = True

USE_TZ = True

STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

REDIS_HOST = os.getenv("REDIS_HOST", "localhost")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")

REDIS_URL = f"redis://{REDIS_HOST}:{REDIS_PORT}/0"

RABBITMQ_HOST = os.getenv("RABBITMQ_HOST", "localhost")
RABBITMQ_PORT = os.getenv("RABBITMQ_PORT", "5672")
RABBITMQ_USER = os.getenv("RABBITMQ_USER", "guest")
RABBITMQ_PASSWORD = os.getenv("RABBITMQ_PASSWORD", "guest")

CELERY_BROKER_URL = (
    f"amqp://{RABBITMQ_USER}:{RABBITMQ_PASSWORD}"
    f"@{RABBITMQ_HOST}:{RABBITMQ_PORT}//"
)
CELERY_RESULT_BACKEND = REDIS_URL

CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TASK_SERIALIZER = "json"
CELERY_RESULT_SERIALIZER = "json"
CELERY_TIMEZONE = "UTC"

CELERY_TASK_ALWAYS_EAGER = False
CELERY_TASK_EAGER_PROPAGATES = True # if CELERY_TASK_ALWAYS_EAGER=True
CELERY_TASK_TRACK_STARTED = True
CELERY_TASK_SEND_SENT_EVENT = True
CELERY_WORKER_SEND_TASK_EVENTS = True
CELERY_WORKER_PREFETCH_MULTIPLIER = 1

LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
MAX_MB = int(os.getenv('MAX_MB', 5))*1024*1024
BACKUP_COUNT = os.getenv('BACKUP_COUNT', 3)

if LOG_TARGET == 'console':
    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'formatters': {
            'verbose': {
                'format': (
                    'TYPE: {levelname}, '
                    'LOCALIZATION: {module}, '
                    'PROCESS: {processName}, '
                    'THREAD: {threadName}\n'
                    'MESSAGE: {message}\n'
                    '{asctime}\n'
                ),
                'datefmt': 'DATE: %d/%m/%Y TIME: %I:%M:%S %p',
                'style': '{',
            },
        },
        'handlers': {
            'console': {
                'class': 'logging.StreamHandler',
                'formatter': 'verbose',
            },
        },
        'root': {
            'handlers': ['console'],
            'level': LOG_LEVEL,
        },
    }
elif LOG_TARGET == 'file':
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    LOGGING = {
        'version': 1,
        'disable_existing_loggers': False,
        'formatters': {
            'verbose': {
                'format': (
                    'TYPE: {levelname}, '
                    'LOCALIZATION: {module}, '
                    'PROCESS: {processName}, '
                    'THREAD: {threadName}\n'
                    'MESSAGE: {message}\n'
                    '{asctime}\n'
                ),
                'datefmt': 'DATE: %d/%m/%Y TIME: %I:%M:%S %p',
                'style': '{',
            },
        },
        'handlers': {
            'file': {
                'level': LOG_LEVEL,
                'class': 'logging.handlers.RotatingFileHandler',
                'formatter': 'verbose',
                'filename': str(LOG_DIR / 'peer2jumble.log'),
                'maxBytes': MAX_MB,
                'backupCount': BACKUP_COUNT,
                'encoding': 'utf-8',
                'mode': 'a',
            },
        },
        'root': {
            'handlers': ['file'],
            'level': LOG_LEVEL,
        },
    }