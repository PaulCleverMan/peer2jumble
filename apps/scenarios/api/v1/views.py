from django.http import JsonResponse
from apps.scenarios.domain import stub

def stub_view(request):
    return JsonResponse(stub())
