# -*- coding: utf-8 -*-

from django.conf.urls import patterns, include, url
from django.contrib import admin, flatpages
from oboevsky import settings
from oboevsky.views import *

admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'oboevsky.views.home'),
    url(r'^wallpaper/(?P<Url>[\w\d_-]+)/?$', 'oboevsky.views.wallpaper'),
    url(r'^producer/(?P<Url>[\w\d_-]+)/?$', 'oboevsky.views.producer'),
    url(r'^catalog/(?P<Url>[\w\d_-]+)/?$', 'oboevsky.views.category'),
    url(r'^country/(?P<Url>[\w\d_-]+)/?$', 'oboevsky.views.country'),
    url(r'^material/(?P<Id>[\d]+)/?$', 'oboevsky.views.material'),
    url(r'^countries/?$', 'oboevsky.views.countries'),
    url(r'^login/?$', 'oboevsky.views.login'),
    url(r'^logout/?$', 'oboevsky.views.logout'),
    url(r'^register/?$', 'oboevsky.views.register'),

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

    url(r'^(?P<url>.*)$', 'django.contrib.flatpages.views.flatpage'),
)