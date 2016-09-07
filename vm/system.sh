#! /usr/bin/env bash

echo "[System] Starting system provisioning"

# System Vars
NODEVERSION=v4.4.0
MYSQLVERSION=mysql-server-5.6

# DB Vars
DBPASSWD=root

# PHP Vars
PHP_INI=/etc/php5/apache2/php.ini
LOG_FOLDER=/vagrant/logs
PHP_ERROR_LOG=/vagrant/logs/php_errors.log
COMPOSER_PATH=/usr/local/bin/composer

# Shell Vars
PROFILE_SOURCE=/home/vagrant-shared/.bash_profile
PROFILE_GUEST=/home/vagrant/.bash_profile

# Repos
PHP_REPO=ppa:ondrej/php5-5.6
# PHP_REPO=ppa:ondrej/php
NODE_REPO=ppa:chris-lea/node.js

# SETUP ########################################################################

echo "[System] Cleaning old packages"
sudo apt-get autoremove
	
echo "[System] Updating packages list"
apt-get -qq update

echo "[System] Installing base packages"
apt-get -y install vim curl build-essential python-software-properties git libssl-dev

echo "[System] Add some repos to update our distro"
add-apt-repository $PHP_REPO
add-apt-repository $NODE_REPO

echo "[System] Updating packages list"
apt-get -qq update

# LOG FOLDER ###################################################################

if [ -e $LOG_FOLDER ]
then
	echo "[System] Found log folder"
else
	echo "[System] Log folder not found, creating it"
	mkdir $LOG_FOLDER
fi

echo "[System] Setting permissions on log folder"
chmod -R 777 $LOG_FOLDER

# MySQL #######################################################################

echo "[System] Installing MySQL"

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

apt-get -y install $MYSQLVERSION

# PHPMyAdmin ##################################################################

echo "[System] Installing PHPMyAdmin"

sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get -y install phpmyadmin

# MongoDB ####################################################################

echo "[System] Installing MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org

# PHP+APACHE SETUP #############################################################

echo "[System] Installing PHP-specific packages"
apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc

echo "[System] Enabling mod-rewrite"
a2enmod rewrite

echo "[System] Allowing Apache override to all"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.confx

# PHP ERRORS ###################################################################

echo "[System] Enabling PHP errors"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" $PHP_INI
sed -i "s/display_errors = .*/display_errors = On/" $PHP_INI

echo "[System] Enabling PHP error log and setting path"
echo "error_log = $PHP_ERROR_LOG" >> "$PHP_INI"

echo "[System] Initializing PHP error log"
sh /vagrant/scripts/log.sh $PHP_ERROR_LOG 'PHP error log'

# APACHE CONFIG #################################################################

echo "[System] Turn off disabled pcntl functions so we can use Boris"
sed -i "s/disable_functions = .*//" /etc/php5/cli/php.ini

echo "[System] Configure Apache to use phpmyadmin"
echo "Listen 81" >> /etc/apache2/ports.conf
cat > /etc/apache2/conf-available/phpmyadmin.conf << "EOF"
<VirtualHost *:81>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/share/phpmyadmin
    DirectoryIndex index.php
    ErrorLog /var/log/apache2/phpmyadmin-error.log
    CustomLog /var/log/apache2/phpmyadmin-access.log combined
</VirtualHost>
EOF
a2enconf phpmyadmin

# COMPOSER ##############################################################

echo "[System] Installing Composer for PHP package management"
curl https://getcomposer.org/installer | php
mv composer.phar $COMPOSER_PATH

# NODE ##################################################################

echo "[System] Installing NodeJS and NPM"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs

# UPGRADE NPM ###########################################################

echo "[System] Upgrading NPM"
npm install -g npm@latest

# MOCHA #################################################################

echo '[System] Installing Mocha'
npm install -g mocha

# BOWER #################################################################

echo "[System] Installing Bower"
npm install -g bower

# REDIS #################################################################

echo "[System] Making download folder for Redis"
mkdir /opt/redis
cd /opt/redis

echo "[System] Downloading latest stable version of Redis"
wget -q http://download.redis.io/redis-stable.tar.gz

echo "[System] Updating with new files"
tar -xz --keep-newer-files -f redis-stable.tar.gz

echo "[System] Running Redis install script"
cd redis-stable
make
make install

if [ -e /etc/redis.conf ]
then
	echo "[System] Removing default Redis config file"
	rm /etc/redis.conf
fi

echo "[System] Creating Redis folders and setting permissions"
mkdir -p /etc/redis
mkdir /var/redis
chmod -R 777 /var/redis

echo "[System] Adding user for Redis"
useradd redis

echo "[System] Copying Redis config file"
cp -u /vagrant/redis/redis.conf /etc/redis/6379.conf

echo "[System] Copying Redis executable"
cp -u /vagrant/redis/redis.init.d /etc/init.d/redis_6379

echo "[System] Adding Redis to Ubuntu startup"
update-rc.d redis_6379 defaults

echo "[System] Setting permissions on Redis executable"
chmod a+x /etc/init.d/redis_6379

echo "[System] Starting Redis"
/etc/init.d/redis_6379 start

# NODE-SASS ##############################################################

echo "[System] Installing node-sass"
npm install -g node-sass

# NPM-RUN-ALL ###########################################################

echo "[System] Installing npm-run-all"
npm install -g npm-run-all

# NODE-DEV ##############################################################

echo "[System] Installing Nodemon"
npm install -g nodemon

# DOTFILES ###############################################################

cd /home/vagrant

if [ -e $PROFILE_SOURCE ]
then
	echo "[System] Found .bash_profile, creating symlink"
	ln -s $PROFILE_SOURCE $PROFILE_GUEST
else
	echo "[System] Skipping .bash_profile symlink"
fi

echo "[System] System provision complete"