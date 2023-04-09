#!/usr/bin/python3

"""
Deploy the to a remote server
Usage: ./2_do_deploy_web_static.py do_deploy
"""

from fabric.api import env, task, put, run
from os import path

env.hosts = ['54.146.84.110', '100.26.156.138']


@task(alias="deploy")
def do_deploy(archive_path) -> bool:
    """
    Deploy the application to the web servers
    Args:
        None
    Returns:
        True ( if all goes well)
        False (if something is not right)
    """
    try:
        if not path.exists(archive_path):
            return False
        else:
            f_name = archive_path.split("/")[-1].split(".")[0]
            run("mkdir -p /data/web_static/releases/{}".format(f_name))

            run("tar -xzf /tmp/{}.tgz -C /data/web_static/releases/{}/"
                .format(f_name, f_name))

            run('rm -rf /tmp/{}.tgz'.format(f_name))

            run(('mv /data/web_static/releases/{}/web_static/* ' +
                '/data/web_static/releases/{}/')
                .format(f_name, f_name))

            run('rm -fr /data/web_static/releases/{}/web_static'
                .format(f_name))

            run('rm -fr /data/web_static/current')

            run(('ln -sf /data/web_static/releases/{}/' +
                ' /data/web_static/current')
                .format(f_name))
            put(archive_path, '/tmp/')
            return True
    except Exception:
        return False
