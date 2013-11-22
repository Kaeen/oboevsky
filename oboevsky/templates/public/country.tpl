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

        {% for group in items %}
            <div class="contentBlock">
                <div>
                    <a href="{{group.1}}"><h2>{{group.0}}</h2></a>
                    <div class="items clear">
                        {% for item in group.2 %}

                            {% if forloop.counter == 9 %}
                                <script>
                                    function fetch_items_{{item.id}}() {
                                        $('#trigger-{{item.id}}').hide();
                                        $.getJSON('http://oboevsky.ru/get-items-collection/{{item.id}}{% for t in group.2|slice:"9:" %},{{t.id}}{% endfor %}/',
                                            function(data) {
                                                $.each(data, function(k, v) {
                                                    $('#items-group-{{item.id}}').append(
                                                        $('<div class="item new-look" style="background:url(\''+v['image']+'\'); cursor:pointer;" onClick="javascript:document.location.href="'+v['url']+'"><a href="'+v['url']+'"><img src="'+v['image']+'" alt="'+v['shortdesc']+'" /></a><p class="title-container"><a href="'+v['url']+'"><b style="text-decoration:none;">'+v['title']+'</b></a><br />'+v['price']+' руб.</p><p><a href="/put-to-cart/'+v['pk']+'">Купить</a></p></div>')
                                                    );
                                                    if( (k + 3) % 3 == 0) {$('#items-group-{{item.id}}}').append('<div class="spacer"></div>');}
                                                });
                                            });

                                        $('#items-group-{{item.id}}').show();
                                    }

                                    function trigger_{{item.id}}() {
                                        $('#trigger-{{item.id}}').hide();
                                        $('#items-group-{{item.id}}').show();
                                    }
                                </script>
                                <a id="trigger-{{item.id}}" href="javascript:trigger_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные</a>
                                <div style="display:none" id="items-group-{{item.id}}">
                            {% endif %}

                            {% if forloop.counter < 9 %}
                                {% include "public/inc/wallpapers_list_item.tpl" %}
                            {% endif %}

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
        {% endfor %}

    {% else %}

        <div class="contentBlock">
            <div>
                <h2>Обои</h2>
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}

                        {% include "public/inc/wallpapers_list_item.tpl" %}

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