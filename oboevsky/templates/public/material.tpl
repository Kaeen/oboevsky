{% extends "public/inc/common_sitepage.tpl" %}

{% block page_title %}{{block.super}} — {{material.title}}, обои{% endblock %}
{% block meta_description %}{{material.short_desc}}{% endblock %}
{% block meta_keywords %}Обоевский обои {{material.title}} {{material.short_desc}}{% endblock %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/materials/">Материалы</a> / {{material.title}}
        </div>
        <div id="producerProfile">
            <h1>{{material.title}}</h1>

            {{material.long_desc|safe}}

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

        {% include "public/inc/grouped_wallpaper_collection.tpl" %}

    {% else %}

        <div class="contentBlock">
            <div>
                <h2>Обои {{material.title|lower}}</h2>

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