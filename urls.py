from django.conf.urls.defaults import *
from django.contrib import admin
from django.views.generic.simple import direct_to_template

handler500 = 'djangotoolbox.errorviews.server_error'

admin.autodiscover()

from django.contrib.staticfiles.urls import staticfiles_urlpatterns
urlpatterns = staticfiles_urlpatterns()

urlpatterns += patterns('',
    ('^_ah/warmup$', 'djangoappengine.views.warmup'),
	(r'^admin/', include(admin.site.urls)),
	
	(r'^api/', include('addressbook.api')),
	( r'^restbrowse', direct_to_template, {'template': 'browse.html'} ),
	url(r'^upload/$', "addressbook.views.upload", name="upload"),
	( r'^$', direct_to_template, {'template': 'addressbook.html'} ),
)