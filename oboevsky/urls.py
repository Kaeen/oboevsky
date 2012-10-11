from django.conf.urls import patterns, include, url
from django.contrib import admin
from oboevsky import settings


admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'oboevsky.views.home'),
	url(r'^/wallpaper/(?P<Url>\w)$', 'oboevsky.views.wallpaper'),

    # Examples:
    # url(r'^$', 'oboevsky.views.home', name='home'),
    # url(r'^oboevsky/', include('oboevsky.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),

    url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
        'document_root': settings.STATIC_ROOT,
    }),
    url(r'^(?P<path>.*\.(txt|html))$', 'django.views.static.serve', {
        'document_root': settings.STATIC_ROOT,
    }),
    url(r'^media/(?P<path>.*)$', 'django.views.static.serve', {
        'document_root': settings.MEDIA_ROOT,
    }),
)