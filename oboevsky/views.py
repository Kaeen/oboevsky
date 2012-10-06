from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404

def home(request):
    import os
    server = os.environ.get('OBOEVSKY_SERVER', 'Var not set yet')
    return HttpResponse(server)