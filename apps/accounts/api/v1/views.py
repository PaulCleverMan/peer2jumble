from django.http import JsonResponse
from apps.accounts.domain import stub

def stub_view(request):
    return JsonResponse(stub())
