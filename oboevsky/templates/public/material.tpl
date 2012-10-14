{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/materials/">Материалы</a> / {{material.title}}
        </div>
        <div id="producerProfile">
            <h1>{{material.title}}</h1>

            {{material.long_desc}}

        </div>
        {% if items|length > 0 %}
            <h1>{{material.title}}</h1>
        {% endif %}
    </div>
    
    {% for iblock in material.info_blocks.all %}
        <div class="contentBlock">
            <h2>{{iblock.title}}</h2>
            {{iblock.content|safe}}
        </div>
    {% endfor %}

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
                <h2>Обои {{material.title|lower}}</h2>
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