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
# install nginx if not present
if ! [[ "$(which nginx)" ]]; then
	sudo apt-get update -y  && \
	     sudo apt-get install -y nginx
fi



# Create directories...
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared/

# setup some fake content
echo -e "$HTML_CONTENT" > data/web_static/releases/test/index.html

# create sym link
sudo ln -sf /data/web_static/releases/test /data/web_static/current

# changing ownership of the /data/ dir to
sudo chown -R ubuntu:ubuntu /data/

# backup default server config file
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/conf.d/backup.bck


sudo sed -i '37i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default

sudo service nginx restart
