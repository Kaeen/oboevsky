# -*- coding: utf-8 -*-

from django.http import HttpResponse, HttpRequest, Http404
from models import *
from django.template import RequestContext
from django.shortcuts import render_to_response, get_list_or_404, get_object_or_404
from django.contrib.flatpages.models import *
from django.contrib.auth.models import User
from django.core.exceptions import ObjectDoesNotExist

####################################
#       Common functionality       # 
####################################

def send_mail(rcv, subject, text):
    from smtplib import SMTP
    from email.mime.text import MIMEText
    text = MIMEText(text.encode('CP1251'))
    text['Subject'] = subject
    text['From'] = 'oboevsky@oboevsky.ru'
    text['To'] = rcv
    text.set_charset('cp1251')

    s = SMTP()
    s.connect('smtp.webfaction.com')
    s.login('oboevsky','qwerty321')
    s.sendmail('oboevsky@oboevsky.ru', [rcv,], text.as_string())


def generate_hash():
    from hashlib import md5
    from random import random
    return md5(str(random())).hexdigest()

def build_items_var(items_list, vars, group_criteria_func=lambda x: x.get_first_category()):
    # Checking for by_attribute
    groups = dict()
    for item in items_list:
        if group_criteria_func(item) in groups:
            groups[group_criteria_func(item)].append(item)
        else:
            groups[group_criteria_func(item)] = [item,]

    if len(groups.keys()) == 1:
        vars['items_display_mode'] = 'plain'
        vars['items'] = items_list
        vars['items_number'] = len(items_list)
    else:
        wallpapers = []
        for x in groups:
            try: 
                wallpapers.append( (x.title, x.get_absolute_url(), groups[x]) )
            except Exception, e:
                pass

        vars['items_number'] = len(items_list)
        vars['items_display_mode'] = 'grouped'
        vars['items'] = wallpapers

    return vars

def build_items_var_m(items_list, vars, group_criteria_func=lambda x: x.categories.all(), include_groups=[]):
    # То же самое, что и build_items_var, но для мультигрупп
    groups = dict()
    for item in items_list:
        for c in group_criteria_func(item):
            if include_groups and c.pk not in include_groups or not c.visible: continue
            if c in groups:
                groups[c].append(item)
            else:
                groups[c] = [item,]

    if len(groups.keys()) == 1:
        vars['items_display_mode'] = 'plain'
        vars['items'] = items_list
        vars['items_number'] = len(items_list)
    else:
        wallpapers = []
        for x in groups:
            try: 
                wallpapers.append( (x.title, x.get_absolute_url(), groups[x]) )
            except Exception, e:
                pass

        vars['items_number'] = len(items_list)
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
    cart_items = Request.session.get('cart', {}).values()
    cart_items_total = Request.session.get('cart_total', 0)

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
#               Ajax               #
####################################

def get_items_collection(Request, query):

    from django.core.serializers.json import DjangoJSONEncoder

    query = query.split(',')
    db = Wallpaper.objects.filter(pk__in=query, visible=True)
    objects = []
    for t in db:
        objects.append({
                'image': t.get_first_image().image.url_170x111,
                'url': t.get_absolute_url(),
                'shortdesc': t.short_desc,
                'title': t.title,
                'price': t.price,
                'pk': t.pk
            })
    import json
    json = json.dumps(objects, cls=DjangoJSONEncoder)

    return HttpResponse(json, mimetype="application/javascript")



####################################
#              Views               # 
####################################



def error(Request):
    vars = {}
    return render_to_response('public/error.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def home(Request):
    top_sells = Wallpaper.objects.filter(top_sells=True, visible=True)
    new_items = Wallpaper.objects.filter(new=True, visible=True)
    top_sells_q = new_items_q = ''
    for t in top_sells: top_sells_q += str(t.id) if top_sells_q == '' else ','+str(t.id)
    for t in new_items: new_items_q += str(t.id) if new_items_q == '' else ','+str(t.id)

    vars = {
        'top_sells_items': top_sells,
        'top_sells_q': top_sells_q,
        'new_items': new_items,
        'new_items_q': new_items_q,
        'no_homepage_link': True,
    }

    return render_to_response('public/index.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def wallpaper(Request, Url):
    item = get_object_or_404(Wallpaper, url=Url, visible=True)

    q = Request.GET.get('q', str(item.id))
    collection = q.split(',')

    i = 0
    p = n = None
    for t in collection:
        if unicode(item.id) == t:
            p = get_object_or_404(Wallpaper, pk=collection[i-1]) if i>0 else None
            n = get_object_or_404(Wallpaper, pk=collection[i+1]) if i<len(collection)-1 else None
            break
        i += 1

    no_breadcrumps = True if p or n else False

    vars = {
        'item': item,
        'collection': collection,
        'q': q,
        'previous': p,
        'next': n,
        'no_breadcrumps': no_breadcrumps,
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

def search(Request):
    if Request.GET.get('do', None) is not None:

        selected_producers = map(lambda x: int(x), Request.POST.getlist('producers', None))
        selected_categories = map(lambda x: int(x), Request.POST.getlist('categories', None))
        selected_materials = map(lambda x: int(x), Request.POST.getlist('materials', None))
        min_price = int(Request.POST.get('min_price', 0)) if Request.POST.get('min_price') or None
        max_price = int(Request.POST.get('max_price', 0)) if Request.POST.get('max_price') or None
        POST = Request.POST.items()

        if selected_producers or selected_categories or selected_materials:
            conditions = dict(visible=True)
            if selected_producers: conditions['producer__in'] = selected_producers
            if selected_categories: conditions['categories__in'] = selected_categories
            if selected_materials: conditions['materials__in'] = selected_materials
            if min_price: conditions['price__gte'] = min_price
            if max_price: conditions['price_lte'] = max_price
            items = Wallpaper.objects.filter(**conditions)
            no_criteria = False

        else:
            items = []
            no_criteria = True

        vars = {
            'items': items,
            'items_found': len(items),
            'selected_producers': selected_producers,
            'selected_materials': selected_materials,
            'selected_categories': selected_categories,
            'POST': POST,
            'no_criteria': no_criteria,
        }

        # ГРУППИРОВКА
        if selected_categories and len(selected_categories) > 1:
            build_items_var_m(items, vars, lambda x: x.categories.all(), selected_categories)
        elif selected_producers and len(selected_producers) > 1:
            build_items_var(items, vars, lambda x: x.producer)
        elif selected_materials and len(selected_materials) > 1:
            build_items_var_m(items, vars, lambda x: x.materials.all(), selected_materials)
        else: 
            build_items_var_m(items, vars, lambda x: x.categories.all(), selected_categories)

        if vars['items_display_mode'] != 'grouped' and items:
            q = ''
            for t in items: 
                if q != '': q+= ','
                q+= str(t.pk)
            vars['q'] = q

    else:

        POST = Request.POST.items()
        vars = {
            'items': [],
            'no_criteria': True,
            'POST': POST,
        }


    return render_to_response('public/search.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

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

    if Request.GET.get('do', None) is not None:
        email = Request.POST['email']
        password = Request.POST['pass']
        vars['registered'] = True if Request.GET.get('registered', None) is not None else False
        vars['email'] = email
        try:
            user = User.objects.get(email=email)
        except Exception, e:
            # TODO: remove after debug is finished!
            vars['error'] = u'Ошибка' + unicode(e)
            return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))
        if not user or not user.check_password(password):
            # Return an 'invalid login' error message.
            #raise Exception, u"Неверные логин/пароль"
            vars['error'] = u'Неверные логин/пароль'
            return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

        if not Customer.objects.get(user=user, email_confirmation_hash=None):
            vars['error'] = u'Пожалуйста, подтвердите адрес электронной почты'
            return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

        user.backend = 'django.contrib.auth.backends.ModelBackend'
        login(Request, user)

        from django.shortcuts import redirect
        return redirect('/')
                
    return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def confirm_email(Request, hash):
    vars = {}

    customer = get_object_or_404(Customer, email_confirmation_hash=hash)
    customer.email_confirmation_hash = None
    customer.save()

    return render_to_response('public/authorize.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def register(Request):
    from django.contrib.auth.models import User
    vars = {}

    if Request.GET.get('do', None) is not None:
        # Registration attempt
        try:
            fields = (
                ('first_name', u'Имя'),
                ('second_name', u'Отчество'),
                ('surname', u'Фамилия'),
                ('email', u'Электронная почта'),
                ('phone', u'Телефон'),
                ('address', u'Адрес'),
                ('pass', u'Пароль'),
                ('pass2', u'Подтверждение пароля'),
            )
            for field in fields:
                if field[0] != 'second_name':
                    assert len(Request.POST.get(field[0], '').strip()) > 0, \
                        u'Поле "%s" не заполнено!' % field[1]

                if field[0] == 'email':
                    import re
                    assert re.match(r"^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@([a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(ru|aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$", Request.POST.get(field[0], '')) is not None, \
                        u'Пожалуйста, введите правильный адрес электронной почты.'

                if field[0] == 'phone':
                    import re
                    assert re.match(r"^((8|0|\+\d{1,2})[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$", Request.POST.get(field[0])), \
                        u'Пожалуйста, введите правильный телефонный номер, чтобы мы смогли с Вами связаться.'


                vars[field[0]] = Request.POST.get(field[0], None)

            # TODO validation
            assert vars['pass'] == vars['pass2'], \
                u'Поля "Пароль" и "Подтверждение пароля" не совпадают.'

        #except AssertionError, e:
        except Exception, e:
            vars['error'] = u'Ошибка: '+unicode(e)
            return render_to_response('public/register.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

        try:
            try:
                User.objects.get(email=vars['email'].strip())
            except ObjectDoesNotExist:
                pass
            else:
                assert False, \
                    u"Пользователь с таким электронным адресом уже существует!"

            vars['user'] = User.objects.create_user( vars['email'], vars['email'], vars['pass'] )
            vars['user'].save()

            kw = dict()
            for field in fields:
                kw[field[0]] = vars[field[0]]

            hash = generate_hash()

            customer = Customer.objects.create(
                user=vars['user'],
                first_name=vars['first_name'],
                second_name=vars['second_name'],
                surname=vars['surname'],
                email=vars['email'],
                phone=vars['phone'],
                address=vars['address'],
                email_confirmation_hash=hash
            )
            customer.save()

            send_mail(vars['email'], u'Регистрация на oboevsky.ru', u'''

                Благодарим за регистрацию! Перейдите по указанной ниже ссылке, чтобы подтвердить Вашу учётную запись.

                http://oboevsky.ru/confirm-email/%s

                С уважением, Обоевский.
                ''' % hash)

            # TODO: EXTRA TEMPLATE FOR THIS SHIT IS REQUIRED!!!!! 

            from django.shortcuts import redirect
            return redirect('/login/?registered')

        except Exception, e:
            vars['error'] = u'Ошибка: '+unicode(e)

    return render_to_response('public/register.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def logout(Request):
    from django.contrib.auth import logout
    logout(Request)
    from django.shortcuts import redirect
    return redirect('/?logout')


def cart(Request):
    vars = {}
    action = Request.GET.get('action', None)
    item = Request.GET.get('item', None)
    if action == 'remove' and item is not None:
        cart = Request.session.get('cart', {})
        
        if not item in cart: 
            # TODO: better handling wrong item index
            from django.shortcuts import redirect
            return redirect('/cart/')

        del cart[item]

        # this code should be refactored: 
        # Recalculating totals:    
        total = 0
        for i in cart:
            total += cart[i].total

        Request.session['cart'] = cart
        Request.session['cart_total'] = total

    if action == 'update':
        cart = Request.session.get('cart', {})
        pk = Request.GET.get('item')
        quantity = Request.POST.get('quantity', 1)

        if not pk in cart: 
            #TODO: better handling wrong item index
            from django.shortcuts import redirect
            return redirect('/cart/')

        item = cart[pk]
        try:
            item.quantity = int(quantity)
        except ValueError, e: 
            # When user suddenly inputs space or letter, we won't change anything
            pass
        item.total = item.quantity * item.price

        if not item.quantity is 0:
            cart[pk] = item
        else:
            del cart[pk]

        # this code should be refactored: 
        # Recalculating totals:    
        total = 0
        for i in cart:
            total += cart[i].total

        Request.session['cart'] = cart
        Request.session['cart_total'] = total

    return render_to_response('public/cart.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def account(Request):
    vars = {}
    user = Request.user
    if not user: 
        return redirect('/login/')
    customer = Customer.objects.get(user=user)

    def update_vars():
        vars['first_name'] = customer.first_name
        vars['second_name'] = customer.second_name
        vars['surname'] = customer.surname
        vars['email'] = customer.email
        vars['address'] = customer.address
        vars['phone'] = customer.phone
    update_vars()

    if Request.GET.get('do', None) is not None:
        if not user.check_password(Request.POST.get('old-pass')):    
            vars['error'] = u'Неверно введён старый пароль'
        else:

            if len(Request.POST.get('first_name').strip()) > 0:
                customer.first_name = Request.POST.get('first_name')
            if len(Request.POST.get('second_name').strip()) > 0:
                customer.second_name = Request.POST.get('second_name')
            if len(Request.POST.get('surname').strip()) > 0:
                customer.surname = Request.POST.get('surname')
            if len(Request.POST.get('email').strip()) > 0:
                customer.email = Request.POST.get('email')
            if len(Request.POST.get('address').strip()) > 0:
                customer.address = Request.POST.get('address')
            customer.save()
            update_vars()

            vars['error'] = u'Изменения успешно сохранены'


    return render_to_response('public/account.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def change_password(Request):
    vars = {}
    user = Request.user
    if not user: 
        return redirect('/login/')

    if Request.GET.get('do', None) is not None:
        if not user.check_password(Request.POST.get('old-pass')):
            vars['error'] = u'Неверно введён старый пароль'
        else:
            if not Request.POST.get('pass') == Request.POST.get('pass2'):
                vars['error'] = u'Введённые пароли не совпадают'
            else:
                user.set_password(Request.POST.get('pass'))
                user.save()
                vars['error'] = u'Новый пароль успешно сохранён'

    return render_to_response('public/change-password.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))


def order_history(Request):
    vars = {}
    user = Request.user
    if not user: 
        return redirect('/login/')

    cust = Customer.objects.get(user=Request.user)
    orders = Order.objects.filter(customer=cust)

    vars['orders_history'] = orders
    return render_to_response('public/order-history.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))



def add_item_to_cart(Request, pk):
    from django.shortcuts import get_object_or_404
    item = get_object_or_404(Wallpaper, pk=pk)
    cart = Request.session.get('cart', {})

    item.quantity = item.quantity + 1 if item.quantity else 1

    assert item.price is not None, \
        u"ПИЗДЕЦ! У ТОВАРА ЦЕНЫ НЕТ, БЛЯТЬ!"
    item.total = item.price * item.quantity

    cart.update({pk: item})

    total = 0
    for i in cart:
        total += cart[i].total

    Request.session['cart'] = cart
    Request.session['cart_total'] = total

    #TODO: FIX VULNERABILITY HERE:
    from django.shortcuts import redirect
    return redirect(Request.META.get('HTTP_REFERER', '/cart/'))

def order(Request):
    vars = {}   
    if Request.user.is_authenticated():
        try:
            cust = Customer.objects.get(user=Request.user)

            vars['first_name'] = cust.first_name
            vars['second_name'] = cust.second_name
            vars['surname'] = cust.surname
            vars['email'] = cust.email
            vars['phone'] = cust.phone
            vars['address'] = cust.address
        except Exception, e:
            pass #TODO: examine, wtf

    return render_to_response('public/order.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

def place_order(Request):

    vars = {}

    try:
        fields = (
            ('first_name', u'Имя'),
            ('second_name', u'Отчество'),
            ('surname', u'Фамилия'),
            ('email', u'Электронная почта'),
            ('phone', u'Телефон'),
            ('address', u'Адрес'),
        )
        for field in fields:
            if field[0] not in ('second_name', 'surname', 'email'):
                assert len(Request.POST.get(field[0], '').strip()) > 0, \
                    u'Пожалуйста, заполните поле "%s".' % field[1]

            if field[0] == 'email':
                import re
                assert re.match(r"^[-a-z0-9!#$%&'*+/=?^_`{|}~]+(\.[-a-z0-9!#$%&'*+/=?^_`{|}~]+)*@([a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?\.)*(ru|aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|[a-z][a-z])$", Request.POST.get(field[0], '')) is not None, \
                    u'Пожалуйста, введите правильный адрес электронной почты.'

            if field[0] == 'phone':
                import re
                assert re.match(r"^((8|0|\+\d{1,2})[\- ]?)?(\(?\d{3}\)?[\- ]?)?[\d\- ]{7,10}$", Request.POST.get(field[0])), \
                    u'Пожалуйста, введите правильный телефонный номер, чтобы мы смогли с Вами связаться.'

            vars[field[0]] = Request.POST.get(field[0], None)


        cart = Request.session.get('cart')
        import pickle

        cart = pickle.dumps(cart)

        order = Order.objects.create(
            state=u'Не обработан',
            visible=True,
            dump=cart,
            total=Request.session['cart_total'],
            comments=u"""
            first_name: %s,
            second_name: %s,
            surname: %s,
            email: %s,
            phone: %s,
            address: %s

            comment: %s

            ---

            %s
            """ % (
                Request.POST.get('first_name'),
                Request.POST.get('second_name'),
                Request.POST.get('surname'),
                Request.POST.get('email'),
                Request.POST.get('phone'),
                Request.POST.get('address'),
                Request.POST.get('comment'),
                str(Request.POST.dict())
                ),
            customer=None if not Request.user.is_authenticated() else Customer.objects.get(user=Request.user),  
        )
        order.save()

        Request.session['cart'] = {}

    except Exception, e:
        vars['error'] = unicode(e)
        return render_to_response('public/order.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))

    return render_to_response('public/order-placed.tpl', vars, RequestContext(Request, processors=[common_context_proc,]))
