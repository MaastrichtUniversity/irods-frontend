#!/bin/bash
set -e

# Start Tomcat8 service
/var/lib/tomcat8/bin/startup.sh

# Force start of apache2 server
rm -f /var/run/apache2/apache2.pid
service apache2 start

# this script must end with a persistent foreground process
tail -F /var/lib/tomcat8/logs/catalina.out /var/lib/tomcat8/logs/localhost* /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log