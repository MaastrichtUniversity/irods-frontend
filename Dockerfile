FROM ubuntu:14.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    python-software-properties \
    apache2 \
    unzip \
    git \
    nano \
    curl

RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections
RUN apt-add-repository ppa:webupd8team/java && apt-get update && apt-get install oracle-java8-installer -y

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Setup Apache reverse proxy for Tomcat
# Enable proxy modules
RUN a2enmod proxy_http
# Add modified apache site-configuration
ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./index.html /var/www/html/index.html

# Install tomcat8
RUN wget -P /tmp/ http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz \
    && tar xvf /tmp/apache-tomcat-8.0.35.tar.gz -C /tmp/ && mv /tmp/apache-tomcat-8.0.35/ /var/lib/tomcat8

# Install iRODS-REST
RUN wget -P /tmp/ https://github.com/DICE-UNC/irods-rest/releases/download/4.1.10.0-RC1/irods-rest.war \
    && mv /tmp/irods-rest.war /var/lib/tomcat8/webapps/ \
    && mkdir /etc/irods-ext
ADD ./irods-rest.properties /etc/irods-ext/irods-rest.properties

# Install Cloud-Browser config 
ADD ./irods-cloud-backend-config.groovy /etc/irods-ext/irods-cloud-backend-config.groovy

# Add the precompiled irods-cloud-browser
RUN wget -P  /var/lib/tomcat8/webapps/ https://github.com/MaastrichtUniversity/irods-cloud-browser/releases/download/1.1.1-RELEASE-MUMC/irods-cloud-backend.war

EXPOSE 80

###############################################################################
#                                INSTALLATION LOGBEAT
###############################################################################

### install Filebeat

RUN apt-get update -qq \
 && apt-get install -qqy curl \
 && apt-get clean

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.2.0-amd64.deb \
 && dpkg -i filebeat-5.2.0-amd64.deb \
 && rm filebeat-5.2.0-amd64.deb

###############################################################################
#                                CONFIGURATION LOGBEAT
###############################################################################

### configure Filebeat

# config file
ADD filebeat.yml /etc/filebeat/filebeat.yml

# Add bootstrap script
ADD ./bootstrap.sh /opt/bootstrap.sh 

ENTRYPOINT [ "/opt/bootstrap.sh" ]
