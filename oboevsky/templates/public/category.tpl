{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/catalog/">Каталог</a> / {{category.title}}
        </div>
        <div id="producerProfile">
            <h1>{{category.title}}</h1>
            {{category.long_desc}}
        </div>
        {% if items|length > 0 %}
        <h1>{{category.title}}</h1>
        {% endif %}
    </div>

    {% if items_display_mode == 'grouped' %}

        {% for group in items %}
            <div class="contentBlock">
                <div>
                    <a href="{{group.1}}"><h2>{{group.0}}</h2></a>
                    <div class="items clear">
                        {% for item in group.2 %}
                            <div class="item">
                                {% if item.get_first_image %}
                                    <a href="{{item.get_absolute_url}}">
                                        <img src="{{item.get_first_image.image.url}}" alt="{{item.short_desc}}" />
                                    </a>
                                {% endif %}
                                <p>{{item.title}}</p>
                                <p>&nbsp;</p>
                                <p><a href="#">В корзину</a></p>
                            </div>

                            {% if forloop.counter|divisibleby:"3" %}
                                <div class="spacer"></div>
                            {% endif %}
                        {% endfor %}

                    </div>
                </div>
            </div>
        {% endfor %}

    {% else %}

        <div class="contentBlock">
            <div>
                <h2>Обои {{category.title|lower}}</h2>
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}
                        <div class="item">
                            <a href="{{item.get_absolute_url}}">
                                <img src="{{item.get_first_image.image.url}}" alt="{{item.short_desc}}" />
                            </a>
                            <p>{{item.title}}</p>
                            {% if item.price %}
                                <p>{{item.price}} руб</p>
                            {% endif %}
                            <p><a href="#">В корзину</a></p>
                        </div>
                    {% endfor %}
                </div>

                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}
            </div>
        </div>

    {% endif %}

{% endblock %}