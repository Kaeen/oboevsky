{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Корзина
        </div>

        <h1>Корзина</h1>

        <style type="text/css">
            .quantity-input {
                border: 1px solid #ccc;
                width: 25px;
                height: 18px;
                padding: 0 2px 2px 2px;
                margin: 0px;
                text-align: center;
                font-size: 15px;
            }

            .form-line {
                padding-bottom: 5px;
                margin-bottom: 5px;
                border-bottom: 1px solid #ccc;
            }

            #cart-form {
                width: 100%;
            }

            #cart-form td {
                vertical-align: top;
            }

            #cart-form .cart-item-title {
                display: block;
                height: 111px;
                width: 170px;
                line-height: 18px;
            }

            #cart-form .cart-item-title p {
                background: rgba(0, 0, 0, 0.5);
                line-height: 20px;
                height: 20px;
                padding: 0;
                margin: 1px;
                text-indent: 5px;
                color: #fef2ca;
            }

            #cart-form .title-col {
                width: 120px;
            }

            #cart-form .quantity-col {
                width: auto;
                line-height: 24px;
                font-size: 13px;
            }

            #cart-form .controls-col {
                width: 130px;
            }

            #cart-form .controls-col input {
                width: 120px;
                height: 25px;
                margin: 1px;
            }

            #cart-total-wrapper p,
            #cart-total-wrapper p a {
                font-size: 17px;
            }
        </style>

        <table id="cart-form" width="100%">

        {% for item in cart_items %}

        <form action="?action=update&item={{item.id}}" method="post">

            {% csrf_token %}

            <tr class="form-line">
                <td class="title-col">
                    <a href="{{item.get_absolute_url}}">
                        <div class="cart-item-title" style="background: url('{{item.get_first_image.image.url_170x111}}') repeat-x;">
                            <p>{{item.title}}</p>
                        </div>
                    </a>
                </td>
                <td class="quantity-col">
                    <input class="quantity-input" name="quantity" type="text" value="{{item.quantity}}" onChange="javascript:$('#cart-form form').submit();" /> рулонов {% if item.total %}по {{item.price}} рублей каждый {% endif %}
                </td>
                <td class="controls-col">
                    <input type='submit' value='Пересчитать' /><br />
                    <input type='button' value='Удалить' onclick="document.location.href='/cart?action=remove&item={{item.id}}'" />
                </td>
            </tr>

        </form>

        {% endfor %}

        </table>

        {% if cart_items_total > 0 %}
        <div id="cart-total-wrapper">
            <p>Итого: {{cart_items_total}} руб.</p>
            <p><a href="/order">Оформить</a> заказ? </p>
        </div>
        {% else %}
        <p>В Вашей корзине пока нет товаров. </p>
        {% endif %}


    </div>
{% endblock %}

{% block cart_sidebar %}
{% endblock %}