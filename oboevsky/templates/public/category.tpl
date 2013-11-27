{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — {{category.title}}, обои{% endblock %}
{% block meta_description %}{{category.short_desc}}{% endblock %}
{% block meta_keywords %}Обоевский обои {{category.title}} {{category.short_desc}}{% endblock %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> {#/ <a href="/catalog/">Каталог</a> #}/ 
            {% for breadcrump in category.get_breadcrumps_list %}
                {{breadcrump.title}}
            {% endfor %}
        </div>
        <div id="producerProfile">
            <h1>{{category.title}}</h1>
            {{category.long_desc|safe}}
        </div>
        {% if items|length > 0 %}
        <h1>{{category.title}}</h1>
        {% endif %}
    </div>

    {% for iblock in category.info_blocks.all %}
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
                <h2>Обои {{category.title|lower}}</h2>

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

            </div>
        </div>

    {% endif %}

{% endblock %}