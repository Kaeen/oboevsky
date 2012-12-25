# -*- coding: utf-8 -*-

from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404
from django.contrib.flatpages.models import *

####################################
#       Common functionality       # 
####################################

def build_items_var(items_list, vars, group_criteria_func=lambda x: x.get_first_category(), start_page=0, step=15):
    # Checking for by_attribute
    groups = dict()
    for item in items_list:
        if group_criteria_func(item) in groups:
            groups[group_criteria_func(item)].append(item)
        else:
            groups[group_criteria_func(item)] = [item,]

    if len(groups.keys()) == 1:
        vars['items_display_mode'] = 'plain'

        if step and start_page:
            vars['items'] = items_list[start_page::step]
        else:
            vars['items'] = items_list

        vars['start_page'] = start_page
        vars['items_number'] = len(items_list)
        vars['step'] = step
    else:
        wallpapers = []
        for x in groups:
            wallpapers.append( (x.title, x.get_absolute_url(), groups[x]) )

        vars['items_display_mode'] = 'grouped'
        vars['items'] = wallpapers

    return vars

def common_context_proc(Request=None):
    # Building menus:
    menu_categories = Category.objects.filter(visible=True)
    menu_countries = Country.objects.filter(visible=True)
    menu_materials = Material.objects.filter(visible=True)
    menu_producers = Producer.objects.filter(visible=True)
    flatpages = FlatPage.objects.all()
    user = Request.user
    cart_items = [] #TODO
    cart_items_total = 0 #TODO

    return {
        'menu_categories': menu_categories,
        'menu_countries': menu_countries,
        'menu_materials': menu_materials,
        'menu_producers': menu_producers,
        'flatpages': flatpages,
        'user': user,
        'cart_items': cart_items,
        'cart_items_total': cart_items_total,
    }


####################################
#              Views               # 
####################################

def home(Request):
    vars = {
        'top_sells_items': Wallpaper.objects.filter(top_sells=True, visible=True),
        'new_items': Wallpaper.objects.filter(new=True, visible=True),
    }

    return render_to_response('public/index.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def wallpaper(Request, Url):
    item = get_object_or_404(Wallpaper, url=Url, visible=True)

    vars = {
        'item': item
    }

    return render_to_response('public/item.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def country(Request, Url):
    country = get_object_or_404(Country, url=Url, visible=True)

    vars = {
        'country': country,
        'producers': Producer.objects.all().filter(country=country, visible=True),
    }

    wallpapers = Wallpaper.objects.filter(producer__country=country, visible=True)
    build_items_var(wallpapers, vars, lambda x: x.get_first_category()) #start_page, step...)

    return render_to_response('public/country.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def producer(Request, Url):
    producer = get_object_or_404(Producer, url=Url, visible=True)

    vars = {
        'producer': producer,
    }

    wallpapers = Wallpaper.objects.filter(producer=producer, visible=True)
    build_items_var(wallpapers, vars, lambda x: x.get_first_category()) #start_page, step...)

    return render_to_response('public/producer.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def category(Request, Url):
    category = get_object_or_404(Category, url=Url, visible=True)

    vars = {
        'category': category,
    }

    wallpapers = category.wallpapers.all().filter( visible=True)
    build_items_var(wallpapers, vars, lambda x: x.producer) #start_page, step...)

    return render_to_response('public/category.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def material(Request, Id):
    material = get_object_or_404(Material, id=Id, visible=True)

    vars = {
        'material': material,
    }

    wallpapers = material.wallpapers.all().filter( visible=True)
    build_items_var(wallpapers, vars, lambda x: x.get_first_category()) #start_page, step...)

    return render_to_response('public/material.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def countries(Request):
    countries = Country.objects.filter( visible=True )
    vars = {
        'countries': countries,
    }
    return render_to_response('public/countries.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

#################################
#     Всякая аутентификация     #
#################################

def login(Request):
    from django.contrib.auth.models import User
    from django.contrib.auth import authenticate, login
    vars = {}

    if Request.GET.get('do', None):
        username = Request.POST['username']
        password = Request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                login(Request, user)
                #TODO: Redirect to a success page.
                return home(Request)
            else:
                # Return a 'disabled account' error message
                raise Exception, u"Учётная запись заблокирована администратором"
        else:
            # Return an 'invalid login' error message.
            #raise Exception, u"Неверные логин/пароль"
            vars = {
                'message': u'Неверные логин/пароль',
            }
        
    return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def register(Request):
    from django.contrib.auth.models import User
    # TODO
    vars = {}
    return render_to_response('public/register.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def logout(Request):
    from django.contrib.auth import logout
    logout(Request)
    #TODO: Redirect to a success page.
    return home(Request)

def account(Request):
    return home(Request)