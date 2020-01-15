This image is a base Tomcat image with Simflofy WARs not included, but environment variables in place to properly place them in their expected location.  This will fail to run if a license key is not included in one of the required environment variables though.

The `init-simflofy-bd.sh` script is for use with a MongoDB image, in order to create a database using the **MONGO_INITDB_DATABASE** environment variable. 

Required Environment Variables:  
**SIMFLOFY_ADMIN_DOWNLOAD_URL** -  This variable is the Download URL for the **simflofy-admin.war** file for the Simflofy instance. ***Must*** be provided in order to run.   
**SIMFLOFY_TSEARCH_DOWNLOAD_URL** -  This variable is the Download URL for the **tsearch.war** file for the Simflofy instance. ***Must*** be provided in order to run.   
**SIMFLOFY_MONGODB_URI** - This variable is the **Connection URI** of the MongoDB instance for Simflofy to connect with. Defaults to **localhost** as the host, which is not provided in this image.  

Other Environment Variables to consider.  
**SIMFLOFY_MONGODB_USERNAME** - This variable is the **username** of the user to authenticate to MongoDB with. Defaults to **simflofy**.   
**SIMFLOFY_MONGODB_PASSWORD** - This variable is the **password** of the user to authenticate to MongoDB with. Defaults to **simflofy**.   
**SIMFLOFY_MONGODB_NAME** - This variable is the **Database name** of the MongoDB instance to connect with. Defaults to **simflofy**.  