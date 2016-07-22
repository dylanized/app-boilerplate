echo '[App.user] Starting app provision (normal user)'

# VARS ##################################################################

APPROOT=/vagrant
INSTALL_TASK=modules:install
LOAD_TASK=sql:load

# CHANGE DIRECTORY ######################################################

echo "[App.user] Changing to $APPROOT"
cd $APPROOT

# INSTALL MODULES #######################################################

echo '[App.user] Install modules'
npm run $INSTALL_TASK

# LOAD DB's ###############################################################

echo '[App.user] Create & seed database'
npm run $LOAD_TASK

# END #####################################################################

echo '[App.user] App provision complete'