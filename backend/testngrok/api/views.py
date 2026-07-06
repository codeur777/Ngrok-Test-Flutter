from django.http import JsonResponse


def bonjour(request):
    return JsonResponse({
        "message": "Bonjour Solo : Solange Test avec ngrok Fonctionnelle "
    })
