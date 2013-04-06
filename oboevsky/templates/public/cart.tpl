{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Корзина
        </div>

        <h1>Корзина</h1>

        {% for item in cart_items %}

        <p><form action="?action=update&item={{item.id}}" method="post">

            {% csrf_token %}

            {{item.title}}, <input name="quantity" type="text" value="{{item.quantity}}" /> рулонов {% if item.total %}по {{item.price}} рублей каждый {% endif %}
            <input type='submit' value='Пересчитать' /> <input type='button' value='Удалить' onclick="document.location.href='/cart?action=remove&item={{item.id}}'" />

        </form></p>

        {% endfor %}

        {% if cart_items_total > 0 %}
        <p>Итого: {{cart_items_total}} руб.</p>
        <p><a href="/order">Оформить</a> заказ? </p>
        {% else %}
        В Вашей корзине пока нет товаров. 
        {% endif %}


    </div>
{% endblock %}

{% block cart_sidebar %}
{% endblock %}