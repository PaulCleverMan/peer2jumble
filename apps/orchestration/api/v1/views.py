from django.http import JsonResponse
from apps.orchestration.domain import stub

def stub_view(request):
    return JsonResponse(stub())
