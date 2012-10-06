from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404

def common_context_proc(Request):
    #TODO: common context
    return {}

def home(request):
    return render_to_response('public/index.tpl', {}, RequestContext(Request, processors=[common_context_proc,]))
