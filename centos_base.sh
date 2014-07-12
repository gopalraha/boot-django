#!/bin/bash
sudo yum -y install postgresql postgresql-client postgresql-contrib python-pygresql
sudo yum -y install postgresql-devel
sudo yum -y install postgresql-server
sudo service postgresql restart
sudo service postgresql initdb
sudo service postgresql restart
sudo easy_install psycopg2
sudo yum -y install python-devel
sudo easy_install psycopg2
mkdir ~/base-django
cd ~/base-django/
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -ivh epel-release-6-8.noarch.rpm
sudo yum -y install yum-priorities
sudo sed -i '/\[epel\]/a priorities=10' /etc/yum.repos.d/epel.repo
# sudo yum -y install mod_python
sudo yum -y install mod_wsgi
sudo easy_install Django

echo "Modules are installed, configuration begins..."
