#!/bin/sh

set -e

echo "-------------------"
echo Processing master
echo "-------------------"
git checkout master
git pull origin master
git push origin master
echo
echo

for branch in dev uat tst prd; do
    echo "-------------------"
    echo Processing $branch
    echo "-------------------"
    git checkout $branch
    git pull origin $branch
    git merge master
    git push origin $branch
    echo 
    echo 
done

