#!/bin/bash

DBS=$(mysql -u root -pneueda -e "show databases;")

echo "$DBS"

echo "Which DB to delete, can use partial names, use : instead of space"
echo -n "Type DB: "
read DBDEL

tmpDBS=$(echo "$DBS" | sed 's/ /:/g')

for dbnameTMP in $(echo "$tmpDBS" | grep $DBDEL)
do
	dbname=$(echo "$dbnameTMP" | sed 's/:/ /g')
	echo "Deleting $dbname"
	mysql -u root -pneueda -e "drop database \`$dbname\`"
done
