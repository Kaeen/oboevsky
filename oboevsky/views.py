from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404

def common_context_proc(Request):
    # Building menus:
    menu_categories = Category.objects.all()
    menu_countries = Country.objects.all()
    menu_materials = Material.objects.all()
    menu_producers = Producer.objects.all()

    return {
        'menu_categories': menu_categories,
        'menu_countries': menu_countries,
        'menu_materials': menu_materials,
        'menu_producers': menu_producers
    }

def home(Request):
    return render_to_response('public/index.tpl', {}, RequestContext(Request, processors=[common_context_proc,]))
