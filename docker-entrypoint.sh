#! /bin/bash
set -e

#Check for mongodb uri
if [ -z "$SIMFLOFY_MONGODB_URI" ]; then 
	echo "SIMFLOFY_MONGODB_URI not provided"
	shutdown -f
fi

if [ "$SIMFLOFY_TSEARCH_DOWNLOAD_URL" ]; then
	echo 
	echo "Starting TSearch Download"
	echo 
	wget -q -O /usr/local/tomcat/webapps/tsearch.war "${SIMFLOFY_TSEARCH_DOWNLOAD_URL}"
	echo 
	echo "TSearch Download Complete"
	echo 
fi
#Get simflofy-admin war if download url exists
if [ "$SIMFLOFY_ADMIN_DOWNLOAD_URL" ]; then
	echo 
	echo "Starting Simflofy Admin Download"
	echo 
	wget -q -O /usr/local/tomcat/webapps/simflofy-admin.war "${SIMFLOFY_ADMIN_DOWNLOAD_URL}"
	echo 
	echo "Simflofy Admin Download Complete"
	echo 
fi

echo "Placing new properties in shared/classes at catalina home"

echo "mongo.db.uri=$SIMFLOFY_MONGODB_URI" >> /usr/local/tomcat/shared/classes/mongo_db.properties

if [ "$SIMFLOFY_MONGODB_USERNAME" ]; then
	echo "mongo.db.username=$SIMFLOFY_MONGODB_USERNAME" >> /usr/local/tomcat/shared/classes/mongo_db.properties
fi

if [ "$SIMFLOFY_MONGODB_PASSWORD" ]; then
	echo "mongo.db.password=$SIMFLOFY_MONGODB_PASSWORD" >> /usr/local/tomcat/shared/classes/mongo_db.properties
fi

if [ "$SIMFLOFY_MONGODB_NAME" ]; then
	echo "mongo.db.dbname=$SIMFLOFY_MONGODB_NAME" >> /usr/local/tomcat/shared/classes/simflofy-global.properties
else
	echo "mongo.db.dbname=simflofy" >> /usr/local/tomcat/shared/classes/simflofy-global.properties
fi

exec "$@"