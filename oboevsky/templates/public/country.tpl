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
                            <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}');">
                                {% if item.get_first_image %}
                                    <a href="{{item.get_absolute_url}}">
                                        <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                    </a>
                                {% endif %}
                                <p class="title-container">
                                    <b>{{item.title}}</b><br />
                                    {{item.price|floatformat:"-3"}} руб.
                                </p>
                                <p><a href="/put-to-cart/{{item.pk}}">В корзину</a></p>
                            </div>

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
                <h2>Обои</h2>
                {# PAGINATION #}
                {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                <div class="items clear">
                    {% for item in items %}
                        <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}');">
                            {% if item.get_first_image %}
                                <a href="{{item.get_absolute_url}}">
                                    <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                </a>
                            {% endif %}
                            <p class="title-container">
                                <b>{{item.title}}</b><br />
                                {{item.price|floatformat:"-3"}} руб.
                            </p>
                            <p><a href="/put-to-cart/{{item.pk}}">В корзину</a></p>
                        </div>

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