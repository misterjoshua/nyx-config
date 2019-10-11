#!/bin/bash -e

# Invoked from a crontab defined in refresh-packages.cron

HERE=$(dirname $0)

git stash push >/dev/null

$HERE/refresh-packages.sh >/dev/null
git add $HERE/packages.sh >/dev/null
git commit -m "Packages updated on $(date)" >/dev/null
git push origin master >/dev/null

git stash pop >/dev/null
