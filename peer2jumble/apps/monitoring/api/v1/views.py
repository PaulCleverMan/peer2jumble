from django.http import JsonResponse
from apps.monitoring.domain import get_system_health

def health(request):
    return JsonResponse(get_system_health())