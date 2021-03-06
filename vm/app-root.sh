echo '[App.root] Starting app provision (root user)'

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

# APACHE ROOT ############################################################

echo '[App.root] Setting document root to public directory'
rm -rf $OLDROOT
ln -fs $WEBROOT $OLDROOT

# BACKUP APACHE ERROR LOG ################################################

echo "[App.root] Initializing Apache error log"
sh /vagrant/scripts/log.sh $APACHE_ERROR_LOG 'Apache error log'

# BACKUP APACHE ACCESS LOG ###############################################

echo "[App.root] Initializing Apache access log"
sh /vagrant/scripts/log.sh $APACHE_ACCESS_LOG 'Apache access log'

# APACHE ENV #############################################################

echo "[App.root] Adding environment variables to Apache"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName $URL
  ServerAlias $URL
  DocumentRoot $WEBROOT
  <Directory />
    Options FollowSymLinks
  </Directory>
  <Directory /vagrant/webroot/>
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

echo "[App.root] Restarting Apache"
service apache2 restart

# BASH ENV ##############################################################

echo "[App.root] Adding environment variables locally"
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

echo "[App.root] IP Address:"
ifconfig eth0 | grep inet | awk '{ print $2 }'

# APP FOLDER ############################################################

echo "[App.root] Setting permissions on $APPROOT"
chown -R www-data:www-data $APPROOT