#!/usr/bin/env bash

#mvn clean compile package
#mvn clean compile assemble:jar
mvn clean install compile assembly:single
