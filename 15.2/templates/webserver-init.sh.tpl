#!/bin/bash
# Выполняется на каждой ВМ Instance Group при старте (передаётся через
# metadata.user-data — см. задание: "рекомендуется использовать раздел
# user_data в meta_data"). LAMP-образ (fd827b91d99psvq5fjit) уже содержит
# Apache — просто перезаписываем стартовую страницу.
cat > /var/www/html/index.html << HTML
<!DOCTYPE html>
<html>
  <head><title>HW15.2 — Instance Group + Load Balancer</title></head>
  <body style="font-family: sans-serif; text-align: center; padding-top: 80px;">
    <h1>Привет от $(hostname)!</h1>
    <p>Эта страница раздаётся с одной из ВМ в Instance Group за балансировщиком нагрузки.</p>
    <img src="${picture_url}" alt="Demo picture" style="max-width: 500px; border: 4px solid #333;">
  </body>
</html>
HTML
