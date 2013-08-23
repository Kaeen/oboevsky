{% extends "public/inc/common_sitepage.tpl" %}

{% block left_sidebar %}
<div class="pageSidebar left">
        <div class="pageColumn">
            <h2>Личный кабинет</h2>
            <ul class="no-list">
            	{# TODO: selection #}
                <li><a href="/account/">Личные данные</a></li>
                <li><a href="/account/change-password/">Смена пароля</a></li>
                <li><a href="/account/order-history/">Мои заказы</a></li>
            </ul>
        </div>
</div>
{% endblock %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">

            <a href="/">Главная</a> / <a href="/account/">Личный кабинет</a> / Мои заказы

            <p></p>

            <p>//TODO//</p>

            {% for order in order_history %}

            <table id="cart-form" width="100%">

                <tr class="form-line">
                    <td class="title-col">
                        Товар
                    </td>
                    <td class="quantity-col">
                        Количество
                    </td>
                </tr>

                {% for item in order.items %}

                <tr class="form-line">
                    <td class="title-col">
                        <a href="{{item.get_absolute_url}}">
                            <div class="cart-item-title" style="background: url('{{item.get_first_image.image.url_170x111}}') repeat-x;">
                                <p>{{item.title}}</p>
                            </div>
                        </a>
                    </td>
                    <td class="quantity-col">
                        {{item.quantity}} рулонов {% if item.total %}sпо {{item.price}} рублей каждый {% endif %}
                    </td>
                </tr>

                {% endfor %}

            </table>

            {% endfor %}


        </div>

    </div>
{% endblock %}