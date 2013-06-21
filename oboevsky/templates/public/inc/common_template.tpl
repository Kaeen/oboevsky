<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <!--<meta name="google-site-verification" content="2YvCIVqZpQsJ94T50ADKcWq6vRBp31f23cNQ9-zx5X8" />
    <meta name='yandex-verification' content='79ebedfb7b6478a9' />-->
    <title>{% block page_title %}Обоевский{% endblock %}</title>
    <meta name="content-type" content="text/html;encoding=utf-8" />
    <meta name="description" content="{% block meta_description %}{% endblock %}" />
    <meta name="keywords" content="{% block meta_keywords %}{% endblock %}" />
    <meta name='yandex-verification' content='6eae11a050283af2' />
    {% block extra_meta %}{% endblock %}

    <link media="all" rel="stylesheet" href="/static/css/common.css" />
    {% block page_css %}{% endblock %}

    {% block page_scripts %}
          <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
          <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
          <script src="/static/js/jquery.mousewheel.min.js"></script>
          <script src="/static/js/jquery.mCustomScrollbar.min.js"></script>
    {% endblock %}
    <!--
    <script type="text/javascript">
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-33434730-1']);
      _gaq.push(['_setDomainName', '{{Request.META.HTTP_HOST}}']);
      _gaq.push(['_setAllowLinker', true]);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    </script>
    -->
</head>
<body id="{% block body_id %}{% endblock %}">
{% block body %}{% endblock %}
</body>
</html>