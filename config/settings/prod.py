from .base import *

DEBUG = False

if DEBUG:
    import logging
    logging.getLogger(__name__).critical(
        "SECURITY WARNING: DEBUG=True in production configuration!"
    )

SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

SECURE_HSTS_SECONDS = 0
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

LOG_LEVEL='INFO'