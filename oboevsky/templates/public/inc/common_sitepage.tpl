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
                </ul>
            </div>

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

        </div>
        {% endblock %}

        {% block right_sidebar %}
        <div class="pageSidebar right">
            {% comment %}
            <div class="pageColumn">
                <h2>Поиск</h2>
                <p class="text-center">TODO</p>
            </div>
            {% endcomment %}

            <div class="pageColumn">
                <h2>Корзина</h2>
                <p class="text-center">В Вашей корзине нет товаров</p>
            </div>

            <a href="#">
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