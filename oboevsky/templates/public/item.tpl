{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / {{item.title}}
        </div>
        <div id="itemInfo" class="clear">
            <h1>{{item.title}}</h1>

            {% if item.images.all %}
                <div id="itemPreviewWrapper" class="right">
                    <img src="{{item.images.all.0.image.url}}" alt="" />
                </div>
            {% endif %}

            <div class="itemAttribute clear">
                <div class="caption">Артикул:</div>
                <div class="left">{{item.sku}}</div>
            </div>
            <div class="itemAttribute clear">
                <div class="caption">Торговая марка:</div>
                <div class="left"><a href="{{item.producer.country.get_absolute_url}}"><img alt="{{item.producer.country.short_desc}}" align="absmiddle" src="{{item.producer.country.pic.url}}" /></a> <a href="{{item.producer.get_absolute_url}}" alt="{{item.producer.short_desc}}">{{item.producer.title}}</a></div>
            </div>
            {% if item.texture.all %}
                <div class="itemAttribute clear">
                    <div class="caption">Узоры:</div>
                    <div class="left">
                        {% for texture in item.texture.all %}
                            <a href="{{texture.get_absolute_url}}"><img src="{{texture.pic.url}}" alt="{{texture.short_desc}}" class="left icon" /></a>
                        {% endfor %}
                    </div>
                </div>
            {% endif %}
            {% if item.price %}
                <div class="itemAttribute clear">
                    <div class="caption">Цена:</div>
                    <div class="left">
                        {{item.price}} руб.
                    </div>
                </div>
            {% endif %}
        </div>

        {{item.long_desc|safe}}
    </div>

{% endblock %}