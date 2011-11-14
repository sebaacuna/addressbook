from django.conf.urls.defaults import *
from django.contrib import admin
import demo.api

handler500 = 'djangotoolbox.errorviews.server_error'

admin.autodiscover()

from django.contrib.staticfiles.urls import staticfiles_urlpatterns
urlpatterns = staticfiles_urlpatterns()

urlpatterns += patterns('',
    ('^_ah/warmup$', 'djangoappengine.views.warmup'),

	(r'^admin/', include(admin.site.urls)),
	
	(r'^api/', include('demo.api')),
	(r'^', include('demo.urls')),
	
	(r'^addressbook/', include('addressbook.urls')),

    #(r'^$', 'django.views.generic.simple.direct_to_template',
     #{'template': 'demo/main.html'}),

)