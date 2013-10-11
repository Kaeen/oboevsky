{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/producers">Производители</a> / {{producer.title}}
        </div>
        <div id="producerProfile">
            <h1>{{producer.title}}</h1>
            {% if producer.logo %}
                <img id="producerLogo" src="{{producer.logo.url}}" />
            {% endif %}
            {{producer.long_desc|safe}}
            <h2>Страна: &nbsp;<a href="{{producer.country.get_absolute_url}}"><img src="{{producer.country.pic.url_13x20}}" alt="{{producer.country.short_desc}}" width height /></a>&nbsp;<a href="{{producer.country.get_absolute_url}}">{{producer.country.title}}</a></h2>
        </div>
    </div>

    {% for iblock in producer.info_blocks.all %}
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

                            {% include "public/inc/public/inc/wallpapers_list_item.tpl" %}

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
                <h2>Обои торговой марки "{{producer.title}}"</h2>
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}

                        {% include "public/inc/public/inc/wallpapers_list_item.tpl" %}

                        {% if forloop.counter|divisibleby:"3" %}
                            <div class="spacer"></div>
                        {% endif %}
                    {% endfor %}
                </div>

                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}
            </div>
        </div>

    {% endif %}


{% endblock %}