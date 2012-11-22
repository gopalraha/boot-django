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
export home_dir=`pwd`

django-admin.py startproject $project

mkdir ~/$project/$project/static
cp $cwd/django_icon.png ~/$project/$project/static
ln -s /usr/lib/python2.7/dist-packages/django/contrib/admin/media ~/$project/$project/static/admin

pushd ~/$project/$project/static/admin/img
sudo ln -s admin/* .
sudo ln -s gis/* .
popd

echo "***************** httpd.conf:"
cat $cwd/httpd.conf | \
        sed "s=HOME=$home_dir=g" | \
        sed "s=PROJECT=$project=g" | \
        sudo tee /etc/apache2/httpd.conf

mv ~/$project/$project/wsgi.py ~/$project/$project/wsgi.py.bak
echo "***************** ~/$project/$project/wsgi.py"
cat $cwd/wsgi.py | \
        sed "s=HOME=$home_dir=g" | \
        sed "s=PROJECT=$project=g" | \
        tee ~/$project/$project/wsgi.py

cd ~/$project
python manage.py startapp $application
cd $application
chmod a+w . 

mv ~/$project/$project/urls.py ~/$project/$project/urls.py.bak
echo "***************** urls.py:"
cat $cwd/urls.py | \
        sed "s=APPLICATION=$application=g" | \
        tee ~/$project/$project/urls.py

mv ~/$project/$project/settings.py ~/$project/$project/settings.py.bak
echo "***************** settings.py:"
cat $cwd/settings.py | \
        sed "s=HOME=$home_dir=g" | \
        sed "s=PROJECT=$project=g" | \
        sed "s=APPLICATION=$application=g" | \
        sed "s=mydjangoapp_password=$db_pswd=g" > \
	~/$project/$project/settings.py 

cp $cwd/views.py ~/$project/$application
mkdir ~/$project/$application/html
cp $cwd/index.html ~/$project/$application/html 

echo "*********************************************************"
echo "****Please cut and paste these lines into Postgres******"
echo "*********************************************************"
echo "ALTER USER postgres WITH PASSWORD '$db_pswd';"
echo "\q"
echo "*********************************************************"
sudo su postgres -c psql template1

sudo passwd -d postgres
sudo su postgres -c passwd

echo "*********************************************************"
echo "****Please cut and paste these lines into Postgres******"
echo "*********************************************************"
echo "CREATE USER mydjangoapp WITH PASSWORD '$db_pswd';"
echo "create database mydjangoappdb;"
echo "grant all privileges on database mydjangoappdb to mydjangoapp;"
echo "\q"
echo "*********************************************************"
sudo su postgres -c psql template1

sudo sh -c 'echo "local   mydjangoappdb     mydjangoapp                         md5" >>  /etc/postgresql/9.1/main/pg_hba.conf '

sudo service postgresql restart

pushd ~/$project
# These two lines are needed for GCE
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
python manage.py syncdb
popd

sudo service apache2 restart
popd
