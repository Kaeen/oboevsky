{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    {#<a href="#"><img alt="" src="/static/images/sample_moneyshot.jpg" /></a>#}

    {% if new_items|length > 0 %}
        <div class="contentBlock">
            <div>
                <a{# href="#"#}><h2>Новинки</h2></a>
                <div class="items clear">
                    {% for item in new_items %}

                        <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}'); cursor:pointer;" onClick="javascript:document.location.href='{{item.get_absolute_url}}?q={{new_items_q}}';">
                            {% if item.get_first_image %}
                                <a href="{{item.get_absolute_url}}?q={{new_items_q}}">
                                    <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                </a>
                            {% endif %}
                            <p class="title-container">
                                <a href="{{item.get_absolute_url}}?q={{new_items_q}}"><b style="text-decoration:none;">{{item.title}}</b></a><br />
                                {{item.price|floatformat:"-3"}} руб.
                            </p>
                            <p><a href="/put-to-cart/{{item.pk}}">Купить</a></p>
                        </div>

                        {% if forloop.counter|divisibleby:"3" %}
                            <div class="spacer"></div>
                        {% endif %}
                    {% endfor %}
                </div>
            </div>
        </div>
    {% endif %}

    {% if top_sells_items|length > 0 %}
        <div class="contentBlock">
            <div>
                <a{# href="#"#}><h2>Топ продаж</h2></a>
                <div class="items clear">
                    {% for item in top_sells_items %}

                        <div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}'); cursor:pointer;" onClick="javascript:document.location.href='{{item.get_absolute_url}}?q={{top_sells_q}}';">
                            {% if item.get_first_image %}
                                <a href="{{item.get_absolute_url}}?q={{top_sells_q}}">
                                    <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                                </a>
                            {% endif %}
                            <p class="title-container">
                                <a href="{{item.get_absolute_url}}?q={{top_sells_q}}"><b style="text-decoration:none;">{{item.title}}</b></a><br />
                                {{item.price|floatformat:"-3"}} руб.
                            </p>
                            <p><a href="/put-to-cart/{{item.pk}}">Купить</a></p>
                        </div>

                        {% if forloop.counter|divisibleby:"3" %}
                            <div class="spacer"></div>
                        {% endif %}
                    {% endfor %}
                </div>
            </div>
        </div>
    {% endif %}

    <div class="contentBlockNoBorder">
        <h1>Уважаемый покупатель!</h1>
        <p>Мы рады предложить Вам широкий выбор обоев от лучших производителей Германии, Великобритании, Франции, США, Италии, Нидерландов, Финляндии и других стран. Мы специально выбирали для Вас коллекции в которых сочетаются изысканность, утонченность и оригинальность. Мы поможем придать интерьеру Вашего дома индивидуальность, статус и уют. </p>
        <p>Если Вы хотите лично посмотреть обои до их заказа - приезжайте в наш шоурум. К Вашим услугам каталоги и профессиональные консультации наших сотрудников. Для того, чтобы сделать Ваш интерьер неповторимым, мы готовы предложить Вам услуги профессионального дизайнера.</p>
        <p>Мы верим, что наша продукция поможет Вам сделать Ваш дом лучше. Приходите к нам!</p>
        <p style="text-align:right;">С Уважением, Обоевский</p>
    </div>
{% endblock %}