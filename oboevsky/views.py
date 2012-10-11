from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404

def common_context_proc(Request):
    # Building menus:
    menu_categories = Category.objects.filter(visible=True)
    menu_countries = Country.objects.filter(visible=True)
    menu_materials = Material.objects.filter(visible=True)
    menu_producers = Producer.objects.filter(visible=True)

    return {
        'menu_categories': menu_categories,
        'menu_countries': menu_countries,
        'menu_materials': menu_materials,
        'menu_producers': menu_producers
    }

def home(Request):
    vars = {
        'top_sells_items': Wallpaper.objects.filter(top_sells=True),
        'new_items': Wallpaper.objects.filter(new=True),
    }

    return render_to_response('public/index.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def wallpaper(Request, Url):
    item = get_object_or_404(Wallpaper, url=Url, visible=True)

    vars = {
        'item': item
    }

    return render_to_response('public/item.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))