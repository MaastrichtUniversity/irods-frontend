FROM tomcat:8.5.40-jre8-slim

ARG ENV_IRODS_REST_VERSION
ARG ENV_FILEBEAT_VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    apache2 \
    unzip \
    git \
    nano \
    curl \
    wget

## Setup Apache reverse proxy for Tomcat
# Enable proxy modules
RUN a2enmod proxy_http
# Add modified apache site-configuration
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./index.html /var/www/html/index.html

# Install iRODS-REST
RUN wget -P /tmp/ https://github.com/irods-contrib/irods-rest/releases/download/${ENV_IRODS_REST_VERSION}/irods-rest.war \
    && mv /tmp/irods-rest.war ${CATALINA_HOME}/webapps/ \
    && mkdir /etc/irods-ext
ADD ./irods-rest.properties /etc/irods-ext/irods-rest.properties

EXPOSE 80

# Conditionally trust the custom DataHub Certificate Authority (CA) for iRODS-SSL-connections
ADD test_only_dev_irods_dh_ca_cert.pem /tmp/test_only_dev_irods_dh_ca_cert.pem
ARG SSL_ENV
RUN if [ $SSL_ENV != "acc" ] && [ $SSL_ENV != "prod" ]; then \
       echo "Adding custom DataHub iRODS-CA-certificate to the JVM truststore (FOR DEV & TEST ONLY!)..." ; \
       keytool -import -noprompt -keystore /etc/ssl/certs/java/cacerts -storepass changeit -file /tmp/test_only_dev_irods_dh_ca_cert.pem -alias irods_dh_ca_cert ; \
       echo "done!" ; \
    else \
       echo "Skipping update of the JVM truststore" ; \
    fi

###############################################################################
#                                INSTALLATION FILEBEAT
###############################################################################

### install Filebeat
RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ENV_FILEBEAT_VERSION}-amd64.deb -O /tmp/filebeat.deb \
 && dpkg -i /tmp/filebeat.deb

ADD filebeat.yml /etc/filebeat/filebeat.yml
RUN chmod go-w /etc/filebeat/filebeat.yml

# Add bootstrap script
ADD ./bootstrap.sh /opt/bootstrap.sh 

ENTRYPOINT [ "/opt/bootstrap.sh" ]
