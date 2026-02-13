from django.http import JsonResponse
from .domain import stub

def stub_view(request):
    return JsonResponse(stub())