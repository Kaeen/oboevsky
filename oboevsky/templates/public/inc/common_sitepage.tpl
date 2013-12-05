{% extends "public/inc/common_template.tpl" %}

{% block page_title %}Обоевский{% endblock %}

{% block body %}
<div id="pageWrapper">
    {% block page_header %}
        {% include "public/inc/common_page_header.tpl" %}
    {% endblock %}

    {% block page_content_wrapper %}
    <div id="contentWrapper" class="clear">
        {% block left_sidebar %}
        <div class="pageSidebar left">
            <div class="pageColumn">
                <h2>Категории обоев</h2>
                <ul>
                    {% block menu_categories %}
                        {% if menu_categories|length > 0 %}
                        <li>
                            <h3>Обои по назначению</h3>
                            <ul>
                                {% for temp in menu_categories %}
                                <li><a href="{{temp.get_absolute_url}}">{{temp.title}}</a></li>
                                {% endfor %}
                            </ul>
                        </li>
                        {% endif %}
                    {% endblock %}

                    {% block menu_prices %}
                        <li>
                            <h3>Обои по цене</h3>
                            <ul>
                                <li><a href="/search?do&max_price=1000">До 1000 рублей</a></li>
                                <li><a href="/search?do&min_price=1000&max_price=3000">От 1000 до 3000 рублей</a></li>
                                <li><a href="/search?do&min_price=3000">От 3000 рублей</a></li>
                            </ul>
                        </li>
                    {% endblock %}

                    {% block menu_countries %}
                        {% if menu_countries|length > 0 %}
                        <li>
                            <h3>Обои по странам</h3>
                            <ul>
                                {% for temp in menu_countries %}
                                    <li>{{temp.get_html|safe}}</li>
                                {% endfor %}
                            </ul>
                        </li>
                        {% endif %}
                    {% endblock %}

                    {% block menu_materials %}
                        {% if menu_materials|length > 0 %}
                        <li>
                            <h3>Виды обоев</h3>
                            <ul>
                                {% for temp in menu_materials %}
                                    <li><a href="{{temp.get_absolute_url}}">{{temp.title}}</a></li>
                                {% endfor %}
                            </ul>
                        </li>
                        {% endif %}
                    {% endblock %}
                </ul>
            </div>

            {% block menu_producers %}
                {% if menu_producers|length > 0 %}
                <div class="pageColumn">
                    <h2>Производители обоев</h2>
                    <ul class="no-list">
                        {% for temp in menu_producers %}
                            <li><a href="{{temp.get_absolute_url}}">{{temp.title}}</a></li>
                        {% endfor %}
                    </ul>
                </div>
                {% endif %}
            {% endblock %}

        </div>
        {% endblock %}

        {% block right_sidebar %}
        <div class="pageSidebar right">
            {% if not user.is_anonymous %}
            <div class="pageColumn">
                <h2>Здравствуйте, {{user.customer.first_name}}{% if user.customer.second_name %} {{user.customer.second_name}}{% endif %}!</h2>
                <p><a href="/account/">Личный кабинет</a></p>
                <p><a href="/logout/">Выйти</a></p>
            </div>
            {% endif %}

            {% block sorting %}
            <div class="pageColumn">
                <h2>Сортировка товаров</h2>
                <ul class="no-list">
                    <li>
                        {% if ordering == '-priority,price' %}
                            &#10003; По умолчанию
                        {% else %}
                            <a href="{{request.get_full_path}}{% if '?' in request.get_full_path %}&{% else %}?{% endif %}order=-priority,price">По умолчанию</a>
                        {% endif %}
                    </li><br />
                    <li><h3>По цене:</h3></li>
                    <li>
                        {% if ordering == 'price' %}
                            &#10003; Сначала подешевле (&uarr;)
                        {% else %}
                            <a href="{{request.get_full_path}}{% if '?' in request.get_full_path %}&{% else %}?{% endif %}order=price">Сначала подешевле (&uarr;)</a>
                        {% endif %}
                    </li>
                    <li>
                        {% if ordering == '-price' %}
                            &#10003; Сначала дорогие (&darr;)
                        {% else %}
                            <a href="{{request.get_full_path}}{% if '?' in request.get_full_path %}&{% else %}?{% endif %}order=-price">Сначала дорогие (&darr;)</a>
                        {% endif %}
                    </li><br />
                    <li><h3>По новизне:</h3></li>
                    <li>
                        {% if ordering == '-created' %}
                            &#10003; Сначала новые
                        {% else %}
                            <a href="{{request.get_full_path}}{% if '?' in request.get_full_path %}&{% else %}?{% endif %}order=-created">Сначала новые</a>
                        {% endif %}
                    </li>
                    <li>
                        {% if ordering == 'created' %}
                            &#10003; Сначала старые
                        {% else %}
                            <a href="{{request.get_full_path}}{% if '?' in request.get_full_path %}&{% else %}?{% endif %}order=created">Сначала старые</a>
                        {% endif %}
                    </li>
                </ul>
            </div>
            {% endblock %}

            {% comment %}
            <div class="pageColumn">
                <h2>Поиск</h2>
                <p class="text-center">TODO</p>
            </div>
            {% endcomment %}


            {% block cart_sidebar %}
            <div class="pageColumn">
                <h2>Корзина</h2>
                {% if cart_items|length < 1 %}
                <p class="text-center">В Вашей корзине нет товаров</p>
                {% else %}
                    {% for item in cart_items %}
                        <p><a href="/cart?action=remove&item={{item.id}}" class="redBoldLink">X</a> {{item.title}} x {{item.quantity}} рул.{% if item.total %} = {{item.total}} руб.{% else %} (цену необходимо уточнить){% endif %}</p>
                    {% endfor %}
                    {% if cart_items_total > 0 %}
                    <p>Итого: {{cart_items_total}} руб.</p>
                    {% endif %}
                    <br />
                    <a href="/cart/">Подробнее</a> <a href="/order">Оформить</a>
                {% endif %}
            </div>
            {% endblock %}

            {% comment %}
            <a href="/order-sample">
            <div class="pageColumn">
                <br />
                <h2>Заказать образец</h2>
            </div>
            </a>
            {% endcomment %}
        </div>
        {% endblock %}

        <div id="content">
            {% block content %}-- CONTENT!? --{% endblock %}
        </div>
    </div>
    {% endblock %}

    {% block page_footer %}
        {% include "public/inc/common_page_footer.tpl" %}
    {% endblock %}
</div>
{% endblock %}