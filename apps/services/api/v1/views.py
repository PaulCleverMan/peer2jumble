from django.http import JsonResponse
from apps.services.domain import stub

def stub_view(request):
    return JsonResponse(stub())
