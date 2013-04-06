{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Оформление заказа
        </div>

        <h1>Оформление заказа</h1>


        {% if cart_items_total > 0 %}
        <p>Итого: {{cart_items_total}} руб.</p>

        <form action="/place-order" method="post">

            {% csrf_token %}

            {% if error %}
                <p class="red">{{error}}</p>
            {% endif %}

            <p>
                * Имя: <input name="first_name" type="text" value="{{first_name}}" />
            </p>
            <p>
                Отчество: <input name="second_name" type="text" value="{{second_name}}" />
            </p>
            <p>
                Фамилия: <input name="surname" type="text" value="{{surname}}" />
            </p>

            <p>
                e-mail: <input name="email" type="text" value="{{email}}" />
            </p>

            <p>
                * Телефон: <input name="phone" type="text" value="{{phone}}" />
            </p>

            <p>
                * Адрес доставки: <br />
                <textarea name="address">{{address}}</textarea>
            </p>


            <p><input type='submit' value='Оформить!' /></p>

        </form>
        {% else %}

        <p>В Вашей корзине пока нет товаров. </p>
        
        {% endif %}

    </div>
{% endblock %}

{% block cart_sidebar %}
{% endblock %}