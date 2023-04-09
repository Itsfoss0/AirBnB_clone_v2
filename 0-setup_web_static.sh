#!/usr/bin/env bash
#set things up for deployment

MY_HTML=\
"
<html>
    <head>
        <title>DevOps is Fun </title>
    </head>
    <body>
        <h2> Getting started with DevOps </h2>
    </body>
</html>
"
if [ ! -x /usr/sbin/nginx ]; then
	sudo apt-get update -y -qq && \
	    sudo apt-get install -y nginx
fi


# make dirs...
sudo mkdir -p /data/web_static/releases/test  /data/web_static/shared/


echo -e "$MY_HTML" > /data/web_static/releases/test/index.html

# create sym link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

sudo chown -R ubuntu:ubuntu /data/


sudo cp /etc/nginx/sites-enabled/default /etc/nginx/nginx-sites-enabled_default.bck


sudo sed -i '37i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

sudo service nginx restart
