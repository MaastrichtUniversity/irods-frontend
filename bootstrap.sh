#!/bin/bash
set -e

# Start Tomcat8 service
/var/lib/tomcat8/bin/startup.sh

# Force start of apache2 server
rm -f /var/run/apache2/apache2.pid
service apache2 start

#logstash
/etc/init.d/filebeat start

sleep 10

cat << EOF > /var/lib/tomcat8/webapps/irods-cloud-backend/js/Vars.js
var pacmanHost = "${PACMAN_HOST}";

function pacmanButton() {
    console.log(pacmanHost);
    window.open(pacmanHost+"/cloudbrowser/index","_blank");
}
EOF


sed -i '76i<script src="js/Vars.js"></script>' /var/lib/tomcat8/webapps/irods-cloud-backend/index.html 

# this script must end with a persistent foreground process
tail -F /var/lib/tomcat8/logs/catalina.out /var/lib/tomcat8/logs/localhost* /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log