{% extends "public/inc/common_sitepage.tpl" %}

{% block sorting %}{% endblock %}

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
            
            <a href="/">Главная</a> / <a href="/account/">Личный кабинет</a> / Личные данные

            <p></p>

            {# TODO: написать нормальный текст #}


            <style type="text/css">
                #order-form-table input {
                    height: 18px;
                }
                #order-form-table textarea {
                    height: 40px;
                }

                #order-form-table {
                    margin-top: 10px;
                }

                #order-form-table td {
                    vertical-align: top;
                }

                #order-form-table input,
                #order-form-table textarea {
                    border: 1px solid #ccc;
                    width: 300px;
                    padding: 0 2px 2px 2px;
                    margin: 0px;
                    font-size: 13px;
                }

                .field-caption-wrapper {
                    width: 120px;
                    font-size: 14px;
                }

                #order-form-table .red {
                    color: #C00;
                }

                #order-form-table p {
                    padding-bottom: 10px;
                }
            </style>


            <form action="?do" method="post">

                {%if error %}
                    <p>{{error}}</p>
                {%endif%}

                {% csrf_token %}

                <table id="order-form-table">

                    <tr>
                        <td class="field-caption-wrapper red">Пароль: </td>
                        <td><input name="old-pass" type="password" /></td>
                    </tr>

                    <tr>
                        <td colspan="2"><br /></td>
                    </tr>

                    <tr>
                        <td class="field-caption-wrapper">Имя: </td>
                        <td><input name="first_name" type="text" value="{{first_name}}" /></td>
                    </tr>


                    <tr>
                        <td class="field-caption-wrapper">Отчество: </td>
                        <td><input name="second_name" type="text" value="{{second_name}}" /></td>
                    </tr>

                    <tr>
                        <td class="field-caption-wrapper">Фамилия: </td>
                        <td><input name="surname" type="text" value="{{surname}}" /></td>
                    </tr>

                    <tr>
                        <td class="field-caption-wrapper">e-mail: </td>
                        <td><input name="email" type="text" value="{{email}}" /></td>
                    </tr>

                    <tr>
                        <td class="field-caption-wrapper">Телефон: </td>
                        <td><input name="phone" type="text" value="{{phone}}" /></td>
                    </tr>

                    <tr>
                        <td class="field-caption-wrapper">Адрес доставки: </td>
                        <td><textarea name="address">{{address}}</textarea></td>
                    </tr>

                </table>

                <p><input type='submit' value='Сохранить' /></p>
            </form>

        </div>

    </div>
{% endblock %}