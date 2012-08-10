from django.conf.urls import patterns, include, url

# Comment the next two lines to disable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'APPLICATION.views.home', name='home'),
    
    # Comment the admin/doc line below to disable admin documentation:
    url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Comment the next line to disable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
