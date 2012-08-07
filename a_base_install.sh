echo "This script needs you to provide a project name and an application name."
echo "The two names you provide need to be different."

read -p "Please enter the project name            " project
read -p "Please enter the application name        " application
read -p "Please enter a password for the database " db_pswd

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install build-essential
sudo apt-get -y install apache2 libapache2-mod-python
sudo apt-get -y install libapache2-mod-wsgi
sudo apt-get -y install python-pip
sudo apt-get -y install python-dev
sudo pip install django
sudo apt-get -y install python-django

sudo apt-get -y install postgresql postgresql-client postgresql-contrib python-pygresql
sudo apt-get -y install postgresql-server-dev-all
sudo easy_install psycopg2

echo "Modules are installed, configuration begins..."
echo ""
export cwd=`pwd`

pushd ~
django-admin.py startproject $project
mkdir ~/$project/$project/static

echo "httpd.conf:"
sed "s/project/$project/g" < $cwd/httpd.conf | sudo tee /etc/apache2/httpd.conf

mv ~/$project/$project/wsgi.py ~/$project/$project/wsgi.py.bak
echo "~/$project/$project/wsgi.py"
sudo sed "s/project/$project/g" < $cwd/wsgi.py | tee ~/$project/$project/wsgi.py

mkdir ~/$project/$project/static/admin
ln -s /usr/lib/python2.7/dist-packages/django/contrib/admin/media ~/$project/$project/static/admin

cd ~/$project
python manage.py startapp $application
cd $application
chmod a+w . 

mv ~/$project/$project/urls.py ~/$project/$project/urls.py.bak
echo "urls.py:"
sed "s/application/$application/g" < $cwd/urls.py | tee ~/$project/$project/urls.py

mv ~/$project/$project/settings.py ~/$project/$project/settings.py.bak
echo "settings.py:"
cat $cwd/settings.py | \
    sed "s/PROJECT/$project/g" | \
    sed "s/APPLICATION/$application/g" > \
    sed "s/mydjangoapp_password/$db_pswd/g" > \
    ~/$project/$project/settings.py 

echo "*********************************************************"
echo "****Please cut and paste these lines into Postgres******"
echo "*********************************************************"
echo "template1=# ALTER USER postgres WITH PASSWORD '$db_pswd';"
echo "template1=# \q"
echo "*********************************************************"
sudo su postgres -c psql template1

sudo passwd -d postgres
sudo su postgres -c passwd

echo "*********************************************************"
echo "****Please cut and paste these lines into Postgres******"
echo "*********************************************************"
echo "postgres=# CREATE USER mydjangoapp WITH PASSWORD '$db_pswd';"
echo "postgres=# create database mydjangoappdb;"
echo "postgres=# grant all privileges on database mydjangoappdb to mydjangoapp;"
echo "postgres=# \q"
echo "*********************************************************"
sudo su postgres -c psql template1

sudo sh -c 'echo "local   mydjangoappdb     mydjangoapp                         md5" >>  /etc/postgresql/9.1/main/pg_hba.conf '

sudo service postgresql restart

pushd ~/$project
python manage.py syncdb
popd

sudo service apache2 restart
popd
