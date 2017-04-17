#!/usr/bin/env bash

# If you want to update this code, after you change it, copy it to teamcity's configuration.
# This script has to be hardcoded in team city configuraton as 03-build step.

BRANCH=`echo "%teamcity.build.vcs.branch.NpowerSoapBridge_HttpsGithubComEnergylinxNpowerSoapBridgeGitRefsHeadsMaster%" | grep -o "/\([a-z0-9]*\)$" | cut -d "/" -f 2`
echo "Branch: $BRANCH"

sudo docker build --pull=true -t energylinx/npowersoapbridge:${BRANCH}-latest .
sudo docker login -e cx@initd.cz -u creckx -p XyJCmSG8Y6l8
sudo docker push energylinx/npowersoapbridge:${BRANCH}-latest
