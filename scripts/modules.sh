# INSTALL MODULES #######################################################

if [ -e composer.json ]; then
	echo '[Modules] Updating Composer versions'
	composer update
	echo '[Modules] Installing Composer modules'
	composer install
else
	echo "[Modules] No Composer modules needed"
fi

if [ -e package.json ]; then
	echo '[Modules] Installing NPM modules'
	npm install
else
	echo "[Modules] No NPM modules needed"
fi

if [ -e bower.json ]; then
	echo '[Modules] Installing Bower modules'
	bower install
else
	echo "[Modules] No Bower modules needed"
fi



composer update