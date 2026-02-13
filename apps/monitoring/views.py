from django.http import JsonResponse
from .domain import get_system_health

def health(request):
    return JsonResponse(get_system_health())