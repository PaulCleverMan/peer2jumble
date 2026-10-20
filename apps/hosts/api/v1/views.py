from django.http import JsonResponse
from apps.hosts.domain import stub

def stub_view(request):
    return JsonResponse(stub())
