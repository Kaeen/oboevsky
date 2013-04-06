{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Оформление заказа
        </div>

        <h1>Оформление заказа</h1>


        {% if cart_items_total > 0 %}
        <p>Итого: {{cart_items_total}} руб.</p>

        <form action="" method="post">

            {% csrf_token %}

            <p><input name="quantity" type="text" value="{{item.quantity}}" /></p>
            <p><input type='submit' value='Оформить!' /></p>

        </form>
        {% else %}

        <p>В Вашей корзине пока нет товаров. </p>
        
        {% endif %}

    </div>
{% endblock %}

{% block cart_sidebar %}
{% endblock %}