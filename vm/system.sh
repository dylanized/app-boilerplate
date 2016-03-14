#! /usr/bin/env bash

echo "[System] Starting system provisioning"

# Vars
NODEVERSION=v4.2.2
PHPVERSION=php5-5.6
MYSQLVERSION=mysql-server-5.6

DBPASSWD=root

# SETUP ########################################################################

echo "[System] Cleaning old packages"
sudo apt-get autoremove
	
echo "[System] Updating packages list"
apt-get -qq update

echo "[System] Installing base packages"
apt-get -y install vim curl build-essential python-software-properties git libssl-dev

echo "[System] Add some repos to update our distro"
add-apt-repository ppa:ondrej/$PHPVERSION
add-apt-repository ppa:chris-lea/node.js

echo "[System] Updating packages list"
apt-get -qq update

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

# PHP/APACHE ##################################################################

echo "[System] Installing PHP-specific packages"
apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc

echo "[System] Enabling mod-rewrite"
a2enmod rewrite

echo "[System] Allowing Apache override to all"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.confx

echo "[System] Enabling PHP errors"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

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
mv composer.phar /usr/local/bin/composer

# NODE ##################################################################

echo "[System] Installing NodeJS and NPM"
apt-get -y install nodejs
curl https://npmjs.org/install.sh | sh

# BOWER #################################################################

echo "[System] Installing Bower"
npm install -g bower

# DOTFILES ###############################################################

if [ -e /home/vagrant-shared/.bash_profile ]
then
	echo "[System] Found .bash_profile, creating symlink"
	ln -s /home/vagrant-shared/.bash_profile /home/vagrant/.bash_profile
else
	echo "[System] No .bash_profile found, skipping symlink"
fi

echo "[System] System provision complete"