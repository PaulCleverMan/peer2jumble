from django.http import JsonResponse
from apps.simulations.domain import stub

def stub_view(request):
    return JsonResponse(stub())
