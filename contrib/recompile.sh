#!/usr/bin/env bash

cd /vagrant
sudo supervisorctl stop java
sudo mvn package
sudo supervisorctl start java
