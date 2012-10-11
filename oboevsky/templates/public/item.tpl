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
                        <div class="left"><a href="{{item.producer.get_absolute_url}}" alt="{{item.producer.short_desc}}">{{item.producer.title}}</a></div>
                    </div>
                    <div class="itemAttribute clear">
                        <div class="caption">Страна-производитель:</div>
                        <div class="left">{{item.producer.country.get_html|safe}}</div>
                    </div>
                </div>
            </div>

        </div>

{% endblock %}