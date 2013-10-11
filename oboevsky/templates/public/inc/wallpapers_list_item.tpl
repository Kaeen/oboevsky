<div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}'); cursor:pointer;" onClick="javascript:document.location.href='{{item.get_absolute_url}}';">
    {% if item.get_first_image %}
        <a href="{{item.get_absolute_url}}">
            <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
        </a>
    {% endif %}
    <p class="title-container">
        <a href="{{item.get_absolute_url}}"><b style="text-decoration:none;">{{item.title}}</b></a><br />
        {{item.price|floatformat:"-3"}} руб.
    </p>
    <p><a href="/put-to-cart/{{item.pk}}">Купить</a></p>
</div>