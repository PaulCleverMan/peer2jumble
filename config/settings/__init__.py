import os

env = os.getenv('DJANGO_ENV', 'dev').lower()

if env not in ('dev', 'prod'):
    raise RuntimeError('Invalid DJANGO_ENV value')

if env == 'prod':
    from .prod import *
else:
    from .dev import *