#!/bin/bash

sudo apt-get -y update

sudo apt-get -y install git tofrodos unzip vim sed wget gzip awscli curl openjdk-7-jre-headless \
    supervisor maven openjdk-7-jdk python3 python3-yaml python3-requests

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mailutils libsasl2-modules
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y postfix
sudo cp /vagrant/contrib/sasl_passwd /etc/postfix/
sudo chmod 600 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
sudo cp /vagrant/contrib/main.cf /etc/postfix/
sudo sed -i.orig "s/myhostname.*=.*/myhostname=${HOSTNAME}\.energylinx\.co\.uk/" /etc/postfix/main.cf
sudo service postfix restart

su vagrant -c "mkdir -p /home/vagrant/log"

cd /vagrant
/bin/sh /vagrant/contrib/01-build-update-system.sh 
/bin/sh /vagrant/contrib/02-build-maven.sh
cd -

cat << EOF > /etc/supervisor/conf.d/npowersoapbridge.conf
[program:java]
command=/usr/bin/java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=5005,suspend=n -jar /vagrant/target/npower-soap-bridge-0.1.1-jar-with-dependencies.jar
environment=JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64,npowerJSONSearchURLgas="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/quotes/gas/",npowerJSONSearchURLelec="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/quotes/elec/",jsonSearchAuthToken="7005381ff9f4b37296aea2f6898a566f13f6068a",environment="vagrant",translateJSONTranslation="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/tariffs-by-product-codes/",npowerJSONSearchURLdual="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/quotes/elecgas/",productListDiffURL="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/tariffs/changes/",suppliersByIdsURL="http://192.168.70.13:8000/v2/partner-resources/NPOWER_SOAP/suppliers-by-ids/"
directory=/home/vagrant
autostart=true
autorestart=true
stdout_logfile=/home/vagrant/log/java.log
stdout_logfile_maxbytes=2MB
stdout_logfile_backups=5
stdout_capture_maxbytes=2MB
stdout_events_enabled=false
redirect_stderr=true
EOF

cat << EOF > /usr/local/bin/rebuild.sh
#!/bin/sh

export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64

cd /vagrant
sh /vagrant/contrib/02-build-maven.sh
supervisorctl reread
supervisorctl update
supervisorctl restart java
cd -
EOF
chmod 755 /usr/local/bin/rebuild.sh

#cd /vagrant
#su vagrant -c "JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-amd64 mvn clean compile package"
su vagrant -c "/usr/local/bin/rebuild.sh"

chmod 777 /run/supervisor.sock

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl restart java
