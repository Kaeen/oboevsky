{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — {{country.title}}, обои в Обоевском{% endblock %}
{% block meta_description %}{{country.short_desc}}{% endblock %}
{% block meta_keywords %}Обоевский обои {{country.title}}{% endblock %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/countries/">Страны-производители обоев</a> / {{ country.title }}
        </div>
        <div id="producerProfile">
            <h1><img src="{{country.pic.url}}" alt="{{country.title}}" width="20px" height="13px" /> {{country.title}}</h1>
            {{country.long_desc|safe}}

            {% if producers|length > 0 %}
                <h1>Производители:</h1>
                <ul>
                    {% for producer in producers %}
                        <li><a href="{{producer.get_absolute_url}}">{{producer.title}}</a></li>
                    {% endfor %}
                </ul>
            {% endif %}

        </div>
    </div>
    
    {% for iblock in country.info_blocks.all %}
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
                <h2>Обои</h2>

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