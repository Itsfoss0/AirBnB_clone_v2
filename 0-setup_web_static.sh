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
sudo apt-get -y update && sudo apt-get -y install nginx 
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared/

echo -e "$HTML_CONTENT" > /data/web_static/releases/test/index.html

# create sym link, if it already exists, replace it.
sudo ln -sf /data/web_static/releases/test /data/web_static/current

sudo chown -R ubuntu:ubuntu /data/

echo -e "$NGINX_CONFIG" > /etc/nginx/sites-available/default

sudo service nginx restart
