from django.http import JsonResponse
from apps.metrics.domain import stub

def stub_view(request):
    return JsonResponse(stub())
