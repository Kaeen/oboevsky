{% extends "public/inc/common_sitepage.tpl" %}

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
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}

                            {% if forloop.counter == 9 %}
                                <script>
                                    function trigger_{{item.id}}() {
                                        $('#trigger-{{item.id}}').hide();
                                        $('#items-group-{{item.id}}').show();
                                    }
                                </script>
                                <a id="trigger-{{item.id}}" href="javascript:trigger_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные</a>
                                <div style="display:none" id="items-group-{{item.id}}">
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

                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}
            </div>
        </div>

    {% endif %}

{% endblock %}