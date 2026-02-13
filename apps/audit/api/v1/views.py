from django.http import JsonResponse
from apps.audit.domain import stub

def stub_view(request):
    return JsonResponse(stub())
