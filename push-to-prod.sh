#!/bin/bash

cp /var/lib/go-agent/pipelines/zips/danglay.zip /tmp/
cd /tmp
unzip danglay.zip -d folder
cd folder/danglay
rm -rf /var/lib/go-agent/pipelines/danglay-prod/*
files=`ls -A`
for file in $files; do
        mv  $file  /var/lib/go-agent/pipelines/danglay-prod/  2>/dev/null
done
rm -rf /tmp/danglay.zip /tmp/folder
cd /var/lib/go-agent/pipelines/danglay-prod/
git push prod master
heroku run bundle exec rake db:migrate -r prod
heroku logs -r prod > prod.log
cp prod.log ../danglay
