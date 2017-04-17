#!/usr/bin/env bash

# If you want to update this code, after you change it, copy it to teamcity's configuration.
# This script has to be hardcoded in team city configuraton as deploy step.

if [ -n "$1" ]; then
    BRANCH=$1
else
    BRANCH=`echo "%teamcity.build.vcs.branch.NpowerSoapBridge_HttpsGithubComEnergylinxNpowerSoapBridgeGitRefsHeadsMaster%" | grep -o "/\([a-z0-9]*\)$" | cut -d "/" -f 2`
fi

BACKENDURL=sandbox.svcs2.energylinx.com
BACKENDTOKEN=970a389ba6546916ff42a48a359d812804d018a3

case $BRANCH in
    "dev")
        PORT=8601
        DEPLOYHOST=deploy@elex-docker-1-test.energylinx.co.uk
    ;;
    "tst")
        PORT=8602
        DEPLOYHOST=deploy@elex-docker-1-test.energylinx.co.uk
    ;;
    "uat")
        PORT=8603
        DEPLOYHOST=deploy@elex-docker-1-test.energylinx.co.uk
    ;;
    "production")
        PORT=8604
        DEPLOYHOST=deploy@elex-docker-1.energylinx.co.uk
    ;;
    *)
        PORT=8600
        DEPLOYHOST=deploy@elex-docker-1-test.energylinx.co.uk
        BACKENDURL=master.svcs2.energylinx.com
        BACKENDTOKEN=970a389ba6546916ff42a48a359d812804d018a3
    ;;
esac

CONFDIR=/home/deploy/npowersoapbridge_$BRANCH
OPT=-oStrictHostKeyChecking=no
DOCKER_EMAIL=cx@initd.cz
DOCKER_USERNAME=creckx
DOCKER_PASSWORD=XyJCmSG8Y6l8

ssh $OPT $DEPLOYHOST mkdir -p $CONFDIR || exit 2
cat contrib/docker-compose.yml | sed "s/{{BRANCH}}/$BRANCH/g" | sed "s/{{PORT}}/$PORT/g" | sed "s/{{BACKEND_URL}}/$BACKENDURL/g" | sed "s/{{BACKEND_TOKEN}}/$BACKENDTOKEN/g" | ssh $DEPLOYHOST tee $CONFDIR/docker-compose.yml || exit 2
ssh $DEPLOYHOST docker login -e $DOCKER_EMAIL -u $DOCKER_USERNAME -p $DOCKER_PASSWORD

ssh $DEPLOYHOST "cd $CONFDIR; docker-compose pull app"
ssh $DEPLOYHOST "cd $CONFDIR; docker-compose stop app"
ssh $DEPLOYHOST "cd $CONFDIR; docker-compose rm -f app"
ssh $DEPLOYHOST "cd $CONFDIR; docker-compose up -d app"

if [ $? -eq 0 ]; then
  echo "Deployed!"
else
  echo "Not deployed :-("
  exit 1
fi