{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / <a href="/catalog/">Каталог</a> / 
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
                                    {{item.title}}<br />
                                    {{item.price}} руб.
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
                <h2>Обои {{category.title|lower}}</h2>

                <div class="items clear">
                    {% for item in items %}
                        <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}');">
                            {% if item.get_first_image %}
                                <a href="{{item.get_absolute_url}}">
                                    <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                </a>
                            {% endif %}
                            <p class="title-container">
                                {{item.title}}<br />
                                {{item.price}} руб.
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

    {% endif %}

{% endblock %}