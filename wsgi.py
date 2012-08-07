import os, sys
sys.path.append('/home/ubuntu/project')
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "project.settings")
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
