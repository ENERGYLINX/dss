#!/usr/bin/env bash

#mvn clean compile package
#mvn clean compile assemble:jar

cd /vagrant
sudo supervisorctl stop java
sudo mvn clean install compile assembly:single
sudo supervisorctl start java
