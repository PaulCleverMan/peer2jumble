

def get_system_health():
    return {
        'status': 'ok',
        'db': True,
        'redis': True,
        'rabbitmq': True,
    }

