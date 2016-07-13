if [ -f $1 ]
then
	echo "[Log] Existing $2 found, backing it up"
	mv $1 ${1}.bak	
else
	echo "[Log] No $2 found"
fi

echo "[Log] Creating new $2"
touch $1

echo "[Log] Setting permissions on $2"
chmod 777 $1