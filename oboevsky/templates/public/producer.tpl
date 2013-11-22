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

                            {% if forloop.counter == 9 %}
                                <script>
                                function fetch_items_{{item.id}}() {
                                    $('#trigger-{{item.id}}').hide();
                                    $.getJSON('http://oboevsky.ru/get-items-collection/{{item.id}}{% for t in group.2|slice:"8:" %},{{t.id}}{% endfor %}/',
                                        function(data) {
                                            $.each(data, function(k, v) {
                                                $('#items-group-{{item.id}}').append(
                                                    $('<div class="item new-look" style="background:url(\''+v['image']+'\'); cursor:pointer;" onClick="javascript:document.location.href="'+v['url']+'"><a href="'+v['url']+'"><img src="'+v['image']+'" alt="'+v['shortdesc']+'" /></a><p class="title-container"><a href="'+v['url']+'"><b style="text-decoration:none;">'+v['title']+'</b></a><br />'+v['price']+' руб.</p><p><a href="/put-to-cart/'+v['pk']+'">Купить</a></p></div>')
                                                );
                                                if( (k + 3) % 3 == 0) {$('#items-group-{{item.id}}').append('<div class="spacer"></div>');}
                                            });
                                        });
                                    $('#items-group-{{item.id}}').show();
                                }
                                </script>
                                <a id="trigger-{{item.id}}" href="javascript:fetch_items_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные ({{group.2|slice:"8:"|length}})</a>
                                <div style="display:none" id="items-group-{{item.id}}">
                            {% endif %}

                            {% if forloop.counter < 9 %}
                                {% include "public/inc/wallpapers_list_item.tpl" %}
                                {% if forloop.counter|divisibleby:"3" %}
                                    <div class="spacer"></div>
                                {% endif %}
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
                <h2>Обои торговой марки "{{producer.title}}"</h2>
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}

                        {% if forloop.counter == 9 %}
                            <script>
                            function fetch_items_{{item.id}}() {
                                $('#trigger-{{item.id}}').hide();
                                $.getJSON('http://oboevsky.ru/get-items-collection/{{item.id}}{% for t in group.2|slice:"8:" %},{{t.id}}{% endfor %}/',
                                    function(data) {
                                        $.each(data, function(k, v) {
                                            $('#items-group-{{item.id}}').append(
                                                $('<div class="item new-look" style="background:url(\''+v['image']+'\'); cursor:pointer;" onClick="javascript:document.location.href="'+v['url']+'"><a href="'+v['url']+'"><img src="'+v['image']+'" alt="'+v['shortdesc']+'" /></a><p class="title-container"><a href="'+v['url']+'"><b style="text-decoration:none;">'+v['title']+'</b></a><br />'+v['price']+' руб.</p><p><a href="/put-to-cart/'+v['pk']+'">Купить</a></p></div>')
                                            );
                                            if( (k + 3) % 3 == 0) {$('#items-group-{{item.id}}').append('<div class="spacer"></div>');}
                                        });
                                    });
                                $('#items-group-{{item.id}}').show();
                            }
                            </script>
                            <a id="trigger-{{item.id}}" href="javascript:fetch_items_{{item.id}}();" style="width:169px; height:169px; line-height: 160px; text-align:center; display:block; float: left;">Показать&nbsp;остальные ({{group.2|slice:"8:"|length}})</a>
                            <div style="display:none" id="items-group-{{item.id}}">
                        {% endif %}

                        {% if forloop.counter < 9 %}
                            {% include "public/inc/wallpapers_list_item.tpl" %}
                            {% if forloop.counter|divisibleby:"3" %}
                                <div class="spacer"></div>
                            {% endif %}
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