{% extends "public/inc/common_sitepage.tpl" %}

{% block content %}
    <div class="contentBlockNoBorder">

        <div id="breadcrumps">
            <a href="/">Главная</a> / Оформление заказа
        </div>

        <h1>Оформление заказа</h1>

        <style type="text/css">
            #order-form-table input {
                height: 18px;
            }

            #order-form-table input,
            #order-form-table textarea {
                border: 1px solid #ccc;
                width: 300px;
                padding: 0 2px 2px 2px;
                margin: 0px;
                font-size: 13px;
            }
        </style>


        {% if cart_items_total > 0 %}

        {% if error %}
            <p class="red">{{error}}</p>
        {% endif %}

        {# <p>Итого: {{cart_items_total}} руб.</p> #}

        <form action="/place-order" method="post">

            {% csrf_token %}
            <table id="order-form-table">

                <tr>
                    <td width="100">* Имя: </td>
                    <td><input name="first_name" type="text" value="{{first_name}}" /></td>
                </tr>

                <tr>
                    <td>Отчество: </td>
                    <td><input name="second_name" type="text" value="{{second_name}}" /></td>
                </tr>

                <tr>
                    <td>Фамилия: </td>
                    <td><input name="surname" type="text" value="{{surname}}" /></td>
                </tr>

                <tr>
                    <td>e-mail: </td>
                    <td><input name="email" type="text" value="{{email}}" /></td>
                </tr>

                <tr>
                    <td>* Телефон: </td>
                    <td><input name="phone" type="text" value="{{phone}}" /></td>
                </tr>

                <tr>
                    <td>* Адрес доставки: </td>
                    <td><textarea name="address">{{address}}</textarea></td>
                </tr>

            </table>


            <p><input type='submit' value='Оформить!' /></p>

        </form>
        {% else %}

        <p>В Вашей корзине пока нет товаров. </p>
        
        {% endif %}

    </div>
{% endblock %}

{% block cart_sidebar %}
{% endblock %}