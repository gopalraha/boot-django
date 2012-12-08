# boot-django

## Bootstrap Django 1.4.1 on ubuntu

### About

This project contains a script for a fresh install of Django.
It is based on `ami-82fa58eb`, an Ubuntu Precise 12.04 AMD64 Server AMI.
I used [Eddy Chan's Blog](http://eddychan.com/post/18484749431/) as the source.

To install, once you get a fresh instance, do a

    git clone https://github.com/singhj/boot-django.git
    
in a user directory. Then, run the `a_base_install.sh` script. 
When the script completes, edit `settings.py` appropriately and populate project files.

### Caveats

* Django admin interfaces are turned on in this build. You can comment them out if you want.
* It's been tested for the AMI mentioned above. For other AMIs, your mileage will vary.
* The script calls for three inputs. There are no defaults -- all three inputs must be provided.
* It would be nice if the script was restartable in the event of errors.
* It is set up to install and use Postgres as the back end database.

### Open to pull requests

If you get the script working on another platform, or another AMI, please send me a pull request.

### Postscript

You will probably want to make these adjustments on your machine

* Keep the clock synchronized: [Ubuntu Time](https://help.ubuntu.com/community/UbuntuTime)
* Set up ownership of `/var/log/apache2` and any Django loggers to `www-data` (the Apache user) and `ubuntu`, respectively. See [this](http://superuser.com/questions/95972/how-do-i-add-a-user-to-multiple-groups-in-ubuntu) for how to.

### Securing Django

With inspiration from [Red Robot Studios](http://www.redrobotstudios.com/blog/2009/02/18/securing-django-with-ssl/)... 

* [Create and purchase certificates](https://knowledge.rapidssl.com/support/ssl-certificate-support/index?page=content&actp=CROSSLINK&id=so13985).
* [Deploy mod_ssl](http://serverfault.com/questions/446328/aws-installing-mod-ssl-on-apache).
* [Configure Apache for https](https://help.ubuntu.com/10.04/serverguide/httpd.html#https-configuration).
* [Configure Django for https](http://stackoverflow.com/questions/2131727/django-and-ssl-question).
* Install the certificates and key files into `/etc/ssl/private`.
* Turn off HTTP by commenting out the `NameVirtualHost *:80` and `Listen 80` lines in `ports.conf`.
