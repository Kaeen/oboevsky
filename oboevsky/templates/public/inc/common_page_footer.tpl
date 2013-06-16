<div id="footerWrapper" class="clear">
    <div id="copyrightWrapper" class="left">
        <p><strong>&copy; Обоевский 2012г.</strong></p>
        <p>
            +7-495-201-38-68<br />
            skype: oboevsky
        </p>
    </div>
    <div id="bottomMenu" class="left">
        <p><a href="/">Главная</a> &middot;
            {% for flatpage in flatpages %}
                <a href="{{flatpage.url}}">{{flatpage.title}}</a>
                {#{% if not forloop.last %} &middot; {% endif %}#}
                &middot;
            {% endfor %}
  
            {% if user.is_authenticated %}
                <a href="/account">Личный кабинет</a>
            {% else %}
                <a href="/login">Авторизация</a>
            {% endif %}
        </p>
        <p id="publicNote">Цены на данном сайте не являются публичной офертой согласно законодательству РФ</p>
    </div>
    <div id="signatureWrapper" class="right">
        <img alt="" src="/static/images/signature.png" />
    </div>
</div>