from django.http import JsonResponse
from apps.incidents.domain import stub

def stub_view(request):
    return JsonResponse(stub())
