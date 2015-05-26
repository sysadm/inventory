## About Inventory

Inventory is a Ruby on Rails stand-alone multilanguage software for mid-size/large companies to store information about
all hardware in stock. It was created for internal purpose of [Multitel A.S.B.L.](http://www.multitel.be/)
(non-profit organisation) by Jerzy Sładkowski. Our company just need to have custom but fast and effective web based application
with complete information about any equipment including type, model, serial, date of purchase, warranty, vendor, user etc.

Features
--------

* Easy install and using (autocomplete and ajax autocomplete in forms).
* As a backend author use sqlite for some internal Multitel reason. But you can use any other database which supported by ActiveRecord as well.
* Two way login. You can use your LDAP or standard login/pass authentication (take a look on screenshots section).
* Three roles for authorization. You can be administrator (read/write anything), read only user (read access everywhere), user (read only access to equipment assigned to you).
* Changing user access permissions on the fly.
* Live search. Main goal of this application 'cause you can find the hardware by its sticker number or any other information (user, vendor, serial, model etc) just in few clicks.
* Automatic backup system with versioning. If you change anything in your equipment (modify model/description, delete old one or add new one) next backup of all database to CSV file will be created in background. You always can restore any previous state of your system by rollback to specific version.
* CSV import for massive changes of database.
* Automatic tests with poltergeist or selenium (if you prefer to observe what's going on) to easy support and upgrade application/environment.

## Screenshots

Login page

[![inventory screenshot1](https://github.com/sysadm/inventory/raw/master/doc/screenshots/screen1.jpg)](#login)

Main page

[![inventory screenshot2](https://github.com/sysadm/inventory/raw/master/doc/screenshots/screen2.jpg)](#main)

Live search in action (french localization)

[![inventory screenshot3](https://github.com/sysadm/inventory/raw/master/doc/screenshots/screen3.jpg)](#live-search)

CSV backups

[![inventory screenshot4](https://github.com/sysadm/inventory/raw/master/doc/screenshots/screen4.jpg)](#backups)


## Getting Started

1. Install sqlite development package
2. Install [RVM](http://rvm.io/) and source it (better way: add `source ~/.rvm/scripts/rvm` to your .profile or .bashrc for autoload).
3. `git clone git@github.com:sysadm/inventory.git`
4. `cd inventory && bundle install`
5. `rake db:create && rake db:migrate && rake db:seed && bin/delayed_job start && rails server`
6. use it!

**Note:** *You can find very detailed installation example [here](https://github.com/sysadm/inventory/raw/master/doc/INSTALL)*


## License

Inventory is released under the [GNU General Public License](http://www.gnu.org/licenses/).


## Contributing

Since this is a completely free software under GPL license - **feel free to contribute**, improve its source code or give me constructive criticism.
Your git pull request will be pleasantly welcome.


#####Thanks a lot for using!
**Author**
