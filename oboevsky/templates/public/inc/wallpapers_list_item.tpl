<div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}'); cursor:pointer;" onClick="javascript:document.location.href='{{item.get_absolute_url}}?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}';">
    {% if item.get_first_image %}
        <a href="{{item.get_absolute_url}}?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}">
            <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
        </a>
    {% endif %}
    <p class="title-container">
        <a href="{{item.get_absolute_url}}?q={{group.2.0.id}}{% for t in group.2|slice:"1:" %},{{t.id}}{% endfor %}"><b style="text-decoration:none;">{{item.title}}</b></a><br />
        {% if not no_categories %}
            {% for c in item.categories.all %}
                {{c.title}}<br />
            {% endfor %}
        {% endif %}
        {% if not no_materials %}
            {{materials_as_text}}<br />
        {% endif %}
        {{item.price|floatformat:"-3"}} руб.
    </p>
    <p><a class="buy-link" href="/put-to-cart/{{item.pk}}">Купить</a></p>
</div>