# boot-django

## Bootstrap Project for installing Django 1.4.1 on ubuntu

### This build is based on `ami-82fa58eb`, an Ubuntu Precise 12.04 AMD64 Server AMI

Source: [Eddy Chan's Blog](http://eddychan.com/post/18484749431/)

To install everything, do a

    git clone https://github.com/singhj/boot-django.git
    
in a user directory once you fire up the server. Then, run the `a_base_install.sh` script. 
When the script completes, edit up `settings.py` appropriately and and populate project files.

### Caveats

* It's been tested for the AMI mentioned above. For other AMIs, your mileage _will_vary.
* The script calls for three inputs. There are no defaults -- all three inputs must be provided.
* It would be nice if the script was restartable in the event of errors.
* It is set up to install Postgres as the back end database.

### Open to pull requests

If you get the script working on another platform, or another AMI, please send me a pull request.
