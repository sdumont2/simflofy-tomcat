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
	wget -q -O $WEBAPP_DIR/tsearch.war "${SIMFLOFY_TSEARCH_DOWNLOAD_URL}"
	echo 
	echo "TSearch Download Complete"
	echo 
fi
#Get simflofy-admin war if download url exists
if [ "$SIMFLOFY_ADMIN_DOWNLOAD_URL" ]; then
	echo 
	echo "Starting Simflofy Admin Download"
	echo 
	wget -q -O $WEBAPP_DIR/simflofy-admin.war "${SIMFLOFY_ADMIN_DOWNLOAD_URL}"
	echo 
	echo "Simflofy Admin Download Complete"
	echo 
fi


if [ -f "$WEBAPP_DIR/simflofy-admin.war" ]; then

	echo " "
	echo "Placing new Simflofy properties in shared/classes at catalina home"
	echo " "

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

	jar -x --file $WEBAPP_DIR/tsearch.war $WEBAPP_DIR/WEB-INF/classes/tsearch.properties

	if [ "$TSEARCH_SIMFLOFY_SERVICES_URL" ]; then
		sed -i '/tsearch\.simflofy\.services\.url/s/.*/tsearch\.simflofy\.services\.url\=$TSEARCH_SIMFLOFY_SERVICES_URL/' $WEBAPP_DIR/WEB-INF/classes/tsearch.properties
	else
		sed -i '/tsearch\.simflofy\.services\.url/s/.*/tsearch\.simflofy\.services\.url\=http\:\/\/localhost\:8080\/simflofy\-admin/' $WEBAPP_DIR/WEB-INF/classes/tsearch.properties
	fi

	zip -r $WEBAPP_DIR/tsearch.war $WEBAPP_DIR/WEB-INF/classes/tsearch.properties

	rm -rf $WEBAPP_DIR/WEB-INF

	echo " "
	echo "Completed placing properties in tsearch war at catalina webapps"
	echo " "

fi

exec "$@"