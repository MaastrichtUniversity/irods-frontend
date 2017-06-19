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

# Install latest version of NodeJS and NPM using Node's setup script
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nodejs


RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | /usr/bin/debconf-set-selections
RUN apt-add-repository ppa:webupd8team/java && apt-get update && apt-get install oracle-java8-installer -y

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#Install grails and add to export
RUN cd /tmp \
    && wget https://github.com/grails/grails-core/releases/download/v2.5.0/grails-2.5.0.zip \
    && unzip grails-2.5.0.zip

##exports
ENV JAVA_HOME "/usr/lib/jvm/java-8-oracle"
ENV GRAILS_HOME "/tmp/grails-2.5.0"
ENV PATH "$PATH:$GRAILS_HOME/bin"

### Clone cloudbrowser
RUN cd /opt \
    cd /opt \
    && git clone https://github.com/MaastrichtUniversity/irods-cloud-browser.git

## run npm install
RUN cd /opt/irods-cloud-browser/irods-cloud-frontend \
    && npm install --unsafe-perm \
    && npm install --global gulp-cli


## run gulp builds
RUN cd /opt/irods-cloud-browser/irods-cloud-frontend \
    &&  gulp backend-clean
RUN cd /opt/irods-cloud-browser/irods-cloud-frontend \
    &&  gulp backend-build
RUN cd /opt/irods-cloud-browser/irods-cloud-frontend \
    &&  gulp gen-war \
    &&  gulp gen-war
### BUG FIX FIRST RUN DOES NOT CREATE WAR

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

RUN cp /opt/irods-cloud-browser/build/irods-cloud-backend.war /var/lib/tomcat8/webapps/

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
