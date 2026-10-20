from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

import logging
from django.conf import settings

logger = logging.getLogger(__name__)

API_VERSIONS = ['v1']
APPS = [
    'accounts',
    'hosts',
    'services',
    'scenarios',
    'simulations',
    'incidents',
    'metrics',
    'monitoring',
    'orchestration',
    'audit',
]

urlpatterns = [path('admin/', admin.site.urls)]

# api/v1/app_name/
for version in API_VERSIONS:
    for app in APPS:
        urlpatterns.append(
            path(f'api/{version}/{app}/', include(f'apps.{app}.api.{version}.urls'))
        )

# app_name/
for app in APPS:
    urlpatterns.append(
        path(f'{app}/', include(f'apps.{app}.urls'))
    )

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    try:
        import debug_toolbar

        urlpatterns = [
            path("__debug__/", include(debug_toolbar.urls)),
        ] + urlpatterns

        logger.info("debug_toolbar enabled")

    except ImportError:
        logger.warning(
            "DEBUG=True but django-debug-toolbar is not installed. Toolbar disabled."
        )
