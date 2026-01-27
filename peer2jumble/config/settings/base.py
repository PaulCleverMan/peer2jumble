import os
import logging
from config.env import BASE_DIR

SECRET_KEY = os.getenv('SECRET_KEY', 'unsafe-secret')

DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'

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
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
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


LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
MAX_MB = int(os.getenv('MAX_MB', 5))*1024*1024
BACKUP_COUNT = os.getenv('BACKUP_COUNT', 3)

LOGGING = {
    'version': 1,
    'disable_existing_loggers' : False,
    'formatters': {
        'verbose': {
            'format' : 'TYPE: {levelname}, LOCALIZATION: {module},PROCESS: {processName}, THREAD: {threadName}\nMESSAGE: {message}\n{asctime}\n',
            'datefmt': 'DATE: %d/%m/%Y TIME: %I:%M:%S %p',
            'style' : '{',
        },
    },
    'handlers' : {
        'file' : {
            'level' : LOG_LEVEL,
            'class' : 'logging.handlers.RotatingFileHandler',
            'formatter' : 'verbose',
            'filename' : os.path.join(BASE_DIR.parent, 'logs/peer2jumble.log'),
            'maxBytes': MAX_MB,
            'backupCount': BACKUP_COUNT,
            'encoding' : 'utf-8',
            'mode' : 'a',
        },
    },
    'loggers' : {
        '' : {
            'handlers' : ['file'],
            'level' : LOG_LEVEL,
            'propagate' : True,
        }
    },
}