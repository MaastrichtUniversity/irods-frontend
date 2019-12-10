#!/bin/bash
set -e

# Start Tomcat8 service
${CATALINA_HOME}/bin/startup.sh

# Force start of apache2 server
rm -f /var/run/apache2/apache2.pid
service apache2 start

#logstash
/etc/init.d/filebeat start

# this script must end with a persistent foreground process
tail -F ${CATALINA_HOME}/logs/catalina.out ${CATALINA_HOME}/logs/localhost* /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log