#!/bin/bash -e

# Invoked from a crontab defined in refresh-packages.cron

HERE=$(dirname $0)

git stash push

$HERE/refresh-packages.sh
git add packages.sh
git commit -m "Packages updated on $(date)"
git push origin master

git stash pop
