#! /bin/bash
set -e

WEBAPP_DIR="/usr/local/tomcat/webapps"
SHARED_DIR="/usr/local/tomcat/shared/classes"

#Check for mongodb uri
if [ -z "$SIMFLOFY_MONGODB_URI" ]; then 
	echo "SIMFLOFY_MONGODB_URI not provided"
	shutdown -f
fi

if [ "$SIMFLOFY_TSEARCH_DOWNLOAD_URL" ]; then
	echo 
	echo "Starting TSearch Download"
	echo 
	wget -q --no-check-certificate -O $WEBAPP_DIR/tsearch.war "${SIMFLOFY_TSEARCH_DOWNLOAD_URL}"
	echo 
	echo "TSearch Download Complete"
	echo 
fi
#Get simflofy-admin war if download url exists
if [ "$SIMFLOFY_ADMIN_DOWNLOAD_URL" ]; then
	echo 
	echo "Starting Simflofy Admin Download"
	echo 
	wget -q --no-check-certificate -O $WEBAPP_DIR/simflofy-admin.war "${SIMFLOFY_ADMIN_DOWNLOAD_URL}"
	echo 
	echo "Simflofy Admin Download Complete"
	echo 
fi


if [ -f "$WEBAPP_DIR/simflofy-admin.war" ]; then

	echo " "
	echo "Placing new Simflofy properties in shared/classes at catalina home"
	echo " "

	chmod 755 $WEBAPP_DIR/simflofy-admin.war

	echo "mongo.db.uri=$SIMFLOFY_MONGODB_URI" > $SHARED_DIR/mongo_db.properties

	if [ "$SIMFLOFY_MONGODB_USERNAME" ]; then
		echo "mongo.db.username=$SIMFLOFY_MONGODB_USERNAME" >> $SHARED_DIR/mongo_db.properties
	fi

	if [ "$SIMFLOFY_MONGODB_PASSWORD" ]; then
		echo "mongo.db.password=$SIMFLOFY_MONGODB_PASSWORD" >> $SHARED_DIR/mongo_db.properties
	fi

	if [ "$SIMFLOFY_MONGODB_NAME" ]; then
		echo "mongo.db.dbname=$SIMFLOFY_MONGODB_NAME" > $SHARED_DIR/simflofy-global.properties
	else
		echo "mongo.db.dbname=simflofy" > $SHARED_DIR/simflofy-global.properties
	fi

	echo " "
	echo "Completed placing properties in shared/classes at catalina home"
	echo " "

fi

if [ -f "$WEBAPP_DIR/tsearch.war" ]; then

	echo " "
	echo "Placing new TSearch properties in tsearch war at catalina webapps"
	echo " "

	chmod 755 $WEBAPP_DIR/tsearch.war

	cd $WEBAPP_DIR
	jar -x --file tsearch.war WEB-INF/classes/tsearch.properties
	cd ..

	if [ "$TSEARCH_SIMFLOFY_SERVICES_URL" ]; then
		sed -i '/tsearch\.simflofy\.services\.url/s/.*/tsearch\.simflofy\.services\.url\=$TSEARCH_SIMFLOFY_SERVICES_URL/' $WEBAPP_DIR/WEB-INF/classes/tsearch.properties
	else
		sed -i '/tsearch\.simflofy\.services\.url/s/.*/tsearch\.simflofy\.services\.url\=http\:\/\/localhost\:8080\/simflofy\-admin/' $WEBAPP_DIR/WEB-INF/classes/tsearch.properties
	fi

	cd $WEBAPP_DIR
	zip -r tsearch.war WEB-INF/classes/tsearch.properties

	rm -rf WEB-INF
	cd ..

	echo " "
	echo "Completed placing properties in tsearch war at catalina webapps"
	echo " "

fi

exec "$@"