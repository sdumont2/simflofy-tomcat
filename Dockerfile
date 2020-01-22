FROM tomcat:9.0.30-jdk11-adoptopenjdk-hotspot

ARG TOMCAT_DIR=/usr/local/tomcat

RUN mkdir -p ${TOMCAT_DIR}/shared/classes && touch ${TOMCAT_DIR}/shared/classes/simflofy-global.properties && touch ${TOMCAT_DIR}/shared/classes/mongo_db.properties && touch ${TOMCAT_DIR}/shared/classes/tsearch.properties
RUN sed -i "s/shared.loader=/shared.loader=\${catalina.base}\/shared\/classes/" ${TOMCAT_DIR}/conf/catalina.properties

RUN sed -i -e "\$a\grant\ codeBase\ \"file:\$\{catalina.base\}\/webapps\/simflofy-admin\/-\" \{\n\    permission\ java.security.AllPermission\;\n\};\ngrant\ codeBase\ \"file:\$\{catalina.base\}\/webapps\/tsearch\/-\" \{\n\    permission\ java.security.AllPermission\;\n\};\ngrant\ codeBase\ \"file:\$\{catalina.base\}\/webapps\/ROOT\/-\" \{\n\    permission org.apache.catalina.security.DeployXmlPermission \"ROOT\";\n\};" ${TOMCAT_DIR}/conf/catalina.policy

RUN apt-get update && apt-get install -y --no-install-recommends wget

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080
EXPOSE 8443
CMD ["catalina.sh", "run", "-security"]



