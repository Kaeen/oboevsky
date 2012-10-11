{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}

            <div class="contentBlockNoBorder">
                <div id="breadcrumps">
                    <a href="/">Главная</a> / <a href="/countries/">Страны-производители обоев</a> / {{ country.title }}
                </div>
                <div id="producerProfile">
                    <h1>{{country.title}}</h1>
                    {{country.long_desc}}

                    {% if country.producer.all %}
                    <h1>Производители:</h1>
                    <ul>
                        {% for producer in country.producer.all %}
                        <li><a href="{{producer.get_absolute_url}}">{{producer.title}}</a></li>
                        {% endfor %}
                    </ul>
                    {% endif %}

                </div>
            </div>

            {% if country_items %}
            <div class="contentBlock">
                <div>
                    {# PAGINATION #}
                    {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}

                    {% for item in country_items %}
                    <div class="items clear">
                        <div class="item">
                            <a href="{{item.get_absolute_url}}">
                                <img alt="" src="{{item.images.all.0.image.url}}" />
                            </a>
                            <p>{{item.title}}</p>
                            <p>{{item.price}} руб</p>
                            <p><a href="#">В корзину</a></p>
                        </div>
                    </div>
                    {% endfor %}

                    {# PAGINATION #}
                    {#<p><a href="#">1</a>, <a href="#">2</a>, <a href="#">3</a></p>#}
                </div>
            </div>
            {% endif %}
        </div>

{% endblock %}