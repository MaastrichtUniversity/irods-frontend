FROM tomcat:8.5.40-jre8-slim

ARG ENV_IRODS_REST_VERSION
ARG ENV_CLOUDBROWSER_VERSION
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
RUN wget -P /tmp/ https://github.com/DICE-UNC/irods-rest/releases/download/${ENV_IRODS_REST_VERSION}/irods-rest.war \
    && mv /tmp/irods-rest.war ${CATALINA_HOME}/webapps/ \
    && mkdir /etc/irods-ext
ADD ./irods-rest.properties /etc/irods-ext/irods-rest.properties

# Install Cloud-Browser config 
ADD ./irods-cloud-backend-config.groovy /etc/irods-ext/irods-cloud-backend-config.groovy

# Add the precompiled irods-cloud-browser
RUN wget -P ${CATALINA_HOME}/webapps/ https://github.com/MaastrichtUniversity/irods-cloud-browser/releases/download/${ENV_CLOUDBROWSER_VERSION}/irods-cloud-backend.war

EXPOSE 80

###############################################################################
#                                INSTALLATION FILEBEAT
###############################################################################

### install Filebeat
RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${ENV_FILEBEAT_VERSION}-amd64.deb -O /tmp/filebeat.deb \
 && dpkg -i /tmp/filebeat.deb

ADD filebeat.yml /etc/filebeat/filebeat.yml

# Add bootstrap script
ADD ./bootstrap.sh /opt/bootstrap.sh 

ENTRYPOINT [ "/opt/bootstrap.sh" ]
