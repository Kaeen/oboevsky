{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — обои {{producer.title}}, {{producer.country.title}}{% endblock %}
{% block meta_description %}{{producer.short_desc}}{% endblock %}
{% block meta_keywords %}Обоевский обои {{producer.title}} {{producer.country.title}}{% endblock %}

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

        {% include "public/inc/grouped_wallpaper_collection.tpl" %}

    {% else %}

        <div class="contentBlock">
            <div>
                <h2>Обои торговой марки "{{producer.title}}"</h2>

                <div class="items clear">
                    {% for item in items %}

                            {% if forloop.counter == 9 %}
                                <script>
                                    function trigger() {
                                        $('#trigger').hide();
                                        $('#items-group').show();
                                    }
                                </script>
                                <a id="trigger" href="javascript:trigger();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные</a>
                                <div style="display:none" id="items-group}">
                            {% endif %}

                            {% include "public/inc/wallpapers_list_item.tpl" %}

                            {% if forloop.counter|divisibleby:"3" %}
                                <div class="spacer"></div>
                            {% endif %}

                            {% if forloop.counter > 9 %}
                                {% if forloop.last %}
                                    </div>
                                {% endif %}
                            {% endif %}

                    {% endfor %}
                </div>
            </div>
        </div>

    {% endif %}


{% endblock %}