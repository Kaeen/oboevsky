{% extends "public/inc/common_sitepage.tpl" %}

{% block sorting %}{% endblock %}

{% block content %}
    <div class="contentBlockNoBorder">
        <div id="breadcrumps">
            <a href="/">Главная</a> / Регистрация
        </div>

        {%if error %}

            <h1>Ошибка</h1>
            <p>{{error}}</p>

        {%else%}

            <h1>Здравствуйте!</h1>
            <p>Для того, чтобы мы могли всегда Вас узнать и предложить Вам наилучшие условия сотрудничества, лучше всего иметь учётную запись. Это позволит нам запоминать, что Вы заказываете, предлагать Вам новые товары и сокращать время, которые Вы тратите на заполнение различных форм при заполнении заказа. </p>
            <p>Всё, что нужно сделать — это заполнить форму ниже. </p>

        {%endif%}


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

            {% csrf_token %}


            <table id="order-form-table">

                <tr>
                    <td class="field-caption-wrapper red">Имя: </td>
                    <td><input name="first_name" type="text" value="{{first_name}}" /></td>
                </tr>


                <tr>
                    <td class="field-caption-wrapper">Отчество: </td>
                    <td><input name="second_name" type="text" value="{{second_name}}" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">Фамилия: </td>
                    <td><input name="surname" type="text" value="{{surname}}" /></td>
                </tr>


                <tr>
                    <td class="field-caption-wrapper red">Пароль: </td>
                    <td><input name="pass" type="password" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">Подтверждение пароля: </td>
                    <td><input name="pass2" type="password" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">e-mail: </td>
                    <td><input name="email" type="text" value="{{email}}" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">Телефон: </td>
                    <td><input name="phone" type="text" value="{{phone}}" /></td>
                </tr>

                <tr>
                    <td class="field-caption-wrapper red">Адрес доставки: </td>
                    <td><textarea name="address">{{address}}</textarea></td>
                </tr>

            </table>


            <p><input type='submit' value='Оформить!' /></p>

        </form>
    </div>
{% endblock %}