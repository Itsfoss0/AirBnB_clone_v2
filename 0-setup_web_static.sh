#!/usr/bin/env bash
#set things up for deployment
HTML_CONTENT=\
"
<html>
    <head>
        <title>A dumy page </title>
    </head>
    <body>
        Hi Human, good to see you here
    </body>
</html>
"
NGINX_CONFIG=\
"
server {
 	listen	80;
	location /hbnb_static/ {
		 alias /data/web_static/current/;
		 index index.html;
	}
}	
"
if ! [[ "$(which nginx)" ]]; then
    sudo apt-get -y update
    sudo apt-get install nginx
fi

if ! [[ -d /data/web_static/releases/test/ ]]; then
    sudo mkdir -p /data/web_static/releases/test/
fi
sudo chown -R ubuntu:ubuntu /data/

echo -e "$HTML_CONTENT" > /data/web_static/releases/test/index.html

if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi

ln -sf /data/web_static/releases/test/ /data/web_static/current

echo -e "$NGINX_CONFIG" > /etc/nginx/sites-enabled/default

sudo service nginx restart