from .base import *

if DEBUG:
    import logging
    logging.getLogger(__name__).critical(
        'SECURITY WARNING: DEBUG=True in production configuration!'
    )
    raise RuntimeError("DEBUG cannot be True in production")

SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

SECURE_HSTS_SECONDS = 0 # After setting up, set 31536000
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True