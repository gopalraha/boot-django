import os, sys
sys.path.append('HOME/PROJECT')
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "PROJECT.settings")
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
