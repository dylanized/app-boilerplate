#! /usr/bin/env bash

echo "[System] Starting system provisioning"

# Version Vars
NODEVERSION=v4.2.2
PHPVERSION=php5-5.6
MYSQLVERSION=mysql-server-5.5

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

# MYSQL ########################################################################

echo "[System] Installing MySQL specific packages and settings"
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections

echo "[System] Installing PHPMyAdmin"
apt-get -y install $MYSQLVERSION phpmyadmin

# PHP/APACHE ##################################################################

echo "[System] Installing PHP-specific packages"
apt-get -y install php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql php-apc php-pear

echo "[System] Enabling mod-rewrite"
a2enmod rewrite

echo "[System] Allowing Apache override to all"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo "[System] Setting document root to public directory"
rm -rf /var/www
ln -fs /vagrant/public /var/www

echo "[System] We definitly need to see the PHP errors, turning them on"
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
    ErrorLog ${APACHE_LOG_DIR}/phpmyadmin-error.log
    CustomLog ${APACHE_LOG_DIR}/phpmyadmin-access.log combined
</VirtualHost>
EOF
a2enconf phpmyadmin

# COMPOSER ##############################################################

echo "[System] Installing Composer for PHP package management"
curl https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# NODE ##################################################################

echo "[System] Installing NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash

echo "[System] Installing Node"
source ~/.nvm/nvm.sh
nvm install $NODEVERSION
nvm alias default $NODEVERSION
nvm use default

echo "[System] Using node -v"
node -v

# BOWER #################################################################

echo "[System] Installing Bower"
npm install -g bower

# DOTFILES ###############################################################

if [ -e /home/vagrant-shared/.bash_profile ]
then
	echo "[System] Found .bash_profile, creating symlink"
	ln -s /home/vagrant-shared/.bash_profile /home/vagrant/.bash_profile
else
	echo "[System] Skipping .bash_profile symlink"
fi

echo "[System] System provision complete"