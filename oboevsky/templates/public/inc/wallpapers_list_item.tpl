<a href="{{item.get_absolute_url}}"><div class="item new-look" style="background:url('{{item.get_first_image.image.url_170x111}}');">
    {% if item.get_first_image %}
        
            <img src="{{item.get_first_image.image.url_170x111}}" alt="{{item.short_desc}}" />
        
    {% endif %}
    <p class="title-container">
        <b>{{item.title}}</b><br />
        {{item.price|floatformat:"-3"}} руб.
    </p>
    <p><a href="/put-to-cart/{{item.pk}}">В корзину</a></p>
</div></a>