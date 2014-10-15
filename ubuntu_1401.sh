sudo apt-get update
sudo apt-get upgrade
sudo apt-get install python-pip
sudo apt-get install libpq-dev python-dev
sudo apt-get install postgresql postgresql-contrib
sudo pip install psycopg2
sudo apt-get install nginx
sudo pip install django
sudo pip install gunicorn
echo "Pause to set up the database and the database user:"
echo "sudo su - postgres"
echo "createdb django_db"
echo "createuser –P django_user"
echo "psql"
echo "GRANT ALL PRIVILEGES ON DATABASE django_db TO django_user;"
echo "\\q"
read -p "Resume when done" pause
export cwd=`pwd`
sudo cp $cwd/default.nginx /etc/nginx/sites-enabled/
django-admin.py startproject Appsite
cd Appsite
read -p "Edit settings.py to fold database settings from db_settings.py into settings.py" pause
python manage.py syncdb
sudo service nginx restart
gunicorn Appsite.wsgi:application --bind localhost:8001 &
