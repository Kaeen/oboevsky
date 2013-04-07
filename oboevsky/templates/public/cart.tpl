{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Корзина
        </div>

        <h1>Корзина</h1>

        <style type="text/css">
            .form-line .quantity-input {
                border: 1px solid #ccc;
                width: 25px;
                height: 18px;
                padding: 2px;
                margin: 0px;
                text-align: center;
            }

            #cart-form {
                width: 100%;
            }

            #cart-form .title-col {
                width: 120px;
            }

            #cart-form .quantity-col {
                width: 200px;
            }

            #cart-form .controls-col {
                width: auto;
            }

            #cart-form .controls-col input {
                width: 120px;
                height: 25px;
                margin: 1px;
            }
        </style>

        <table id="cart-form" width="100%">

            <tr>
                <td class="title-col">Товар</td>
                <td class="quantity-col">Количество</td>
                <td class="controls-col">Управление</td>
            </tr>

        {% for item in cart_items %}

        <form action="?action=update&item={{item.id}}" method="post">

            {% csrf_token %}

            <tr class="form-line">
                <td class="title-col">
                    <a href="{{item.get_absolute_url}}">
                        {{item.title}}
                        <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
                    </a>
                </td>
                <td class="quantity-col">
                    <input class="quantity-input" name="quantity" type="text" value="{{item.quantity}}" /> рулонов {% if item.total %}по {{item.price}} рублей каждый {% endif %}
                </td>
                <td class="controls-col">
                    <input type='submit' value='Пересчитать' /><br />
                    <input type='button' value='Удалить' onclick="document.location.href='/cart?action=remove&item={{item.id}}'" />
                </td>
            </tr>
        </form>

        </table>

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