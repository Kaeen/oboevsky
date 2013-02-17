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
                {{user}} + 
                {{user.customer}}
                <h2>Здравствуйте, {{user.customer.first_name}} {{user.customer.second_name}}!</h2>
                <p><a href="/account/">Личный кабинет</a></p>
                <p><a href="/logout/">Выйти</a></p>
            </div>
            {% endif %}

            {% comment %}
            <div class="pageColumn">
                <h2>Поиск</h2>
                <p class="text-center">TODO</p>
            </div>
            {% endcomment %}

            <div class="pageColumn">
                <h2>Корзина</h2>
                {% if cart_items|length < 1 %}
                <p class="text-center">В Вашей корзине нет товаров</p>
                {% else %}
                    {% for item in cart_items %}
                        <p>{{item.title}} x {{item.quantity}} рул.{% if item.total %} = {{item.total}} руб.{% else %} (цену необходимо уточнить){% endif %}</p>
                    {% endfor %}
                    {% if cart_items_total > 0 %}
                    Итого: {{cart_items_total}} руб.
                    {% endif %}
                    <br />
                    <a href="/cart/">Подробнее</a> <a href="#">Оформить</a>
                {% endif %}
            </div>

            <a href="/order-sample">
            <div class="pageColumn">
                <br />
                <h2>Заказать образец</h2>
            </div>
            </a>
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