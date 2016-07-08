echo '[App] Starting app provision'

# Env Vars
APPENV=local
NODEENV=development

# DB Vars
DBHOST=localhost
DBNAME=foo
DBUSER=root
DBPASSWD=root

# Apache Vars
APACHE_ERROR_LOG=/vagrant/logs/apache_errors.log
APACHE_ACCESS_LOG=/vagrant/logs/apache_access.log

# Path Vars
APPROOT=/vagrant
WEBROOT=/vagrant/webroot
OLDROOT=/var/www

# URL Vars
URL=dev.myapp.com
LOAD_TASK=sql:load

# APACHE ROOT ############################################################

echo '[App] Setting document root to public directory'
rm -rf $OLDROOT
ln -fs $WEBROOT $OLDROOT

# BACKUP APACHE ERROR LOG ################################################

if [ -f $APACHE_ERROR_LOG ]
then
	echo "[App] Existing Apache error log found, backing it up"
	mv $APACHE_ERROR_LOG ${APACHE_ERROR_LOG}.bak	
else
	echo "[App] No Apache error log found"
fi

echo "[App] Creating new Apache error log"
touch $APACHE_ERROR_LOG

echo "[App] Setting permissions on Apache error log"
chmod 777 $APACHE_ERROR_LOG

# BACKUP APACHE ACCESS LOG ###############################################

if [ -f $APACHE_ACCESS_LOG ]
then
	echo "[App] Existing Apache access log found, backing it up"
	mv $APACHE_ACCESS_LOG ${APACHE_ACCESS_LOG}.bak	
else
	echo "[App] No Apache access log found"
fi

echo "[App] Creating new Apache access log"
touch $APACHE_ACCESS_LOG

echo "[App] Setting permissions on Apache access log"
chmod 777 $APACHE_ACCESS_LOG

# APACHE ENV #############################################################

echo "[App] Adding environment variables to Apache"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName $URL
  ServerAlias $URL
  DocumentRoot $WEBROOT
  <Directory />
    Options FollowSymLinks
  </Directory>
  <Directory /vagrant/web/webroot/>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride All
    Require all granted
  </Directory>

  ErrorLog $APACHE_ERROR_LOG

  LogLevel debug

  CustomLog $APACHE_ACCESS_LOG combined

  SetEnv APP_ENV $APPENV
  SetEnv DB_HOST $DBHOST
  SetEnv DB_NAME $DBNAME
  SetEnv DB_USER $DBUSER
  SetEnv DB_PASS $DBPASSWD

</VirtualHost>
EOF

echo "[App] Restarting Apache"
service apache2 restart

# BASH ENV ##############################################################

echo "[App] Adding environment variables locally"
cat >> /home/vagrant/.bashrc <<EOF
# Set envvars
export APP_ENV=$APPENV
export NODE_ENV=$NODEENV
export DB_HOST=$DBHOST
export DB_NAME=$DBNAME
export DB_USER=$DBUSER
export DB_PASS=$DBPASSWD
EOF

# PRINT IP ##############################################################

echo "[App] IP Address:"
ifconfig eth0 | grep inet | awk '{ print $2 }'

# APP FOLDER ############################################################

echo "[App] Setting permissions on $APPROOT"
chown -R www-data:www-data $APPROOT

echo "[App] Changing to $APPROOT"
cd $APPROOT

# INSTALL MODULES #######################################################

if [ -e composer.json ]; then
	echo '[App] Updating Composer versions'
	composer update
	echo '[App] Installing Composer modules'
	composer install
else
	echo "[App] No Composer modules needed"
fi

if [ -e package.json ]; then
	echo '[App] Installing NPM modules'
	npm install
else
	echo "[App] No NPM modules needed"
fi

if [ -e bower.json ]; then
	echo '[App] Installing Bower modules'
	bower install
else
	echo "[App] No Bower modules needed"
fi

# LOAD DB's ###############################################################

echo '[App] Load Mongo DB'
npm run reloadDB

echo '[App] Load MySQL DB'
npm run reloadSQL

# END #####################################################################

echo '[App] App provision complete'