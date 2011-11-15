import descanso
from django.db.models import get_app, get_models

api = descanso.api()
for m in get_models(get_app("main")):
    api.register(m)

urlpatterns = api.urlpatterns()