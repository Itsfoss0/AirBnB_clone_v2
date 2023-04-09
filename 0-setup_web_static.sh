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
function install_nginx(){
    #start with installing nginx( if it's not already installed)
    if ! [[ "$(which nginx)" ]]; then
        #install nginx
        sudo apt-get -y update
        sudo apt-get -y install nginx
    fi
}
#creating folders if they dont exist
function create_folders(){
    if ! [[ -d "/data/web_static/releases/test/" ]]; then
        mkdir -p /data/web_static/releases/test/ /data/web_static/shared/
    fi
    chown -R ubuntu:ubuntu /data/
}

#creating fake HTML files
function create_fake_html(){
    if ! [[ -s "/data/web_static/releases/test/index.html" ]]; then
        echo -e "$HTML_CONTENT" > /data/web_static/releases/test/index.html
    fi
}

#creating a symlink ( if it doen't already exist)
function create_symlink(){
    if [[ -L /data/web_static/current ]]; then
    rm /data/web_static/current
    fi

    ln -s /data/web_static/releases/test/ /data/web_static/current
}

#configure nginx
function configure_nginx(){
echo  -e "$NGINX_CONFIG" > /etc/nginx/sites-available/default
}

function restart_nginx() {
    if [[ "$(pgrep nginx)" ]]; then
        sudo service nginx restart
    else
        sudo service nginx start
    fi
}
install_nginx;
create_folders;
create_fake_html;
create_symlink;
restart_nginx;